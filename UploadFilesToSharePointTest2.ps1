#Install-Module SharePointPnPPowerShell2016 -SkipPublisherCheck -AllowClobber -Force
function Write-Log {
    [CmdletBinding()]
    param(
        [Parameter()]
        [ValidateNotNullOrEmpty()]
        [string]$Message,

        [Parameter()]
        [ValidateNotNullOrEmpty()]
        [ValidateSet('Info', 'Warn', 'Error', 'Success')]
        [string]$Severity = 'Info'
    )

    $fgColor = "White"
    switch ($Severity) {
        Info {
            $fgColor = "White"
        }        
        Warn {  
            $fgColor = "Yellow"
        }
        Error {
            $fgColor = "Red"
        }
        Success {  
            $fgColor = "Green"
        }
    }
    Write-Host "$Message" -ForegroundColor $fgColor
}
try {
        $connection = Connect-PnPOnline -Url https://xxxx.sharepoint.com/sites/Archivos 
        if (-not (Get-PnPContext)) {
            Write-Log -Severity Error -Message "Error connecting to SharePoint Online, unable to establish context"
            return
        }

        Write-Log -Severity Info -Message "Uploading Files from $("PATH")"

        $filesToUpload = Get-ChildItem -Path "PATH"   -Recurse 
        foreach ($file in $filesToUpload) {
            if ($file.PSIsContainer -ne $true) {
                try {
                    Write-Log -Severity Info -Message "Uploading $($file.FullName)"
                    Add-PnPFile -Path $file.FullName -Folder "/Arys/Testing" -Connection $connection
                }
                catch {
                    Write-Log -Severity Error -Message "Failed to upload: $($file.FullName) `n $($_.Exception.Message)"
                }
            }
        } 
    }
    catch {
        Write-Log -Severity Error -Message "Error connecting to SharePoint Online: $($_.Exception.Message)"
        return
    }