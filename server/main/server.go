package main

import (
	"encoding/json"
	"fmt"
	"github.com/stevenschmatz/myo-game/server/protocol"
	"log"
	"net"
	"os"
	"time"
)

const (
	PORT = ":3458"
)

func main() {
	listener, err := net.Listen("tcp", PORT)
	checkErr(err)
	fmt.Println("Server started.\n---------------")

	for {
		conn, err := listener.Accept()
		fmt.Println("Connected from", conn.RemoteAddr())
		checkErr(err)

		go handleConn(conn)
	}

}

func handleConn(conn net.Conn) {
	for {
		jsonBytes, err := json.Marshal(protocol.TestJSON)
		checkErr(err)

		conn.Write(jsonBytes)

		time.Sleep(1000 * time.Millisecond)
	}
}

func checkErr(err error) {
	if err != nil {
		log.Println(err)
		os.Exit(1)
	}
}
