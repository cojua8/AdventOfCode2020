import re


def isvalidpassword(password: str, char: str, firstchar: int, secondchar: int):
    return (password[firstchar-1] == char) ^ (password[secondchar-1] == char)


def processline(line: str):
    template = "(\d*)-(\d*) (\w): (\w*)"

    firstchar, secondchar, character, password = re.match(
        template, line).groups()

    firstchar = int(firstchar)
    secondchar = int(secondchar)

    return password, character, firstchar, secondchar


nvalid = 0
with open("Recursos/day2-input.txt") as io:
    for line in io:
        nvalid += isvalidpassword(*processline(line))

print(nvalid)
