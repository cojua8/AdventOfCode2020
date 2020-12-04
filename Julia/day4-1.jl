function readpassport(lines)
    passport = ""

    for line in lines
        if isempty(strip(line))
            break
        end
        passport *= line * " "
    end

    return passport
end

function isvalidpassport(passport)
    re = r"([a-z]{3}):"

    fields = [m.captures[1] for m in eachmatch(re, passport)]

    if length(fields) == 8
        return true
    elseif length(fields) == 7 && !("cid" in fields)
        return true
    else
        return false
    end
end


valid_passports = 0
open("Recursos/day4-input.txt") do io
    lines = eachline(io)

    while !eof(io)
        passport = readpassport(lines)

        global valid_passports += isvalidpassport(passport)
    end
end

println(valid_passports)
