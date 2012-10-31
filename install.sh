#!/bin/bash
npm install --production
echo "looking for coffee:"
which coffee || sudo npm install coffee-script -g

echo "done"
