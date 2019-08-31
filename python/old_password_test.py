import unittest
import pytest
from old_password import old_password


@pytest.mark.parametrize("password,expected_hash", [
    (None, None),
    ("", ""),
    ("a", "60671c896665c3fa"),
    ("abc", "7cd2b5942be28759"),
    ("ä", "0751368d49315f7f"),
])
def test_old_password(password, expected_hash):
    assert old_password(password) == expected_hash


def test_password_with_space():
    """
    spaces in password are skipped
    """

    assert old_password("pass word") == old_password("password")


def test_password_with_tab():
    """
    tabs in password are skipped
    """

    assert old_password("pass\tword") == old_password("password")
