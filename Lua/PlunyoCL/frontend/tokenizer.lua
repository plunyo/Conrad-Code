local errorMessages = require("frontend.errorMessages")
local TokenType = require("frontend.tokenType")
local Token = require("frontend.token")

local keywords = {
	["blank"] = TokenType.BLANK,
    ["var"] = TokenType.VAR
}

local Tokenizer = {}

local function isAlpha(src)
    return src:match("^[A-z]+$") ~= nil
end

local function isInt(str)
    return str:match("^[0-9]+$") ~= nil
end

function Tokenizer.Tokenize(sourceCode)
    local tokens = {}
    local src = {}

    -- split into individual characters
    for i = 1, #sourceCode do
        src[i] = sourceCode:sub(i, i)
    end

    while #src > 0 do
		local currentChar = table.remove(src, 1)
	
		if currentChar:match("%s") then
			-- GOTO DOESN'T WORK AND CONTINUE DOESN'T EXIST, I'M BOUTA CRASH OUT
		else
			if TokenType.Lookup[currentChar] then
				table.insert(tokens, Token:new(currentChar, TokenType.Lookup[currentChar]))
			elseif isInt(currentChar) then
				local num = currentChar
	
				-- keep tokenizing until we hit a not number char
				while #src > 0 and isInt(src[1]) do
					num = num .. table.remove(src, 1)
				end
	
				table.insert(tokens, Token:new(num, TokenType.NUMBER))
			elseif isAlpha(currentChar) then
				local identifier = currentChar
				
				-- keep tokenizing until we hit a not alphabet char
				while #src > 0 and isAlpha(src[1]) do
					identifier = identifier .. table.remove(src, 1)
				end
	
				local reserved = keywords[identifier]
				table.insert(tokens, Token:new(identifier, (not type(reserved) == "number") and TokenType.IDENTIFIER or reserved))
			else
				-- Handle unrecognized token
				error(errorMessages.UNRECOGNIZED_TOKEN:format(currentChar))
			end
		end
	end

	table.insert(tokens, Token:new("EndOfFile", TokenType.EOF))
    return tokens
end

return Tokenizer
