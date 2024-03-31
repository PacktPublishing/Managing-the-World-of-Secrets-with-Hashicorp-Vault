
Installation on Ubuntu
---
1. Using the Linux DEB Package
- Download apacheds-2.0.0.AM27-amd64.deb
- Install  it with your favaroite package manager (I like Eddy)
```
sudo /etc/init.d/apacheds-2.0.0.AM28-SNAPSHOT-default start
ps aux | grep apacheds
```
2. These are the directories and other important info

Log4J Config
---
    -Dlog4j.configuration=file:////var/lib/apacheds-2.0.0.AM28-SNAPSHOT/default/conf/log4j.properties


More Directories
---
### Default Directory
    -Dapacheds.var.dir=/var/lib/apacheds-2.0.0.AM28-SNAPSHOT/default 

### Log Directory
    -Dapacheds.log.dir=/var/lib/apacheds-2.0.0.AM28-SNAPSHOT/default/log 

### Working Directory
    -Dapacheds.run.dir=/var/lib/apacheds-2.0.0.AM28-SNAPSHOT/default/run 

### Temporary Directory
    -Djava.io.tmpdir=/var/lib/apacheds-2.0.0.AM28-SNAPSHOT/default/tmp 

### Instance Name
    -Dapacheds.instance=default

Java Library Path
---
    -Djava.library.path=../lib -classpath ../lib/apacheds-service-2.0.0.AM28-SNAPSHOT.jar:../lib/apacheds-wrapper-2.0.0.AM28-SNAPSHOT.jar:../lib/wrapper-3.2.3.jar 


Wrapper Key (Tanuki)
---
    -Dwrapper.key=sX6w04_VPadbW_0l 

Wrapper Port
---
    -Dwrapper.port=32000 

Wrapper JVM Port Min
---
    -Dwrapper.jvm.port.min=31000 

Wrapper JVM Port
---
    -Dwrapper.jvm.port.max=31999

Wrapper PID, Version, etc.
---

    -Dwrapper.pid=597109
    -Dwrapper.version=3.2.3 
    -Dwrapper.native_library=wrapper 
    -Dwrapper.service=TRUE 
    -Dwrapper.cpu.timeout=10 


Start Command
---
-Dwrapper.jvmid=1 org.apache.directory.server.wrapper.ApacheDsTanukiWrapper /var/lib/apacheds-2.0.0.AM28-SNAPSHOT/default start
```bash
sudo /etc/init.d/apacheds-2.0.0.AM28-SNAPSHOT-default start
sudo /etc/init.d/apacheds-2.0.0.AM28-SNAPSHOT-default restart
sudo /etc/init.d/apacheds-2.0.0.AM28-SNAPSHOT-default status
sudo /etc/init.d/apacheds-2.0.0.AM28-SNAPSHOT-default stop
```
/etc/init.d/apacheds-2.0.0.AM28-SNAPSHOT-default - just a shell script wrapper calling:
    /opt/apacheds-2.0.0.AM28-SNAPSHOT/bin/apacheds $1 default
- $1 is the command - start, stop, status
- default - name of the ApacheDS instance to start, stop, or get status of

You can alias this to something much shorder in ~/.zshrc

Important Files
---

### Wrapper
/var/lib/apacheds-2.0.0.AM28-SNAPSHOT/default/conf/wrapper-instance.conf


- Use it to override settings in the main conf file:

/opt/apacheds-2.0.0.AM28-SNAPSHOT/conf/wrapper.conf

### Executables
- /opt/apacheds-2.0.0.AM28-SNAPSHOT/apached
- /opt/apacheds-2.0.0.AM28-SNAPSHOT/wrapperds