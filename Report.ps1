# Armazena o conteúdo da “credential” auditoria_azure dentro da váriavel $AutomationCredential
$AutomationCredential = ‘Audit Account’

#Guarda os dados de login/senha dentro da váriavel $cred
$Cred = Get-AutomationPSCredential -Name $AutomationCredential #Autentica no portal ASM e ARM

# Skip ASM
# Add-AzureAccount -Credential $Cred

# Sign in ARM
Login-AzureRmAccount -Credential $Cred #Guarda todas subscriptions dentro da váriavel $Assinaturas
$Assinaturas = Get-AzureRmSubscription | select SubscriptionId

# Laço de repetição para armazenar os objetos criados do dia anterior, filtra em “deployments” selecionando informações, tabula os dados e armazena dentro da variável $objeto
$Lista = foreach
(
    $Assinatura in $Assinaturas = $Assinaturas -replace “@{SubscriptionId=”,”” -replace “.$”
)
{$Subscription = Set-AzureRmContext -SubscriptionId $Assinatura
$Recursos = Get-AzureRmLog -StartTime (Get-Date).AddDays(-1) | Select SubscriptionId, ResourceGroupName, Caller, EventTimestamp, ResourceId  | Format-List -Property *

# Skip filter # | Where-Object { $_.OperationName -like “*deployments*” } 
}

# Todos objetos armazenado na variável $Lista é armazenado também dentro do arquivo NovosObjetos.txt
$Recursos >> NovosRecursos.txt

# Envia e-mail com o arquivo anexo!
[string]$corpoemail = “”
$data = (Get-Date).ToString()
$assunto = “” + $data

# Enviando e-mail com o relatório a partir do Office 365, dessa forma é necessário fazer a autenticação via TLS, utilize um e-mail valido, altere os campos em negrito com e-mail e senha
$secpasswd = ConvertTo-SecureString “” -AsPlainText -Force
$mycreds = New-Object System.Management.Automation.PSCredential (“”, $secpasswd)
Send-MailMessage -To “ <>”, “ <>” -SmtpServer “” -Credential $mycreds -UseSsl $assunto -Port “587” -Body $corpoemail -From “ <>” -BodyAsHtml -Attachments NovosRecursos.txt
