#!/bin/bash
url="http://localhost"
while ! curl "$url/setup/alive"
do
    echo -n "."
    sleep 1
done
