echo
echo "Check ability of lookup from keyring."

ssh-keygen -t rsa -P '' -C "tmp rsa for testing keyring and sagecipher" -f ./tmp_id_rsa
eval $(ssh-agent)
ssh-add ./tmp_id_rsa

export PYTHON_KEYRING_BACKEND=sagecipher.keyring.Keyring 
echo 'test-pwd' | keyring set test-svc test-user

ansible localhost -m 'debug' -a 'msg={{ lookup("keyring", "test-svc test-user") }}' | grep 'test-pwd'
