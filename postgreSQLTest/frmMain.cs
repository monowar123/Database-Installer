using System;
using System.Collections.Generic;
using System.ComponentModel;
using System.Data;
using System.Drawing;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using System.Windows.Forms;
using Npgsql;

namespace postgreSQLTest
{
    public partial class frmMain : Form
    {
        NpgsqlConnection npgConnection;

        string host = string.Empty;
        string port = string.Empty;
        string userID = string.Empty;
        string password = string.Empty;

        public frmMain()
        {
            InitializeComponent();
        }

        private void btnConnect_Click(object sender, EventArgs e)
        {
            if (ValidateInput())
            {
                string connString = GetConnectionString();
                npgConnection = new NpgsqlConnection(connString);

                try
                {
                    npgConnection.Open();

                    frmCreateNewDB frmCreateNewDBObj = new frmCreateNewDB();
                    frmCreateNewDBObj.host = txtHost.Text;
                    frmCreateNewDBObj.port = txtPort.Text;
                    frmCreateNewDBObj.superUserId = txtUserID.Text;
                    frmCreateNewDBObj.superUserPassword = txtPassword.Text;
                    
                    this.Hide();
                    frmCreateNewDBObj.Show();
                }
                catch (Exception ex)
                {
                    MessageBox.Show("Error connecting to database:\n" + ex.Message);
                }
                finally
                {
                    if (npgConnection.State == ConnectionState.Open)
                        npgConnection.Close();
                }
            }
        }

        private bool ValidateInput()
        {
            if (string.IsNullOrEmpty(txtHost.Text) || string.IsNullOrEmpty(txtPort.Text) || string.IsNullOrEmpty(txtUserID.Text) || string.IsNullOrEmpty(txtPassword.Text))
            {
                MessageBox.Show("Field should not be empty");
                return false;
            }

            host = txtHost.Text.Trim();
            port = txtPort.Text.Trim();
            userID = txtUserID.Text.Trim();
            password = txtPassword.Text;
          
            return true;
        }

        private string GetConnectionString()
        {
            string connString = string.Format("SERVER={0}; Port={1}; User id={2}; Password={3}; encoding=unicode;",
                                host, port, userID, password);
            return connString;
        }
    }
}
