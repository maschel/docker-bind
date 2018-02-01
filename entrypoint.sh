#!/bin/sh
set -e

BIND_DATA_DIR=${DATA_DIR}/bind

create_bind_data_dir() {
	mkdir -p ${BIND_DATA_DIR}

	# Copy default config files (if none existing) and set default parameters
	if [ ! -d ${BIND_DATA_DIR}/etc ]; then
		mv /etc/bind ${BIND_DATA_DIR}/etc
		chown -R ${BIND_USER}:${BIND_USER} ${BIND_DATA_DIR}/etc
		chmod -R o+rX ${BIND_DATA_DIR}/etc

		# Enable recursive DNS by default and listen on all interfaces
		mv ${BIND_DATA_DIR}/etc/named.conf.recursive ${BIND_DATA_DIR}/etc/named.conf
		mv ${BIND_DATA_DIR}/etc/named.conf.authoritative ${BIND_DATA_DIR}/etc/named.conf.example.authoritative
		sed -i '/listen-on/s/^/\t\/\//' ${BIND_DATA_DIR}/etc/named.conf
	fi
	# Remove old location and create symlink
	rm -rf /etc/bind
	ln -sf ${BIND_DATA_DIR}/etc /etc/bind


	# Copy var files
	if [ ! -d ${BIND_DATA_DIR}/var ]; then
		mv /var/bind ${BIND_DATA_DIR}/var
		chown -R ${BIND_USER}:${BIND_USER} ${BIND_DATA_DIR}/var
		chmod -R o+rX ${BIND_DATA_DIR}/var
	fi
	# Remove old location and create symlink
	rm -rf /var/bind
	ln -sf ${BIND_DATA_DIR}/var /var/bind
}

create_pid_dir() {
	mkdir -m 0775 -p /var/run/named
	chown root:${BIND_USER} /var/run/named
}

# Prepare bind environment
create_pid_dir
create_bind_data_dir

# allow arguments to be passed to named
if [ "${1%"${var#?}"}" = '-' ]; then
	EXTRA_ARGS="$@"
	set --
elif [ ${1} = named ]; then
	EXTRA_ARGS="${1##named}"
	set --
elif [ ${1} = $(which named) ]; then
	EXTRA_ARGS="${1##$(which named)}"
	set --
fi

# By default start named
if [ -z ${1} ]; then
	echo "Starting named..."
	exec $(which named) -u ${BIND_USER} -g ${EXTRA_ARGS}
else
	exec "$@"
fi
