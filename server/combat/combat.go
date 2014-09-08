package combat

// Package combat contains the code required to control the combat
// between the players.

import (
	"encoding/json"
	"github.com/stevenschmatz/myo-game/server/protocol"
	"reflect"
	"time"
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
	SMOOTHING_FRAME = 10
)

var (
	playerOne = Player{}
	playerTwo = Player{}
	players   = []Player{}
	playersPreviousActions = [][]string{
		[]string{"none", "none"},
		[]string{"none", "none"},
	}
	playerOneTimeout = 0
	playerTwoTimeout = 0
	playerOneLastCommand = "none"
	playerTwoLastCommand = "none"
	playerOneShielded = false
	playerTwoShielded = false

	GameState = "starting"

	StartingTime = 0
)

// SendActions reports the actions that must be sent to the iOS devices.
func SendActions(mainInputData protocol.MainInputData, relayInputData protocol.RelayInputData) protocol.Data {

	if playerOneShielded {
		if players[0].Stamina < 0 {
			playerOneShielded = false
			players[0].Stamina = 0
		}
		players[0].Stamina -= 0.005
	} else {
		if players[0].Stamina < 1.0 {
			players[0].Stamina += 0.001
		}
	}

	if playerTwoShielded {
		if players[1].Stamina < 0 {
			playerTwoShielded = false
			players[1].Stamina = 0
		}
		players[1].Stamina -= 0.005
	} else {
		if players[1].Stamina < 1.0 {
			players[1].Stamina += 0.001
		}
	}

	if mainInputData.Player1.Pitch < 1.5 {
		playerOneShielded = true
		return protocol.Data{
		State: GameState,
		PlayerData: []protocol.MyoPlayer{
			protocol.MyoPlayer{
				Position: mainInputData.Kinect.Player1 + 0.15,
				Health:   players[0].Health,
				Stamina:  players[0].Stamina,
				Pose:     "shield",
			},
			protocol.MyoPlayer{
				Position: mainInputData.Kinect.Player2 - 0.15,
				Health:   players[1].Health,
				Stamina:  players[1].Stamina,
				Pose:     "rest",
			},
		},
	}
	} else {
		playerOneShielded = false
	}

	if relayInputData.Player2.Pitch < 1.5 {
		playerTwoShielded = true
		return protocol.Data{
		State: GameState,
		PlayerData: []protocol.MyoPlayer{
			protocol.MyoPlayer{
				Position: mainInputData.Kinect.Player1 + 0.15,
				Health:   players[0].Health,
				Stamina:  players[0].Stamina,
				Pose:     "shield",
			},
			protocol.MyoPlayer{
				Position: mainInputData.Kinect.Player2 - 0.15,
				Health:   players[1].Health,
				Stamina:  players[1].Stamina,
				Pose:     "rest",
			},
		},
	}
	} else {
		playerTwoShielded = false
	}

	if players[0].Health <= 0 || players[1].Health <= 0 || GameState == "finished" {
		GameState = "finished"
		return protocol.Data{}
	}

	if playerOneTimeout > 0 {
		playerOneTimeout -= 1
	} else if playerTwoTimeout > 0 {
		playerTwoTimeout -= 1
	}

	if GameState == "starting" {
		if StartingTime > 20 {
			GameState = "playing"
		} else if mainInputData.Kinect.Player1 > -0.7 && mainInputData.Kinect.Player2 < 0.7 {
			StartingTime += 1
		} else {
			StartingTime = 0
		}
	}

	action := CheckForAction(mainInputData, relayInputData)
	if !reflect.DeepEqual(action, protocol.Data{}) {
		if action.PlayerData[0].Pose != playerOneLastCommand {
			playerOneLastCommand = action.PlayerData[0].Pose
			return action
		} else if action.PlayerData[1].Pose != playerTwoLastCommand {
			playerTwoLastCommand = action.PlayerData[1].Pose
			return action
		}
	}

	playersPreviousActions[0][0] = playersPreviousActions[0][1]
	playersPreviousActions[0][1] = mainInputData.Player1.Pose
	playersPreviousActions[1][0] = playersPreviousActions[1][1]
	playersPreviousActions[1][1] = relayInputData.Player2.Pose
	
	return protocol.Data{
		State: GameState,
		PlayerData: []protocol.MyoPlayer{
			protocol.MyoPlayer{
				Position: mainInputData.Kinect.Player1 + 0.15,
				Health:   players[0].Health,
				Stamina:  players[0].Stamina,
				Pose:     "rest",
			},
			protocol.MyoPlayer{
				Position: mainInputData.Kinect.Player2 - 0.15,
				Health:   players[1].Health,
				Stamina:  players[1].Stamina,
				Pose:     "rest",
			},
		},
	}
}

