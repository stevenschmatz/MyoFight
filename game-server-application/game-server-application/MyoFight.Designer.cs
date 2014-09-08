namespace game_server_application
{
    partial class MyoFight
    {
        /// <summary>
        /// Required designer variable.
        /// </summary>
        private System.ComponentModel.IContainer components = null;

        /// <summary>
        /// Clean up any resources being used.
        /// </summary>
        /// <param name="disposing">true if managed resources should be disposed; otherwise, false.</param>
        protected override void Dispose(bool disposing)
        {
            if (disposing && (components != null))
            {
                components.Dispose();
            }
            base.Dispose(disposing);
        }

        #region Windows Form Designer generated code

        /// <summary>
        /// Required method for Designer support - do not modify
        /// the contents of this method with the code editor.
        /// </summary>
        private void InitializeComponent()
        {
            this.lblP1X = new System.Windows.Forms.Label();
            this.lblP2X = new System.Windows.Forms.Label();
            this.btnReset = new System.Windows.Forms.Button();
            this.SuspendLayout();
            // 
            // lblP1X
            // 
            this.lblP1X.AutoSize = true;
            this.lblP1X.Font = new System.Drawing.Font("Microsoft Sans Serif", 30F, System.Drawing.FontStyle.Regular, System.Drawing.GraphicsUnit.Point, ((byte)(0)));
            this.lblP1X.Location = new System.Drawing.Point(13, 13);
            this.lblP1X.Name = "lblP1X";
            this.lblP1X.Size = new System.Drawing.Size(281, 46);
            this.lblP1X.TabIndex = 0;
            this.lblP1X.Text = "Player 1 X: 0.0";
            // 
            // lblP2X
            // 
            this.lblP2X.AutoSize = true;
            this.lblP2X.Font = new System.Drawing.Font("Microsoft Sans Serif", 30F, System.Drawing.FontStyle.Regular, System.Drawing.GraphicsUnit.Point, ((byte)(0)));
            this.lblP2X.Location = new System.Drawing.Point(12, 59);
            this.lblP2X.Name = "lblP2X";
            this.lblP2X.Size = new System.Drawing.Size(281, 46);
            this.lblP2X.TabIndex = 1;
            this.lblP2X.Text = "Player 2 X: 0.0";
            // 
            // btnReset
            // 
            this.btnReset.Location = new System.Drawing.Point(548, 12);
            this.btnReset.Name = "btnReset";
            this.btnReset.Size = new System.Drawing.Size(132, 93);
            this.btnReset.TabIndex = 2;
            this.btnReset.Text = "Reset";
            this.btnReset.UseVisualStyleBackColor = true;
            this.btnReset.Click += new System.EventHandler(this.btnReset_Click);
            // 
            // MyoFight
            // 
            this.AutoScaleDimensions = new System.Drawing.SizeF(6F, 13F);
            this.AutoScaleMode = System.Windows.Forms.AutoScaleMode.Font;
            this.ClientSize = new System.Drawing.Size(692, 389);
            this.Controls.Add(this.btnReset);
            this.Controls.Add(this.lblP2X);
            this.Controls.Add(this.lblP1X);
            this.Name = "MyoFight";
            this.Text = "MyoFight";
            this.FormClosing += new System.Windows.Forms.FormClosingEventHandler(this.MyoFight_FormClosing);
            this.ResumeLayout(false);
            this.PerformLayout();

        }

        #endregion

        private System.Windows.Forms.Label lblP1X;
        private System.Windows.Forms.Label lblP2X;
        private System.Windows.Forms.Button btnReset;

    }
}

