
as root:
 /usr/local/bin/jackd -R -d dummy -r 44100
 /usr/local/bin/pd -nrt -jack -nogui -channels 1 voice_follow.pd
