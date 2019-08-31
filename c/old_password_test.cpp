/**
 * @file old_password_test.cpp
 *
 * This file contains some test cases that can be used to verify the
 * correct implementation of the function in other programming languages.
 */
#define CATCH_CONFIG_MAIN
#include "catch.hpp"

#include "old_password.h"

#include <string.h>

std::string old_password(const std::string &password)
{
  char result[17] = "";

  my_make_scrambled_password_323(result, &password[0], password.length());

  return std::string(result);
}

TEST_CASE("examples from MariaDB GitHub")
{
  // these tests would fail, because the empty string and null pointer cases
  // are handled in \ref Item_func_password::val_str_ascii
#if 0
  SECTION("empty string")
  {
    REQUIRE(old_password("") == "");
  }
#endif

  SECTION("a")
  {
    REQUIRE(old_password("a") == "60671c896665c3fa");
  }

  SECTION("abc")
  {
    REQUIRE(old_password("abc") == "7cd2b5942be28759");
  }
}

TEST_CASE("different cases")
{
  REQUIRE(old_password("\xc3\xa4") == "0751368d49315f7f");
}
