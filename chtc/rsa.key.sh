ssh-keygen -t rsa
ssh nu_guos@128.105.244.191 'mkdir -p .ssh'
cat .ssh/id_rsa.pub | ssh nu_guos@128.105.244.191 'cat >> .ssh/authorized_keys'
cat .ssh/id_rsa.pub | ssh nu_guos@128.105.244.191 'chmod 700 ~/.ssh'
#cat .ssh/id_rsa.pub | ssh nu_guos@128.105.244.191 'chmod 640 ~/.ssh/authorized_keys2'
#cat .ssh/id_rsa.pub | ssh nu_guos@128.105.244.191 'cat >> .ssh/authorized_keys2'
ssh nu_guos@128.105.244.191
alias chtc="ssh nu_guos@submit-1.chtc.wisc.edu"


