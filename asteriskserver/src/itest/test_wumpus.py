#!/usr/bin/env python3

from unittest import mock
import wumpus

w = wumpus.Wumpus(mock.MagicMock())
w.say('intro-statement')
#w.hunt()
