# Specify the HTCondor Universe (vanilla is the default and is used
#  for almost all jobs), the desired name of the HTCondor log file,
#  and the desired name of the standard error and standard output file.
universe = vanilla
log = process.log
error = process.err
output = process.out
#
# Specify your executable (single binary or a script that runs several 
# commands) and arguments
executable = run_cv_one_step_nmspe_v2.sh
arguments = v84 para_file.mat EM_res.mat session_idx.txt l_val.txt cv_idx.txt
#
# Specify that HTCondor should transfer files to and from the
#  computer where each job runs.
should_transfer_files = YES
when_to_transfer_output = ON_EXIT
# Set the submission directory for each job with the $(directory)
# variable (set below in the queue statement).  Then transfer all
# files in the shared directory, and from the input folder in the
# submission directory
initialdir = $(directory)
transfer_input_files = ../shared/,EM_res.mat,session_idx.txt,l_val.txt,cv_idx.txt,http://proxy.chtc.wisc.edu/SQUID/r2014b.tar.gz
max_retries = 5
#
# Tell HTCondor what amount of compute resources
#  each job will need on the computer where it runs.
request_cpus = 1
request_memory = 2GB
request_disk = 2GB
#
# UW Grid and OSG
#
+WantFlocking = true
+WantGlideIn = true
#
# Create a job for each "job" directory.
queue directory matching job*
