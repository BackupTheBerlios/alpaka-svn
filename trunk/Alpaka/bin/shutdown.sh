#!/bin/sh
# -----------------------------------------------------------------------------
# Stop Script for the Alpaka Web Server
# -----------------------------------------------------------------------------
PRG="$0"
PRGDIR=`dirname "$PRG"`
EXECUTABLE=alpakad.pl
exec "$PRGDIR"/"$EXECUTABLE" stop
