#!/bin/bash
cd /usr/share/selinux/default || exit 1

SEP="my %Deps = ("
semodule_deps base.pp a*pp backup.pp b[i-z]*pp [c-z]*pp | while read INPUT ; do
  echo $INPUT | grep -q ^module
  if [ "$?" = "0" ]; then
    MODULE=$(echo $INPUT|sed -e s/^module..//)
  else
    echo $INPUT | grep -q "no dependencies"
    if [ "$?" = "1" -a "$INPUT" != "}" ]; then
      echo -n "$SEP"
      SEP=", "
      echo -n " '$MODULE' => '$INPUT'"
    fi
  fi
done

echo " );"
