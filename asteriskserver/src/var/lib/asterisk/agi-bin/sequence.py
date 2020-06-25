#!/usr/bin/env python
"""
Sequence challenge.
"""

#DIGIT_PAUSE = 0.1
#ELEMENT_PAUSE = 0.25
sound_dirname = "/opt/asterisk/var/lib/asterisk/sounds/futel/sequence-challenge/"

def play_sound(agi_o, name, pause=750):
    name = sound_dirname + name
    agi_o.appexec("background", name)
    if pause:
        agi_o.wait_for_digit(pause)

def play_element(agi_o, elt):
    play_sound(agi_o, "seperator")
    play_sound(agi_o, "dtmf" + elt)
    #agi_o.appexec("SendDTMF", elt)
    #agi_o.Wait(ELEMENT_PAUSE)

def play_sequence_prefix(agi_o, sequence, prefix_len):
    play_sound(agi_o, "sequence-prefix-follows")
    play_sound(agi_o, "start-of-sequence")
    for elt in sequence[0:prefix_len]:
        play_element(agi_o, elt)

def accept_next_sequence_element(agi_o, expected):
    """Accept keypresses, return True if they match element."""
    play_sound(agi_o, "seperator", pause=None)
    received = ""
    for character in expected:
        digit = str(agi_o.wait_for_digit(timeout=-1))
        received = received + digit
    if received == expected:
        play_sound(agi_o, "element-correct")
        return True
    play_sound(agi_o, "element-incorrect")
    return False

def test_sequence_remainder(agi_o, sequence, prefix_len):
    """Play, prompt, and notify remainder of sequence after sequence_len.
       Return False if incorrect value is entered, otherwise continue.
       Return True if all elements have been entered correctly.
    """
    for elt in sequence[prefix_len:]:
        if not accept_next_sequence_element(agi_o, elt):
            return False
    return True

def test_sequence(agi_o, sequence, prefix_len):
    """Test each sequence until it is passed."""
    play_sound(agi_o, "sequence-follows")
    passing = False
    while not passing:
        play_sequence_prefix(agi_o, sequence, prefix_len)
        play_sound(agi_o, "start-of-sequence")
        passing = test_sequence_remainder(agi_o, sequence, prefix_len)
    play_sound(agi_o, "sequence-correct")

def test_sequences(agi_o, sequences, prefix_len):
    """Test each sequence."""
    for sequence in sequences:
        test_sequence(agi_o, sequence, prefix_len)
    play_sound(agi_o, "sequences-correct")

def main(agi_o, sequences, prefix_len):
    test_sequences(agi_o, sequences, prefix_len)
