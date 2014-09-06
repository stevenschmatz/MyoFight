package main

import (
	"fmt"
	"log"
	"net"
	"os"
)

func main() {
	listener, err := net.Listen("tcp", ":8080")
	checkErr(err)

	for {
		conn, err := listener.Accept()
		checkErr(err)

		go handleConn(conn)
	}

}

func handleConn(conn net.Conn) {
	conn.Write([]byte("Hello world!"))
}

func checkErr(err error) {
	if err != nil {
		log.Println(err)
		os.Exit(1)
	}
}
