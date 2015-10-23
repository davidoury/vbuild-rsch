# Virtual R, Spark, Cassandra and HDFS 

Vagrant, Virtualbox and Ansible are used to create a virtualbox which runs R, Spark, Cassandra and HDFS.

## Slides 

- [DIY: R, Spark, Cassandra & Hadoop](https://docs.google.com/presentation/d/1rlSrjb9s697owHC3g0x8BnQLfpN1w-eTB-YVwfV_1dI/edit?usp=sharing) --- Instructions on setting up the virtual environment. 

- [Managing the Environment: R, Spark, Cassandra & Hadoop](https://docs.google.com/presentation/d/1j6clObu-HmqIfid-RrZTC-pRAZvhd7QXB4NmWbRfTC0/edit?usp=sharing)
--- Notes on managing the environment.

## Setup

From a Git Shell on Windows or from a Terminal shell on Mac.
```
$ cd vbuild-rsch
$ vagrant up
$ vagrant ssh virtualbulid
```

You are now logged into the virtual machine `virtualbuild`. Run a shell from the `root` user. 
```
$ sudo bash
```

From the `root` user load the Ansible setup files in `setup.tgz` and install Ansible. 
```
# cd /tmp
# tar xvzf /vagrant/setup.tgz 
# /tmp/install.sh
```

```
# /etc/ansible/1-build.sh
```
Answer `yes` when prompted with `(yes/no)?` <br>
Answer `hello` when prompted with `password:`

Create an account to use when connecting to RStudio. Set passwords for this account and for the `hadoop` and `hdfs` accounts. 
```
# /etc/ansible/2-accounts.sh
```
```
# /etc/ansible/3-setup.sh
```
```
# /etc/ansible/4-start.sh
```

## Connector tests

### HDFS
```
$ su -l hdfs
$ 
```