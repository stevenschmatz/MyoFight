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
	"net"
	"os"
	"time"
)

const (
	SERVER_PORT = ":3458"
	RELAY_IP    = "127.0.0.1:2417"
)

var (
	mainInputData = protocol.MainInputData{}
	myoTwoData    = protocol.RelayInputData{}
)

// main accepts clients and starts listening threads.
func main() {

	go continuouslyCheckForInput()
	go receiveDataFromRelay()

	listener, err := net.Listen("tcp", SERVER_PORT)
	checkErr(err)
	fmt.Println("Server started.\n---------------")

	for {
		conn, err := listener.Accept()
		fmt.Println("Connected from", conn.RemoteAddr())
		checkErr(err)

		go handleConn(conn)
	}

}

// handleConn sends a stream of data to the client from both
// Myo devices, as well as from the Kinect device.
func handleConn(conn net.Conn) {
	for {
		jsonBytes, err := json.Marshal(DataToSend)
		checkErr(err)

		conn.Write(jsonBytes)
		conn.Write([]byte("\n"))

		time.Sleep(20 * time.Millisecond)
	}
}

// continuouslyCheckForInput consistently polls stdin for input
// from the first Myo device, as well as the Kinect device.
func continuouslyCheckForInput() {
	bio := bufio.NewReader(os.Stdin)
	for {
		line, _, _ := bio.ReadLine()
		data := protocol.MainInputData{}
		json.Unmarshal(line, &data)
		mainInputData = data
	}
}

// receiveDataFromRelay receives JSON lines from the relay server,
// containing the data from the second Myo device.
func receiveDataFromRelay() {
	conn, _ := net.Dial("tcp", RELAY_IP)

	for {
		buffer := make([]byte, 1024)
		bytesRead, error := conn.Read(buffer)
		if error != nil {
			log.Println("Client connection error: ", error)
		}

		MyoTwoJSON := buffer[0:bytesRead]

		data := protocol.RelayInputData{}
		json.Unmarshal(MyoTwoJSON, &data)

		myoTwoData = data
	}
}

func checkErr(err error) {
	if err != nil {
		log.Println(err)
		os.Exit(1)
	}
}
