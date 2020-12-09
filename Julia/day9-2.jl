struct XMAS
    queue::AbstractVector{Integer}
    sum_matrix::AbstractMatrix{Integer}
    lines::Base.EachLine
    size::Integer
    filename::AbstractString
    function XMAS(queue, lines, filename)
        size = length(queue)

        sum_matrix = [x + y for x in queue, y in queue]

        return new(queue, sum_matrix, lines, size, filename)
    end
end

function XMAS(file::AbstractString)
    lines = eachline(file)

    preamble = parse.(Int, Iterators.take(lines, 25))

    return XMAS(preamble, lines, file)
end


# shift queue and sum_matrix, then put the new number and vector at the end
function add_number!(number::Integer, xmas::XMAS)
    xmas.queue[:] = circshift(xmas.queue, -1)

    xmas.queue[end] = number

    new_vector = xmas.queue .+ number

    xmas.sum_matrix[:] = circshift(xmas.sum_matrix, (-1, -1))

    xmas.sum_matrix[end, :] = new_vector
    xmas.sum_matrix[:, end] = new_vector
    return
end


function find_invalid(xmas::XMAS)
    for (i, line) in enumerate(xmas.lines)
        number = parse(Int, line)

        if !(number in xmas.sum_matrix)
            return number, i + xmas.size - 1
        end

        add_number!(number, xmas)
    end
    return -1, -1
end


function encryption_weakness(number::Integer, lastindex::Integer, xmas::XMAS)
    number_list = parse.(Int,
        Iterators.take(eachline(xmas.filename), lastindex))

    for i in 1:lastindex - 1, j in i + 1:lastindex
        if sum(number_list[i:j]) == number
            return sum(extrema(number_list[i:j]))
        end
    end
end


#####
function main()
    xmas = XMAS("Recursos/day9-input.txt")

    invalidnumber, index = find_invalid(xmas)

    encryption_weakness(invalidnumber, index, xmas)
end

main()
