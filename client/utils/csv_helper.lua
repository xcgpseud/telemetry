CsvHelper = {}

function CsvHelper.TableToCsv(headers, values)
    local valuesCsv = ""

    for _, valueData in ipairs(values) do
        valuesCsv = valuesCsv .. table.concat(valueData, ',') .. "\n"
    end

    return
        table.concat(headers, ',')
        .. "\n"
        .. valuesCsv
end
