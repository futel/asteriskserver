#!/usr/bin/env python
"""
Sequence challenge.
"""


PREFIX_LEN = 3
#DIGIT_PAUSE = 0.1
#ELEMENT_PAUSE = 0.25

def play_sound(agi_o, name):
    #return agi_o.background(name)
    # XXX testing
    import util
    return util.say(agi_o, name)

def play_element(agi_o, elt):
    agi_o.appexec("SendDTMF", elt)
    #agi_o.Wait(ELEMENT_PAUSE)

def play_sequence_prefix(agi_o, sequence, prefix_len):
    play_sound(agi_o, "sequence-sequence-prefix-follows")
    for elt in sequence[0:prefix_len]:
        play_element(agi_o, elt)

def accept_next_sequence_element(agi_o, expected):
    """Accept keypresses, return True if they match element."""
    play_sound(agi_o, "sequence-enter-next-element")
    digit = str(agi_o.wait_for_digit(timeout=-1))
    if digit == expected:
        play_sound(agi_o, "sequence-element-correct")
        return True
    play_sound(agi_o, "sequence-element-incorrect")
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
    play_sound(agi_o, "sequence-sequence-follows")
    passing = False
    while not passing:
        play_sequence_prefix(agi_o, sequence, prefix_len)
        passing = test_sequence_remainder(agi_o, sequence, prefix_len)
    play_sound(agi_o, "sequence-sequence-correct")

def test_sequences(agi_o, sequences, prefix_len):
    """Test each sequence."""
    for sequence in sequences:
        test_sequence(agi_o, sequence, prefix_len)
        play_sound(agi_o, "sequence-sequences-correct")

def main(agi_o, sequences):
    test_sequences(agi_o, PREFIX_LEN)
