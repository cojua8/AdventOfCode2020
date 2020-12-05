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



seat_sum, max_seat, min_seat = open("Recursos/day5-input.txt") do io
    min_seat = typemax(Int)
    max_seat = typemin(Int)
    seat_sum = 0

    for line in eachline(io)
        row, seat = process_line(line)

        row_number = row_text_to_number(row)
        seat_number = seat_text_to_number(seat)
        id = seat_id(row_number, seat_number)

        seat_sum += id
        max_seat = id > max_seat ? id : max_seat
        min_seat = id < min_seat ? id : min_seat
    end

    return seat_sum, max_seat, min_seat
end

# sum of all seats id from min to max
all_seats_sum = (max_seat + min_seat) * (max_seat - min_seat + 1) ÷ 2

# missing seat -> can do this because flight is full
missing_seat = all_seats_sum - seat_sum
