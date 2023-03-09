#!/bin/bash
echo "Installing Go..."
rm -rf /usr/local/go
curl -fL https://go.dev/dl/go1.20.2.linux-amd64.tar.gz | tar -C /usr/local -xzf -