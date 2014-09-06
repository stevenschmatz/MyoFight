// game-connect.cpp : Defines the entry point for the console application.
//

#include "stdafx.h"

#define _USE_MATH_DEFINES
#include <cmath>
#include <iomanip>
#include <stdexcept>
#include <string>

#include <iostream>

#include <myo/myo.hpp>

using namespace std;
using namespace myo;

class MyoDataCollector : public myo::DeviceListener {
public:
	MyoDataCollector() : onArm(false), roll_w(0), pitch_w(0), yaw_w(0), currentPose()
	{
	}

	// onUnpair() is called whenever the Myo is disconnected from Myo Connect by the user.
	void onUnpair(myo::Myo* myo, uint64_t timestamp)
	{
		// We've lost a Myo.
		// Let's clean up some leftover state.
		roll_w = 0;
		pitch_w = 0;
		yaw_w = 0;

		x_w = 0;
		y_w = 0;
		z_w = 0;

		onArm = false;
	}

	// onOrientationData() is called whenever the Myo device provides its current orientation, which is represented
	// as a unit quaternion.
	void onOrientationData(myo::Myo* myo, uint64_t timestamp, const myo::Quaternion<float>& quat)
	{
		using std::atan2;
		using std::asin;
		using std::sqrt;

		// Calculate Euler angles (roll, pitch, and yaw) from the unit quaternion.
		float roll = atan2(2.0f * (quat.w() * quat.x() + quat.y() * quat.z()),
			1.0f - 2.0f * (quat.x() * quat.x() + quat.y() * quat.y()));
		float pitch = asin(2.0f * (quat.w() * quat.y() - quat.z() * quat.x()));
		float yaw = atan2(2.0f * (quat.w() * quat.z() + quat.x() * quat.y()),
			1.0f - 2.0f * (quat.y() * quat.y() + quat.z() * quat.z()));

		// Convert the floating point angles in radians to a scale from 0 to 20.
		roll_w = (float) ((roll + (float) M_PI) / (M_PI * 2.0f) * 18);
		pitch_w = (float) ((pitch + (float) M_PI / 2.0f) / M_PI * 18);
		yaw_w = (float) ((yaw + (float) M_PI) / (M_PI * 2.0f) * 18);
	}

	void onAccelerometerData(Myo *myo, uint64_t timestamp, const Vector3< float > &accel)
	{
		x_w = accel.x();
		y_w = accel.y();
		z_w = accel.z();
	}

	// onPose() is called whenever the Myo detects that the person wearing it has changed their pose, for example,
	// making a fist, or not making a fist anymore.
	void onPose(myo::Myo* myo, uint64_t timestamp, myo::Pose pose)
	{
		currentPose = pose;

		// Vibrate the Myo whenever we've detected that the user has made a fist.
		if (pose == myo::Pose::fist || pose == myo::Pose::fingersSpread) {
			myo->vibrate(myo::Myo::vibrationMedium);
		}
	}

	// onArmRecognized() is called whenever Myo has recognized a setup gesture after someone has put it on their
	// arm. This lets Myo know which arm it's on and which way it's facing.
	void onArmRecognized(myo::Myo* myo, uint64_t timestamp, myo::Arm arm, myo::XDirection xDirection)
	{
		onArm = true;
		whichArm = arm;
	}

	// onArmLost() is called whenever Myo has detected that it was moved from a stable position on a person's arm after
	// it recognized the arm. Typically this happens when someone takes Myo off of their arm, but it can also happen
	// when Myo is moved around on the arm.
	void onArmLost(myo::Myo* myo, uint64_t timestamp)
	{
		onArm = false;
	}

	void jsonOutput() {
		cout << "\r";
		cout << "{" << "\"Positions\": {";
		cout << "\"Roll\": " << roll_w << ", ";
		cout << "\"Pitch\": " << pitch_w << ", ";
		cout << "\"Yaw\": " << yaw_w << "}, ";
		cout << "\"X\": " << x_w << "}, ";
		cout << "\"Y\": " << y_w << "}, ";
		cout << "\"Z\": " << z_w << "}, ";
		cout << "\"Pose\": \"" << currentPose.toString() << "\"}";

		cout << flush;
	}

	// These values are set by onArmRecognized() and onArmLost() above.
	bool onArm;
	myo::Arm whichArm;

	// These values are set by onOrientationData() and onPose() above.
	float roll_w, pitch_w, yaw_w;
	float x_w, y_w, z_w;
	myo::Pose currentPose;
};


int _tmain(int argc, _TCHAR* argv[])
{
	Hub hub("com.mhacks.myogame");
	//cout << "Trying to find a Myo" << endl;

	Myo* myo1 = hub.waitForMyo(10000);
	if (!myo1) {
		cout << "Failure finding device" << endl;
		system("pause");
		return 1;
	}

	//cout << "Connected to Armband" << endl;

	MyoDataCollector listener = * new MyoDataCollector();

	hub.addListener(&listener);

	while (1) {
		hub.run(1000 / 20);
		//listener.print();
		listener.jsonOutput();
		//break;
	}

	system("pause");
	
	return 0;
}