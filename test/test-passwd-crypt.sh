echo
echo "Check ability of crypting the password from prompt."

echo "" \
| ansible-playbook test-passwd-crypt.yml 2>&1 \
| grep 'ERROR! Unexpected Exception: secret must be unicode or bytes, not None' \
&& echo "See the expected exception."
