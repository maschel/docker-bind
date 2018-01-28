#!/bin/bash
set -e

BIND_DATA_DIR=${DATA_DIR}/bind

create_bind_data_dir() {
	mkdir -p ${BIND_DATA_DIR}

	# Copy default config files (if none existing) and set default parameters
	if [ ! -d ${BIND_DATA_DIR}/etc ]; then
		mv /etc/bind ${BIND_DATA_DIR}/etc

		# Set BIND PID and key dir 
		sed -i '/options {/ a\	pid-file "/var/run/named/named.pid";' ${BIND_DATA_DIR}/etc/named.conf.options
		sed -i '/options {/ a\	key-directory "/var/key/bind";' ${BIND_DATA_DIR}/etc/named.conf.options
	fi
	# Remove old location and create symlink
	rm -rf /etc/bind
	ln -sf ${BIND_DATA_DIR}/etc /etc/bind
	chmod -R 0775 ${BIND_DATA_DIR}
	chown -R ${BIND_USER}:${BIND_USER} ${BIND_DATA_DIR}

	# Copy lib files
	if [ ! -d ${BIND_DATA_DIR}/lib ]; then
		mkdir -p ${BIND_DATA_DIR}/lib
		chown ${BIND_USER}:${BIND_USER} ${BIND_DATA_DIR}/lib
	fi
	# Remove old location and create symlink
	rm -rf /var/lib/bind
	ln -sf ${BIND_DATA_DIR}/lib /var/lib/bind
}

create_pid_dir() {
	mkdir -m 0775 -p /var/run/named
	chown root:${BIND_USER} /var/run/named
}

create_bind_cache_dir() {
	mkdir -m 0775 -p /var/cache/bind
	chown root:${BIND_USER} /var/cache/bind
}

create_bind_key_dir() {
	mkdir -m 0775 -p /var/key/bind
	chown root:${BIND_USER} /var/key/bind
}

# Prepare bind environment
create_pid_dir
create_bind_key_dir
create_bind_data_dir
create_bind_cache_dir

# allow arguments to be passed to named
if [[ ${1:0:1} = '-' ]]; then
	EXTRA_ARGS="$@"
	set --
elif [[ ${1} == named || ${1} == $(which named) ]]; then
	EXTRA_ARGS="${@:2}"
	set --
fi

# By default start named
if [[ -z ${1} ]]; then
	echo "Starting named..."
	exec $(which named) -u ${BIND_USER} -g ${EXTRA_ARGS}
else
	exec "$@"
fi
