package main

import (
	"bufio"
	"encoding/json"
	"fmt"
	"github.com/stevenschmatz/myo-game/server/protocol"
	"os"
)

type Data struct {
	Hello string
}

func main() {
	bio := bufio.NewReader(os.Stdin)
	for {
		data := getLineOfJSON(bio)
		fmt.Println(data)
	}
}

func getLineOfJSON(bio *bufio.Reader) protocol.Data {
	line, _, _ := bio.ReadLine()
	data := protocol.Data{}
	json.Unmarshal(line, &data)
	return data
}
