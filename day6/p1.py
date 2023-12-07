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

  length = len(times)
  results = []

  for i in range(length):
    distance_values = [x*(times[i]-x) for x in range(times[i])]
    distance_values.sort()
    distance_values.reverse()
    counter = 0
    for dist_value in distance_values:
      if dist_value > distances[i]:
        counter += 1
      else:
        break

    
    results.append(counter)

  multiplication = 1
  for result in results:
    multiplication = multiplication * result
  print(multiplication)
  
  

if __name__ == '__main__':
  main()
