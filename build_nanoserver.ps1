$ErrorActionPreference = "Stop"
$ScriptPath = $(Split-Path $script:MyInvocation.MyCommand.Path)

# Download Python and install it locally under this folder
$PYTHON_VERSION="3.6.5"
$PYTHON_RELEASE="3.6.5"

If (Test-Path -Path "$ScriptPath\Python36") {
	Write-Output "Found existing Python installation from: $ScriptPath\Python36"
} Else {
	$url = ('https://www.python.org/ftp/python/{0}/python-{1}-amd64.exe' -f $PYTHON_RELEASE, $PYTHON_VERSION)
	Write-Output ('Not found Python installation. Downloading {0} ...' -f $url)
	Invoke-WebRequest -Uri $url -OutFile "$ScriptPath\python.exe"

	Write-Host 'Installing ...'; 
	$Arguments = "/quiet InstallAllUsers=0 TargetDir=$ScriptPath\Python36 PrependPath=0 Shortcuts=0 Include_doc=0 Include_pip=1 Include_test=0 Include_launcher=0"
	Start-Process -FilePath "$ScriptPath\python.exe" -ArgumentList $Arguments -Wait -NoNewWindow -PassThru 

	Remove-Item .\Python.exe -Force
}


# Build docker image
docker build . -f Dockerfile.nanoserver-sac2016 -t microsoft/applicationinsights:0.9.3-nanoserver-sac2016