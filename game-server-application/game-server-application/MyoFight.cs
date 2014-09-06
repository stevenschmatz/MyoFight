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

        Thread execThread;

        private void MyoFight_Load(object sender, EventArgs e)
        {
            

            execThread = new Thread(asyncGameProcessTask);
            execThread.Start();

            
        }

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

                gameServer.StandardInput.WriteLine(gameConnectProcess.StandardOutput.ReadLine());
                //Debug.WriteLine(gameServer.StandardOutput.ReadLine());
                Debug.WriteLine(gameConnectProcess.StandardOutput.ReadLine());
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

        volatile bool shouldStop = false;

        private void MyoFight_FormClosing(object sender, FormClosingEventArgs e)
        {
            shouldStop = true;
            Application.ExitThread();
        }
    }
}
