#!/bin/sh

nidaba worker &
nidaba api_server -b 0.0.0.0:8080
