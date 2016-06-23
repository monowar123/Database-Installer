-- Instruction: 
-- Replace following:
	-- localhost with IP or Server name.
	-- UID with UserID. (Login user name)
	-- UPass with Password. (Login password)
	-- UName with User Name. (User Name that is displayed at home page)
	-- UEmail with User Email.
	-- URole with Role Name.
-- Role: SUPER
-- ADD, EDIT, DELETE functions
-- Common Functions (MAINSETTINGS, ADVANCEDFILTER, EXPORT_REPORT)

------------------------------
-- Delete from Sys tables
------------------------------
DELETE FROM sys_dfn_repdetail WHERE report_code LIKE 'SYS_%';
DELETE FROM sys_report_functions WHERE report_code LIKE 'SYS_%';
DELETE FROM sys_authorization WHERE report_function_code LIKE 'SYS_%';
DELETE FROM sys_metadata WHERE report_code LIKE 'SYS_%';
DELETE FROM sys_commonfunctions WHERE role_id = 'URole';


------------------------------
-- sys_user_reg
------------------------------
INSERT INTO sys_user_reg(id, user_id, user_pass)
        VALUES((select COALESCE(max(id),0) from sys_user_reg) + 1, 'SuperUser', 'SuperUser');

		
------------------------------
-- sys_user_role_relation
------------------------------
INSERT INTO sys_user_role_relation(id, user_name, rolename)
         VALUES((select COALESCE(max(id),0) from sys_user_role_relation) + 1, 'SuperUser', 'URole');
		 

		 
------------------------------
-- sys_dfn_repdetail
------------------------------
INSERT INTO sys_dfn_repdetail(
            report_code, report_name, sql_from, 
            sql_keyfields, multiselect, 
            deeplink, edit_table, 
            add_record_key, report_help)
    VALUES ('SYS_AUTHORIZATION','Sys Authorization','sys_authorization','id',FALSE,FALSE,'sys_authorization','id','<p>This table is used to authorize a Report/ReportFunction against a UserRole.</p><p><strong>[</strong>&nbsp;<u>More detail help is under development</u>&nbsp;<strong>]</strong></p>');
INSERT INTO sys_dfn_repdetail(
            report_code, report_name, sql_from, 
            sql_keyfields, multiselect, 
            deeplink, edit_table, 
            add_record_key, report_help)
    VALUES ('SYS_COMMON_FUNCTIONS','Sys Common Functions','sys_commonfunctions','id',FALSE,FALSE,'sys_commonfunctions','id','<p>This table defines the common functions of ChaloIS.</p><p><strong>[</strong>&nbsp;<u>More detail help is under development</u>&nbsp;<strong>]</strong></p>');
