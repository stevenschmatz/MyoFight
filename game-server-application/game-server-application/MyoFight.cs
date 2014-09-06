using System;
using System.Collections.Generic;
using System.ComponentModel;
using System.Data;
using System.Drawing;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using System.Windows.Forms;

using System.Diagnostics;
using System.Threading;

using KinectManagement;
using Microsoft.Kinect;
using System.IO;

namespace game_server_application
{
    public partial class MyoFight : Form
    {
        Thread execThread;
        KinectSensor kinect;

        public MyoFight()
        {
            InitializeComponent();

            foreach (var potentialSensor in KinectSensor.KinectSensors)
            {
                if (potentialSensor.Status == KinectStatus.Connected)
                {
                    this.kinect = potentialSensor;
                    break;
                }
            }

            if (this.kinect == null) Application.Exit();

            Debug.WriteLine(this.kinect.Status.ToString());

            this.kinect.SkeletonStream.Enable();
            this.kinect.SkeletonFrameReady += this.SensorSkeletonFrameReady;

            this.kinect.Start();

            execThread = new Thread(asyncGameProcessTask);
            execThread.Start();
        }

        private void MyoFight_Load(object sender, EventArgs e)
        {
            
        }

        String kinectData = "";

        private void asyncGameProcessTask()
        {
            Process gameConnectProcess = new Process();
            gameConnectProcess.StartInfo.FileName = "game-connect.exe";
            gameConnectProcess.StartInfo.UseShellExecute = false;
            gameConnectProcess.StartInfo.RedirectStandardOutput = true;

            gameConnectProcess.Start();

            Process gameServer = new Process();
            gameServer.StartInfo.FileName = "server.exe";
            gameServer.StartInfo.UseShellExecute = false;
            gameServer.StartInfo.RedirectStandardInput = true;
            gameServer.StartInfo.RedirectStandardOutput = true;

            gameServer.Start();

            while (true)
            {
                if (shouldStop) break;

                if (gameServer.HasExited || gameConnectProcess.HasExited) break;

                string myo1 = "{\"Player1\":" + gameConnectProcess.StandardOutput.ReadLine() + kinectData + "}";
                kinectData = "";

                gameServer.StandardInput.WriteLine(myo1);
                Debug.WriteLine(myo1);
            }

            if (!gameConnectProcess.HasExited)
            {
                gameConnectProcess.Kill();
                gameConnectProcess.WaitForExit();
            }


            if (!gameServer.HasExited)
            {
                gameServer.Kill();
                gameServer.WaitForExit();
            }
        }

        double x1, x2;

        private void SensorSkeletonFrameReady(object sender, SkeletonFrameReadyEventArgs e)
        {
            Skeleton[] skeletons = new Skeleton[0];

            using (SkeletonFrame skeletonFrame = e.OpenSkeletonFrame())
            {
                if (skeletonFrame != null)
                {
                    skeletons = new Skeleton[skeletonFrame.SkeletonArrayLength];
                    skeletonFrame.CopySkeletonDataTo(skeletons);
                }
            }

            int tempI = 0;
            double[] tempX = new double[2];

            for (int i = 0; i < skeletons.Length; i++)
            {
                double x = skeletons[i].Joints[JointType.Spine].Position.X;

                if (x != 0)
                {
                    tempX[tempI] = x;
                    tempI++;
                    if (tempI >= 2) break;
                }
            }

            x1 = tempX[0];
            x2 = tempX[1];

            if (x1 > x2)
            {
                double temp = x1;
                x1 = x2;
                x2 = temp;
            }

            label1.Text = x1.ToString();
            label2.Text = x2.ToString();

            kinectData = ", {\"Kinect\":{\"Player1\":" + x1.ToString() + ", \"Player2\":" + x2.ToString() + "}}";
        }

        volatile bool shouldStop = false;

        private void MyoFight_FormClosing(object sender, FormClosingEventArgs e)
        {
            shouldStop = true;
            Application.ExitThread();
        }
    }
}
