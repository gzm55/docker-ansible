echo
echo "Check ability of crypting the password from prompt."

echo 123 | ansible-playbook -i inv test-passwd-crypt.yml
