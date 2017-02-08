# AEMATOR
A bash script to automate the Adobe Experience Manager (AEM) environment setup via linux terminal, start to end with multi-tail logging.

### Prerequisites | Purpose | Installation command

* wget | The non-interactive network downloader to download files. | ```sudo apt-get install wget```

* curl | A tool to transfer data from or to a server, using one of the supported protocols. | ```sudo apt-get install curl```

* multitail | It lets you view one or multiple  files  like the  original  tail  program by creates multiple windows on your console. We will use it to monitor the logs | ```sudo apt-get install multitail```

* jre | Java runtime environment to execute AEM quickstart.jar | ```sudo apt-get install openjdk-7-jre```

### How to run?

* Copy the ```aemSetup.sh``` file to directory where you want to setup AEM. This will be your $BASE directory.

* Make sure you have permission to run the file by executing ```chmod +x /path/to/yourscript.sh```.

* Open the script using your preferred editor and update the variables, directories, URLs wherever commented for same.

* Save and exit.

* Run the script using ```./aemSetup.sh``` or ```bash aemSetup.sh```.

* Make a cup of coffee and let it do all the work.

* Profit.
