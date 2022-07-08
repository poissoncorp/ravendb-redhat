#!/bin/bash
COMMAND="./Raven.Server"
RAVEN_ServerUrl="http://$(uname -n):8080"
[ -z "$RAVEN_ServerUrl" ] && export RAVEN_ServerUrl
if [ -n "$RAVEN_SETTINGS" ]; then
    echo "$RAVEN_SETTINGS" > settings.json
fi

if [ -n "$RAVEN_ARGS" ]; then
	COMMAND="$COMMAND ${RAVEN_ARGS}"
fi

handle_term() {
    if [ "$COMMANDPID" ]; then
        kill -TERM "$COMMANDPID" 2>/dev/null
    else
        TERM_KILL_NEEDED="yes"
    fi
}

unset COMMANDPID
unset TERM_KILL_NEEDED
trap 'handle_term' TERM INT

[ -n "$RAVEN_DATABASE" ] && export RAVEN_Setup_Mode=None
"$COMMAND" &
COMMANDPID=$!

[ -n "$RAVEN_DATABASE" ]  && source ./server-utils.sh && create-database

[ "$TERM_KILL_NEEDED" ] && kill -TERM "$COMMANDPID" 2>/dev/null 
wait $COMMANDPID 2>/dev/null
trap - TERM INT
wait $COMMANDPID 2>/dev/null