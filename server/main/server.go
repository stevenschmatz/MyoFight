package main

import (
	"encoding/json"
	"fmt"
	"github.com/stevenschmatz/myo-game/server/protocol"
	"log"
	"net"
	"os"
)

const (
	PORT = ":3458"
)

func main() {
	listener, err := net.Listen("tcp", PORT)
	checkErr(err)

	fmt.Println("Server started.")
	fmt.Println("---------------")

	fmt.Println(listener.Addr().String())

	for {
		conn, err := listener.Accept()
		fmt.Println("Connected from", conn.RemoteAddr())
		checkErr(err)

		go handleConn(conn)
	}

}

func handleConn(conn net.Conn) {
	a := protocol.Data{
		protocol.MyoData{
			Accelerometer: []string{"1", "2"},
			Gyroscope:     []string{"3"},
			Magnemometer:  []string{"4"},
			Gesture:       "fist",
		},
	}

	jsonBytes, err := json.Marshal(a)
	checkErr(err)

	conn.Write(jsonBytes)
}

func checkErr(err error) {
	if err != nil {
		log.Println(err)
		os.Exit(1)
	}
}
