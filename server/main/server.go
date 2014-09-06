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
	PORT = ":3458"
)

var (
	DataToSend = protocol.Data{}
	MyoTwoJSON []byte
)

func main() {

	go continuouslyCheckForInput()
	go receiveDataFromRelay()

	go func() {
		for {
			fmt.Println(string(MyoTwoJSON))
			time.Sleep(1000 * time.Millisecond)
		}
	}()

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
		fmt.Println(string(jsonBytes))
		conn.Write([]byte("\n"))

		time.Sleep(20 * time.Millisecond)
	}
}

func continuouslyCheckForInput() {
	bio := bufio.NewReader(os.Stdin)
	for {
		MyoData := getLineOfJSON(bio)
		data := protocol.Data{
			[]protocol.MyoPlayer{
				protocol.MyoPlayer{
					Health:  0.9,
					Stamina: 0.6,
					Pose:    MyoData.Pose,
				},
			},
		}
		DataToSend = data
	}
}

func receiveDataFromRelay() {
	conn, _ := net.Dial("tcp", "127.0.0.1:2417")

	for {
		buffer := make([]byte, 1024)
		bytesRead, error := conn.Read(buffer)
		if error != nil {
			log.Println("Client connection error: ", error)
		}

		MyoTwoJSON = buffer[0:bytesRead]
	}
}

func getLineOfJSON(bio *bufio.Reader) protocol.MyoPlayer {
	line, _, _ := bio.ReadLine()
	data := protocol.MyoPlayer{}
	json.Unmarshal(line, &data)
	return data
}

func checkErr(err error) {
	if err != nil {
		log.Println(err)
		os.Exit(1)
	}
}
