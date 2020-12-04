import re


def isvalidpassword(password: str, char: str, mintimes: int, maxtimes: int):
    times = password.count(char)

    return mintimes <= times <= maxtimes


def processline(line: str):
    template = "(\d*)-(\d*) (\w): (\w*)"

    mintimes, maxtimes, character, password = re.match(template, line).groups()

    mintimes = int(mintimes)
    maxtimes = int(maxtimes)

    return password, character, mintimes, maxtimes


nvalid = 0
with open("Recursos/day2-input.txt") as io:
    for line in io:
        nvalid += isvalidpassword(*processline(line))

print(nvalid)
