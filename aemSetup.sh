#!/bin/bash
    
#--------------------------------------------------------------------
# Script by Jatin K Malik (@silent_freak)
# Prerequisites | Purpose |Installation command
# 1. wget | The non-interactive network downloader to download files. | sudo apt-get install wget
# 2. curl | A tool to transfer data from or to a server, using one of the supported protocols. | sudo apt-get install curl
# 3. multitail | It lets you view one or multiple  files  like the  original  tail  program by creates multiple windows on your console. We will use it to monitor the logs | sudo apt-get install multitail
# 4. jre | Java runtime environment to execute AEM quickstart.jar | sudo apt-get install openjdk-7-jre 
#--------------------------------------------------------------------

#Variables | Modify the directory name here as per your AEM installation.
AEM="AEM 6.3"
VERSION="63-Snapshot"
ADIR="author$VERSION"
PDIR="publish$VERSION"
BASE="/root/aem63Servers"

#Assets
CQURL="http://abcxyz.com/cq-quickstart.jar" # Insert CQ build url here.
AEMFDURL="http://abcxyz.com/aemfd-linux.zip" # Insert AEMFD package url here.

clear

echo "Hi $USER!, Let's begin with $AEM"
echo
mkdir aem63Servers # Modify the directory name here as per your AEM installation.
cd aem63Servers
mkdir $ADIR $PDIR # Creating directories for Author and Publish instances.

echo "I will now fetch the $AEM quickstart.jar"
wget -v $CQURL -O "cq-quickstart-6.3.0.jar" # To download and rename the jar to snip off the build number/load details from file name.

echo "Creating license from sources..." # Enter your license key information below so as to register the AEM installation.
cat > license.properties <<- EOM
#Adobe Granite License Properties
#Wed Feb  8 10:13:00 GMT 2017
license.product.name= # Enter information here
license.customer.name= # Enter information here
license.product.version= # Enter information here
license.downloadID= # Enter information here
EOM

echo "Done. Let's copy the cq-quickstart to respective directories"
echo $ADIR $PDIR | xargs -n 1 cp cq-quickstart-6.3.0.jar
echo $ADIR $PDIR | xargs -n 1 cp license.properties

echo
echo "Renaming the cq jar for publish instance"
cd $PDIR

mv cq-quickstart-6.3.0.jar cq-quickstart-6.3.0-publish.jar # Adding -publish flag to execute quickstart.jar in Publish mode.

echo "Moving back to base dir.."
cd $BASE

echo "Deleting the original cq jar.."
rm -f cq*.jar

echo "Let's start the instances"
cd $ADIR 

# Using nohup & to run installation in background so as to parallely run both instances.
echo "Starting AEM-Author"
nohup java -Xms512m -Xmx2048m -XX:MaxPermSize=512m -Dabtesting.enabled=true -jar cq-quickstart-6.3.0.jar -p4502 &

cd $BASE
cd $PDIR

echo "Starting AEM-Publish"
nohup java -Xms512m -Xmx2048m -XX:MaxPermSize=512m  -jar cq-quickstart-6.3.0-publish.jar -p4503 &

# A countdown timer to wait for 10 minutes before starting the installation of add on packages.
secs=$((10  * 60))
while [ $secs -gt 0 ]; do
   echo -ne "Time till AEMFD install: T-$secs seconds\033[0K\r"
   sleep 1
   : $((secs--))
done


cd $BASE
echo "Downloading AEMFD Linux pkg"
wget -v $AEMFDURL -O "aemfd-linux.zip" # To download and rename the zip file to snip off the build number/load details from file name.

# Installing addon packages via CURL
cd $BASE
echo "Installing AEMFD-Linux package on Publish instance..."
curl -u admin:admin -F file=@"aemfd-linux.zip"  -F name="aemfd-linux" -F force=true -F install=true  http://localhost:4503/crx/packmgr/service.jsp & 
# APID=$!

echo "Installing AEMFD-Linux package on Author instance..."
curl -u admin:admin -F file=@"aemfd-linux.zip"  -F name="aemfd-linux" -F force=true -F install=true  http://localhost:4502/crx/packmgr/service.jsp &
# PPID=$!

 
echo "AEMFD installation done..."
sleep 10s

echo "Time for logs.."
sleep 10s

# Opening logs via multitail to monitor both author and publish instances.
multitail -i ./$ADIR/crx-quickstart/logs/error.log  ./$PDIR/crx-quickstart/logs/error.log


