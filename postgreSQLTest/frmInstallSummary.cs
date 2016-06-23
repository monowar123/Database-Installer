using System;
using System.Collections.Generic;
using System.ComponentModel;
using System.Data;
using System.Drawing;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using System.Windows.Forms;

namespace postgreSQLTest
{
    public partial class frmInstallSummary : Form
    {
        public string dbName = string.Empty;
        public string userName = string.Empty;
        public string password = string.Empty;
        public bool isRoleExist = false;
        public bool isSussess = false;
        public string errorMessage = string.Empty;

        public frmInstallSummary()
        {
            InitializeComponent();
        }

        private void frmInstallSummary_Load(object sender, EventArgs e)
        {
            //register form closing event
            this.FormClosing += frmInstallSummary_FormClosing;

            if (isSussess)
            {
                pictureBox1.Image = Image.FromFile("../../Images/success.png");
                lblMessage.Text = "Database installed successfully.";
                lblDbName.Text = "Database Name: " + dbName;

                if (isRoleExist)
                {
                    lblUserName.Text = "User Name: " + userName + "(previously exist)";
                    lblPassword.Text = "Password: *******";
                }
                else
                {
                    lblUserName.Text = "User Name: " + userName;
                    lblPassword.Text = "Password: " + password;
                }
            }
            else
            {
                pictureBox1.Image = Image.FromFile("../../Images/fail.png");
                lblMessage.Text = "Installation failed.";
                lblDbName.Text = "Error: \n" + errorMessage;
                lblUserName.Text = "";
                lblPassword.Text = "";
            }
        }

        private void btnExit_Click(object sender, EventArgs e)
        {
            Application.Exit();
        }

        private void frmInstallSummary_FormClosing(object sender, EventArgs e)
        {
            Application.Exit();
        }
    }
}
