$secpasswd = ConvertTo-SecureString “MyPassowrd” -AsPlainText -Force
$mycreds = New-Object System.Management.Automation.PSCredential (“noreply@email.com”, $secpasswd)
Send-MailMessage -To “Name Surname <user@mail.com>” -SmtpServer “smtp-mail.outlook.com” -Credential $mycreds -UseSsl "teste" -Port “587” -Body "teste" -From “Name Surname <noreply@mail.com>” -BodyAsHtml -Attachments file.txt
