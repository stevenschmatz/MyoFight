package combat

// Package combat contains the code required to control the combat
// between the players.

import (
	"encoding/json"
	"github.com/stevenschmatz/myo-game/server/protocol"
)

type (
	Player struct {
		Position float64
		Health   float64
		Stamina  float64
		Action   string
	}
)

var (
	playerOne = Player{}
	playerTwo = Player{}
	players   = []Player{
		playerOne,
		playerTwo,
	}
)

// InitPlayersWithLocation should be called after the Kinect has found locations for each character.
func InitPlayersWithLocation(locationOne, locationTwo float64) {
	players[0] = Player{
		Position: locationOne,
		Health:   1.0,
		Stamina:  1.0,
		Action:   "rest",
	}

	players[1] = Player{
		Position: locationTwo,
		Health:   1.0,
		Stamina:  1.0,
		Action:   "rest",
	}
}

func DecreaseHealthOfPlayer(playerNumber int, percentDamage float64) {
	players[playerNumber-1].Health -= percentDamage
}

func IncreaseStaminaOfPlayer(playerNumber int, percentIncrease float64) {
	players[playerNumber-1].Stamina += percentIncrease
}

func UpdatePosition(playerNumber int, newPosition float64) {
	players[playerNumber-1].Position = newPosition
}

func UpdateAction(playerNumber int, actionString string) {
	players[playerNumber-1].Action = actionString
}

func GetPlayersJSON() ([]byte, error) {
	return json.Marshal(players)
}
