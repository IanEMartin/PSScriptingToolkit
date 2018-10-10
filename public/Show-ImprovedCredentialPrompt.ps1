function Show-ImprovedCredentialPrompt {
  [CmdletBinding()]
  param (
    [Parameter(Mandatory, HelpMessage = 'Enter a domain name')]
    [string]
    $DomainName,
    [Parameter(Mandatory, HelpMessage = 'Enter a computer name')]
    [string[]]
    $ComputerName,
    [Parameter(Mandatory, HelpMessage = 'Enter a message for the prompt')]
    [string]
    $Message
  )

  $ComputerName = $ComputerName.ToUpper()
  $DomainName = $DomainName.ToUpper()
  $userID = '{0}\' -f $DomainName
  $Message = 'Please enter your password for system(s):{0}{1}' -f "`r`n", $ComputerName
  $usercreds = $Host.ui.PromptForCredential('Credentials', $Message, $userID, '')
  $usercreds
}
