SharedUtils = {}

function SharedUtils.DeepCopy(tbl, copied)
    local result = {}
    copied = copied or {}
    copied[tbl] = result

    for key, val in pairs(tbl) do
        if type(val) == "table" then
            result[key] = copied[val] or SharedUtils.DeepCopy(val, copied)
        else
            result[key] = val
        end
    end

    return result
end

function SharedUtils.ReverseTable(tbl)
    local output = {}

    for i = #tbl, 1, -1 do
        table.insert(output, tbl[i])
    end

    return output
end

function SharedUtils.MergeTables(left, ...)
    local args = { ... }
    local out = left

    for i = 1, #args do
        for o = 1, #args[i] do
            table.insert(out, args[i][o])
        end
    end

    return out
end

function SharedUtils.GroupBy(tbl, key)
    local out = {}

    for _, val in pairs(tbl) do
        local groupKey = val[key]
        if groupKey == nil then
            goto Continue
        end

        if out[groupKey] == nil then
            out[groupKey] = {}
        end

        table.insert(out[groupKey], val)

        :: Continue ::
    end

    return out
end

function SharedUtils.ExistsInTable(tbl, valueToFind)
    for _, val in ipairs(tbl) do
        if valueToFind == val then
            return true
        end
    end

    return false
end

function SharedUtils.SplitNumberIntoString(n, delimiter)
    local out = {}

    local str = tostring(n)
    for i = 1, #str do
        table.insert(out, tonumber(string.sub(str, i, i)))
    end

    return table.concat(out, delimiter)
end

function SharedUtils.Alternate(first, second, count)
    local out = {}

    for i = 1, count do
        table.insert(out, i % 2 == 0 and second or first)
    end

    return out
end

function SharedUtils.SplitString(str, delimiter)
    local out = {}
    local splitRegex = ("([^%s]+)"):format(delimiter)

    for word in string.gmatch(str, splitRegex) do
        table.insert(out, word)
    end

    return out
end

function SharedUtils.TableValues(tbl)
    local out = {}

    for _, val in pairs(tbl) do
        table.insert(out, val)
    end

    return out
end

function SharedUtils.TableInsertMany(tbl, ...)
    for i = 1, select('#', ...) do
        tbl[#tbl + 1] = select(i, ...)
    end
end

function SharedUtils.KeyExists(tbl, key)
    return tbl[key] ~= nil
end

function SharedUtils.Filter(tbl, whereFunc)
    local out = {}

    for _, obj in ipairs(tbl) do
        if (whereFunc(obj)) then
            table.insert(out, obj)
        end
    end

    return out
end

function SharedUtils.Range(from, to, step)
    step = step or 1
    local out = {}

    for i = from, to, step do
        table.insert(out, i)
    end

    return out
end

SharedUtils.Table = {}
function SharedUtils.Table.All(tbl, fn)
    for i = 1, #tbl do
        if not fn(tbl[i]) then
            return false
        end
    end

    return true
end

function SharedUtils.Table.Any(tbl, fn)
    for i = 1, #tbl do
        if fn(tbl[i]) then
            return true
        end
    end

    return false
end

function SharedUtils.NameTableValues(table, prefix)
    prefix = prefix or ""

    local out = {}

    for key, value in pairs(table) do
        local jumble = prefix .. key
        if type(value) == "table" then
            out[key] = SharedUtils.NameTableValues(value, jumble)
        else
            out[key] = jumble
        end
    end

    return out
end