func CheckForAction(mainInputData protocol.MainInputData, relayInputData protocol.RelayInputData) protocol.Data {
	playerOneAction := mainInputData.Player1.Pose
	playerTwoAction := relayInputData.Player2.Pose

	sendPlayerOneAction, sendPlayerTwoAction := false, false
	if playerOneAction == playersPreviousActions[0][0] && playerOneAction == playersPreviousActions[0][1] {
		sendPlayerOneAction = true
	} else if playerTwoAction == playersPreviousActions[1][0] && playerOneAction == playersPreviousActions[1][1] {
		sendPlayerTwoAction = true
	}

	if sendPlayerOneAction {
		playerOneTimeout = 3
		playersPreviousActions[0] = []string{"none", "none"}
		if playerOneAction == "fingersSpread" && players[0].Stamina > 0.5 {
			players[0].Stamina -= 0.5
			time.Sleep(200 * time.Millisecond)
			players[1].Health -= 0.50
		}
		result := protocol.Data{
			GameState,
			[]protocol.MyoPlayer{
			protocol.MyoPlayer{
				Position: mainInputData.Kinect.Player1 + 0.15,
				Health:   players[0].Health,
				Stamina:  players[0].Stamina,
				Pose:     playerOneAction,
			},
			protocol.MyoPlayer{
				Position: mainInputData.Kinect.Player2 - 0.15,
				Health:   players[1].Health,
				Stamina:  players[1].Stamina,
				Pose:     playerTwoAction,
			},
		},
	}
	if mainInputData.Kinect.Player2 - mainInputData.Kinect.Player1 < 0.4 && playerOneAction == "fist" {
		if playerTwoLastCommand == "waveOut" || playerTwoLastCommand == "waveIn" {
			DecreaseHealthOfPlayer(1, 0.15)
		} else {
			if !playerTwoShielded {
				DecreaseHealthOfPlayer(2, 0.1)
			}
		}
	}
	return result
	} else if sendPlayerTwoAction {
		if playerTwoAction == "fingersSpread" && players[1].Stamina > 0.5 {
			players[1].Stamina -= 0.5
			time.Sleep(200 * time.Millisecond)
			players[0].Health -= 0.50
		}
		playerTwoTimeout = 10
		playersPreviousActions[1] = []string{"none", "none"}
		result := protocol.Data{
			GameState,
			[]protocol.MyoPlayer{
			protocol.MyoPlayer{
				Position: mainInputData.Kinect.Player1,
				Health:   players[0].Health,
				Stamina:  players[0].Stamina,
				Pose:     playerOneAction,
			},
			protocol.MyoPlayer{
				Position: mainInputData.Kinect.Player2,
				Health:   players[1].Health,
				Stamina:  players[1].Stamina,
				Pose:     playerTwoAction,
			},
		},
	}

	if mainInputData.Kinect.Player2 - mainInputData.Kinect.Player1 < 0.4 && playerOneAction == "fist" {
		if playerOneLastCommand == "waveOut" || playerOneLastCommand == "waveIn" {
			DecreaseHealthOfPlayer(2, 0.15)
		} else {
			if !playerOneShielded {
				DecreaseHealthOfPlayer(1, 0.1)
			}
		}
	}
	return result
	}



	return protocol.Data{}
}

// InitPlayersWithLocation should be called after the Kinect has found locations for each character.
func InitPlayersWithLocation(locationOne, locationTwo float64) {
	players[0] = Player{
		Position: locationOne + 0.15,
		Health:   1.0,
		Stamina:  1.0,
		Action:   "rest",
	}

	players[1] = Player{
		Position: locationTwo - 0.15,
		Health:   1.0,
		Stamina:  1.0,
		Action:   "rest",
	}
}

func UpdatePositions(rawKinectData protocol.KinectData) {
	pos1 := TruncatePosition(rawKinectData.Player1)
	pos2 := TruncatePosition(rawKinectData.Player2)

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