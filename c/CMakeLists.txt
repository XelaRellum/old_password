cmake_minimum_required(VERSION 3.10)

project(old_password_test)

enable_testing()

add_executable(old_password_test
  old_password.c
  old_password_test.cpp
)

target_include_directories(old_password_test
  PRIVATE
  catch2
)

add_test(NAME old_password_test COMMAND old_password_test)
