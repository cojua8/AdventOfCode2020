with open("Recursos/day1-input.txt") as file:
    expenses = [int(i) for i in file.readlines()]

for i in range(len(expenses)):
    for j in range(i, len(expenses)):
        for l in range(j, len(expenses)):
            v1 = expenses[i]
            v2 = expenses[j]
            v3 = expenses[l]
            if v1 + v2 + v3 == 2020:
                print(
                    f"{v1} + {v2} + {v3}= {v1 + v2 + v3}")
                print(
                    f"{v1} * {v2} * {v3}= {v1 * v2 * v3}")
                break
