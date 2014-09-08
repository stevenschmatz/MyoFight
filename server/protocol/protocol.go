package protocol

// package protocol implements the organization of the data sent to
// HUD iOS devices.

type (

	// struct MyoData represents the data captured by one Myo device.
	MyoData struct {
		Roll  float64
		Pitch float64
		Yaw   float64
		X     float64
		Y     float64
		Z     float64
		Pose  string
	}

	KinectData struct {
		Player1 float64
		Player2 float64
	}

	MainInputData struct {
		Player1 MyoData
		Kinect  KinectData
	}

	RelayInputData struct {
		Player2 MyoData
	}

	MyoPlayer struct {
		Position float64
		Health   float64
		Stamina  float64
		Pose     string
	}

	// struct Data is the collection of all data sent to the iOS devices.
	Data struct {
		State string
		PlayerData []MyoPlayer
	}

	Test struct {
		Random float64
	}
)
