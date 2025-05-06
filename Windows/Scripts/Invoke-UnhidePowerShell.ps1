# Modified from: https://github.com/UnhidePowershell/Microsoft-Unhide-PowerShell/blob/master/PowerShell/Invoke-UnhidePowerShell.ps1

$ErrorActionPreference = "SilentlyContinue"

function Invoke-UnhidePowerShell {
    process {
      if (-not ([System.Management.Automation.PSTypeName]'UnhidePowerShellClass').Type) {
        Add-Type -MemberDefinition "[DllImport(`"user32.dll`", SetLastError=true)] public static extern uint GetWindowThreadProcessId(IntPtr hWnd, out uint lpdwProcessId); [DllImport(`"user32.dll`")] public static extern IntPtr GetTopWindow(IntPtr hWnd); [DllImport(`"user32.dll`", SetLastError = true)] public static extern IntPtr GetWindow(IntPtr hWnd, uint uCmd); [DllImport(`"user32.dll`", CharSet = CharSet.Unicode)] public static extern IntPtr FindWindow(IntPtr sClassName, String sAppName); [DllImport(`"user32.dll`")] public static extern bool ShowWindowAsync(IntPtr hWnd, int nCmdShow);" -Namespace UnhidePowerShell -Name Class -Language CSharp
      }

      try {
        $getProccesses = Get-Process PowerShell -ErrorAction Stop | ForEach-Object { $_.ID }
      } catch {
        Write-Host "No PowerShell processes found!"
      }

      $i = 0
      $topWindow = [UnhidePowerShell.Class]::GetTopWindow(0)

      while ($topWindow -ne 0) {
        [UnhidePowerShell.Class]::GetWindowThreadProcessId($topWindow, [ref]$i) | Out-Null
        if ($getProccesses -contains $i) {
          [UnhidePowerShell.Class]::ShowWindowAsync($topWindow, 5) | Out-Null
        }
        $topWindow = [UnhidePowerShell.Class]::GetWindow($topWindow, 2)
      }
    }

    end {
      if ($?) {
          Write-host "Successfully exposed hidden PowerShell instances"
      }
    }
}

Invoke-UnhidePowerShell
