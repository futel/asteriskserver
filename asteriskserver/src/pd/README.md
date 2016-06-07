
as root:
* sudo -u asterisk /usr/local/bin/jackd -R -d dummy -r 16000
* sudo -u asterisk /usr/local/bin/pd -nogui -rt -jack -channels 1 voice_follow.pd
