def lcm(numbers):
  numbers.sort()
  numbers.reverse()
  print(numbers)

  current_multiple = 1
  while True:
    current_value = numbers[0] * current_multiple
    if len([x for x in numbers if (x % current_value == 0)]) == len(numbers):
      return current_value
    current_multiple += 1
  # I believe this will eventually calculate the correct value, but my computer|
  # was being cringe so I asked wolfram alfa and it said 9,858,474,970,153
    

class Node:
  def __init__(self, name, l, r):
    self.name = name
    self.left = l
    self.right = r

  def __str__(self):
    return f'{self.name} ({self.left}, {self.right})'

def locations_are_done(locations, nodes):
  for location in locations:
    if nodes[location].name[2] != 'Z':
      return False
  return True

def main():
  file_lines: list[str] = []
  with open('day8/input_day8.txt', 'r') as f:
    file_lines = f.readlines()

  instructions_str = file_lines.pop(0)
  nodes: list[Node] = []
  index = {}

  for item in file_lines:
    if item == '\n':
      continue
    split = item.split(' = ')
    name = split[0]
    left = split[1][1:4]
    right = split[1][6:9]
    nodes.append(Node(name, left, right))
    index[name] = len(nodes)-1

  instructions = list(instructions_str)
  instructions.pop()

  # current_locations = []
  # for name in index.keys():
  #   if name[2] == 'A':
  #     current_locations.append(index[name])
  # 
  current_locations = [index[name] for name in index if name[2] == 'A']


  print(len(current_locations))
  # while not locations_are_done(current_locations, nodes) and instruction_index < 100000000000:
  #   instruction = instructions[instruction_index % len(instructions)]  
  #   for i in range(len(current_locations)):                            
  #     if instruction == 'L':                                           
  #       current_locations[i] = index[nodes[current_locations[i]].left] 
  #     else:                                                            
  #       current_locations[i] = index[nodes[current_locations[i]].right]
  #   instruction_index += 1                                             

  first_z = []
  for i in range(len(current_locations)):
    current_instruction = 0
    while nodes[current_locations[i]].name[2] != 'Z':
      instruction = instructions[current_instruction % len(instructions)]
      current_locations[i] = index[nodes[current_locations[i]].left] if instruction == 'L' else index[nodes[current_locations[i]].right]

      current_instruction += 1
    first_z.append(current_instruction)


  print(lcm(first_z))


if __name__ == '__main__':
  main()
