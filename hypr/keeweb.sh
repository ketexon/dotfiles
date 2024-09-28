#!/bin/bash

if [ -d ~/builds/keeweb ]
then
	echo "Starting KeeWeb server on 8079..."
	python3 -m http.server -d ~/builds/keeweb 8079
else
	echo "Could not find keeweb."
fi
