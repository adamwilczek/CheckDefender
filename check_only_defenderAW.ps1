$cred = get-credential
$servers = Get-ADComputer -Filter "Name -like 'srvde*'" |select -exp name
#$servers =  ('srvde005.rce-group.local', 'srvde084.rce-group.local')


$collectionObj = New-Object PSObject


foreach ($comp in $servers)
{
    Invoke-Command -ComputerName $comp -ScriptBlock { Try
{



    $defender = Get-Service -Name windefend | select -expand status
    # Write-host $defender 
    if([string]::IsNullOrEmpty($defender))
    {
        Write-host "$env:computername, not found"
    }
    else
    {
        #Write-host "Windows Defender was found on the Server:" $env:computername -foregroundcolor "Cyan"
        # Write-host "Service status" $defender -foregroundcolor "Cyan"
         Get-Service -Name windefend | select -expand status
         Write-Host "$env:computername, $defender"
  
    }
}
Catch
{
    Write-host "$env:computername, not found"
}


   
    
    } -credential $cred  -ErrorAction:SilentlyContinue | Export-Csv -NoTypeInformation 'C:\impex\aw\DefenderReport_AW.csv' -Force -Append
    
 

 
  
    
} 



#$collectionObj | export-csv 'C:\scripts\DefenderReport.csv' -notypeinformation




