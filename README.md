# AEMATOR
A bash script utility to automate the Adobe Experience Manager (AEM) environment setup via linux terminal, start to end with multi-tail logging.

![AEMATOR](https://raw.githubusercontent.com/jatinkrmalik/aemator/master/aematorHeader.png)

### Prerequisites | Purpose | Installation command

* **wget** | The non-interactive network downloader to download files. | ```sudo apt-get install wget```

* **curl** | A tool to transfer data from or to a server, using one of the supported protocols. | ```sudo apt-get install curl```

* **multitail** | It lets you view one or multiple  files  like the  original  tail  program by creates multiple windows on your console. We will use it to monitor the logs | ```sudo apt-get install multitail```

* **jre** | Java runtime environment to execute AEM quickstart.jar | ```sudo apt-get install openjdk-7-jre```

### How to run?

* Clone this repo.

* Copy the ```aemSetup.sh``` file to directory where you want to setup AEM. This will be your $BASE directory.

* Make sure you have permission to run the file by executing ```chmod +x /path/to/yourscript.sh```.

* Open the script using your preferred editor and update the variables, directories, URLs wherever commented for same.

* Save and exit.

* Run the script using ```./aemSetup.sh``` or ```bash aemSetup.sh```.

* Make a cup of coffee and let it do all the work.

* Profit.

---

### Feel free to extend your script with the following CURL commands:
*Note 1: The following CQ curl commands assumes a admin:admin username and password.*

*Note 2: For Windows/Powershell users: use two "" when doing a -F cURL command.*
        Example: ```-F"":operation=delete""```
        
*Note 3: Quotes around name of package (or name of zip file, or jar) should be included.*

* **Uninstall a bundle (use http://localhost:4505/system/console/bundles to access the Apache Felix web console)**

        curl -u admin:admin -daction=uninstall http://localhost:4505/system/console/bundles/"name of bundle"

* **Install a bundle**

        curl -u admin:admin -F action=install -F bundlestartlevel=20 -F bundlefile=@"name of jar.jar" http://localhost:4505/system/console/bundles

* **Build a bundle**

        curl -u admin:admin -F bundleHome=/apps/centrica/bundles/name of bundle -F descriptor=/apps/centrica/bundles/com.centrica.cq.wcm.core-bundle/name_of_bundle.bnd http://localhost:4505/libs/crxde/build

* **Stop a bundle**

        curl -u admin:admin http://localhost:4505/system/console/bundles/org.apache.sling.scripting.jsp -F action=stop

* **Start a bundle**

        curl -u admin:admin http://localhost:4505/system/console/bundles/org.apache.sling.scripting.jsp -F action=start

* **Delete a node (hierarchy) - (this will delete any directory / node / site)**

        curl -X DELETE http://localhost:4505/path/to/node/jcr:content/nodeName -u admin:admin

* **Upload a package AND install**

        curl -u admin:admin -F file=@"name of zip file" -F name="name of package" -F force=true -F install=true http://localhost:4505/crx/packmgr/service.jsp

* **Upload a package DO NOT install**

        curl -u admin:admin -F file=@"name of zip file" -F name="name of package" -F force=true -F install=false http://localhost:4505/crx/packmgr/service.jsp

* **Rebuild an existing package in CQ**

        curl -u admin:admin -X POST http://localhost:4505:/crx/packmgr/service/.json/etc/packages/name_of_package.zip?cmd=build

* **Download (the package)**

        curl -u admin:admin http://localhost:4505/etc/packages/export/name_of_package.zip > name of local package file

* **Upload a new package**

        curl -u admin:admin -F package=@"name_of_package.zip" http://localhost:4505/crx/packmgr/service/.json/?cmd=upload

* **Install an existing package**

        curl -u admin:admin -X POST http://localhost:4505/crx/packmgr/service/.json/etc/packages/export/name of package?cmd=install

* **Activate**

        curl -u admin:admin -X POST -F path="/content/path/to/page" -F cmd="activate" http://localhost:4502/bin/replicate.json

* **Deactivate**

        curl -u admin:admin -X POST -F path="/content/path/to/page" -F cmd="deactivate" http://localhost:4502/bin/replicate.json

* **Tree Activation**

        curl -u admin:admin -F cmd=activate -F ignoredeactivated=true -F onlymodified=true -F path=/content/geometrixx http://localhost:4502/etc/replication/treeactivation.html

* **Lock page**

        curl -u admin:admin -X POST -F cmd="lockPage" -F path="/content/path/to/page" -F "_charset_"="utf-8" http://localhost:4502/bin/wcmcommand

* **Unlock page**

        curl -u admin:admin -X POST -F cmd="unlockPage" -F path="/content/path/to/page" -F "_charset_"="utf-8" http://localhost:4502/bin/wcmcommand

* **Copy page**

        curl -u admin:admin -F cmd=copyPage -F destParentPath=/path/to/destination/parent -F srcPath=/path/to/source/locaiton http://localhost:4502/bin/wcmcommand
        
### Further Resources:
* For Adobe Experience Manager links, cheat sheets and solutions to common problems - https://github.com/paulrohrbeck/aem-links
* For more CURL commands - http://www.aemcq5tutorials.com/tutorials/adobe-cq5-aem-curl-commands/
