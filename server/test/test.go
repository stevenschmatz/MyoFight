package main

import (
	"fmt"
	"github.com/stevenschmatz/myo-game/server/combat"
)

func main() {
	combat.InitPlayersWithLocation(-36.00, 23.2453)
	bytes, _ := combat.GetPlayersJSON()
	fmt.Println(string(bytes))
}
