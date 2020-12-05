process_line(line::AbstractString) = match(r"([BF]{7})([LR]{3})", line).captures

function row_text_to_number(row::AbstractString)
    binary_row = replace(replace(row, "B" => "1"), "F" => "0")

    return parse(Int, binary_row, base=2)
end

function seat_text_to_number(seat::AbstractString)
    binary_row = replace(replace(seat, "R" => "1"), "L" => "0")

    return parse(Int, binary_row, base=2)
end

seat_id(row, seat) = row * 8 + seat

max_id = 0
open("Recursos/day5-input.txt") do io
    for line in eachline(io)
        row, seat = process_line(line)

        row_number = row_text_to_number(row)
        seat_number = seat_text_to_number(seat)
        @show id = seat_id(row_number, seat_number)

        global max_id = max_id > id ? max_id : id
    end
end
println(max_id)
