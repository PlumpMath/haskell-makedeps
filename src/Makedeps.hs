{-|
Module      : Makedeps
Description : Parse dependency rules in makefiles
Copyright   : (c) Ian Denhardt, 2016

License     : GPL-3
Maintainer  : ian@zenhack.net
Stability   : exerimental
Portability : POSIX

Many tools exist for scanning source files for dependencies, and outputting
them as input appropriate for make. Some examples: ocamldep, and  gcc's -M
option.

This module provides a parsec parser and datatypes for working with the
subset of Makefile syntax necessary to support this output.

Useful references:

* Posix makefile spec: <http://pubs.opengroup.org/onlinepubs/009695399/utilities/make.html>
-}
module Makedeps (
    DepSpec(..),
    parseDeps
) where

import Text.ParserCombinators.Parsec (
    Parser,
    char,
    digit,
    letter,
    many,
    many1,
    oneOf,
    string)
import Control.Applicative ((<|>),(<*))
import Control.Monad (void)

-- TODO: we should add more context to the above; explain the file format a
-- little bit, for example.

-- | A makefile rule specifying dependencies
data DepSpec = DepSpec { targets      :: [String]
                       -- ^ list of targets created by the rule
                       , requirements :: [String]
                       -- ^ list of files on which the targets depend
                       }

-- whitespace other than a line break:
lineWS :: Parser ()
lineWS = void (oneOf " \t\f") <|> void (string "\\\n")

token :: Parser a -> Parser a
token p = p <* many lineWS

colon = token (string ":")

-- | Parser for a legal character in a target name. Posix only allows
-- @letter <|> digit <|> oneOf "._"@, but we also allow slashes (@'/'@),
-- since many tools generate that. We probablly should support more than
-- this, but researching exactly what is still TODO
targetChar :: Parser Char
targetChar = letter <|> digit <|> oneOf "._/"

targetName :: Parser String
targetName = token (many1 targetChar)

parseDepSpec :: Parser DepSpec
parseDepSpec = do
    targs <- many1 targetName
    colon
    deps <- many1 targetName
    char '\n'
    return $ DepSpec targs deps

parseDeps :: Parser [DepSpec]
parseDeps = many parseDepSpec
