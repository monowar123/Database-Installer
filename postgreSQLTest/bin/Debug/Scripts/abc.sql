INSERT INTO sys_authorization(role_id, report_function_code, id)
            	VALUES('URole','SYS_AUTHORIZATION_VIEW', (select COALESCE(max(id),0) from sys_authorization) + 1);
				
				
INSERT INTO sys_authorization(role_id, report_function_code, id)
            	VALUES('URole','SYS_REPORT_FUNCTIONS_DELETE', (select max(id) from sys_authorization) + 1);
				
				
INSERT INTO sys_user_reg(id, user_id, user_pass)
            	VALUES((select COALESCE(max(id),0) from sys_user_reg) + 1, 'SuperUser', 'SuperUser');
				
				
INSERT INTO sys_user_role_relation(id, user_name, rolename)
            	VALUES((select COALESCE(max(id),0) from sys_user_role_relation) + 1, 'SuperUser', 'URole');