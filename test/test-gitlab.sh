echo
echo "Check gitlab module."

out=$(mktemp)
ansible-playbook test-gitlab.yml > "$out" 2>&1 || :

if grep 'missing required arguments' "$out"; then
  echo "[ERROR] play is not valid"
  exit 1
fi

if grep 'Failed to import the required Python library' "$out"; then
  echo "[ERROR] dependency is not installed"
  exit 2
fi

rm -f "$out" || :

exit 0
