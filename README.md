# OLD_PASSWORD

Implementations of the MySQL/MariaDB legacy function `OLD_PASSWORD`.

## Introduction

This is a collection of functions that recreate the legacy password generation function `OLD_PASSWORD` used by MySQL < v4.1.

You can use these functions to keep your applications running even after the `OLD_PASSWORD` function has been dropped from MySQL/MariaDB or your ORM doesn't allow the use of functions.

## Implementations

Current implementations:

* C (this is the reference implementation)
* Elixir
* GO
* Python

Planned implementations:

* Julia
* Erlang
* Clojure
* V

### Reference implementation in C

This is the original source code of the function `my_make_scrambled_password_323` (see <https://github.com/MariaDB/server> in the file `/server/sql/password.c`).

Note: this code is licensed under the original GPL v2.

The test cases in `c/old_password_test.cpp` can be used to verify the correct implementation of the function in other programming languages.

## License

This repository is licensed under the MIT License, for details please see `LICENSE`.
