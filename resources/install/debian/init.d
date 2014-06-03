#! /bin/sh
#
# INIT script for Jitsi Videobridge
# Version: 1.0  01-May-2014  yasen@bluejimp.com
#
### BEGIN INIT INFO
# Provides:          jitsi-videobridge
# Required-Start:    $local_fs
# Required-Stop:     $local_fs
# Default-Start:     2 3 4 5
# Default-Stop:      0 1 6
# Short-Description: Jitsi Videobridge
# Description:       WebRTC compatible Selective Forwarding Unit (SFU)
### END INIT INFO

# Include videobridge defaults if available
if [ -f /etc/default/jitsi-videobridge ]; then
    . /etc/default/jitsi-videobridge
fi

PATH=/usr/local/sbin:/usr/local/bin:/sbin:/bin:/usr/sbin:/usr/bin
DAEMON=/opt/jitsi-videobridge/current/jvb.sh
NAME=jvb
USER=jvb
PIDFILE=/var/run/jitsi-videobridge.pid
LOGFILE=/var/log/jitsi/jvb.log
DESC=jitsi-videobridge
DAEMON_OPTS=" --host=localhost --domain=$JVB_HOSTNAME --port=$JVB_PORT --secret=$JVB_SECRET"

test -x $DAEMON || exit 0

set -e

case "$1" in
  start)
    if [ -x $PIDFILE ]; then
        echo "Pidfile $PIDFILE exists. Either Jitsi Videobridge is already running or there was some problem. Investgate before starting."
        exit 1
    fi
    echo -n "Starting $DESC: "
    start-stop-daemon --start --quiet --background --chuid $USER --make-pidfile --pidfile $PIDFILE \
        --exec /bin/bash -- -c "exec $DAEMON $DAEMON_OPTS < /dev/null >> $LOGFILE 2>&1"
    echo "$NAME."
    ;;
  stop)
# FIXME
    echo -n "Stopping $DESC: "
    killall java
    rm $PIDFILE
#    start-stop-daemon --stop --quiet --exec $DAEMON
    echo "$NAME."
    ;;
  *)
    N=/etc/init.d/$NAME
# FIXME
    # echo "Usage: $N {start|stop|restart|reload|force-reload}" >&2
    echo "Usage: $N {start|stop}" >&2
    exit 1
    ;;
esac

exit 0
