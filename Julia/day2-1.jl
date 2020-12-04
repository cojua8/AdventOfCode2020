function processline(line::AbstractString)
    re = r"(\d*)-(\d*) (\w): (\w*)"

    mintimes, maxtimes, character, password = match(re, line).captures

    mintimes = parse(Int, mintimes)
    maxtimes = parse(Int, maxtimes)

    return password, character[1], mintimes, maxtimes
end

function isvalidpassword(password::AbstractString, char::AbstractChar,
    mintimes::Integer, maxtimes::Integer)
    times = count(c -> c == char, password)

    return mintimes ≤ times ≤ maxtimes
end


nvalid = 0
open("Recursos/day2-input.txt") do io
    for line in eachline(io)
        password, char, mintimes, maxtimes = processline(line)

        global nvalid += isvalidpassword(password, char, mintimes, maxtimes)
    end
end

println(nvalid)
