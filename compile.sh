#!/bin/sh

gcc -o recycle -framework CoreServices -framework Cocoa recycle.m
touch test1.todelete something.todelete test2.todelete
ln -s something.todelete link.todelete
