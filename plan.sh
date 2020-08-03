#!/usr/bin/env bash

name="pub"

terraform plan -var myip=$1 -var name=$name -parallelism=20
