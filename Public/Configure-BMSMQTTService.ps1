function Install-BMSMQTTService
{
    switch ($PSVersionTable.Platform) {
        Unix {
            if ((id -u) -eq 1000) {
                (gci $PSCommandPath).Directory
                Join-Path -Path (gci $PSCommandPath).Directory -ChildPath "recbmsmqtt.service"
            }
            else {
                Write-Error "This command requires SUDO privilages"
            }
        }

        Win32NT {
            Write-Warning "Windows Service: Not Implemented Yet"
        }
        Default {
            Write-Error "This script requires PowerShell Core to function properly."
        }
    }
}

function Repair-BMSMQTTService
{
    switch ($PSVersionTable.Platform) {
        Unix {
            if ((id -u) -eq 1000) {
                Join-Path -Path (gci $PSCommandPath).Directory -ChildPath "recbmsmqtt.service"
            }
            else {
                Write-Error "This command requires SUDO privilages"
            }
        }

        Win32NT {
            Write-Warning "Windows Service: Not Implemented Yet"
        }
        Default {
            Write-Error "This script requires PowerShell Core to function properly."
        }
    }
}

function Uninstall-BMSMQTTService
{
    switch ($PSVersionTable.Platform) {
        Unix {
            if ((id -u) -eq 1000) {
                Join-Path -Path (gci $PSCommandPath).Directory -ChildPath "recbmsmqtt.service"
            }
            else {
                Write-Error "This command requires SUDO privilages"
            }
        }

        Win32NT {
            Write-Warning "Windows Service: Not Implemented Yet"
        }
        Default {
            Write-Error "This script requires PowerShell Core to function properly."
        }
    }
}