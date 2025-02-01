if [[ "$(uname)" == "Linux" ]]; then
	if uwsm check may-start > /dev/null 2&>1 && uwsm select; then
		exec systemd-cat -t uwsm_start uwsm start default
	fi
fi


