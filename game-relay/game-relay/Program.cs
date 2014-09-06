using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

using System.Diagnostics;

namespace game_relay
{
    class Program
    {
        static void Main(string[] args)
        {
            Process gameConnectProcess = new Process();
            gameConnectProcess.StartInfo.FileName = "game-connect.exe";
            gameConnectProcess.StartInfo.UseShellExecute = false;
            gameConnectProcess.StartInfo.RedirectStandardOutput = true;

            gameConnectProcess.Start();

            Process relayServer = new Process();
            relayServer.StartInfo.FileName = "relay.exe";
            relayServer.StartInfo.UseShellExecute = false;
            relayServer.StartInfo.RedirectStandardInput = true;
            relayServer.StartInfo.RedirectStandardOutput = true;

            relayServer.Start();

            bool shouldRun = true;

            Console.CancelKeyPress += delegate(object sender, ConsoleCancelEventArgs e) {
			    e.Cancel = true;
			    shouldRun = false;
		    };

            while (shouldRun)
            {
                if (relayServer.HasExited || gameConnectProcess.HasExited) break;

                string myo1 = "{\"Player2\":" + gameConnectProcess.StandardOutput.ReadLine() + "}";

                relayServer.StandardInput.WriteLine(myo1);
                Console.WriteLine(myo1);
            }

            if (!gameConnectProcess.HasExited)
            {
                gameConnectProcess.Kill();
                gameConnectProcess.WaitForExit();
            }


            if (!relayServer.HasExited)
            {
                relayServer.Kill();
                relayServer.WaitForExit();
            }
        }
    }
}
