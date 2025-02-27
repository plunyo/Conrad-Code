using System;
using System.Collections.Generic;
using System.Linq;
using System.Reflection.Emit;
using System.Text;
using System.Threading.Tasks;

namespace PlunyoCL
{
    public enum TokenType
    {
        INT,
        FLOAT,

        Add,
        Minus,
        Mul,
        Div,
        Mod,

        LParen,
        RParen
    }

    struct Token
    {
        public TokenType Type;
        public string Value;
    }

    class Lexer
    {
        currentChar

        public List<Token> Tokenize(string sourceCode = "")
        {
            List<Token> tokens = new List<Token>();

            Dictionary<TokenType, string> TokenMap = new Dictionary<TokenType, string>{
                { TokenType.Add, "+" },
                { TokenType.Minus, "-" },
                { TokenType.Mul, "*" },
                { TokenType.Div, "/" },
                { TokenType.Mod, "%" },

                { TokenType.LParen, "(" },
                { TokenType.RParen, ")" }
            };

            foreach (char currentChar in sourceCode)
            {
                if (char.IsWhiteSpace(currentChar)) continue;

                if (char.IsDigit(currentChar))
                {
                    string numValue;
                    int dotCount = 0;

                    do
                    {
                        if (currentChar == '.' && ++dotCount > 1) break;
                        numValue += currentChar;
                        
                    } while (currentChar != '\0' && char.IsDigit(currentChar));
                }
            }

            return tokens;
        }
    }
}
