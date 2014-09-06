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

	// struct Data is the collection of all data sent to the iOS devices.
	Data struct {
		MyoOne MyoData
		MyoTwo MyoData
	}

	Test struct {
		Random float64
	}
)
