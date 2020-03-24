#!/bin/sh

# Pass the number of active nodemangers in Hadoop to run-dfsio, i.e. if you have 3 active nodemanagers, run ./run-dfsio.sh 3

nodes=$1
shift

# The default size is 1000000 MB or 1TB, change the size as needed.
size=1000000

# Transactions per node is dependent on the amount of memory and cpu available per nodemanager, change this as needed, 50 is the default. 
tpn=50

# Number of files and file size is calculated for you based on the number of active nodemanagers and data size.
files=$((tpn * nodes))
fsize=$((size / files))

# We run three passes of write, read, and cleans so you can determine the write and read averages.  
# Note:  Default block size here is 256MB, not 128MB.  Change this to match your Hadoop dfs.blocksize setting.
# Note: This assumes HDP Hadoop Distribution being used, if using CDH or CDP, change jar directory accordingly.

for count in {1..3}
do
    for action in write read clean
    do
        yarn jar /usr/hdp/current/hadoop-mapreduce-client/hadoop-mapreduce-client-jobclient-tests.jar TestDFSIO \
-D dfs.blocksize=268435456 -D test.build.data=/tmp/testdfsio -${action} -nrFiles $files -size ${fsize}MB
    done
done
