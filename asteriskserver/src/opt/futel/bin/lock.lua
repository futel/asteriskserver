#!/usr/bin/env lua

-- create lockfile to block systems during stage promotion

package.path = package.path .. ';/etc/asterisk/?.lua'

util = require("util")

util.lockfile_create()
