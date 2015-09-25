ansible-playbook /etc/ansible/4-manage.yaml \
	--tags start_spark_master,start_spark_workers,start_hdfs_namenode,start_hdfs_datanodes,start_dsc_seeds,start_dsc_nonseeds,start_rstudio_server
