import random
import math
import os

import util

# Don't get progged!

MOVES = [(-1, -1), (0, -1), (1, -1), (-1, 0), (0, 0), (1, 0), (-1, 1), (0, 1), (1, 1)]

GAME_START = 0
GAME_IN_PROGRESS = 1
GAME_LOST = 2
GAME_WON = 3

# PROMPTS = {
#   "intro.wav": "You are a member of the last human family.  You are in the middle of the city and need to get to safety.  Avoid the robotrons and get home. Use the keypad to move around. Do not get progged by a robotron!",
#   "you-win.wav": "You win! The human family survives a bit longer! Press a button to exit.",
#   "you-lose.wav": "You got progged! Restarting from the beginning.",
#   "ninth-position.wav": "The ninth position is futile!",
#   "distance-to-home.wav": "Distance to home",
#   "distance-to-closest-robotron.wav": "Distance to closest robotron",
#   "0.wav": "0",
#   "1.wav": "1",
#   "2.wav": "2",
#   "3.wav": "3",
#   "4.wav": "4",
#   "5.wav": "5",
#   "6.wav": "6",
#   "7.wav": "7",
#   "8.wav": "8",
#   "9.wav": "9",
#   "10.wav": "10",
#   "pause.wav": ".."
# }

def number_to_word_string(number):
    return {
        1: "one",
        2: "two",
        3: "three",
        4: "four",
        5: "five",
        6: "six",
        7: "seven",
        8: "eight",
        9: "nine",
        10: "ten"}[number]

def progged(agi_o):
  game_state = create_game_state(5)
  while game_state["state"] != GAME_WON:
    move = play_list_and_get_input(agi_o, communicate_game_state(game_state))
    game_state = update_game_state(game_state, MOVES[int(move)-1])
  # player won, return
  play_list_and_get_input(agi_o, communicate_game_state(game_state))

def create_game_state(field_size):
  def rand():
    return random.randrange(-field_size, field_size+1)

  potential_goals = [(-field_size, rand()), (field_size, rand()), (rand(), -field_size), (rand(), field_size)]
  goal = random.choice(potential_goals)

  player_position = (0, 0)

  # Create the robots
  bots = []
  for i in range(field_size):
    spawn_pt = (rand(), rand())
    while dist(spawn_pt, player_position) < 2 or same_pos(spawn_pt, goal):
      spawn_pt = (rand(), rand())
    bots.append(spawn_pt)

  return { "state": GAME_START, "player_position": player_position, "goal": goal, "bots": bots, "field_size": field_size }

def update_game_state(game_state, move):
  if game_state["state"] == GAME_WON:
    return game_state
  old_player_position = game_state['player_position']
  field_size = game_state["field_size"]
  player_position = (clamp(old_player_position[0] + move[0], -field_size, field_size), clamp(old_player_position[1] + move[1], -field_size, field_size))
  new_game_state = GAME_IN_PROGRESS
  if same_pos(player_position, game_state["goal"]):
    new_game_state = GAME_WON
  else:
    for bot in game_state["bots"]:
      if same_pos(bot, player_position):
        new_game_state = GAME_LOST
        player_position = (0, 0)

  return { "state": new_game_state, "player_position": player_position, "goal": game_state["goal"], "bots": game_state["bots"], "field_size": game_state["field_size"], "last_move": move }

def communicate_game_state(game_state):
  ret = []
  if game_state["state"] == GAME_WON:
    return ["you-win"]
  ret = []
  if game_state["state"] == GAME_START:
    ret.append("you-are-a-member-of-the-last-human-family")
    ret.append("you-are-in-the-middle-of-the-city-and-need-to-get-to-safety")
    ret.append("avoid-the-robotrons-and-get-home")
    ret.append("use-the-keypad-to-move-around")
    ret.append("do-not-get-progged-by-a-robotron")
  if game_state["state"] == GAME_LOST:
    ret.append("you-got-progged")
    ret.append("restarting-from-the-beginning")
  if "last_move" in game_state and same_pos(game_state["last_move"], (0, 0)):
    ret.append("the-ninth-position-is-futile")

  home_dist = dist(game_state["player_position"], game_state["goal"])
  ret.append("distance-to-home")
  ret.append(number_to_word_string(home_dist))

  closest_bot = min(map(lambda x: dist(game_state["player_position"], x), game_state["bots"]))
  ret.append("distance-to-closest-robotron")
  ret.append(number_to_word_string(closest_bot))
  return ret

def dist(a, b):
  return max(abs(a[0] - b[0]), abs(a[1] - b[1]))

def same_pos(a, b):
  return a[0] == b[0] and a[1] == b[1]

def clamp(val, minv, maxv):
  return min(maxv, max(minv, val))

def play_list_and_get_input(agi_o, files):
  # print(files)
  for file in files:
    digit = util.say(
        agi_o, file, preferred_subs=['challenge'], escape=True)
    if digit is not '':
      return digit
    #print(PROMPTS[file])
    #os.system("play " + file)
  digit = util.say(
      agi_o, "enter-move", preferred_subs=['challenge'], escape=True)
  if digit is not '':
    return digit
  return agi_o.wait_for_digit(timeout=-1)

# def generate_wav():
#   for prompt in PROMPTS.keys():
#     aiff = prompt.replace(".wav", ".aiff")
#     os.system("say -o " + aiff + " -v Veena " + PROMPTS[prompt])
#     os.system("sox " + aiff + " " + prompt)
#     os.remove(aiff)

# progged()
# # generate_wav()
