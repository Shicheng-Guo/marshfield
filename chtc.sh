ssh-keygen -t rsa
ssh nu_guos@submit-3.chtc.wisc.edu mkdir -p .ssh
cat .ssh/id_rsa.pub | ssh nu_guos@submit-3.chtc.wisc.edu 'cat >> .ssh/authorized_keys'
cat .ssh/id_rsa.pub | ssh nu_guos@submit-3.chtc.wisc.edu 'cat >> .ssh/authorized_keys2'
cat .ssh/id_rsa.pub | ssh nu_guos@submit-3.chtc.wisc.edu 'chmod 700 ~/.ssh'
cat .ssh/id_rsa.pub | ssh nu_guos@submit-3.chtc.wisc.edu 'chmod 640 ~/.ssh/authorized_keys2'
ssh nu_guos@submit-3.chtc.wisc.edu
alias chtc="ssh nu_guos@submit-3.chtc.wisc.edu"
