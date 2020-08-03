#!/usr/bin/env bash

name="pub"

terraform apply -var myip=$1 -var name=$name -parallelism=20
