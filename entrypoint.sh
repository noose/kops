#!/bin/bash
set -ex

response=$(bash -c $*)

echo "::set-output name=response::$response"
