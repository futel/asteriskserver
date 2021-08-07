#!/usr/bin/env python3

import challenge
challenge.set_challenge_value("foo", "bar")
value = challenge.has_challenge_value("foo", "bar")
assert(value == True)
value = challenge.has_challenge_value("foo", "baz")
assert(value == False)
