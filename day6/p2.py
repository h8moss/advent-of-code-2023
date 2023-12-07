def main():
  file_lines = []
  with open('day6/input_day6.txt') as f:
    file_lines = f.readlines()

  time_string = file_lines[0]
  distance_string = file_lines[1]
  times = []
  distances = []
  for text in time_string.split(' '):
    val = 0
    try:
      val = int(text)
    except:
      continue
    times.append(val)
  for text in distance_string.split(' '):
    val = 0
    try:
      val = int(text)
    except:
      continue
    distances.append(val)

  distance = int(''.join([str(x) for x in distances]))
  time = int(''.join([str(x) for x in times]))

  half_point = int(time/2)
  count = 0
  for i in reversed(range(half_point+1)):
    if (i * (time - i)) < distance:
      break

    if i == half_point:
      # if time % 2 == 0:
      #   count += 2
      # else:
      #   count += 1
      # Don't know why chingados this aint it lmao
      count += 1
    else:
      count += 2

  print(count)

if __name__ == '__main__':
  main()
