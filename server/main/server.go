package main

// package main implements the server-side code that organizes input
// data from the Myo and Kinect devices, and sends it to multiple
// iOS clients.

import (
	"bufio"
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

var (
	DataToSend = protocol.MyoData{}
)

func main() {

	go continuouslyCheckForInput()

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
		jsonBytes, err := json.Marshal(DataToSend)
		checkErr(err)

		conn.Write(jsonBytes)
		conn.Write([]byte("\n"))

		time.Sleep(20 * time.Millisecond)
	}
}

func getSampleSinValue() float64 {
	// Computes a periodic function of time with period of 1 second
	return (math.Sin(((float64(time.Now().UnixNano() / int64(time.Millisecond))) / (100.0 * math.Pi))) + 1.0) / 2.0
}

func continuouslyCheckForInput() {
	bio := bufio.NewReader(os.Stdin)
	for {
		data := getLineOfJSON(bio)
		DataToSend = data
	}
}

func getLineOfJSON(bio *bufio.Reader) protocol.MyoData {
	line, _, _ := bio.ReadLine()
	data := protocol.MyoData{}
	json.Unmarshal(line, &data)
	return data
}

func checkErr(err error) {
	if err != nil {
		log.Println(err)
		os.Exit(1)
	}
}
