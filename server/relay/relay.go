package main

// The relay sends the second Myo data through a virtual machine.

import (
	"bufio"
	"fmt"
	"log"
	"net"
	"os"
	"time"
)

const (
	PORT = ":2417"
)

var (
	DataToSend []byte
)

func main() {

	listener, err := net.Listen("tcp", PORT)
	checkErr(err)
	fmt.Println("Relay started.\n---------------")

	for {
		conn, err := listener.Accept()
		fmt.Println("Connected from", conn.RemoteAddr())
		checkErr(err)

		go handleConn(conn)
	}

}

func handleConn(conn net.Conn) {
	for {
		conn.Write(DataToSend)
		conn.Write([]byte("\n"))

		time.Sleep(20 * time.Millisecond)
	}
}

func continuouslyCheckForInput() {
	bio := bufio.NewReader(os.Stdin)
	for {
		line, _, _ := bio.ReadLine()
		DataToSend = line
	}
}

func checkErr(err error) {
	if err != nil {
		log.Println(err)
		os.Exit(1)
	}
}
