package protocol

// package protocol implements the organization of the data sent to
// HUD iOS devices.

type (
	PositionValues struct {
		Roll  float64
		Pitch float64
		Yaw   float64
	}

	// struct MyoData represents the data captured by one Myo device.
	MyoData struct {
		Positions PositionValues
		Pose      string
	}

	KinectData struct {
		PlayerOnePosition float64
		PlayerTwoPosition float64
	}

	MyoPlayer struct {
		Health  float64
		Stamina float64
		Pose    string
	}

	// struct Data is the collection of all data sent to the iOS devices.
	Data struct {
		PlayerData []MyoPlayer
	}

	Test struct {
		Random float64
	}
)
