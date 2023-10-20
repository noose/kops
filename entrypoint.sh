#!/bin/sh
set -ex

response=$(sh -c "$*")

echo "::set-output name=response::$response"
