def all_are_zero(numbers):
  for num in numbers:
    if num != 0:
      return False
  return True

def predict_next_number(numbers):
  # use recursion to predict the next number
  differences = []
  for i in range(len(numbers)-1):
    differences.append(numbers[i+1] - numbers[i])
  if all_are_zero(numbers):
    return numbers[0]
  return numbers[-1] + predict_next_number(differences)

def main():
  with open('day9/input_day9.txt', 'r') as f:
    file_lines = f.readlines()

  sequences = []
  for line in file_lines:
    if line[-1] == '\n':
      line = line[0:-1]
    split = line.split(' ')
    sequences.append(list(map(lambda i: int(i), split)))
  print(sequences)
  for seq in sequences:
    print(predict_next_number(seq))
  print('SUM: ')
  print(sum(list(map(lambda seq:predict_next_number(seq), sequences))))


if __name__ == '__main__':
  main()