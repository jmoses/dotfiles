#!/bin/bash

echo Fetching pinset for $1

echo | /usr/local/Cellar/openssl/1.0.2o_1/bin/openssl s_client -connect "$1:853" 2>/dev/null | /usr/local/Cellar/openssl/1.0.2o_1/bin/openssl x509 -pubkey -noout | /usr/local/Cellar/openssl/1.0.2o_1/bin/openssl pkey -pubin -outform der | /usr/local/Cellar/openssl/1.0.2o_1/bin/openssl dgst -sha256 -binary | /usr/local/Cellar/openssl/1.0.2o_1/bin/openssl enc -base64
