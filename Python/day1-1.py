with open("Recursos/day1-input.txt") as file:
    expenses = [int(i) for i in file.readlines()]

for i in range(len(expenses)):
    for j in range(i, len(expenses)):
        v1 = expenses[i]
        v2 = expenses[j]
        if v1 + v2 == 2020:
            print(
                f"{v1} + {v2} = {v1 + v2 }")
            print(
                f"{v1} * {v2} = {v1 * v2 }")
            break
