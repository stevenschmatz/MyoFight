package main

import (
	"fmt"
	"log"
	"net"
)

func main() {
	conn, _ := net.Dial("tcp", "127.0.0.1:2417")

	for {
		buffer := make([]byte, 1024)
		bytesRead, error := conn.Read(buffer)
		if error != nil {
			log.Println("Client connection error: ", error)
		}

		fmt.Println(string(buffer[0:bytesRead]))
	}
}
