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
using System.IO;
using System.Diagnostics;
using System.Reflection;
using System.Threading;

namespace postgreSQLTest
{
    public partial class frmCreateNewDB : Form
    {
        public string host = string.Empty;
        public string port = string.Empty;
        public string superUserId = string.Empty;
        public string superUserPassword = string.Empty;

        string dbName = string.Empty;
        string userID = string.Empty;
        string password = string.Empty;

        DialogResult dialogResultRole;
        DialogResult dialogResultDatabase;

        bool isRoleExist = false;
        bool isSuccess = false;

        public frmCreateNewDB()
        {
            InitializeComponent();        
        }

        private void frmCreateNewDB_Load(object sender, EventArgs e)
        {
            //register events
            this.FormClosing += frmCreateNewDB_FormClosing;
            txtDbName.KeyDown += new KeyEventHandler(EnterEvent);
            txtUserID.KeyDown += new KeyEventHandler(EnterEvent);
            txtPassword.KeyDown += new KeyEventHandler(EnterEvent);
        }

        private void EnterEvent(object sender, KeyEventArgs e)
        {
            if (e.KeyCode == Keys.Enter)
            {
                btnCreate_Click(sender, e);
            }
        }

        private bool ValidateInput()
        {
            if (string.IsNullOrEmpty(txtDbName.Text) || string.IsNullOrEmpty(txtUserID.Text) || string.IsNullOrEmpty(txtPassword.Text))
            {
                MessageBox.Show("Field should not be empty");
                return false;
            }

            dbName = txtDbName.Text.Trim();
            userID = txtUserID.Text.Trim();
            password = txtPassword.Text;

            return true;
        }

        private void btnCreate_Click(object sender, EventArgs e)
        {
            
            string connString = string.Format("SERVER={0}; Port={1}; User id={2}; Password={3}; encoding=unicode;",
                                host, port, superUserId, superUserPassword);

            DBHandler dbHandler = new DBHandler(connString);
            QueryProvider queryProvider = new QueryProvider();        

            if (ValidateInput())
            {
                try
                {
                    btnCreate.Enabled = false;
                    this.UseWaitCursor = true;

                    //if role already exist
                    isRoleExist = dbHandler.IsItemExists(queryProvider.GetSQLFor_RoleExist(userID));
                    if (isRoleExist)
                    {
                        dialogResultRole = MessageBox.Show("The user already exist.\nDo you continue.....", "User Exist", MessageBoxButtons.YesNo);
                    }
                    else
                    {                   
                        lblMessage.Text = "Creating Role...";
                        progressBar1.Value = 1;
                        Application.DoEvents();

                        //create new role with userID and password
                        dbHandler.ExecuteNonQuery(queryProvider.GetSQLFor_CreateRole(userID, password));

                        //Thread.Sleep(1000);
                    }


                    if (dialogResultRole == DialogResult.Yes || !isRoleExist)
                    {
                        //if database already exist
                        bool isDatabaseExist = dbHandler.IsItemExists(queryProvider.GetSQLFor_DatabaseExist(dbName));
                        if (isDatabaseExist)
                        {
                            dialogResultDatabase = MessageBox.Show("The database: " + dbName + " already exist.\nDo you replace.....?", "Replace Database", MessageBoxButtons.YesNo);

                            //delete and create new database
                            if (dialogResultDatabase == DialogResult.Yes)
                            {
                                lblMessage.Text = "Replacing database....";
                                progressBar1.Value = 2;
                                Application.DoEvents();

                                dbHandler.ExecuteNonQuery(queryProvider.GetSQLFor_DeleteDB(dbName));  //delete old database
                                dbHandler.ExecuteNonQuery(queryProvider.GetSQLFor_CreateDatabase(dbName, userID)); // create new database
                                
                                lblMessage.Text = "Running Script...";
                                progressBar1.Value = 3;
                                Application.DoEvents();

                                runScript();

                                isSuccess = true;
                            }
                        }
                        else
                        {                           
                            lblMessage.Text = "Creating database...";
                            progressBar1.Value = 2;
                            Application.DoEvents();

                            //create new database with name and owner
                            dbHandler.ExecuteNonQuery(queryProvider.GetSQLFor_CreateDatabase(dbName, userID));
                         
                            lblMessage.Text = "Running Script...";
                            progressBar1.Value = 3;
                            Application.DoEvents();

                            runScript();

                            isSuccess = true;
                        }
                    }

                    if (isSuccess)
                    {
                        lblMessage.Text = "Completed.";
                        progressBar1.Value = 4;
                        Application.DoEvents();

                        frmInstallSummary frmInstallSummaryObj = new frmInstallSummary();
                        frmInstallSummaryObj.dbName = dbName;
                        frmInstallSummaryObj.userName = userID;
                        frmInstallSummaryObj.password = password;
                        frmInstallSummaryObj.isRoleExist = isRoleExist;
                        frmInstallSummaryObj.isSussess = isSuccess;

                        this.Hide();
                        frmInstallSummaryObj.Show();
                    }
                }
                catch (Exception ex)
                {
                    frmInstallSummary frmInstallSummaryObj = new frmInstallSummary();
                    frmInstallSummaryObj.errorMessage = ex.Message;

                    this.Hide();
                    frmInstallSummaryObj.Show();
                }
                finally
                {
                    btnCreate.Enabled = true;
                    this.UseWaitCursor = false;
                }
            }

        }
  

        private void runScript()
        {
            string scriptPath = Path.GetDirectoryName(Assembly.GetExecutingAssembly().Location) + "\\Scripts\\bgtTest.backup";
            string scriptQuery = File.ReadAllText(scriptPath);

            string scriptPath2 = Path.GetDirectoryName(Assembly.GetExecutingAssembly().Location) + "\\Scripts\\SQL_Sys_tables_ADD_EDIT_DELETE.sql";
            string scriptQuery2 = File.ReadAllText(scriptPath2);

            string connString = string.Format("SERVER={0}; Port={1}; Database={2}; User id={3}; Password={4}; encoding=unicode;",
                                host, port, dbName, superUserId, superUserPassword);

            try
            {
                scriptQuery = scriptQuery.Replace("AOXX", userID);
                DBHandler dbHandler = new DBHandler(connString);
                dbHandler.ExecuteNonQuery(scriptQuery);

                MessageBox.Show("old value completed");
                //-----------------------------------------------------------//
                dbHandler.ExecuteNonQuery(scriptQuery2);
                MessageBox.Show("All completed");
                
            }
            catch (Exception ex)
            {
                MessageBox.Show(ex.Message);
            }
        }

        private void frmCreateNewDB_FormClosing(object sender, EventArgs e)
        {
            Application.Exit();
        }
    
    }
}
