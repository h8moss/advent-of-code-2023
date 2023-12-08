from typing import Tuple

card_values = {
  'A': 14,
  'K': 13,
  'Q': 12,
  'J': 11,
  'T': 10,
  '9': 9,
  '8': 8,
  '7': 7,
  '6': 6,
  '5': 5,
  '4': 4,
  '3': 3,
  '2': 2
}

class Hand(): 
  def __init__(self, card_string: str):
    self.cards = list(card_string)
    self.card_values = list(map(lambda v: card_values[v], self.cards))
    self.number = self.play_value()
    for card_value in self.card_values:
      self.number = self.number * 100 + card_value

  def play_value(self):
    # play_value -> high card:1, one pair:2, two pair:3 threekind:4 house:5, fourkind:6 fivekind:7
    repetition_dict = {}
    for card in self.cards:
      if card in repetition_dict:
        repetition_dict[card] +=1
      else:
        repetition_dict[card] = 1
    count3 = 0
    count2 = 0
    for k, v in repetition_dict.items():
      if v == 5:
        return 7
      if v == 4:
        return 6
      if v == 3:
        count3 += 1
      if v == 2:
        count2 += 1
    if count3 == 1 and count2 == 1:
      return 5
    if count3 == 1:
      return 4
    if count2 == 2:
      return 3
    if count2 == 1:
      return 2
    return 1
  

  def __str__(self) -> str:
    return ''.join(self.cards)
  def __repr__(self) -> str:
    return ''.join(self.cards)


 
def main():
  file_lines: list[str] = []
  with open('day7/input_day7.txt') as f:
    file_lines = f.readlines()

  hand_and_bids = []
  for line in file_lines:
    split = line.split(' ')
    hand_and_bids.append((Hand(split[0]), int(split[1])))
  print(hand_and_bids)
  hand_and_bids.sort(key=lambda x: x[0].number)
  print('-----------------------------------')
  print(hand_and_bids)

  final_bid_returns = list(map(lambda i: hand_and_bids[i][1]*(i+1), range(len(hand_and_bids))))
  print(final_bid_returns)
  print('total:', sum(final_bid_returns))

if __name__ == '__main__':
  main()