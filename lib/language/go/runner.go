package main

import (
	"encoding/json"
	"fmt"
	"go/ast"
	"go/parser"
	"go/token"
	"os"
	"os/exec"
	"strings"
	"unicode"
	"unicode/utf8"
)

type Result struct {
	Passed []string
	Failed []string
	Log    string
}

func testNames(filename string) (names []string) {
	f, err := parser.ParseFile(token.NewFileSet(), filename, nil, parser.ParseComments)
	if err != nil {
		panic(err)
	}
	for _, d := range f.Decls {
		n, ok := d.(*ast.FuncDecl)
		if !ok {
			continue
		}
		if n.Recv != nil {
			continue
		}
		name := n.Name.String()

		if isTest(name, "Test") {
			names = append(names, name)
		}
	}

	return
}

// isTest tells whether name looks like a test (or benchmark, according to prefix).
// It is a Test (say) if there is a character after Test that is not a lower-case letter.
// We don't want TesticularCancer.
func isTest(name, prefix string) bool {
	if !strings.HasPrefix(name, prefix) {
		return false
	}
	if len(name) == len(prefix) { // "Test" is ok
		return true
	}
	rune, _ := utf8.DecodeRuneInString(name[len(prefix):])
	return !unicode.IsLower(rune)
}

func main() {
	result := new(Result)
	tests := testNames(os.Args[2])

	for _, test := range tests {
		cmd := exec.Command("go", "test", "-test.run", test, "-test.timeout", "1s")
		out, err := cmd.CombinedOutput()

		if err == nil {
			result.Passed = append(result.Passed, test)
		} else if _, ok := err.(*exec.ExitError); ok {
			result.Failed = append(result.Failed, test)
		} else {
			panic(err)
		}

		result.Log += string(out)
	}

	jsonResult, _ := json.Marshal(result)
	fmt.Println(string(jsonResult))
}
