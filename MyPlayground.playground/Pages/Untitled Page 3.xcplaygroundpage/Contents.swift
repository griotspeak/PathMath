// "Grid.Point(noteNumber: \(noteNumber), coordinates: Grid.CoordinatePair(column: \(column), row: \(row))),"

var output = "[\n"
for row in 0 ..< 8 {
    output.append("// Row \(row)\n")
    let lowNote = row * 5
    for column in 0 ..< 25 {
        let noteNumber = lowNote + column
        output.append("Grid.Point(noteNumber: \(noteNumber + 30), coordinates: Grid.CoordinatePair(column: \(column), row: \(row))),\n")
    }

    output.append("\n")
}

output.removeLast(3)
output.append("\n]\n")
print(output)
