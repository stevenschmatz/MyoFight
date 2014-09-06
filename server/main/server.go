package main

// package main implements the server-side code that organizes input
// data from the Myo and Kinect devices, and sends it to multiple
// iOS clients.

import (
	"encoding/json"
	"fmt"
	"github.com/stevenschmatz/myo-game/server/protocol"
	"log"
	"math"
	"net"
	"os"
	"time"
)

const (
	PORT = ":3458"
)

func main() {

	jsonBytes, err := json.Marshal(protocol.TestJSON)
	checkErr(err)

	fmt.Println(string(jsonBytes))

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
		a := protocol.Test{
			Random: getSampleSinValue(),
		}
		jsonBytes, err := json.Marshal(a)
		checkErr(err)

		conn.Write(jsonBytes)
		conn.Write([]byte("\n"))

		time.Sleep(10 * time.Millisecond)
	}
}

func getSampleSinValue() float64 {
	// Computes a periodic function of time with period of 1 second
	return (math.Sin(((float64(time.Now().UnixNano() / int64(time.Millisecond))) / (100.0 * math.Pi))) + 1.0) / 2.0
}

func checkErr(err error) {
	if err != nil {
		log.Println(err)
		os.Exit(1)
	}
}
