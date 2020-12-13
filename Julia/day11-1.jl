function readinput(file_name::AbstractString)
    return open(file_name) do io
        text = read(io, String)

        nlines = countlines(IOBuffer(text))

        text = replace(text, r"\n|\r" => "")

        grid = permutedims(reshape(split(text, ""), :, nlines))

        grid = replace(grid, "." => missing, "L" => false)

        grid_size = size(grid)

        seats = [Seat(i, j, grid[i,j]) for i = 1:grid_size[1], j = 1:grid_size[2]]

        neighbors = neighbors_indices(grid_size)

        return SeatGrid(seats, neighbors, grid_size)
    end
end

function neighbors_indices(grid_size)
    neighbors = [
        [
            (ii, jj)
            for ii in i - 1:i + 1
            for jj in j - 1:j + 1
            if (ii > 0 && ii ≤ grid_size[1] && jj > 0 && jj ≤ grid_size[2]
                && (ii, jj) ≠ (i, j))
        ]
        for i = 1:grid_size[1], j = 1:grid_size[2]
    ]
    return neighbors
end

struct Seat
    i::Integer
    j::Integer
    status::Union{Missing,Bool}
end
struct SeatGrid
    seats::Matrix{Seat}
    neighbors::Matrix{Vector{Tuple{Integer,Integer}}}
    size::Tuple{Int,Int}
end

isoccupied(s::Seat) = s.status !== missing && s.status
isfloor(s::Seat) = s.status === missing
occupy(s::Seat) = Seat(s.i, s.j, true)
empty(s::Seat) = Seat(s.i, s.j, false)

function neighbors_are_empty(seat::Seat, seat_grid::SeatGrid)
    return !any(
        n -> isoccupied(seat_grid.seats[n...]),
        seat_grid.neighbors[seat.i, seat.j])
end

function neighbors_are_occupied(seat::Seat, seat_grid::SeatGrid)
    occupied_count =  count(
        n -> isoccupied(seat_grid.seats[n...]),
        seat_grid.neighbors[seat.i, seat.j])

    return occupied_count ≥ 4
end

total_occupied(seat_grid::SeatGrid) = sum(isoccupied.(seat_grid.seats))

function occupy_seats!(seat_grid::SeatGrid)
    new_seats = Matrix{Seat}(undef, seat_grid.size)
    for (i, seat) in enumerate(seat_grid.seats)
        if isfloor(seat)
            new_seats[i] = seat
        elseif !isoccupied(seat) && neighbors_are_empty(seat, seat_grid)
            new_seats[i] = occupy(seat)
        elseif isoccupied(seat) && neighbors_are_occupied(seat, seat_grid)
            new_seats[i] = empty(seat)
        else
            new_seats[i] = seat
        end
    end
    seat_grid.seats[:] = new_seats
    return
end

function grid2string(seat_grid::SeatGrid)
    grid_string = """"""
    for i in 1:seat_grid.size[1]
        grid_string *= join([status2char(s) for s in seat_grid.seats[i,:]]) * '\n'
    end
    return grid_string
end

status2char(s::Seat) = isfloor(s) ? '.' : isoccupied(s) ? '#' : 'L'

function main()
    seat_grid = readinput("Recursos/day11-input.txt")

    old_seats = """"""
    new_seats = grid2string(seat_grid)
    while old_seats != new_seats
        old_seats = new_seats

        occupy_seats!(seat_grid)
        new_seats = grid2string(seat_grid)
    end
    println(new_seats)
    total_occupied(seat_grid)
end
seats = main()
