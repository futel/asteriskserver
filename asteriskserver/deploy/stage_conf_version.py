#!/usr/bin/env python
# given prod conf version, print stage conf version

import sys

def main(lines):
    prod_to_stage = {'foo': 'bar', 'bar': 'foo'}
    lines = set([line.strip() for line in lines])
    if len(lines) != 1:
        raise Exception
    return prod_to_stage[lines.pop()]

if __name__ == "__main__":
    print main(sys.stdin)
