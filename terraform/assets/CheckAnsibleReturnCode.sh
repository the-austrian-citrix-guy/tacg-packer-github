#!/bin/bash

FILE="$1"
TEXT="$2"

if grep -qE "$TEXT" "$FILE"; then
  echo "{\"found\": \"1\"}"
else
  echo "{\"found\": \"0\"}"
fi
