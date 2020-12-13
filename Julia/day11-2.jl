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

    return occupied_count ≥ 5
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

function readinput(file_name::AbstractString)
    return open(file_name) do io
        text = read(io, String)

        nlines = countlines(IOBuffer(text))

        text = replace(text, r"\n|\r" => "")

        grid = permutedims(reshape(split(text, ""), :, nlines))

        grid = replace(grid, "." => missing, "L" => false, "#" => true)

        grid_size = size(grid)

        seats = [Seat(i, j, grid[i,j]) for i = 1:grid_size[1], j = 1:grid_size[2]]

        neighbors = neighbors_indices(seats)

        return SeatGrid(seats, neighbors, grid_size)
    end
end

function neighbors_indices(seats::Matrix{Seat})
    grid_size = size(seats)
    neighbors = Matrix{Vector{Tuple{Int,Int}}}(undef, grid_size)
    for seat in seats
        first_neighbors = Tuple{Int,Int}[]
        # top-left
        for n = 1:min(seat.i - 1, seat.j - 1)
            if !isfloor(seats[seat.i - n, seat.j - n])
                push!(first_neighbors, (seat.i - n, seat.j - n))
                break
            end
        end
        # left
        for n = 1:(seat.j - 1)
            if !isfloor(seats[seat.i, seat.j - n])
                push!(first_neighbors, (seat.i, seat.j - n))
                break
            end
        end
        # bottom-left
        for n = 1:min(grid_size[1] - seat.i, seat.j - 1)
            if !isfloor(seats[seat.i + n, seat.j - n])
                push!(first_neighbors, (seat.i + n, seat.j - n))
                break
            end
        end
        # bottom
        for n = 1:(grid_size[1] - seat.i)
            if !isfloor(seats[seat.i + n , seat.j])
                push!(first_neighbors, (seat.i + n, seat.j))
                break
            end
        end
        # bottom-right
        for n = 1:min(grid_size[1] - seat.i, grid_size[2] - seat.j)
            if !isfloor(seats[seat.i + n, seat.j + n])
                push!(first_neighbors, (seat.i + n, seat.j + n))
                break
            end
        end
        # right
        for n = 1:(grid_size[2] - seat.j)
            if !isfloor(seats[seat.i, seat.j + n])
                push!(first_neighbors, (seat.i, seat.j + n))
                break
            end
        end
        # top-right
        for n = 1:min(seat.i - 1, grid_size[2] - seat.j)
            if !isfloor(seats[seat.i - n, seat.j + n])
                push!(first_neighbors, (seat.i - n, seat.j + n))
                break
            end
        end
        # top
        for n = 1:(seat.i - 1)
            if !isfloor(seats[seat.i - n, seat.j])
                push!(first_neighbors, (seat.i - n, seat.j))
                break
            end
        end

        neighbors[seat.i, seat.j] = first_neighbors
    end

    return neighbors
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
    total_occupied(seat_grid)
end

main()
