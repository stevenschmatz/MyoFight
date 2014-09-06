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
		MyoData
	}
)
