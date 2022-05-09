#!/usr/bin/env bash

cat /tmp/extensions.txt | while read extension || [[ -n $extension ]];
do
  code-server --install-extension $extension --force
done
