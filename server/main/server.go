package main

// package main implements the server-side code that organizes input
// data from the Myo and Kinect devices, and sends it to multiple
// iOS clients.

import (
	"bufio"
	"encoding/json"
	"fmt"
	"github.com/stevenschmatz/myo-game/server/combat"
	"github.com/stevenschmatz/myo-game/server/protocol"
	"net"
	"os"
	"time"
)

const (
	SERVER_PORT = ":4458"
	RELAY_IP    = "35.2.108.81:2417"
)

var (
	mainInputData  = protocol.MainInputData{}
	relayInputData = protocol.RelayInputData{}
	output []byte
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
	combat.InitPlayersWithLocation(mainInputData.Kinect.Player1, mainInputData.Kinect.Player2)
	for {
		DataToSend := combat.SendActions(mainInputData, relayInputData)
		jsonBytes, err := json.Marshal(DataToSend)
		checkErr(err)

		conn.Write(jsonBytes)
		conn.Write([]byte("\n"))

		time.Sleep(50 * time.Millisecond)
	}
}

// continuouslyCheckForInput consistently polls stdin for input
// from the first Myo device, as well as the Kinect device.
func continuouslyCheckForInput() {
	bio := bufio.NewReader(os.Stdin)
	
	counter := 0
	for {
		line, _, _ := bio.ReadLine()

		output = line

		data := protocol.MainInputData{}
		json.Unmarshal(line, &data)
		mainInputData = data
		counter += 1
	}
}

// receiveDataFromRelay receives JSON lines from the relay server,
// containing the data from the second Myo device.
func receiveDataFromRelay() {
	conn, err := net.Dial("tcp", RELAY_IP)
	checkErr(err)
	
	for {
		buffer := make([]byte, 1024)
		bytesRead, _ := conn.Read(buffer)
		/*
		if err != nil {
			log.Println("Client connection err: ", err)
		}
		*/
		MyoTwoJSON := buffer[0:bytesRead]

		data := protocol.RelayInputData{}
		json.Unmarshal(MyoTwoJSON, &data)

		relayInputData = data
	}
}

func checkErr(err error) {
	if err != nil {
		output = []byte(err.Error())
		os.Exit(1)
	}
}
