using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace postgreSQLTest
{
    public class QueryProvider
    {
        public string GetSQLFor_RoleExist(string roleName)
        {
            return string.Format("SELECT rolname FROM pg_roles where rolname='{0}';", roleName);
        }

        public string GetSQLFor_CreateRole(string roleName, string password)
        {
            return string.Format("CREATE ROLE \"{0}\" WITH LOGIN PASSWORD '{1}';", roleName, password);
        }

        public string GetSQLFor_DeleteRole(string roleName)
        {
            return string.Format("DROP ROLE IF EXISTS \"{0}\"", roleName);
        }

        public string GetSQLFor_DatabaseExist(string dbName)
        {
            return string.Format("SELECT datname FROM pg_database WHERE datistemplate = false AND datname='{0}';", dbName);
        }

        public string GetSQLFor_CreateDatabase(string dbName, string roleName)
        {
            return string.Format("CREATE DATABASE \"{0}\" WITH OWNER = \"{1}\" ENCODING = 'UTF8' TABLESPACE = pg_default CONNECTION LIMIT = -1;",
                dbName, roleName);
        }

        public string GetSQLFor_DeleteDB(string dbName)
        {
            return string.Format("DROP DATABASE IF EXISTS \"{0}\"", dbName);
        }
    }
}
