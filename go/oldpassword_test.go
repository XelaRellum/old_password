package oldpassword

import (
	"bufio"
	"os"
	"strings"
	"testing"

	"github.com/stretchr/testify/require"
)

func TestOldPassword(t *testing.T) {
	r := require.New(t)

	testCases := []struct {
		password     string
		expectedHash string
	}{
		{"", ""},
		{"a", "60671c896665c3fa"},
		{"abc", "7cd2b5942be28759"},
		{"ä", "0751368d49315f7f"},
	}

	for _, testCase := range testCases {
		actualHash := OldPassword(testCase.password)

		r.Equal(testCase.expectedHash, actualHash)
	}
}

func TestPasswordWithSpace(t *testing.T) {
	r := require.New(t)

	r.Equal(OldPassword("pass word"), OldPassword("password"))
}

func TestPasswordWithTabs(t *testing.T) {
	r := require.New(t)

	r.Equal(OldPassword("pass\tword"), OldPassword("password"))
}

func TestWithTestdata(t *testing.T) {
	r := require.New(t)

	f, err := os.Open("../testdata.csv")
	r.Nil(err, "Error opening file")

	scanner := bufio.NewScanner(f)
	scanner.Split(bufio.ScanLines)
	for scanner.Scan() {
		line := scanner.Text()
		parts := strings.Split(line, ";")
		password := parts[0]
		expectedHash := parts[1]
		actualHash := OldPassword(password)

		r.Equal(expectedHash, actualHash)
	}

}
