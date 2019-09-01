package oldpassword

import (
	"fmt"
)

// OldPassword GO implementation of the MySQL / MariaDB OLD_PASSWORD function
func OldPassword(password string) string {
	if password == "" {
		return ""
	}

	var (
		nr  uint32 = 1345345333
		add uint32 = 7
		nr2 uint32 = 0x12345671
	)

	passwordBytes := []byte(password)
	for _, c := range passwordBytes {
		if c == 32 {
			continue // skips spaces
		}
		if c == 9 {
			continue // skip tabs
		}

		tmp := uint32(c)

		nr ^= (((nr & 63) + add) * tmp) + (nr << 8)
		nr2 += (nr2 << 8) ^ nr
		add += tmp
	}

	result0 := nr & 0x7FFFFFFF
	result1 := nr2 & 0x7FFFFFFF

	return fmt.Sprintf("%08x%08x", result0, result1)
}
