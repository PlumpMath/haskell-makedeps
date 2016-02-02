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
-}
module Makedeps (
    DepSpec(..),
    parseDeps
) where

import Text.ParserCombinators.Parsec (Parser,oneOf,string,many)
import Control.Applicative ((<|>),(<*))

-- TODO: we should add more context to the above; explain the file format a
-- little bit, for example.

-- | A makefile rule specifying dependencies
data DepSpec = DepSpec { targets      :: [String]
                       -- ^ list of targets created by the rule
                       , requirements :: [String]
                       -- ^ list of files on which the targets depend
                       }

-- whitespace other than a line break:
lineWS :: Parser Char
lineWS = oneOf " \t\f" <|> string "\\\n"

token :: Parser a -> Parser a
token p = p <* many lineWS

colon = token (string ":")

targetName :: Parser String
parseDepSpec :: Parser DepSpec

parseDeps :: Parser DepSpec
