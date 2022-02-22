function WriteEml($argument) {
    $file = [System.IO.Path]::GetFileName("$argument")
    $byte = ([System.Text.Encoding]::GetEncoding('utf-8')).GetBytes($file)
    $b64enc = [Convert]::ToBase64String($byte)
    Add-Type -AssemblyName "System.Web"
    Write-OutPut "From: <file2eml@localhost>`r`nTo: <file2eml@localhost>`r`nSubject: =?UTF-8?B?" | Out-File "$file.eml" -Append -NoNewline -Encoding ascii
    Write-OutPut $b64enc | Out-File "$file.eml" -Append -NoNewline -Encoding ascii
    Write-OutPut "?=`r`nDate: " | Out-File "$file.eml" -Append -NoNewline -Encoding ascii
    $gmt = $(Get-ItemProperty $file).LastWriteTime | Get-Date -F R
    $gmt -replace "GMT","+0900" | Out-File "$file.eml" -Append -NoNewline -Encoding ascii
    Write-OutPut "`r`nContent-Type: multipart/mixed; boundary=--boundary_text_string`r`n`r`n----boundary_text_string`r`nContent-Type: text/html; charset=UTF-8`r`n`r`n----boundary_text_string`r`nContent-Type: " | Out-File "$file.eml" -Append -NoNewline -Encoding ascii
    [System.Web.MimeMapping]::GetMimeMapping($file) | Out-File "$file.eml" -Append -NoNewline -Encoding ascii
    Write-OutPut '; name="=?UTF-8?B?' | Out-File "$file.eml" -Append -NoNewline -Encoding ascii
    Write-OutPut $b64enc | Out-File "$file.eml" -Append -NoNewline -Encoding ascii
    Write-OutPut '?="' | Out-File "$file.eml" -Append -NoNewline -Encoding ascii
    Write-Output "`r`nContent-Transfer-Encoding: base64`r`nContent-Disposition: attachment`r`n`r`n" | Out-File "$file.eml" -Append -NoNewline -Encoding ascii
    [Convert]::ToBase64String([System.IO.File]::ReadAllBytes($(Convert-Path .) + "\" + $file)) | Out-File "$file.eml" -Append -NoNewline -Encoding ascii
    Write-Output "`r`n`r`n----boundary_text_string--" | Out-File "$file.eml" -Append -NoNewline -Encoding ascii
}

for ($i=0; ![string]::IsNullOrEmpty($args[$i]); $i++) {
    cd $(Split-Path -Parent $args[$i])
    WriteEml $args[$i]
}