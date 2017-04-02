echo
echo "galaxy install should not always warn."

ansible-galaxy -p roles install gzm55.require_disabe_become 2>&1 | tee test-role-spec-issue-14612.txt

! grep 'The comma separated role spec format' test-role-spec-issue-14612.txt
