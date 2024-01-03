#!/bin/bash

sudo apt update
sudo apt install -y apache2

echo "<html><body><h1>A simple website</h1></body></html>" > /var/www/html/index.html
