echo
echo "Check synchronize module."

mkdir ./a
echo aaa > ./a/1.txt

ansible localhost -m synchronize -a 'src=./a dest=./b'
