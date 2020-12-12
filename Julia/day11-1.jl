function readinput(file_name::AbstractString)
    return open(file_name) do io
        text = read(io, String)

        nlines = countlines(IOBuffer(text))

        text = replace(text, "\n" => "")

        grid = reshape(split(text, ""), 93, :)

        grid = replace(grid, "." => missing, "L" => true)

        return grid
    end
end

function main()
    readinput("Recursos/day11-input.txt")
end
main()
