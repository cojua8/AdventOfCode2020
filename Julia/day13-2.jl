# chinese remainder solves x in the system of congruences:
# x ≡ aₖ (mod nₖ)
# in this case aₖ is the bus ID minus its position in the list
# nₖ is the bus ID
# the implemetation is from:
# https://rosettacode.org/wiki/Chinese_remainder_theorem
function chinese_remainder(buses::Vector{Tuple{Int,Int}})
    N = prod(b -> b[1], buses)

    x = sum(b -> (b[1] - b[2]) * invmod(N ÷ b[1], b[1]) * (N ÷ b[1]), buses)
    return mod(x, N)
end

function available_buses(buses::AbstractString)
    re = r"(\w+)"
    return [
        (parse(Int, match.captures[1]), i - 1)
        for (i, match) in enumerate(eachmatch(re, buses))
        if match.captures[1] != "x"]
end

function main()
    earliest, buses = readlines("Recursos/day13-input.txt")

    earliest = parse(Int, earliest)

    @show buses = available_buses(buses)

    chinese_remainder(buses)
end

n = main()
