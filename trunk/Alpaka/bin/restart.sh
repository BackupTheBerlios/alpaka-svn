#!/bin/sh
# -----------------------------------------------------------------------------
# ReStart Script for the Alpaka Web Server
# -----------------------------------------------------------------------------
export PERL5LIB=

PRG="$0"
PRGDIR=`dirname "$PRG"`
EXECUTABLE=alpakad.pl
exec "$PRGDIR"/"$EXECUTABLE" restart
