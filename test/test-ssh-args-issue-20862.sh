echo
echo "Check ansible_ssh_extra_args is not ignored when ansible_ssh_executable is set."

ansible all \
        -i $(dirname "$0")/test-ssh-args-issue-20862.inv \
        -e ansible_ssh_executable=echo \
        -e ansible_ssh_common_args=AA \
        -e ansible_ssh_extra_args=BB \
        -m raw \
        -a exit \
| grep "AA.*BB\|BB.*AA"
