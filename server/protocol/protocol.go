package protocol

// package protocol implements the organization of the data sent to
// HUD iOS devices.

type (

	// struct MyoData represents the data captured by one Myo device.
	MyoData struct {
		Accelerometer []float64
		Gyroscope     []float64
		Magnemometer  []float64
		Gesture       string
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

var (

	// struct TestJSON is a sample piece of data sent to the iOS devices.
	TestJSON = Data{
		MyoOne: MyoData{
			Accelerometer: []float64{0.01, 0.98, 0.52},
			Gyroscope:     []float64{0.03, 0.35, 0.89},
			Magnemometer:  []float64{0.38, 0.86, 0.01},
			Gesture:       "Fist",
		},

		MyoTwo: MyoData{
			Accelerometer: []float64{0.01, 0.98, 0.52},
			Gyroscope:     []float64{0.03, 0.35, 0.89},
			Magnemometer:  []float64{0.38, 0.86, 0.01},
			Gesture:       "Open hand",
		},
	}
)
