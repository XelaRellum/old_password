#! python3
def old_password(password):
    if password == None:
        return None
    if password == "":
        return ""

    nr = 1345345333
    add = 7
    nr2 = 0x12345671

    if type(password) == str:
        password = password.encode("utf-8")

    for ch in password:
        if ch == ord(" "):
            continue  # skip spaces
        if ch == ord("\t"):
            continue  # skip tabs

        tmp = ch
        nr ^= (((nr & 63) + add) * tmp) + (nr << 8)
        nr2 += (nr2 << 8) ^ nr
        add += tmp

    # Don't use sign bit (str2int)
    result0 = nr & ((1 << 31) - 1)
    result1 = nr2 & ((1 << 31) - 1)

    return "%08x%08x" % (result0, result1)
