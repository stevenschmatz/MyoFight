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

namespace game_server_application
{
    public partial class MyoFight : Form
    {
        public MyoFight()
        {
            InitializeComponent();
        }

        private void MyoFight_Load(object sender, EventArgs e)
        {
            

            Thread execThread = new Thread(asyncGameProcessTask);
            execThread.Start();

            
        }

        private void asyncGameProcessTask()
        {
            Process gameConnectProcess = new Process();
            gameConnectProcess.StartInfo.FileName = "game-connect.exe";
            gameConnectProcess.StartInfo.UseShellExecute = false;
            gameConnectProcess.StartInfo.RedirectStandardOutput = true;

            gameConnectProcess.Start();

            Process gameInputProcess = new Process();
            gameInputProcess.StartInfo.FileName = "input.exe";
            gameInputProcess.StartInfo.UseShellExecute = false;
            gameInputProcess.StartInfo.RedirectStandardInput = true;
            gameInputProcess.StartInfo.RedirectStandardOutput = true;

            gameInputProcess.Start();

            while (true)
            {
                if (gameInputProcess.HasExited || gameConnectProcess.HasExited) break;

                gameInputProcess.StandardInput.WriteLine(gameConnectProcess.StandardOutput.ReadLine());
                Debug.WriteLine(gameInputProcess.StandardOutput.ReadLine());
            }

            gameConnectProcess.WaitForExit();
            gameInputProcess.WaitForExit();
        }
    }
}
