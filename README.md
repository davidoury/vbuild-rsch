# Virtual R, Spark, Cassandra and HDFS 

Vagrant, Virtualbox and Ansible are used to create a virtualbox which runs R, Spark, Cassandra and HDFS.

Table of contents: 

- [Slides](#slides)
- [Memory settings and requirements](#memory-settings-and-requirements)
- [Setup](#setup)
- [Management](#management)
    - [From the virtual build machine](#from-the-virtual-build-machine)
    - [From the virtual cluster machines](#from-the-virtual-cluster-machines)
- [Examples](#examples)
    - [HDFS](#hdfs)
    - [Cassandra](#cassandra)
    - [Scala Spark shell](#scala-spark-shell)
    - [Python Spark shell](#python-spark-shell)

## Important!

The environment currently loads Spark version of 1.5.2 which has broken the spark-cassandra connector. I'll be working on that and hoping to learn how to uses branches in Git. 

## Slides 

- [DIY: R, Spark, Cassandra & Hadoop](https://docs.google.com/presentation/d/1rlSrjb9s697owHC3g0x8BnQLfpN1w-eTB-YVwfV_1dI/edit?usp=sharing) --- Instructions on setting up the virtual environment. 

- [Managing the Environment: R, Spark, Cassandra & Hadoop](https://docs.google.com/presentation/d/1j6clObu-HmqIfid-RrZTC-pRAZvhd7QXB4NmWbRfTC0/edit?usp=sharing)
--- Notes on managing the environment.

## Memory settings and requirements

- Your computer needs at least 4GB of RAM, but 8GB is helpful. 
- Memory settings for `virtualbuild` are set to 512MB and for `virtualbox1` are set to 2GB. 
- If you have 8GB of memory then the settings for `virtualbox1` could be increased to 4GB. 
  To do make this change before you create the virtual boxes with the `vagrant up` command, 
  then change `2048` on approximately line 25 of `Vagrantfile` to `4096`.
- To modify these memory settings after you have created your virtual boxes
    - `vagrant halt virtualbox1` from your shell
    - Open the VirtualBox GUI, select `virtualbox1`, click `Settings`, `System`
    - Then change the `Base Memory` settings
    - `vagrant up virtualbox11` from your shell
    
## Download and install programs

Download and install the following three programs for Windows and the first two for Mac. 

1. VirtualBox https://www.virtualbox.org/wiki/Downloads
1. Vagrant https://www.vagrantup.com/downloads.html
1. GitHub Desktop (Windows only) https://desktop.github.com. 
   After installation the application will start. Exit the application. 

## Setup

From a Git Shell on Windows or from a Terminal shell on Mac.
```
$ git clone https://github.com/davidoury/vbuild-rsch.git
$ cd vbuild-rsch
```

Configuration details for the creation of the virtual boxes are
contained in file `Vagrantfile` in the `vbuild-rsch` directory. 
By default the virtual machine `virtualbox1` is created, 
with the following command, to use 4GB of RAM from the host machine.
```
vb.customize ["modifyvm", :id, "--memory", "4096"]
```
If you machine has a total of 4GB of RAM then replace the line
above with the line below in file `Vagrantfile`. 
```
vb.customize ["modifyvm", :id, "--memory", "2048"]
```

Type the following to create both virtual boxes `virtualbuild` and `virtualbox1`.
```
$ vagrant up
```

Type the following to login (using SSH) to `virtualbuild`.
```
$ vagrant ssh virtualbuild
```

You are now logged into the virtual machine `virtualbuild`. 
Run the `bash` shell as the `root` user. 
```
$ sudo bash
```

From the `root` user load the Ansible setup files in `setup.tgz` and install Ansible. 
```
# cd /tmp
# tar xvzf /vagrant/setup.tgz 
# /tmp/install.sh
```

Material is downloaded into the `virtualbuild` virtual box. 
```
# /etc/ansible/1-build.sh
```
Answer `yes` when prompted with `(yes/no)?` <br>
Answer `hello` when prompted with `password:`

Create an account to use when connecting to RStudio. Set passwords for this account and for the `hadoop` and `hdfs` accounts. 
```
# /etc/ansible/2-accounts.sh
```

All programs and packages (R, Spark, Cassandra, HDFS and others) are installed and configured 
on the virtual box `virtualbox1`.
```
# /etc/ansible/3-setup.sh
```

## Management

All virtual machines can be shutdown from the VirtualBox GUI or 
from the command line with
```
$ cd vbuild-rsch
$ vagrant halt
```

The memory reserved by the virtual machines will be returned when the machines are shut down with these commands.

HDFS is setup to start when `virtualbox1` starts. 
Cassandra and Spark need to be started manually. 

### From the virtual build machine

The virtual machine `virtualbuild` is the _virtual build machine_.
To connect to `virtualbuild` from the command shell on your laptop 
run the commands
```
cd vbuild-rsch
vagrant ssh virtualbuild
```

To start and stop all of the Spark, Cassandra and HDFS services 
use the commands: 
```
# /etc/ansible/4-start.sh
# /etc/ansible/4-stop.sh
```

### From the virtual cluster machines 

A _virtual cluster machine_ is a machine that runs any of the
Spark, Cassandra or HDFS services.
The virtual machine `virtualbox1` is the only such machine 
in the default configuration. 
To connect to `virtualbox1` from the command shell on your laptop 
run the commands
```
cd vbuild-rsch
vagrant ssh virtualbox1
```
Once connected  you will be running a shell from the `vagrant` user account 
and the command prompt will look like 
```
[vagrant@box1 ~]$
```

Each of the commands in this section should be run by the `root` account. 
From the `vagrant` account run the following command to run a shell 
in the `root` account (from which you can run these commands.)
```
$ sudo bash
```
Notice that the command prompt ends with a `#`. 
This indicates that the shell is run by the `root` account. 

To start and stop Cassandra use the commands:
```
# service cassandra start
# service cassandra stop
```

Cassandra log files can be viewed with the commands:
```
# less /var/log/cassandra/system.log
# less /var/log/cassandra/cassandra.log
```

To start and stop the Spark master: 
```
# $SPARK_HOME/sbin/start-master.sh 
# $SPARK_HOME/sbin/stop-master.sh 
```

To start and stop Spark workers: 
```
# $SPARK_HOME/sbin/start-slave.sh spark://box1.cluster.bentley.edu:7077
# $SPARK_HOME/sbin/stop-slave.sh 
```

To stop and start the HDFS name node: 
```
# service hadoop-hdfs-namenode start
# service hadoop-hdfs-namenode stop
```

To stop and start a HDFS data node: 
```
# service hadoop-hdfs-datanode start
# service hadoop-hdfs-datanode stop
```

## Configuration

### Spark configuration

### Cassandra configuration

### HDFS configuration

## Examples

### HDFS
Login to the `hdfs` account. 
```
$ su -l hdfs
```
Copy a couple files into HDFS.
```
$ hdfs dfs -copyFromLocal /opt/spark-1.4.1-bin-cdh4/README.md /
$ wget https://s3-us-west-2.amazonaws.com/bentley-psap/iris.csv
$ hdfs dfs -copyFromLocal iris.csv /
```
Check for them.
```
$ hdfs dfs -ls / 
Found 2 items
-rw-r--r--   3 hdfs hadoop       3624 2015-10-23 13:34 /README.md
-rw-r--r--   3 hdfs hadoop       4821 2015-10-23 15:19 /iris.csv
$ hdfs dfs -cat /README.md
[contents of the README.md file]
```

### Casssandra

Start the Cassandra Query Language shell `cqlsh`.
```
$ cqlsh box1
[cqlsh 5.0.1 | Cassandra 2.2.3 | CQL spec 3.3.1 | Native protocol v4]
Use HELP for help.
```

Create a _keyspace_ called `test`.
Tables created in that keyspace are not replicated as we have only a single node cluster.
```
cqlsh> create keyspace test with replication = {'class':'SimpleStrategy',
                                                'replication_factor': 1};
```

Create the `city` table in the `test` keyspace with text variable `name` as the primary key and an integer variable `population`. 
```
cqlsh> create table test.city (name text primary key, population int);
```

Insert data into table `city`.
```
cqlsh> insert into test.city (name, population) values ('Shanghai', 24150000);
cqlsh> insert into test.city (name, population) values ('Karachi',  23500000);
cqlsh> insert into test.city (name, population) values ('Lagos',    21324000);
cqlsh> insert into test.city (name, population) values ('Delhi',    16787941);
cqlsh> insert into test.city (name, population) values ('Tianjin',  14722100);
```

Display all rows from the `city` table.
```
cqlsh> select * from test.city;
```

#### Cassandra documentation

This environment runs Cassandra 2.2.3 from the [Datastax community edition](http://www.planetcassandra.org/cassandra/). 

- [DataStax Cassandra 2.2](http://docs.datastax.com/en/cassandra/2.2/cassandra/cassandraAbout.html) 
- [CQL for Cassandra 2.2](http://docs.datastax.com/en/cql/3.3/cql/cqlIntro.html) --- Documentation on using the Cassandra Query Language (CQL) and the CQL shell (`cqlsh`).

### Scala Spark shell 

Start the Spark shell `spark-shell`,
from any account except `root`.
```
$ spark-shell
[lots of output]
sc: org.apache.spark.SparkContext = org.apache.spark.SparkContext@542aba71
```

The following sends `Array(1,2,3)` to the spark cluster with the `parallelize` command and then retreives this data with the collect commnd. 
```scala
scala> val rdd = sc.parallelize(Array(1,2,3))
scala> rdd.collect()
res1: Array[Int] = Array(1, 2, 3)
```

#### Built-in HDFS support

The following reads the `README.md` file from HDFS into a Spark RDD and then retrieves this data with the `collect` command.
```scala
scala> val rdd = sc.textFile("hdfs://box1/README.md")
scala> rdd.collect()
res2: Array[String] = Array(# Apache Spark, "", Spark is a fast and general cluster computing system for Big Data. It provides, high-level APIs in Scala, Java, and Python, and [more output] ...
``` 

#### Spark Cassandra Connector

The Spark Cassandra connector is a library which allows the use of Cassandra from Spark.
The library and documention on its use are available on GitHub at

- https://github.com/datastax/spark-cassandra-connector

It is installed in this environment and so doesn't require additional configuration.
Functions are added to the spark context object `sc` made available in the Spark shells below (`spark-shell`, `sparkR`, `pyspark`) to connect to (read from, write to) a Cassandra database. 
The example below assumes that you have created and inserted rows into the `city` table in the [Cassandra](#casssandra) section.

Read the `city` table of the `test` keyspace from Cassandra into a Spark RDD. 
```scala
scala> val rdd = sc.cassandraTable("test", "city")
scala> rdd.collect()
scala> rdd.collect().foreach(println)
```

Insert into the `city` table of the `test` keyspace from Cassandra.
```scala
scala> val collection = sc.parallelize(Seq(("Boston", 655884), 
                                           ("Los Angeles", 3928864), 
                                           ("New York", 8175133)))
scala> collection.saveToCassandra("test", "city", SomeColumns("name", "population"))
```

Check that these rows were inserted in the `city` table of the `test` keyspace.
```scala
scala> val rdd = sc.cassandraTable("test", "city")
scala> rdd.collect().foreach(println)
```

### Spark and R

Spark can be called from R in two ways: 

1. From RStudio
1. From the `sparkR` shell

Below are sections for both. 
The RStudio examples seem to be more problematic. 

#### SparkR from RStudio 

Go to http://localhost:8787 with a browser. 
In the console you should see
```
Attaching package: ‘SparkR’

The following objects are masked from ‘package:base’:

    intersect, sample, table

Launching java with spark-submit command /opt/spark-1.4.1-bin-cdh4/bin/spark-submit   sparkr-shell /tmp/Rtmp11GIa5/backend_port4efc7c062a86 
```

From the R console run 
```
> sqlContext <- sparkRSQL.init(sc) 
```

[I'll update this as I learn more.]

#### SparkR shell (`sparkR`)

```r
> iris.DF <- createDataFrame(sqlContext, iris) 
[warnings]
> iris.DF
DataFrame[Sepal_Length:double, Sepal_Width:double, Petal_Length:double, Petal_Width:double, Species:string]
> head(iris.DF, 5)
```

```r
registerTempTable(iris.DF, "iris.sql")
large.iris <- sql(sqlContext, "select * from iris.sql where Sepal_Width < 3.0")
head(large.iris)
```

```r
> head(summarize(groupBy(iris.DF, iris.DF$Species), count = n(iris.DF$Species)))
```


Similar problems (to above with RStudio) reading a CSV file from HDFS or the local filesystem. 
I'll install Spark 1.5.1 and try again. 

#### SparkR sources

- https://spark.apache.org/releases/spark-release-1-4-1.html
- http://spark.apache.org/docs/1.4.1/sparkr.html
- http://spark.apache.org/docs/1.4.1/programming-guide.html
- http://www.r-bloggers.com/spark-1-4-for-rstudio/

### Python Spark shell 

Start `pyspark` shell. 
```
$ pyspark --master spark://box1.cluster.bentley.edu:7077 
[lots of output]
SparkContext available as sc, HiveContext available as sqlContext.
```

Send the sequence `[1, 2, 3, 4, 5]` to Spark to store in an RDD. 
```python
>>> data = [1, 2, 3, 4, 5]
>>> distData = sc.parallelize(data)
>>> data
>>> distData
```

Retreive the first 3 values. 
```python
>>> distData.take(3)
[1, 2, 3]
```

Read a text file from the local file system.
```
>>> distFile = sc.textFile("file:///etc/hosts")
>>> distFile.collect()
>>> distFile.first()
```

Read a text file from HDFS.
```
>>> distFile = sc.textFile("hdfs://box1.cluster.bentley.edu/README.md")
>>> distFile.collect()
>>> distFile.first()
```

A sample map-reduce program.
```
>>> distFile.map(lambda aline: len(aline))
>>> distFile.map(lambda aline: len(aline)).collect()
>>> distFile.map(lambda aline: len(aline)).reduce(lambda a, b: a+b)
```

#### HDFS examples

To read the `README.md` file from HDFS. 
```python
>>> rdd = sc.textFile("hdfs://box1/README.md")
>>> rdd
MapPartitionsRDD[1] at textFile at NativeMethodAccessorImpl.java:-2
```

Retrieve the first five rows.
```python
>>> rdd.take(5)
```

#### Python sources

- http://spark.apache.org/docs/1.4.1/programming-guide.html


## [in progress stuff]

- [linux tutorial](http://www.ee.surrey.ac.uk/Teaching/Unix/unix1.html)

## test

- asdfasdf asdf 