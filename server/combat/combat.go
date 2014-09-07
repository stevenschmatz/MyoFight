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

const (
	CLOSE_RANGE  = 0.10 // 10 percent of Kinect frame
	KINECT_RANGE = 2.0
)

var (
	playerOne = Player{}
	playerTwo = Player{}
	players   = []Player{
		playerOne,
		playerTwo,
	}
)

// SendActions reports the actions that must be sent to the iOS devices.
func SendActions(mainInputData protocol.MainInputData, relayInputData protocol.RelayInputData) protocol.Data {
	return protocol.Data{
		PlayerData: []protocol.MyoData{
			protocol.MyoData{
				Position: mainInputData.Kinect.Player1,
				Health:   players[0].Health,
				Stamina:  players[0].Stamina,
				Pose:     players[0].Action,
			},
			protocol.MyoData{
				Position: mainInputData.Kinect.Player2,
				Health:   players[1].Health,
				Stamina:  players[1].Stamina,
				Pose:     players[1].Action,
			},
		},
	}
}

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

func UpdatePositions(rawKinectData protocol.KinectData) {
	pos1 := TruncatePosition(rawKinectData.PlayerOnePosition)
	pos2 := TruncatePosition(rawKinectData.PlayerTwoPosition)

	players[0].Position = pos1
	players[1].Position = pos2
}

func TruncatePosition(position float64) float64 {
	position /= (KINECT_RANGE / 2) // Standardizing
	if position > 1 {
		return 1
	} else if position < -1 {
		return -1
	} else {
		return position
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
