#/usr/bin/sh
scp -o 'ProxyCommand ssh nu_guos@submit-3.chtc.wisc.edu nc %h %p' shg047@23.99.137.107:/home/shg047/data1/fastq/* ./
scp -o 'ProxyCommand ssh nu_guos@submit-3.chtc.wisc.edu nc %h %p' shg047@23.99.137.107:/home/shg047/data2/*gz ./
scp -o 'ProxyCommand ssh nu_guos@submit-3.chtc.wisc.edu nc %h %p' shg047@23.99.137.107:/home/shg047/data3/*gz ./
