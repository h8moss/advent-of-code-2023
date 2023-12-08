from typing import Tuple

card_values = {
  'A': 13,
  'K': 12,
  'Q': 11,
  'T': 10,
  '9': 9,
  '8': 8,
  '7': 7,
  '6': 6,
  '5': 5,
  '4': 4,
  '3': 3,
  '2': 2,
  'J': 1,
}

class Hand(): 
  def __init__(self, card_string: str):
    self.card_string = card_string
    self.cards = list(card_string)
    self.card_values = list(map(lambda v: card_values[v], self.cards))
    self.number = self.play_value()
    for card_value in self.card_values:
      self.number = self.number * 100 + card_value

  def play_value(self):
    # play_value -> high card:1, one pair:2, two pair:3 threekind:4 house:5, fourkind:6 fivekind:7
    repetition_dict = {}
    jCount = 0
    for card in self.cards:
      if card == 'J':
        jCount += 1
        continue
      if card in repetition_dict:
        repetition_dict[card] +=1
      else:
        repetition_dict[card] = 1

    if len(repetition_dict.keys()) == 0:
      return 7 # 5 Jokers
    if len(repetition_dict.keys()) == 1:
      return 7 # 1 card and 4 jokers or 2 cards and 3 jokers or so on and so forth
    
    sorted_repetition = list(reversed(sorted(list(repetition_dict.keys()), key=lambda k:repetition_dict[k])))
    greatest_key = sorted_repetition[0]

    if repetition_dict[greatest_key] + jCount == 5:
      return 7
    if repetition_dict[greatest_key] + jCount == 4:
      return 6
    if repetition_dict[greatest_key] + jCount == 3:
      second_greatest = sorted_repetition[1]
      if repetition_dict[second_greatest] == 2:
        return 5
      return 4
    if repetition_dict[greatest_key] + jCount == 2:
      second_greatest = sorted_repetition[1]
      if repetition_dict[second_greatest] == 2:
        return 3
      return 2
    if repetition_dict[greatest_key] + jCount == 1:
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
  print(list(map(lambda i:(hand_and_bids[i][0], hand_and_bids[i][0].number), range(len(hand_and_bids)))))
  print('total:', sum(final_bid_returns))

if __name__ == '__main__':
  main()
