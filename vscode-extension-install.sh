#!/usr/bin/env bash

cat /tmp/extensions.txt | while read extension || [[ -n $extension ]]
done
