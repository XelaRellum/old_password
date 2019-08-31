/**
 * @file old_password.c
 *
 * @details This is the original source code of the function
 *          `my_make_scrambled_password_323`
 *          (see https://github.com/MariaDB/server,
 *          `/server/sql/password.c`).
 */
/*
   Copyright (c) 2000, 2017, Oracle and/or its affiliates.
   Copyright (c) 2009, 2019, MariaDB Corporation
   This program is free software; you can redistribute it and/or modify
   it under the terms of the GNU General Public License as published by
   the Free Software Foundation; version 2 of the License.
   This program is distributed in the hope that it will be useful,
   but WITHOUT ANY WARRANTY; without even the implied warranty of
   MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
   GNU General Public License for more details.
   You should have received a copy of the GNU General Public License
   along with this program; if not, write to the Free Software
   Foundation, Inc., 51 Franklin St, Fifth Floor, Boston, MA 02110-1335  USA
*/

#include <stdio.h>

#include "old_password.h"

typedef unsigned long ulong;
typedef unsigned int uint;
typedef unsigned char uchar;

void hash_password(ulong *result, const char *password, uint password_len)
{
  ulong nr = 1345345333L, add = 7, nr2 = 0x12345671L;
  ulong tmp;
  const char *password_end = password + password_len;
  for (; password < password_end; password++)
  {
    if (*password == ' ' || *password == '\t')
      continue; /* skip space in password */
    tmp = (ulong)(uchar)*password;
    nr ^= (((nr & 63) + add) * tmp) + (nr << 8);
    nr2 += (nr2 << 8) ^ nr;
    add += tmp;
  }
  result[0] = nr & (((ulong)1L << 31) - 1L); /* Don't use sign bit (str2int) */
  ;
  result[1] = nr2 & (((ulong)1L << 31) - 1L);
}

/*
    Create password to be stored in user database from raw string
    Used for pre-4.1 password handling
  SYNOPSIS
    my_make_scrambled_password_323()
    to        OUT store scrambled password here
    password  IN  user-supplied password
    pass_len  IN  length of password string
*/

void my_make_scrambled_password_323(char *to, const char *password,
                                    size_t pass_len)
{
  ulong hash_res[2];
  hash_password(hash_res, password, (uint)pass_len);
  sprintf(to, "%08lx%08lx", hash_res[0], hash_res[1]);
}
