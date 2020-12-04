function isvalidpassword(password::AbstractString, char::AbstractChar,
    firstchar::Integer, secondchar::Integer)
    return (password[firstchar] == char) ⊻ (password[secondchar] == char)
end

function processline(line::AbstractString)
    re = r"(\d*)-(\d*) (\w): (\w*)"

    firstchar, secondchar, character, password = match(re, line).captures

    firstchar = parse(Int, firstchar)
    secondchar = parse(Int, secondchar)

    return password, character[1], firstchar, secondchar
end

nvalid = 0
open("Recursos/day2-input.txt") do io
    for line in eachline(io)
        password, char, firstchar, secondchar = processline(line)

        global nvalid += isvalidpassword(password, char, firstchar, secondchar)
    end
end

println(nvalid)
