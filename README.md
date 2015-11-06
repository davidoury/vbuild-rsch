# Virtual R, Spark, Cassandra and HDFS 

Vagrant, Virtualbox and Ansible are used to create a virtualbox which runs R, Spark, Cassandra and HDFS.

Table of contents: 

- [Slides](#slides)
- [Memory settings and requirements](#memory-settings-and-requirements)
- [Setup](#setup)
- [Management](#management)
- [Examples](#examples)



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

## Setup

From a Git Shell on Windows or from a Terminal shell on Mac.
```
$ git clone https://github.com/davidoury/vbuild-rsch.git
$ cd vbuild-rsch
$ vagrant up
$ vagrant ssh virtualbulid
```

You are now logged into the virtual machine `virtualbuild`. Run the `bash` shell as the `root` user. 
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

All services are started with:
```
# /etc/ansible/4-start.sh
```

All services are stopped with:
```
# /etc/ansible/4-stop.sh
```
Shutting down the machines from the VirtualBox GUI or from the command line with
```
$ cd vbuild-rsch
$ vagrant halt
```
will also stop the services. In addition, the memory reserved by the virtual machines will be returned when the machines are shut down from the VirtualBox GUI or by using the two commands above. 

To stop and start Cassandra: 
```

```

To stop and start Spark: 
```

```

To stop and start HDFS: 
```

```

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

### Scala Spark shell (`spark-shell`)

From any account, except `root`, run the following.
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

### Python Spark shell (`pyspark`)

Start the shell.
```
$ pyspark
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

#### HDFS

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