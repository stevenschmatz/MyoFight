package protocol

type (
	TestData struct {
		Hello string
	}

	MyoData struct {
		Accelerometer []string
		Gyroscope     []string
		Magnemometer  []string
		Gesture       string
	}

	Data struct {
		MyoOne MyoData
		MyoTwo MyoData
	}
)

var (
	TestJSON = Data{
		MyoOne: MyoData{
			Accelerometer: []string{"0.01", "0.98", "0.52"},
			Gyroscope:     []string{"0.03", "0.35", "0.89"},
			Magnemometer:  []string{"0.38", "0.86", "0.01"},
			Gesture:       "Fist",
		},

		MyoTwo: MyoData{
			Accelerometer: []string{"0.01", "0.98", "0.52"},
			Gyroscope:     []string{"0.03", "0.35", "0.89"},
			Magnemometer:  []string{"0.38", "0.86", "0.01"},
			Gesture:       "Open hand",
		},
	}
)
