class Node:
  def __init__(self, name, l, r):
    self.name = name
    self.left = l
    self.right = r

  def __str__(self):
    return f'{self.name} ({self.left}, {self.right})'


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
  instruction_index = 0

  current_location = index['AAA']
  while current_location != index['ZZZ']:
    instruction = instructions[instruction_index%len(instructions)]
    if instruction == 'L':
      current_location = index[nodes[current_location].left]
    elif instruction == 'R':
      current_location = index[nodes[current_location].right]
    instruction_index += 1

  print(instruction_index)
    


if __name__ == '__main__':
  main()