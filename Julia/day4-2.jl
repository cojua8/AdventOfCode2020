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

passes_byr(byr) = length(byr) == 4 && 1920 ≤ parse(Int, byr) ≤ 2002
passes_iyr(iyr) = length(iyr) == 4 && 2010 ≤ parse(Int, iyr) ≤ 2020
passes_eyr(eyr) = length(eyr) == 4 && 2020 ≤ parse(Int, eyr) ≤ 2030
function passes_hgt(hgt)
    re = r"(\d*)(cm|in)"
    match_hgt = match(re, hgt)

    match_hgt === nothing && return false

    height, unit = match_hgt.captures
    unit == "cm" && 150 ≤ parse(Int, height) ≤ 193 && return true
    unit == "in" && 59 ≤ parse(Int, height) ≤ 76 && return true

    return false
end
passes_hcl(hcl) = match(r"#[0-9a-f]{6}", hcl) !== nothing
passes_ecl(ecl) = match(r"amb|blu|brn|gry|grn|hzl|oth", ecl) !== nothing
passes_pid(pid) = match(r"^\d{9}$", pid) !== nothing

function isvalidpassport(passport)
    re = r"([a-z]*):([^\s]+)"

    fields = Dict(
        m.captures[1] => m.captures[2] for m in eachmatch(re, passport))

    if length(fields) < 7 || (length(fields) == 7 && ("cid" in keys(fields)))
        return false
    elseif (
        passes_byr(fields["byr"]) &&
        passes_iyr(fields["iyr"]) &&
        passes_eyr(fields["eyr"]) &&
        passes_hgt(fields["hgt"]) &&
        passes_hcl(fields["hcl"]) &&
        passes_ecl(fields["ecl"]) &&
        passes_pid(fields["pid"])
        )
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
