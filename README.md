Many tools exist for scanning source files for dependencies, and
outputting them as input appropriate for make. Some examples: ocamldep,
and  gcc's -M option.

This is a haskell library for parsing the subset of Makefile syntax
necessary to support this output. It provides a parsec parser for the
file format.

License: Apache 2.0