INSERT INTO sys_dfn_repdetail(
            report_code, report_name, sql_from, 
            sql_keyfields, multiselect, 
            deeplink, edit_table, 
            add_record_key, report_help)
    VALUES ('SYS_DFN_REPDETAIL','Sys Report Definition','sys_dfn_repdetail','report_code',FALSE,FALSE,'sys_dfn_repdetail','report_code','<p>Report definition is used to configure reports. Each record defines a single report. It defines the report source, behaviour of the report in ChaloIS and few other settings.</p>

<table border=&quot;&quot;&quot;&quot;&quot;&quot;&quot;1&quot;&quot;&quot;&quot;&quot;&quot;&quot; cellpadding=&quot;&quot;&quot;&quot;&quot;&quot;&quot;1&quot;&quot;&quot;&quot;&quot;&quot;&quot; cellspacing=&quot;&quot;&quot;&quot;&quot;&quot;&quot;1&quot;&quot;&quot;&quot;&quot;&quot;&quot;>
	<caption>SYS_DFN_REPDETAIL Table (Report Definition)</caption>
	<thead>
		<tr>
			<th scope=&quot;&quot;&quot;&quot;&quot;&quot;&quot;col&quot;&quot;&quot;&quot;&quot;&quot;&quot;>Field Name</th>
			<th scope=&quot;&quot;&quot;&quot;&quot;&quot;&quot;col&quot;&quot;&quot;&quot;&quot;&quot;&quot;>Description</th>
			<th scope=&quot;&quot;&quot;&quot;&quot;&quot;&quot;col&quot;&quot;&quot;&quot;&quot;&quot;&quot;>Remark/Sample</th>
		</tr>
	</thead>
	<tbody>
		<tr>
			<td>report_code</td>
			<td>A unique name to identify a report.</td>
			<td>&nbsp;</td>
		</tr>
		<tr>
			<td>report_name</td>
			<td>A suitable name that describe the report very well</td>
			<td>&nbsp;</td>
		</tr>
		<tr>
			<td>report_order</td>
			<td>An integer value to make ordering in ChaloIS. If you want to order alphabetically then keep this field 0 for all report&nbsp;</td>
			<td>&nbsp;</td>
		</tr>
		<tr>
			<td>sql_from</td>
			<td>Original data source name. It can be table or view.</td>
			<td>For view use the format tablename_v</td>
		</tr>
		<tr>
			<td>connection_string</td>
			<td>Specifiy connection string for this report if this report reside in other database. Connection string will be prefixed by a string. Prefixes are : MySQL, Postgres, SqlServer_2008 to indecate the database type seperated by a colon.</td>
			<td>
			<p>For example:</p>

			<p><strong>SqlServer_2008:</strong>Your_connection_string&nbsp;</p>
			</td>
		</tr>
		<tr>
			<td>sql_keyfields</td>
			<td>primary key(s) for this report.</td>
			<td>For more than one keys use semicolon in between</td>
		</tr>
		<tr>
			<td>multiselect</td>
			<td>
			<p>Whether multiselect of rows are activated or not. If true, multiple rows can be selected at a time by checkboxes.</p>
			</td>
			<td>A boolean field.</td>
		</tr>
		<tr>
			<td>gis_theme_layer</td>
			<td>This field is used for GIS enabled report. For the moment keep it blank.</td>
			<td>This field will be describe clearly in future</td>
		</tr>
		<tr>
			<td>report_settings</td>
			<td>Keep it blank for the new record. This will be used from application.</td>
			<td>Application store settings per report.</td>
		</tr>
		<tr>
			<td>deeplink</td>
			<td>
			<p>Specify if deeplink enabled for the report.</p>
			</td>
			<td>A boolean field</td>
		</tr>
		<tr>
			<td>edit_table</td>
			<td>A table, where the editing will effect.</td>
			<td>&nbsp;</td>
		</tr>
		<tr>
			<td>document_forlder</td>
			<td>Specify the folder path for storing document</td>
			<td>&nbsp;</td>
		</tr>
		<tr>
			<td>tabls</td>
			<td>Specify the name of the tabs to be enable for this report.</td>
			<td>&nbsp;</td>
		</tr>
		<tr>
			<td>implecit_Where</td>
			<td>
			<p>This where clause is used to limit to view data from this report.<br />
			--- Use a formatted string &quot;###domain###&quot; to filter with domain value or/and<br />
			&nbsp; &nbsp;&quot;###userid###&quot; to filter with user id</p>
			</td>
			<td>For example: ((status = &#39;###domain###&#39;) OR (&#39;###domain###&#39; = &#39;&#39;) &nbsp;OR &#39;c.nieboer&#39; = upper(&#39;###userid###&#39;))</td>
		</tr>
		<tr>
			<td>add_record_key</td>
			<td>Keep it blank for the moment&nbsp;</td>
			<td>[This field is not clear yet]</td>
		</tr>
		<tr>
			<td>copy_sql</td>
			<td>Keep it blank for the moment&nbsp;</td>
			<td>[This field is not clear yet]</td>
		</tr>
		<tr>
			<td>report_help</td>
			<td>Keep it blank</td>
			<td>This field will be used from application to add/edit help texts.</td>
		</tr>
	</tbody>
</table>

<p>&nbsp;</p>
');
INSERT INTO sys_dfn_repdetail(
            report_code, report_name, sql_from, 
            sql_keyfields, multiselect, 
            deeplink, edit_table, 
            add_record_key, report_help)
    VALUES ('SYS_GROUP_COLOR','Sys Group Color','sys_group_color','report_code',FALSE,FALSE,'sys_group_color','report_code','<p>This report defines a color column in a report when it is represented as grouped by.</p>

<p><strong>[</strong>&nbsp;<u>More detail help is under development</u>&nbsp;<strong>]</strong></p>');
INSERT INTO sys_dfn_repdetail(
            report_code, report_name, sql_from, 
            sql_keyfields, multiselect, 
            deeplink, edit_table, 
            add_record_key, report_help)
    VALUES ('SYS_METADATA','Sys Property Editor Rules','sys_metadata','id',FALSE,FALSE,'sys_metadata','id','<p><strong><span style=''font-size:26px''><span style=''color:rgb(255, 140, 0)''>Property Editor Rule</span></span></strong> report is used to configure the report tables. Here each record of for report defines a sinngle field of a specific report. Only these configured fields will be editable using property editor tool and will be available for adding a record in the report table.</p>

<p>Rules are mostly validation for the specific field and few configurations to render the interface for this field.</p>

<p><u>Detail of the property editor fields to show how it will be configured and what will be the effect</u></p>

<table border=''&quot;&quot;&quot;&quot;&quot;.1&quot;&quot;&quot;&quot;&quot;'' cellpadding=''&quot;&quot;&quot;&quot;&quot;1&quot;&quot;&quot;&quot;&quot;'' cellspacing=''&quot;&quot;&quot;&quot;&quot;1&quot;&quot;&quot;&quot;&quot;''>
	<thead>
		<tr>
			<th scope=''&quot;&quot;&quot;&quot;&quot;&quot;&quot;&quot;&quot;&quot;&quot;col&quot;&quot;&quot;&quot;&quot;&quot;&quot;&quot;&quot;&quot;&quot;''>
			<p><strong>Field Name</strong></p>
			</th>
			<th scope=''&quot;&quot;&quot;&quot;&quot;&quot;&quot;&quot;&quot;&quot;&quot;col&quot;&quot;&quot;&quot;&quot;&quot;&quot;&quot;&quot;&quot;&quot;''>
			<p><span style=''color:#FF0000''><strong>Description</strong></span></p>
			</th>
			<th scope=''&quot;&quot;&quot;&quot;&quot;&quot;&quot;&quot;&quot;&quot;&quot;col&quot;&quot;&quot;&quot;&quot;&quot;&quot;&quot;&quot;&quot;&quot;''>
			<p><strong><span style=''background-color:#008000''>Remark/Sample</span></strong></p>
			</th>
		</tr>
	</thead>
	<tbody>
		<tr>
			<td>
			<p>ID</p>

			<p>&nbsp;</p>
			</td>
			<td>
			<p>Auto generated primary key of integer type</p>
			</td>
			<td>&nbsp;</td>
		</tr>
		<tr>
			<td>Fieldname</td>
			<td>Exact name of the field of the configuring report</td>
			<td>&nbsp;</td>
		</tr>
		<tr>
			<td>
			<p>Fieldtype</p>
			</td>
			<td>
			<p>Type of the field. For the moment choices are:&nbsp;STR&nbsp;/&nbsp;Text / DATE / INT / FLOAT</p>
			</td>
			<td>
			<p>STR: For string type value</p>

			<p>Text: For multiline string</p>

			<p>DATE: For date type value</p>

			<p>INT: For integer tupe value</p>

			<p>FLOAT: For float type value</p>
			</td>
		</tr>
		<tr>
			<td>
			<p>Caption</p>
			</td>
			<td>
			<p>Caption of the field.[Optional]</p>
			</td>
			<td>&nbsp;</td>
		</tr>
		<tr>
			<td>
			<p>Mandatory</p>
			</td>
			<td>
			<p>This field indicates the mandatory level. Values must be one of three choices (Yes, No or LOV)&nbsp;</p>
			</td>
			<td>
			<p>Yes: user can edit values by typing into this field. It can&#39;t be kept blank during saving records.</p>

			<p>No: user can edit values by typing into this field. Field can be kept blank during saving records.<br />
			LOV: It means &#39;List Of Values&#39;. Values must come from a combo or popup or both. If user can type into this field, the typed value is validated against the list of values while saving/validating values.</p>
			</td>
		</tr>
		<tr>
			<td>
			<p>Default</p>
			</td>
			<td>
			<p>The default value of a field is defined here.</p>
			</td>
			<td>
			<p>To assign &#39;department&#39; field to be always &#39;SBO&#39; when property editor appears, SBO is the default value.</p>
			</td>
		</tr>
		<tr>
			<td>LOVC</td>
			<td>
			<p>List of Value Combo. It is a combobox containing the options to be selected.</p>
			</td>
			<td>
			<p>1. /a/b/c/d<br />
			It means the options are: a or b or c or d.</p>

			<p>2. select &lt;fieldname1, fieldname2,..,fieldnameN&gt; from &lt;tablename&gt;<br />
			It means fetching fieldname/s from database table and displaying as options into the combobox. If more than one column is fetched, the combo will get only the first column as options. Here, only fieldname1 will appear into the combo.</p>
			</td>
		</tr>
		<tr>
			<td>
			<p>LOVP</p>
			</td>
			<td>
			<p>List of Values Popup. It is a modal popup by which user can choose a value by looking-up. It also contains filtering, page navigation, sorting column/s, and choosing values.</p>
			</td>
			<td>
			<p>Select &lt;fieldname1, fieldname2,..,fieldnameN&gt; from &lt;tablename&gt;</p>

			<p>It will fetch columns from the database table and display in the popup window. User can choose values from here. Only values from the first column(fieldname1) will be set as a value for this selection.</p>
			</td>
		</tr>
		<tr>
			<td>LOVCP</td>
			<td>
			<p>List of Values containing both Combo and Popup for better lookup options.</p>
			</td>
			<td>
			<p>Select &lt;fieldname1, fieldname2,..,fieldnameN&gt; from &lt;tablename&gt;<br />
			It will fetch columns from the database table. Combo will get the first column(fieldname1). Popup will show all the specified fields. When a record will be chosen from popup, only the first column(fieldname1) will be set as the value.</p>
			</td>
		</tr>
		<tr>
			<td>
			<p>Minvalue</p>
			</td>
			<td>
			<p>Gives the maximal value for INT and FLOAT.</p>
			</td>
			<td>&nbsp;</td>
		</tr>
		<tr>
			<td>
			<p>Maxvalue</p>
			</td>
			<td>
			<p>Indicates how many digits will be there after a decimal point. Only applicable for fieldtype INT or FLOAT.</p>
			</td>
			<td>&nbsp;</td>
		</tr>
		<tr>
			<td>
			<p>Decimals</p>
			</td>
			<td>
			<p>Indicates how many digits will be there after a decimal point. Only applicable for fieldtype FLOAT.</p>
			</td>
			<td>&nbsp;</td>
		</tr>
		<tr>
			<td>
			<p>Strlen</p>
			</td>
			<td>
			<p>Gives the maximum string length for a STR.&nbsp;</p>
			</td>
			<td>For the moment this must be filled up for primary key</td>
		</tr>
		<tr>
			<td>
			<p>Displen</p>
			</td>
			<td>Gives the display length in the interface (excluding the pick button).</td>
			<td>&nbsp;</td>
		</tr>
		<tr>
			<td>tablename</td>
			<td>Name of the source table for the report.</td>
			<td>&nbsp;</td>
		</tr>
		<tr>
			<td>
			<p>Allowedit</p>
			</td>
			<td>
			<p>Indicates whether the field is enabled to edit or not.</p>
			</td>
			<td>Values can be either true or false</td>
		</tr>
		<tr>
			<td>
			<p>Tip</p>
			</td>
			<td>Tool tip text to show for the field control in the property editor.</td>
			<td>Tool tip should describe about the field rules.&nbsp;</td>
		</tr>
		<tr>
			<td>
			<p>Errorlevel</p>
			</td>
			<td>
			<p>Indicates what type of error will be generated for wrong data entry. One of the three values can be chosen</p>
			</td>
			<td>
			<p>0: No error will be generated even there is violation of rules.</p>

			<p>1: Warning. If error exists but records can be saved.</p>

			<p>2: Error. If error exists, records can&#39;t be saved until correct value is given for that field.</p>
			</td>
		</tr>
		<tr>
			<td>
			<p>field_specialty</p>
			</td>
			<td>
			<p>Special cases for a field. For the moment three different values are available. (p,u,n)</p>
			</td>
			<td>
			<p>p: Primary key</p>

			<p>u: Unique value</p>

			<p>n: Not null.</p>
			</td>
		</tr>
		<tr>
			<td>
			<p>field_order</p>
			</td>
			<td>
			<p>[Optional] Within the interface the fields appear in this integer based order value.</p>
			</td>
			<td>&nbsp;</td>
		</tr>
		<tr>
			<td>
			<p>field_group</p>
			</td>
			<td>
			<p>[Optional] Groupname by which the control&#39;s will be grouped in fieldsets in the interface.</p>
			</td>
			<td>&nbsp;</td>
		</tr>
		<tr>
			<td>report_code</td>
			<td>The report code for the configuring table from the sys_dfn_repdetail table.</td>
			<td>&nbsp;</td>
		</tr>
	</tbody>
</table>

<p>&nbsp;</p>
');
INSERT INTO sys_dfn_repdetail(
            report_code, report_name, sql_from, 
            sql_keyfields, multiselect, 
            deeplink, edit_table, 
            add_record_key, report_help)
    VALUES ('SYS_REPORT_FUNCTIONS','Sys Report Functions','sys_report_functions','id',FALSE,FALSE,'sys_report_functions','id','<p>This table is used to specify the Functions for a Report, with the function config.</p>

<p><strong>[</strong>&nbsp;<u>More detail help is under development</u>&nbsp;<strong>]</strong></p>');
INSERT INTO sys_dfn_repdetail(
            report_code, report_name, sql_from, 
            sql_keyfields, multiselect, 
            deeplink, edit_table, 
            add_record_key, report_help)
    VALUES ('SYS_REPORT_LINKING','Sys Report Linking','sys_report_linking','id',FALSE,FALSE,'sys_report_linking','id','<p>This table is used to define the Report Linking settings for Reports.&nbsp;DB driven Report linking feature shows a menu of items in grid. User can choose an item&nbsp;and that item (Report) and that item will be loaded with the keyfield defined.</p>

<p><strong>[</strong>&nbsp;<u>More detail help is under development</u>&nbsp;<strong>]</strong></p>');
INSERT INTO sys_dfn_repdetail(
            report_code, report_name, sql_from, 
            sql_keyfields, multiselect, 
            deeplink, edit_table, 
            add_record_key, report_help)
    VALUES ('SYS_USER_REG','Sys User Registration','sys_user_reg','user_id',FALSE,FALSE,'sys_user_reg','user_id','<p>This table keeps the users&#39; detail</p>

<p><strong>[</strong>&nbsp;<u>More detail help is under development</u>&nbsp;<strong>]</strong></p>');
INSERT INTO sys_dfn_repdetail(
            report_code, report_name, sql_from, 
            sql_keyfields, multiselect, 
            deeplink, edit_table, 
            add_record_key, report_help)
    VALUES ('SYS_USR_ROLE','Sys User Roles','sys_user_role_relation','id',FALSE,FALSE,'sys_user_role_relation','id','<p>This table defines the relation between user and userrole.</p>

<p><strong>[</strong>&nbsp;<u>More detail help is under development</u>&nbsp;<strong>]</strong></p>');

----------------------------
-- sys_report_functions
----------------------------	
INSERT INTO sys_report_functions(report_code, function_name, order_position, parameters, is_report_specific, id)
    VALUES ('SYS_AUTHORIZATION','ADD',1,'id',TRUE,(select COALESCE(COALESCE(max(id),0),0) from sys_report_functions) + 1);
INSERT INTO sys_report_functions(report_code, function_name, order_position, parameters, is_report_specific, id)
    VALUES ('SYS_AUTHORIZATION','EDIT',2,'id',FALSE,(select COALESCE(COALESCE(max(id),0),0) from sys_report_functions) + 1);
INSERT INTO sys_report_functions(report_code, function_name, order_position, parameters, is_report_specific, id)
    VALUES ('SYS_AUTHORIZATION','DELETE',3,'id',FALSE,(select COALESCE(COALESCE(max(id),0),0) from sys_report_functions) + 1);
	
INSERT INTO sys_report_functions(report_code, function_name, order_position, parameters, is_report_specific, id)
    VALUES ('SYS_COMMON_FUNCTIONS','ADD',1,'id',TRUE,(select COALESCE(COALESCE(max(id),0),0) from sys_report_functions) + 1);
INSERT INTO sys_report_functions(report_code, function_name, order_position, parameters, is_report_specific, id)
    VALUES ('SYS_COMMON_FUNCTIONS','EDIT',2,'id',FALSE,(select COALESCE(COALESCE(max(id),0),0) from sys_report_functions) + 1);
INSERT INTO sys_report_functions(report_code, function_name, order_position, parameters, is_report_specific, id)
    VALUES ('SYS_COMMON_FUNCTIONS','DELETE',3,'id',FALSE,(select COALESCE(COALESCE(max(id),0),0) from sys_report_functions) + 1);
	
INSERT INTO sys_report_functions(report_code, function_name, order_position, parameters, is_report_specific, id)
    VALUES ('SYS_DFN_REPDETAIL','ADD',1,'report_code',TRUE,(select COALESCE(COALESCE(max(id),0),0) from sys_report_functions) + 1);
INSERT INTO sys_report_functions(report_code, function_name, order_position, parameters, is_report_specific, id)
    VALUES ('SYS_DFN_REPDETAIL','EDIT',2,'report_code',FALSE,(select COALESCE(COALESCE(max(id),0),0) from sys_report_functions) + 1);
INSERT INTO sys_report_functions(report_code, function_name, order_position, parameters, is_report_specific, id)
    VALUES ('SYS_DFN_REPDETAIL','DELETE',3,'report_code',FALSE,(select COALESCE(COALESCE(max(id),0),0) from sys_report_functions) + 1);

INSERT INTO sys_report_functions(report_code, function_name, order_position, parameters, is_report_specific, id)
    VALUES ('SYS_METADATA','ADD',1,'id',TRUE,(select COALESCE(COALESCE(max(id),0),0) from sys_report_functions) + 1);
INSERT INTO sys_report_functions(report_code, function_name, order_position, parameters, is_report_specific, id)
    VALUES ('SYS_METADATA','EDIT',2,'id',FALSE,(select COALESCE(COALESCE(max(id),0),0) from sys_report_functions) + 1);
INSERT INTO sys_report_functions(report_code, function_name, order_position, parameters, is_report_specific, id)
    VALUES ('SYS_METADATA','DELETE',3,'id',FALSE,(select COALESCE(COALESCE(max(id),0),0) from sys_report_functions) + 1);
	
INSERT INTO sys_report_functions(report_code, function_name, order_position, parameters, is_report_specific, id)
    VALUES ('SYS_REPORT_FUNCTIONS','ADD',1,'id',TRUE,(select COALESCE(COALESCE(max(id),0),0) from sys_report_functions) + 1);
INSERT INTO sys_report_functions(report_code, function_name, order_position, parameters, is_report_specific, id)
    VALUES ('SYS_REPORT_FUNCTIONS','EDIT',2,'id',FALSE,(select COALESCE(COALESCE(max(id),0),0) from sys_report_functions) + 1);
INSERT INTO sys_report_functions(report_code, function_name, order_position, parameters, is_report_specific, id)
    VALUES ('SYS_REPORT_FUNCTIONS','DELETE',3,'id',FALSE,(select COALESCE(COALESCE(max(id),0),0) from sys_report_functions) + 1);
	
INSERT INTO sys_report_functions(report_code, function_name, order_position, parameters, is_report_specific, id)
    VALUES ('SYS_REPORT_LINKING','ADD',1,'id',TRUE,(select COALESCE(COALESCE(max(id),0),0) from sys_report_functions) + 1);
INSERT INTO sys_report_functions(report_code, function_name, order_position, parameters, is_report_specific, id)
    VALUES ('SYS_REPORT_LINKING','EDIT',2,'id',FALSE,(select COALESCE(COALESCE(max(id),0),0) from sys_report_functions) + 1);
INSERT INTO sys_report_functions(report_code, function_name, order_position, parameters, is_report_specific, id)
    VALUES ('SYS_REPORT_LINKING','DELETE',3,'id',FALSE,(select COALESCE(COALESCE(max(id),0),0) from sys_report_functions) + 1);
	
INSERT INTO sys_report_functions(report_code, function_name, order_position, parameters, is_report_specific, id)
    VALUES ('SYS_USER_REG','ADD',1,'user_id',TRUE,(select COALESCE(COALESCE(max(id),0),0) from sys_report_functions) + 1);
INSERT INTO sys_report_functions(report_code, function_name, order_position, parameters, is_report_specific, id)
    VALUES ('SYS_USER_REG','EDIT',2,'user_id',FALSE,(select COALESCE(COALESCE(max(id),0),0) from sys_report_functions) + 1);
INSERT INTO sys_report_functions(report_code, function_name, order_position, parameters, is_report_specific, id)
    VALUES ('SYS_USER_REG','DELETE',3,'user_id',FALSE,(select COALESCE(COALESCE(max(id),0),0) from sys_report_functions) + 1);
	
INSERT INTO sys_report_functions(report_code, function_name, order_position, parameters, is_report_specific, id)
    VALUES ('SYS_USR_ROLE','ADD',1,'id',TRUE,(select COALESCE(COALESCE(max(id),0),0) from sys_report_functions) + 1);
INSERT INTO sys_report_functions(report_code, function_name, order_position, parameters, is_report_specific, id)
    VALUES ('SYS_USR_ROLE','EDIT',2,'id',FALSE,(select COALESCE(COALESCE(max(id),0),0) from sys_report_functions) + 1);
INSERT INTO sys_report_functions(report_code, function_name, order_position, parameters, is_report_specific, id)
    VALUES ('SYS_USR_ROLE','DELETE',3,'id',FALSE,(select COALESCE(COALESCE(max(id),0),0) from sys_report_functions) + 1);
	
INSERT INTO sys_report_functions(report_code, function_name, order_position, parameters, is_report_specific, id)
    VALUES ('SYS_GROUP_COLOR','ADD',1,'reportcode',TRUE,(select COALESCE(COALESCE(max(id),0),0) from sys_report_functions) + 1);
INSERT INTO sys_report_functions(report_code, function_name, order_position, parameters, is_report_specific, id)
    VALUES ('SYS_GROUP_COLOR','EDIT',2,'reportcode',FALSE,(select COALESCE(COALESCE(max(id),0),0) from sys_report_functions) + 1);
INSERT INTO sys_report_functions(report_code, function_name, order_position, parameters, is_report_specific, id)
    VALUES ('SYS_GROUP_COLOR','DELETE',3,'reportcode',FALSE,(select COALESCE(COALESCE(max(id),0),0) from sys_report_functions) + 1);
	
	
-----------------------------
-- sys_commonfunctions
-----------------------------
INSERT INTO sys_commonfunctions(role_id, function_code, action, weight)
	VALUES('SUPER','HELP','EDIT',2);

INSERT INTO sys_commonfunctions(role_id, function_code, action, weight)
	VALUES('SUPER','GENERIC_SETTINGS','SAVE',1);
	
INSERT INTO sys_commonfunctions(role_id, function_code, action, weight)
	VALUES('SUPER','MAINSETTINGS','VIEW',1);
	
INSERT INTO sys_commonfunctions(role_id, function_code, action, weight)
	VALUES('SUPER','ADVANCEDFILTER','VIEW',1);
	
INSERT INTO sys_commonfunctions(role_id, function_code, action, weight)
	VALUES('SUPER','EXPORT_REPORT','VIEW',1);
	
	
-----------------------------
-- sys_authorization
-----------------------------
INSERT INTO sys_authorization(role_id, report_function_code, id)
	VALUES('URole','SYS_AUTHORIZATION_VIEW', (select COALESCE(COALESCE(max(id),0),0) from sys_authorization) + 1);
INSERT INTO sys_authorization(role_id, report_function_code, id)
	VALUES('URole','SYS_AUTHORIZATION_ADD', (select COALESCE(COALESCE(max(id),0),0) from sys_authorization) + 1);
INSERT INTO sys_authorization(role_id, report_function_code, id)
	VALUES('URole','SYS_AUTHORIZATION_EDIT', (select COALESCE(COALESCE(max(id),0),0) from sys_authorization) + 1);
INSERT INTO sys_authorization(role_id, report_function_code, id)
	VALUES('URole','SYS_AUTHORIZATION_DELETE', (select COALESCE(COALESCE(max(id),0),0) from sys_authorization) + 1);
	
INSERT INTO sys_authorization(role_id, report_function_code, id)
	VALUES('URole','SYS_DFN_REPDETAIL_VIEW', (select COALESCE(COALESCE(max(id),0),0) from sys_authorization) + 1);
INSERT INTO sys_authorization(role_id, report_function_code, id)
	VALUES('URole','SYS_DFN_REPDETAIL_ADD', (select COALESCE(COALESCE(max(id),0),0) from sys_authorization) + 1);
INSERT INTO sys_authorization(role_id, report_function_code, id)
	VALUES('URole','SYS_DFN_REPDETAIL_EDIT', (select COALESCE(COALESCE(max(id),0),0) from sys_authorization) + 1);
INSERT INTO sys_authorization(role_id, report_function_code, id)
	VALUES('URole','SYS_DFN_REPDETAIL_DELETE', (select COALESCE(COALESCE(max(id),0),0) from sys_authorization) + 1);
	
INSERT INTO sys_authorization(role_id, report_function_code, id)
	VALUES('URole','SYS_REPORT_FUNCTIONS_VIEW', (select COALESCE(COALESCE(max(id),0),0) from sys_authorization) + 1);
INSERT INTO sys_authorization(role_id, report_function_code, id)
	VALUES('URole','SYS_REPORT_FUNCTIONS_ADD', (select COALESCE(COALESCE(max(id),0),0) from sys_authorization) + 1);
INSERT INTO sys_authorization(role_id, report_function_code, id)
	VALUES('URole','SYS_REPORT_FUNCTIONS_EDIT', (select COALESCE(COALESCE(max(id),0),0) from sys_authorization) + 1);
INSERT INTO sys_authorization(role_id, report_function_code, id)
	VALUES('URole','SYS_REPORT_FUNCTIONS_DELETE', (select COALESCE(COALESCE(max(id),0),0) from sys_authorization) + 1);
	
INSERT INTO sys_authorization(role_id, report_function_code, id)
	VALUES('URole','SYS_USER_REG_VIEW', (select COALESCE(COALESCE(max(id),0),0) from sys_authorization) + 1);
INSERT INTO sys_authorization(role_id, report_function_code, id)
	VALUES('URole','SYS_USER_REG_ADD', (select COALESCE(COALESCE(max(id),0),0) from sys_authorization) + 1);
INSERT INTO sys_authorization(role_id, report_function_code, id)
	VALUES('URole','SYS_USER_REG_EDIT', (select COALESCE(COALESCE(max(id),0),0) from sys_authorization) + 1);
INSERT INTO sys_authorization(role_id, report_function_code, id)
	VALUES('URole','SYS_USER_REG_DELETE', (select COALESCE(COALESCE(max(id),0),0) from sys_authorization) + 1);
	
INSERT INTO sys_authorization(role_id, report_function_code, id)
	VALUES('URole','SYS_METADATA_VIEW', (select COALESCE(COALESCE(max(id),0),0) from sys_authorization) + 1);
INSERT INTO sys_authorization(role_id, report_function_code, id)
	VALUES('URole','SYS_METADATA_ADD', (select COALESCE(COALESCE(max(id),0),0) from sys_authorization) + 1);
INSERT INTO sys_authorization(role_id, report_function_code, id)
	VALUES('URole','SYS_METADATA_EDIT', (select COALESCE(COALESCE(max(id),0),0) from sys_authorization) + 1);
INSERT INTO sys_authorization(role_id, report_function_code, id)
	VALUES('URole','SYS_METADATA_DELETE', (select COALESCE(COALESCE(max(id),0),0) from sys_authorization) + 1);
	
INSERT INTO sys_authorization(role_id, report_function_code, id)
	VALUES('URole','SYS_USR_ROLE_VIEW', (select COALESCE(COALESCE(max(id),0),0) from sys_authorization) + 1);
INSERT INTO sys_authorization(role_id, report_function_code, id)
	VALUES('URole','SYS_USR_ROLE_ADD', (select COALESCE(COALESCE(max(id),0),0) from sys_authorization) + 1);
INSERT INTO sys_authorization(role_id, report_function_code, id)
	VALUES('URole','SYS_USR_ROLE_EDIT', (select COALESCE(COALESCE(max(id),0),0) from sys_authorization) + 1);
INSERT INTO sys_authorization(role_id, report_function_code, id)
	VALUES('URole','SYS_USR_ROLE_DELETE', (select COALESCE(COALESCE(max(id),0),0) from sys_authorization) + 1);
	
INSERT INTO sys_authorization(role_id, report_function_code, id)
	VALUES('URole','SYS_GROUP_COLOR_VIEW', (select COALESCE(COALESCE(max(id),0),0) from sys_authorization) + 1);
INSERT INTO sys_authorization(role_id, report_function_code, id)
	VALUES('URole','SYS_GROUP_COLOR_ADD', (select COALESCE(COALESCE(max(id),0),0) from sys_authorization) + 1);
INSERT INTO sys_authorization(role_id, report_function_code, id)
	VALUES('URole','SYS_GROUP_COLOR_EDIT', (select COALESCE(COALESCE(max(id),0),0) from sys_authorization) + 1);
INSERT INTO sys_authorization(role_id, report_function_code, id)
	VALUES('URole','SYS_GROUP_COLOR_DELETE', (select COALESCE(COALESCE(max(id),0),0) from sys_authorization) + 1);
	
INSERT INTO sys_authorization(role_id, report_function_code, id)
	VALUES('URole','SYS_REPORT_LINKING_VIEW', (select COALESCE(COALESCE(max(id),0),0) from sys_authorization) + 1);
INSERT INTO sys_authorization(role_id, report_function_code, id)
	VALUES('URole','SYS_REPORT_LINKING_ADD', (select COALESCE(COALESCE(max(id),0),0) from sys_authorization) + 1);
INSERT INTO sys_authorization(role_id, report_function_code, id)
	VALUES('URole','SYS_REPORT_LINKING_EDIT', (select COALESCE(COALESCE(max(id),0),0) from sys_authorization) + 1);
INSERT INTO sys_authorization(role_id, report_function_code, id)
	VALUES('URole','SYS_REPORT_LINKING_DELETE', (select COALESCE(COALESCE(max(id),0),0) from sys_authorization) + 1);
	
	
-----------------------------
-- sys_metadata
-----------------------------
INSERT INTO sys_metadata(fieldname, fieldtype, caption, mandatory, defaultvalue, lovc, lovp, lovcp, minvalue, maxvalue, decimals, strlen, displen, allowedit, tip, tablename, errorlevel, field_specialty, report_code, id)
	VALUES('report_code','STR','Report Code','Yes','','','','','','','',50,250,FALSE,'Enter a unique name for report. Report code must not contain space and special character','sys_dfn_repdetail',2,'p','SYS_DFN_REPDETAIL', (select COALESCE(COALESCE(max(id),0),0) from sys_metadata) + 1);
	
INSERT INTO sys_metadata(fieldname, fieldtype, caption, mandatory, defaultvalue, lovc, lovp, lovcp, minvalue, maxvalue, decimals, strlen, displen, allowedit, tip, tablename, errorlevel, field_specialty, report_code, id)
	VALUES('report_name','STR','Report Name','Yes','','','','','','','',40,250,TRUE,'Define a preferable name for this report which will be shown in the report list','sys_dfn_repdetail',1,'n','SYS_DFN_REPDETAIL', (select COALESCE(COALESCE(max(id),0),0) from sys_metadata) + 1);
	
INSERT INTO sys_metadata(fieldname, fieldtype, caption, mandatory, defaultvalue, lovc, lovp, lovcp, minvalue, maxvalue, decimals, strlen, displen, allowedit, tip, tablename, errorlevel, field_specialty, report_code, id)
	VALUES('report_order','INT','Report Order','Yes','0','','','','','','',50,75,TRUE,'Order of the report to show in the dropdown box in ChaloIS. 
If you want reports to be ordered alphabetically than keep order field 0 for all the fields','sys_dfn_repdetail',1,'n','SYS_DFN_REPDETAIL', (select COALESCE(COALESCE(max(id),0),0) from sys_metadata) + 1);

INSERT INTO sys_metadata(fieldname, fieldtype, caption, mandatory, defaultvalue, lovc, lovp, lovcp, minvalue, maxvalue, decimals, strlen, displen, allowedit, tip, tablename, errorlevel, field_specialty, report_code, id)
	VALUES('sql_from','STR','Source Table/View','LOV','','select table_name from INFORMATION_SCHEMA.tables WHERE table_schema = ANY (current_schemas(false))','','','','','',50,150,TRUE,'Source table/view to create a report','sys_dfn_repdetail',1,'n','SYS_DFN_REPDETAIL', (select COALESCE(COALESCE(max(id),0),0) from sys_metadata) + 1);
	
INSERT INTO sys_metadata(fieldname, fieldtype, caption, mandatory, defaultvalue, lovc, lovp, lovcp, minvalue, maxvalue, decimals, strlen, displen, allowedit, tip, tablename, errorlevel, field_specialty, report_code, id)
	VALUES('connection_string','STR','Connection String','No','','','','','','','',500,300,TRUE,'If the table/view reside in another database then specify the connection string here with one of the predefined prefix and a colon. Prefixes are:
Postgres: For postgres database
Oracle: For oracle database
MySql: For mysql database
SqlServer_2005: For sql server 2005
SqlServer_2008:For sql server 2008

For example: Postgres:SERVER=localhost,Port=5432,Database=ChaloIS,User id=postgres,Password=postgres,encoding=unicode','sys_dfn_repdetail',1,'','SYS_DFN_REPDETAIL', (select COALESCE(COALESCE(max(id),0),0) from sys_metadata) + 1);
	
INSERT INTO sys_metadata(fieldname, fieldtype, caption, mandatory, defaultvalue, lovc, lovp, lovcp, minvalue, maxvalue, decimals, strlen, displen, allowedit, tip, tablename, errorlevel, field_specialty, report_code, id)
	VALUES('multiselect','STR','Is multi-selectable','LOV','False','/True/False','','','','','',50,75,TRUE,'Choose true if you want to select multiple row in the report 
otherwise keep it false','sys_dfn_repdetail',1,'','SYS_DFN_REPDETAIL', (select COALESCE(COALESCE(max(id),0),0) from sys_metadata) + 1);
	
INSERT INTO sys_metadata(fieldname, fieldtype, caption, mandatory, defaultvalue, lovc, lovp, lovcp, minvalue, maxvalue, decimals, strlen, displen, allowedit, tip, tablename, errorlevel, field_specialty, report_code, id)
	VALUES('edit_table','STR','Report Table Source','LOV','','SELECT tablename FROM pg_catalog.pg_tables where schemaname = ''public''','','','','','',50,150,TRUE,'Select a table that is the main source of this report. 
Hence edit will effect this selected table.','sys_dfn_repdetail',1,'n','SYS_DFN_REPDETAIL', (select COALESCE(COALESCE(max(id),0),0) from sys_metadata) + 1);

INSERT INTO sys_metadata(fieldname, fieldtype, caption, mandatory, defaultvalue, lovc, lovp, lovcp, minvalue, maxvalue, decimals, strlen, displen, allowedit, tip, tablename, errorlevel, field_specialty, report_code, id)
	VALUES('sql_keyfields','STR','Keyfields','Yes','','','','','','','',50,175,TRUE,'Keyfields for a report. For more than one key fields define all with comma or semicolon seperated string. Mostly, primary keys are keyfields in a report.
For example: Id,Roll','sys_dfn_repdetail',1,'','SYS_DFN_REPDETAIL', (select COALESCE(COALESCE(max(id),0),0) from sys_metadata) + 1);

INSERT INTO sys_metadata(fieldname, fieldtype, caption, mandatory, defaultvalue, lovc, lovp, lovcp, minvalue, maxvalue, decimals, strlen, displen, allowedit, tip, tablename, errorlevel, field_specialty, report_code, id)
	VALUES('tabs','STR','Tabs','Yes','','','','','','','',50,175,TRUE,'Tab name or for more than semicolon separated names 
to show different specific functionality under specific tab.','sys_dfn_repdetail',1,'','SYS_DFN_REPDETAIL', (select COALESCE(COALESCE(max(id),0),0) from sys_metadata) + 1);


-----
INSERT INTO sys_metadata(fieldname, fieldtype, caption, mandatory, defaultvalue, lovc, lovp, lovcp, minvalue, maxvalue, decimals, strlen, displen, allowedit, tip, tablename, errorlevel, field_specialty, report_code, id)
	VALUES('id','INT','ID','Yes','','','','','','','',30,75,FALSE,'Auto generated primary key. Not editable','sys_commonfunctions',0,'p','SYS_COMMON_FUNCTIONS', (select COALESCE(COALESCE(max(id),0),0) from sys_metadata) + 1);

INSERT INTO sys_metadata(fieldname, fieldtype, caption, mandatory, defaultvalue, lovc, lovp, lovcp, minvalue, maxvalue, decimals, strlen, displen, allowedit, tip, tablename, errorlevel, field_specialty, report_code, id)
	VALUES('role_id','STR','Role','LOV','','Select distinct rolename from sys_user_role_relation','','','','','',50,150,TRUE,'Select a role name for which you are defining the function''s action','sys_commonfunctions',0,'','SYS_COMMON_FUNCTIONS', (select COALESCE(COALESCE(max(id),0),0) from sys_metadata) + 1);

INSERT INTO sys_metadata(fieldname, fieldtype, caption, mandatory, defaultvalue, lovc, lovp, lovcp, minvalue, maxvalue, decimals, strlen, displen, allowedit, tip, tablename, errorlevel, field_specialty, report_code, id)
	VALUES('function_code','STR','Function Name','Yes','','','','','','','',50,100,TRUE,'Enter exact name of the function that is used in the application.
For example: HELP, MAINSETTINGS
Function name is preferred to be in Capital latter','sys_commonfunctions',0,'','SYS_COMMON_FUNCTIONS', (select COALESCE(COALESCE(max(id),0),0) from sys_metadata) + 1);

INSERT INTO sys_metadata(fieldname, fieldtype, caption, mandatory, defaultvalue, lovc, lovp, lovcp, minvalue, maxvalue, decimals, strlen, displen, allowedit, tip, tablename, errorlevel, field_specialty, report_code, id)
	VALUES('action','STR','Func. Action','Yes','VIEW','','','','','','',50,150,TRUE,'Enter a correct action that is already implemented inside application.
For example: VIEW,EDIT,SAVE
Action name preferred to be in Capital latter.','sys_commonfunctions',0,'','SYS_COMMON_FUNCTIONS', (select COALESCE(COALESCE(max(id),0),0) from sys_metadata) + 1);


-----------------

INSERT INTO sys_metadata(fieldname, fieldtype, caption, mandatory, defaultvalue, lovc, lovp, lovcp, minvalue, maxvalue, decimals, strlen, displen, allowedit, tip, tablename, errorlevel, field_specialty, report_code, id)
	VALUES('id','INT','ID','Yes','','','','','','','',30,75,FALSE,'Auto generated primary key. Not editable.','sys_report_functions',0,'p','SYS_REPORT_FUNCTIONS', (select COALESCE(COALESCE(max(id),0),0) from sys_metadata) + 1);

INSERT INTO sys_metadata(fieldname, fieldtype, caption, mandatory, defaultvalue, lovc, lovp, lovcp, minvalue, maxvalue, decimals, strlen, displen, allowedit, tip, tablename, errorlevel, field_specialty, report_code, id)
	VALUES('report_code','STR','Report','LOV','','','','Select report_code,report_name from sys_dfn_repdetail','','','',50,150,TRUE,'Select a report to define a function for that report','sys_report_functions',0,'','SYS_REPORT_FUNCTIONS', (select COALESCE(COALESCE(max(id),0),0) from sys_metadata) + 1);

INSERT INTO sys_metadata(fieldname, fieldtype, caption, mandatory, defaultvalue, lovc, lovp, lovcp, minvalue, maxvalue, decimals, strlen, displen, allowedit, tip, tablename, errorlevel, field_specialty, report_code, id)
	VALUES('order_position','INT','Position on interface','Yes','','','','','','','',50,75,TRUE,'This the position in the report grid by which they will be shown one after anohter','sys_report_functions',0,'','SYS_REPORT_FUNCTIONS', (select COALESCE(COALESCE(max(id),0),0) from sys_metadata) + 1);

INSERT INTO sys_metadata(fieldname, fieldtype, caption, mandatory, defaultvalue, lovc, lovp, lovcp, minvalue, maxvalue, decimals, strlen, displen, allowedit, tip, tablename, errorlevel, field_specialty, report_code, id)
	VALUES('parameters','STR','Function params','Yes','','','','','','','',50,150,TRUE,'One or more field names(usually key fields) of the report tables which will be passed 
as argument through the function. More more than one field use semicolon in between.
For example: id,name','sys_report_functions',0,'','SYS_REPORT_FUNCTIONS', (select COALESCE(COALESCE(max(id),0),0) from sys_metadata) + 1);

INSERT INTO sys_metadata(fieldname, fieldtype, caption, mandatory, defaultvalue, lovc, lovp, lovcp, minvalue, maxvalue, decimals, strlen, displen, allowedit, tip, tablename, errorlevel, field_specialty, report_code, id)
	VALUES('function_name','STR','Function Name','Yes','','','','','','','',50,150,TRUE,'The name of the function implemented in the application for this report. 
For example: ADD or EDIT or DELETE etc.','sys_report_functions',0,'','SYS_REPORT_FUNCTIONS', (select COALESCE(COALESCE(max(id),0),0) from sys_metadata) + 1);

INSERT INTO sys_metadata(fieldname, fieldtype, caption, mandatory, defaultvalue, lovc, lovp, lovcp, minvalue, maxvalue, decimals, strlen, displen, allowedit, tip, tablename, errorlevel, field_specialty, report_code, id)
	VALUES('is_report_specific','STR','Is report specific','LOV','False','/True/False','','','','','',50,75,TRUE,'False: If you are using the common functions which are shared by more than one report.
True: If you are using this as a dedicated function for this report only.','sys_report_functions',0,'','SYS_REPORT_FUNCTIONS', (select COALESCE(COALESCE(max(id),0),0) from sys_metadata) + 1);


----------------------------
INSERT INTO sys_metadata(fieldname, fieldtype, caption, mandatory, defaultvalue, lovc, lovp, lovcp, minvalue, maxvalue, decimals, strlen, displen, allowedit, tip, tablename, errorlevel, field_specialty, report_code, id)
	VALUES('id','INT','ID','Yes','','','','','','','',30,75,FALSE,'Auto generated primary key. No editable','sys_user_reg',2,'p','SYS_USER_REG', (select COALESCE(COALESCE(max(id),0),0) from sys_metadata) + 1);

INSERT INTO sys_metadata(fieldname, fieldtype, caption, mandatory, defaultvalue, lovc, lovp, lovcp, minvalue, maxvalue, decimals, strlen, displen, allowedit, tip, tablename, errorlevel, field_specialty, report_code, id)
	VALUES('user_id','STR','User ID','Yes','','','','','','','',50,75,TRUE,'Give a unique user id. That must not contain any space and special character.','sys_user_reg',0,'','SYS_USER_REG', (select COALESCE(COALESCE(max(id),0),0) from sys_metadata) + 1);

INSERT INTO sys_metadata(fieldname, fieldtype, caption, mandatory, defaultvalue, lovc, lovp, lovcp, minvalue, maxvalue, decimals, strlen, displen, allowedit, tip, tablename, errorlevel, field_specialty, report_code, id)
	VALUES('user_pass','STR','Password','Yes','','','','','','','',50,150,TRUE,'Password for this user.','sys_user_reg',0,'','SYS_USER_REG', (select COALESCE(COALESCE(max(id),0),0) from sys_metadata) + 1);

INSERT INTO sys_metadata(fieldname, fieldtype, caption, mandatory, defaultvalue, lovc, lovp, lovcp, minvalue, maxvalue, decimals, strlen, displen, allowedit, tip, tablename, errorlevel, field_specialty, report_code, id)
	VALUES('user_name','STR','User Name','Yes','','','','','','','',50,150,TRUE,'Name of the user','sys_user_reg',0,'','SYS_USER_REG', (select COALESCE(COALESCE(max(id),0),0) from sys_metadata) + 1);

INSERT INTO sys_metadata(fieldname, fieldtype, caption, mandatory, defaultvalue, lovc, lovp, lovcp, minvalue, maxvalue, decimals, strlen, displen, allowedit, tip, tablename, errorlevel, field_specialty, report_code, id)
	VALUES('user_email','STR','Email','Yes','','','','','','','',50,200,TRUE,'Provide user email address','sys_user_reg',0,'','SYS_USER_REG', (select COALESCE(COALESCE(max(id),0),0) from sys_metadata) + 1);

INSERT INTO sys_metadata(fieldname, fieldtype, caption, mandatory, defaultvalue, lovc, lovp, lovcp, minvalue, maxvalue, decimals, strlen, displen, allowedit, tip, tablename, errorlevel, field_specialty, report_code, id)
	VALUES('domain','STR','Domain value','No','','','','','','','',50,150,TRUE,'Optional value. It can be any value 
that will be used to filtering on the report to restrict the user to have access to the data.','sys_user_reg',0,'','SYS_USER_REG', (select COALESCE(COALESCE(max(id),0),0) from sys_metadata) + 1);

----

INSERT INTO sys_metadata(fieldname, fieldtype, caption, mandatory, defaultvalue, lovc, lovp, lovcp, minvalue, maxvalue, decimals, strlen, displen, allowedit, tip, tablename, errorlevel, field_specialty, report_code, id)
	VALUES('id','INT','ID','Yes','','','','','','','',30,75,FALSE,'Auto generated primary key.','sys_user_role_relation',2,'p','SYS_USR_ROLE', (select COALESCE(COALESCE(max(id),0),0) from sys_metadata) + 1);

INSERT INTO sys_metadata(fieldname, fieldtype, caption, mandatory, defaultvalue, lovc, lovp, lovcp, minvalue, maxvalue, decimals, strlen, displen, allowedit, tip, tablename, errorlevel, field_specialty, report_code, id)
	VALUES('user_name','STR','User ID','LOV','','Select user_id from sys_user_reg','','','','','',50,150,TRUE,'Select a user id to assign the role to.','sys_user_role_relation',0,'','SYS_USR_ROLE', (select COALESCE(COALESCE(max(id),0),0) from sys_metadata) + 1);

INSERT INTO sys_metadata(fieldname, fieldtype, caption, mandatory, defaultvalue, lovc, lovp, lovcp, minvalue, maxvalue, decimals, strlen, displen, allowedit, tip, tablename, errorlevel, field_specialty, report_code, id)
	VALUES('rolename','STR','Role','Yes','','','','','','','',50,150,TRUE,'Give a role name to the user. Role name is defined by the application administrator','sys_user_role_relation',0,'','SYS_USR_ROLE', (select COALESCE(COALESCE(max(id),0),0) from sys_metadata) + 1);
	
	-----

INSERT INTO sys_metadata(fieldname, fieldtype, caption, mandatory, defaultvalue, lovc, lovp, lovcp, minvalue, maxvalue, decimals, strlen, displen, allowedit, tip, tablename, errorlevel, field_specialty, report_code, id)
	VALUES('id','INT','ID','Yes','','','','','','','',30,75,FALSE,'Auto generated primary key. Not editable','sys_report_linking',0,'p','SYS_REPORT_LINKING', (select COALESCE(COALESCE(max(id),0),0) from sys_metadata) + 1);
	
INSERT INTO sys_metadata(fieldname, fieldtype, caption, mandatory, defaultvalue, lovc, lovp, lovcp, minvalue, maxvalue, decimals, strlen, displen, allowedit, tip, tablename, errorlevel, field_specialty, report_code, id)
	VALUES('function_name','STR','Function Name','Yes','','','','','','','',50,150,TRUE,'Name of the function for a Report. Format is: [Reportcode]_LINK.','sys_report_linking',0,'','SYS_REPORT_LINKING', (select COALESCE(COALESCE(max(id),0),0) from sys_metadata) + 1);
	
INSERT INTO sys_metadata(fieldname, fieldtype, caption, mandatory, defaultvalue, lovc, lovp, lovcp, minvalue, maxvalue, decimals, strlen, displen, allowedit, tip, tablename, errorlevel, field_specialty, report_code, id)
	VALUES('tooltip','Text','Tool tip','Yes','','','','','','','',50,300,TRUE,'Tool tip for this link function that describe the function.','sys_report_linking',0,'','SYS_REPORT_LINKING', (select COALESCE(COALESCE(max(id),0),0) from sys_metadata) + 1);
	
INSERT INTO sys_metadata(fieldname, fieldtype, caption, mandatory, defaultvalue, lovc, lovp, lovcp, minvalue, maxvalue, decimals, strlen, displen, allowedit, tip, tablename, errorlevel, field_specialty, report_code, id)
	VALUES('source_report_code','STR','Source Report','LOV','','Select report_code from sys_dfn_repdetail','','','','','',50,150,TRUE,'The report_code in which linking function is added','sys_report_linking',0,'','SYS_REPORT_LINKING', (select COALESCE(COALESCE(max(id),0),0) from sys_metadata) + 1);
	
INSERT INTO sys_metadata(fieldname, fieldtype, caption, mandatory, defaultvalue, lovc, lovp, lovcp, minvalue, maxvalue, decimals, strlen, displen, allowedit, tip, tablename, errorlevel, field_specialty, report_code, id)
	VALUES('source_keyfield','STR','Source key field','Yes','','','','','','','',50,150,TRUE,'Source report table''s key field','sys_report_linking',0,'','SYS_REPORT_LINKING', (select COALESCE(COALESCE(max(id),0),0) from sys_metadata) + 1);
	
INSERT INTO sys_metadata(fieldname, fieldtype, caption, mandatory, defaultvalue, lovc, lovp, lovcp, minvalue, maxvalue, decimals, strlen, displen, allowedit, tip, tablename, errorlevel, field_specialty, report_code, id)
	VALUES('destination_report_code','STR','Destination Report','LOV','','Select report_code from sys_dfn_repdetail','','','','','',50,150,TRUE,'','sys_report_linking',0,'','SYS_REPORT_LINKING', (select COALESCE(COALESCE(max(id),0),0) from sys_metadata) + 1);
	
INSERT INTO sys_metadata(fieldname, fieldtype, caption, mandatory, defaultvalue, lovc, lovp, lovcp, minvalue, maxvalue, decimals, strlen, displen, allowedit, tip, tablename, errorlevel, field_specialty, report_code, id)
	VALUES('destination_keyfield','STR','Destination key field','Yes','','','','','','','',50,150,TRUE,'Destination report table''s key field','sys_report_linking',0,'','SYS_REPORT_LINKING', (select COALESCE(COALESCE(max(id),0),0) from sys_metadata) + 1);
	
-----

INSERT INTO sys_metadata(fieldname, fieldtype, caption, mandatory, defaultvalue, lovc, lovp, lovcp, minvalue, maxvalue, decimals, strlen, displen, allowedit, tip, tablename, errorlevel, field_specialty, report_code, id)
	VALUES('id','INT','ID','Yes','','','','','','','',30,150,FALSE,'Auto generated unique Id','sys_metadata',2,'p','SYS_METADATA', (select COALESCE(COALESCE(max(id),0),0) from sys_metadata) + 1);
	
INSERT INTO sys_metadata(fieldname, fieldtype, caption, mandatory, defaultvalue, lovc, lovp, lovcp, minvalue, maxvalue, decimals, strlen, displen, allowedit, tip, tablename, errorlevel, field_specialty, report_code, id)
	VALUES('fieldname','STR','Field Name','Yes','','','','','','','',30,150,TRUE,'Give the original name of the field of database
table/view for which you want to create report.','sys_metadata',2,'','SYS_METADATA', (select COALESCE(COALESCE(max(id),0),0) from sys_metadata) + 1);
	
INSERT INTO sys_metadata(fieldname, fieldtype, caption, mandatory, defaultvalue, lovc, lovp, lovcp, minvalue, maxvalue, decimals, strlen, displen, allowedit, tip, tablename, errorlevel, field_specialty, report_code, id)
	VALUES('fieldtype','STR','Field Type','LOV','','/INT/FLOAT/STR/Text/DATE','','','','','',30,150,TRUE,'Data type of this field. Select one of the data type from this list.
STR: For string data type. Choose STR for boolean data as well and 
         select LOV in mandatory field and give /True/False in LOVC field
INT: For integer data type
FLOAT: For float/double data type
DATE: For date data type
Text: For multiline string data.
LOV: For list of values( To choose fixed values from a list ). 
LASTUPDATE: Not avaibale yet for use','sys_metadata',0,'','SYS_METADATA', (select COALESCE(COALESCE(max(id),0),0) from sys_metadata) + 1);
	
INSERT INTO sys_metadata(fieldname, fieldtype, caption, mandatory, defaultvalue, lovc, lovp, lovcp, minvalue, maxvalue, decimals, strlen, displen, allowedit, tip, tablename, errorlevel, field_specialty, report_code, id)
	VALUES('caption','STR','Caption','No','','','','','','','',30,150,TRUE,'Optional caption for the field name to show as a label in the property editor','sys_metadata',0,'','SYS_METADATA', (select COALESCE(COALESCE(max(id),0),0) from sys_metadata) + 1);
	
INSERT INTO sys_metadata(fieldname, fieldtype, caption, mandatory, defaultvalue, lovc, lovp, lovcp, minvalue, maxvalue, decimals, strlen, displen, allowedit, tip, tablename, errorlevel, field_specialty, report_code, id)
	VALUES('mandatory','STR','Mandatory','LOV','','/Yes/No/LOV','','','','','',30,100,TRUE,'Define if the field is mandatory. Three values can be given here:
YES: Field must be filled
NO:  Field can be empty
LOV: Field value have to be chosen from a 
        list(Slash seperted string or SQL query)/grid(May be a SQL query)
        That have to be defined in the next LOVC or LOVP or LOVCP field','sys_metadata',0,'n','SYS_METADATA', (select COALESCE(COALESCE(max(id),0),0) from sys_metadata) + 1);
	
INSERT INTO sys_metadata(fieldname, fieldtype, caption, mandatory, defaultvalue, lovc, lovp, lovcp, minvalue, maxvalue, decimals, strlen, displen, allowedit, tip, tablename, errorlevel, field_specialty, report_code, id)
	VALUES('defaultvalue','STR','Default Value','No','','','','','','','',30,150,TRUE,'Default Value of this field.','sys_metadata',0,'','SYS_METADATA', (select COALESCE(COALESCE(max(id),0),0) from sys_metadata) + 1);
	
INSERT INTO sys_metadata(fieldname, fieldtype, caption, mandatory, defaultvalue, lovc, lovp, lovcp, minvalue, maxvalue, decimals, strlen, displen, allowedit, tip, tablename, errorlevel, field_specialty, report_code, id)
	VALUES('lovc','STR','LOVC','No','','','','','','','',50,150,TRUE,'< nieuw xmlns=''http://www.nedgraphics.nl/NGDW/GEOCAD/1.0''>< aaa>this< /aaa>< /nieuw >','sys_metadata',0,'','SYS_METADATA', (select COALESCE(COALESCE(max(id),0),0) from sys_metadata) + 1);
	
INSERT INTO sys_metadata(fieldname, fieldtype, caption, mandatory, defaultvalue, lovc, lovp, lovcp, minvalue, maxvalue, decimals, strlen, displen, allowedit, tip, tablename, errorlevel, field_specialty, report_code, id)
	VALUES('lovp','STR','LOVP','No','','','','','','','',50,150,TRUE,'Only sql query allowed(For this moment sql must contain 
at least two field names in select statement and no order by and where clause).
LOV will appear as editbox with a lookup button behind it, calling a modal 
window in which more things like filtering, ordering and other general grid 
behaviour supports quick navigation (Filtering is under development).','sys_metadata',0,'','SYS_METADATA', (select COALESCE(COALESCE(max(id),0),0) from sys_metadata) + 1);
	
INSERT INTO sys_metadata(fieldname, fieldtype, caption, mandatory, defaultvalue, lovc, lovp, lovcp, minvalue, maxvalue, decimals, strlen, displen, allowedit, tip, tablename, errorlevel, field_specialty, report_code, id)
	VALUES('lovcp','STR','LOVCP','No','','','','','','','',50,150,TRUE,'Only sql query allowed(For this moment sql must contain 
at least two field names in select statement and no order by and where clause).
This property combines LOVC and LOVP. The inputbox will be converted to 
a combo and a pick button will appear as well for better searching posibilities.','sys_metadata',0,'','SYS_METADATA', (select COALESCE(COALESCE(max(id),0),0) from sys_metadata) + 1);
	
INSERT INTO sys_metadata(fieldname, fieldtype, caption, mandatory, defaultvalue, lovc, lovp, lovcp, minvalue, maxvalue, decimals, strlen, displen, allowedit, tip, tablename, errorlevel, field_specialty, report_code, id)
	VALUES('minvalue','INT','Minimum Value','No','','','','','','','',30,150,TRUE,'Minimum acceptable value for INT and FLOAT value','sys_metadata',0,'','SYS_METADATA', (select COALESCE(COALESCE(max(id),0),0) from sys_metadata) + 1);
	
INSERT INTO sys_metadata(fieldname, fieldtype, caption, mandatory, defaultvalue, lovc, lovp, lovcp, minvalue, maxvalue, decimals, strlen, displen, allowedit, tip, tablename, errorlevel, field_specialty, report_code, id)
	VALUES('maxvalue','INT','Maximum Value','No','','','','','','','',30,150,TRUE,'Maximum acceptable value for INT and FLOAT value','sys_metadata',0,'','SYS_METADATA', (select COALESCE(COALESCE(max(id),0),0) from sys_metadata) + 1);
	
INSERT INTO sys_metadata(fieldname, fieldtype, caption, mandatory, defaultvalue, lovc, lovp, lovcp, minvalue, maxvalue, decimals, strlen, displen, allowedit, tip, tablename, errorlevel, field_specialty, report_code, id)
	VALUES('decimals','FLOAT','Decimals','No','','','','','','','',30,150,TRUE,'Define the number of decimals for a FLOAT value','sys_metadata',0,'','SYS_METADATA', (select COALESCE(COALESCE(max(id),0),0) from sys_metadata) + 1);
	
INSERT INTO sys_metadata(fieldname, fieldtype, caption, mandatory, defaultvalue, lovc, lovp, lovcp, minvalue, maxvalue, decimals, strlen, displen, allowedit, tip, tablename, errorlevel, field_specialty, report_code, id)
	VALUES('strlen','INT','String Length','No','','','','','','','',30,150,TRUE,'Define the maximum string length for a STR type value. 
For a primary key field, string length must be filled up','sys_metadata',0,'','SYS_METADATA', (select COALESCE(COALESCE(max(id),0),0) from sys_metadata) + 1);
	
INSERT INTO sys_metadata(fieldname, fieldtype, caption, mandatory, defaultvalue, lovc, lovp, lovcp, minvalue, maxvalue, decimals, strlen, displen, allowedit, tip, tablename, errorlevel, field_specialty, report_code, id)
	VALUES('displen','INT','Display Length','No','','','','','','','',30,150,TRUE,'Define the display length of control (editbox, combo etc)in the interface  
(excluding the pick button).','sys_metadata',0,'','SYS_METADATA', (select COALESCE(COALESCE(max(id),0),0) from sys_metadata) + 1);
	
INSERT INTO sys_metadata(fieldname, fieldtype, caption, mandatory, defaultvalue, lovc, lovp, lovcp, minvalue, maxvalue, decimals, strlen, displen, allowedit, tip, tablename, errorlevel, field_specialty, report_code, id)
	VALUES('allowedit','STR','Allow Edit','LOV','','/True/False','','','','','',30,100,TRUE,'True/False: 
--- For true field would be editable.
--- For false field would be appeared in the interface but would not be editable.','sys_metadata',0,'','SYS_METADATA', (select COALESCE(COALESCE(max(id),0),0) from sys_metadata) + 1);
	
INSERT INTO sys_metadata(fieldname, fieldtype, caption, mandatory, defaultvalue, lovc, lovp, lovcp, minvalue, maxvalue, decimals, strlen, displen, allowedit, tip, tablename, errorlevel, field_specialty, report_code, id)
	VALUES('tip','Text','Tooltip','No','','','','','','','',50,250,TRUE,'Text entered here will be appeared as tool tip on this property in property editor.','sys_metadata',0,'','SYS_METADATA', (select COALESCE(COALESCE(max(id),0),0) from sys_metadata) + 1);
	
	
	
	
	----
	
INSERT INTO sys_metadata(fieldname, fieldtype, caption, mandatory, defaultvalue, lovc, lovp, lovcp, minvalue, maxvalue, decimals, strlen, displen, allowedit, tip, tablename, errorlevel, field_specialty, report_code, id)
	VALUES('tablename','STR','DB Table Name','LOV','','select table_name from INFORMATION_SCHEMA.tables WHERE table_schema = ANY (current_schemas(false))','','','','','',30,150,TRUE,'Select a table that is the source of this field','sys_metadata',0,'n','SYS_METADATA', (select COALESCE(COALESCE(max(id),0),0) from sys_metadata) + 1);
	
INSERT INTO sys_metadata(fieldname, fieldtype, caption, mandatory, defaultvalue, lovc, lovp, lovcp, minvalue, maxvalue, decimals, strlen, displen, allowedit, tip, tablename, errorlevel, field_specialty, report_code, id)
	VALUES('errorlevel','INT','Error Level','LOV','','/0/1/2','','','','','',10,75,TRUE,'0/1/2:0: If 0, then interface will not check any constriant which has been defined in     property editor rules table.1: If 1, interface should mention an warning if validation is not correct but it     should allow save with an invalid value. This is only for string type value. 2: If 2, interface should show an error icon next to the field,  whenever user     does mouse over the icon it will show the validation error. And system will     not allow to save (edit can be cancelled of course)','sys_metadata',0,'','SYS_METADATA', (select COALESCE(COALESCE(max(id),0),0) from sys_metadata) + 1);
	
INSERT INTO sys_metadata(fieldname, fieldtype, caption, mandatory, defaultvalue, lovc, lovp, lovcp, minvalue, maxvalue, decimals, strlen, displen, allowedit, tip, tablename, errorlevel, field_specialty, report_code, id)
	VALUES('field_specialty','STR','Field Constrains','No','','/ /p/n/u','','','','','',10,75,TRUE,'p/u/n: This defines the constraint of the field in the database table.

p: Indicate the field as primary key.
u: Indicate the field as unique value field.
n: Indicate the field as not null.

N.B: If all fields are null allowed except primary key 
       then at least one field must be defined not null (n) here','sys_metadata',0,'','SYS_METADATA', (select COALESCE(COALESCE(max(id),0),0) from sys_metadata) + 1);
	
INSERT INTO sys_metadata(fieldname, fieldtype, caption, mandatory, defaultvalue, lovc, lovp, lovcp, minvalue, maxvalue, decimals, strlen, displen, allowedit, tip, tablename, errorlevel, field_specialty, report_code, id)
	VALUES('field_order','INT','Property Order','No','','','','','','','',10,75,TRUE,'Within the interface the fields appear in this integer based order value.','sys_metadata',0,'','SYS_METADATA', (select COALESCE(COALESCE(max(id),0),0) from sys_metadata) + 1);
	
INSERT INTO sys_metadata(fieldname, fieldtype, caption, mandatory, defaultvalue, lovc, lovp, lovcp, minvalue, maxvalue, decimals, strlen, displen, allowedit, tip, tablename, errorlevel, field_specialty, report_code, id)
	VALUES('field_group','STR','Field Group','No','','','','','','','',10,75,TRUE,'Any name to use as groupname by which the controls will be 
grouped in fieldsets in the interface.(Not functional yet)','sys_metadata',0,'','SYS_METADATA', (select COALESCE(COALESCE(max(id),0),0) from sys_metadata) + 1);
	
INSERT INTO sys_metadata(fieldname, fieldtype, caption, mandatory, defaultvalue, lovc, lovp, lovcp, minvalue, maxvalue, decimals, strlen, displen, allowedit, tip, tablename, errorlevel, field_specialty, report_code, id)
	VALUES('report_code','STR','Report Code','LOV','report_code','','SELECT report_code, report_name FROM sys_dfn_repdetail','','','','',30,150,TRUE,'Name of the report code (same as in SYS_REPORT_DETAIL table) to add/edit report','sys_metadata',0,'','SYS_METADATA', (select COALESCE(COALESCE(max(id),0),0) from sys_metadata) + 1);


--------------
INSERT INTO sys_metadata(fieldname, fieldtype, caption, mandatory, defaultvalue, lovc, lovp, lovcp, minvalue, maxvalue, decimals, strlen, displen, allowedit, tip, tablename, errorlevel, field_specialty, report_code, id)
	VALUES('reportcode','STR','Report Code','Yes','report_code','','SELECT report_code, report_name FROM sys_dfn_repdetail','','','','',30,150,TRUE,'Name of the report code (same as in SYS_REPORT_DETAIL table) to add/edit report','sys_group_color',0,'','SYS_GROUP_COLOR', (select COALESCE(COALESCE(max(id),0),0) from sys_metadata) + 1);
	
INSERT INTO sys_metadata(fieldname, fieldtype, caption, mandatory, defaultvalue, lovc, lovp, lovcp, minvalue, maxvalue, decimals, strlen, displen, allowedit, tip, tablename, errorlevel, field_specialty, report_code, id)
	VALUES('groupby','STR','Group by','No','','','','','','','',30,150,TRUE,'Group by','sys_group_color',0,'','SYS_GROUP_COLOR', (select COALESCE(COALESCE(max(id),0),0) from sys_metadata) + 1);
	
INSERT INTO sys_metadata(fieldname, fieldtype, caption, mandatory, defaultvalue, lovc, lovp, lovcp, minvalue, maxvalue, decimals, strlen, displen, allowedit, tip, tablename, errorlevel, field_specialty, report_code, id)
	VALUES('groupcode','STR','Group Code','No','','','','','','','',30,150,TRUE,'Group Code','sys_group_color',0,'','SYS_GROUP_COLOR', (select COALESCE(COALESCE(max(id),0),0) from sys_metadata) + 1);
	
INSERT INTO sys_metadata(fieldname, fieldtype, caption, mandatory, defaultvalue, lovc, lovp, lovcp, minvalue, maxvalue, decimals, strlen, displen, allowedit, tip, tablename, errorlevel, field_specialty, report_code, id)
	VALUES('colorcode','STR','Color Code','No','','','','','','','',30,150,TRUE,'Color Code','sys_group_color',0,'','SYS_GROUP_COLOR', (select COALESCE(COALESCE(max(id),0),0) from sys_metadata) + 1);

--------------------------------
-- sys_authorization
--------------------------------
INSERT INTO sys_metadata(fieldname, fieldtype, caption, mandatory, defaultvalue, lovc, lovp, lovcp, minvalue, maxvalue, decimals, strlen, displen, allowedit, tip, tablename, errorlevel, field_specialty, report_code, id)
	VALUES('id','INT','Id','Yes','','','','','','','',30,150,FALSE,'Color Code','sys_authorization',2,'p','SYS_AUTHORIZATION', (select COALESCE(COALESCE(max(id),0),0) from sys_metadata) + 1);
INSERT INTO sys_metadata(fieldname, fieldtype, caption, mandatory, defaultvalue, lovc, lovp, lovcp, minvalue, maxvalue, decimals, strlen, displen, allowedit, tip, tablename, errorlevel, field_specialty, report_code, id)
	VALUES('role_id','STR','Role Id','LOV','','select distinct rolename from sys_user_role_relation','','','','','',100,100,TRUE,'Role ID','sys_authorization',2,'u','SYS_AUTHORIZATION', (select COALESCE(COALESCE(max(id),0),0) from sys_metadata) + 1);
INSERT INTO sys_metadata(fieldname, fieldtype, caption, mandatory, defaultvalue, lovc, lovp, lovcp, minvalue, maxvalue, decimals, strlen, displen, allowedit, tip, tablename, errorlevel, field_specialty, report_code, id)
	VALUES('report_function_code','STR','Report function Code','Yes','','','','','','','',100,250,TRUE,'Report function Code','sys_authorization',2,'u','SYS_AUTHORIZATION', (select COALESCE(COALESCE(max(id),0),0) from sys_metadata) + 1);