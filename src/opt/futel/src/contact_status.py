#!/usr/bin/env python3
"""
Print an <extension> <status> line for each current contact in asterisk.
"""

import collections
import re
import subprocess

# match a sip extension
# Contact:  630/sip:630@192.168.56.1;transport=udp         9aa59cc6c8 Avail        11.957
extension_re = re.compile("([0-9][0-9][0-9])/sip:[0-9][0-9][0-9]")

#   Contact:  <Aor/ContactUri..............................> <Hash....> <Status> <RTT(ms)..>
# ==========================================================================================

#   Contact:  630/sip:630@192.168.56.1;transport=udp         9aa59cc6c8 Avail        11.957
#   Contact:  twilio-aors/sip:futel.pstn.twilio.com          b4a31af920 NonQual         nan
#   Contact:  voipms-aor/sip:185060_dev-oscule@sanjose.voip. fd346d1b7c NonQual         nan

# Objects found: 3

Line = collections.namedtuple('Line', ['line', 'extension', 'status'])

def get_contact_lines():
    """Return Lines from contact lines from asterisk."""
    lines = subprocess.run(
        ["/sbin/asterisk", "-cx", "pjsip show contacts"],
        stdout=subprocess.PIPE)
    lines = [line.decode('ascii') for line in lines.stdout.splitlines()]
    lines = [line for line in lines
             if line.strip().startswith("Contact")]
    return [
        Line(line=line, extension=None, status=None) for line in lines]

def get_extension_lines(lines):
    """Return filtered and populated Lines from lines."""
    # filter for lines with extension
    lines = [
        Line(line=line.line,
             extension=extension_re.search(line.line), status=None)
        for line in lines]
    lines = [line for line in lines if line.extension]
    # extract extension
    lines = [
        Line(line=line.line,
             extension=line.extension.group(1),
             status=None) for line in lines]
    # extract status
    lines = [
        Line(line=line.line,
             extension=line.extension,
             status=line.line.split()) for line in lines]
    lines = [
        Line(line=line.line,
             extension=line.extension,
             status=line.status[3]) for line in lines]
    # we are done
    return lines

# for (line) in lines:
#     print(line.extension, line.status)
