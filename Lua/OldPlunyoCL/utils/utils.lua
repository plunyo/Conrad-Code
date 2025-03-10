local TokenType = require("frontend.tokenType")

require("frontend.astNodes")

local Utils = {}

function Utils.printAST(tbl, indent)
    indent = indent or 0  -- Set default indentation if not provided

    -- Start the structure with an opening brace
    print(string.rep("  ", indent) .. "{")
    
    for key, value in pairs(tbl) do
        local formatting = string.rep("  ", indent + 1) .. key .. ": "  -- Create formatting string

        if type(value) == "table" then
            print(formatting)  -- Print the key with indentation
            Utils.printAST(value, indent + 2)  -- Recursively print nested tables
        elseif key == "kind" and TokenType then
            -- Lookup enum name for kind
            local kindName = TokenType.Lookup[value] and TokenType:getName(value) or NodeType:getName(value)
            print(formatting .. (kindName or "UNKNOWN"))  -- Print kind name or UNKNOWN
        else
            print(formatting .. tostring(value))  -- Print the value
        end
    end

    -- End the structure with a closing brace
    print(string.rep("  ", indent) .. "}")
end

function Utils.tableToString(tbl)
    local result = "{"
    for k, v in pairs(tbl) do
        -- Check the key type (ignore any numerical keys - assume its an array)
        if type(k) == "string" then
            result = result.."[\""..k.."\"]".."="
        end

        -- Check the value type
        if type(v) == "table" then
            result = result..Utils.tableToString(v)
        elseif type(v) == "boolean" then
            result = result..tostring(v)
        else
            result = result.."\""..v.."\""
        end
        result = result..","
    end
    -- Remove leading commas from the result
    if result ~= "" then
        result = result:sub(1, result:len()-1)
    end
    return result.."}"
end

return Utils