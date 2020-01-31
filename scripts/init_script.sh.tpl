#!/bin/bash

cd /home/ubuntu/app
sudo npm install ejs express mongoose
export DB_HOST=mongodb://${db-ip}:27017/posts
node seeds/seed.js
node app.js
