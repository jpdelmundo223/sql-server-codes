use Timerecord
go

declare @datetime date;
declare @htmlbody  nvarchar(max);

set @datetime = getdate()
set @htmlbody = N'<p>Hi Mam Agnes,</p>' +
				 N'<p>Sending you this branch time logs report for the ff. branches, as of ' + cast(@datetime as nvarchar(30)) + ':</p><br>' + 
				 N'<table border = "1">' + 
				 N'<tr><th>Branch</th>' + 
				 N'<th>Last Date Sync</th>' + 
				 N'<th>Remarks</th></tr>' + 
				 cast((select td = udf.Branch, '', 
						td = udf.[Last Date Synced], '',
						td = udf.Remarks, ''
				 from dbo.udfBranchTimeLogs() udf
				 for xml path('tr'), type) as nvarchar(max)) +
				 N'</table><br><br>' + 
				 N'<p>Thank you!</p>';
exec msdb.dbo.sp_send_dbmail
 @profile_name = 'MIS Email',
 @recipients = 'agnes.rivero@cebookshop.com',
 @copy_recipients = 'misconcern@cebookshop.com;john.delmundo@cebookshop.com;janno.santiago@cebookshop.com',
 @subject = 'Branch Time Logs',
 @body = @htmlbody,
 @body_format = 'HTML',
 @importance = 'Normal',
 @sensitivity = 'Confidential'
