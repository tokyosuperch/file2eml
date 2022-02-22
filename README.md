# file2eml
File converter to eml file (file attached E-Mail)

### Before using
If you live in a timezone other than +0900, please change **line 10** before using.
```
    $gmt -replace "GMT","+0900" | Out-File "$file.eml" -Append -NoNewline -Encoding ascii
```

## Usage
Usage:
```
> .\file2eml.ps1 fullpath_to_file1 fullpath_to_file2 fullpath_to_file3 ...
```
