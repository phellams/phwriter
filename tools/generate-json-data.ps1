#Note: load hashtable data from ps1 file
. './phwriter-metadata.ps1'

foreach ($helpdata in $phwriter_metadata_array) {
    $cmdlet_name = $helpdata.CommandInfo.cmdlet
    # Add Module Name
    $helpdata.name = $modulename
    # Add version to each cmdlet propery
    $helpdata.version = $moduleversion
    # Add Padding to each cmdlet propery
    $helpdata.padding = 3
    # Add indenting to each cmdlet propery
    $helpdata.indent = 2
    # Add source to each cmdlet propery
    $helpdata.CommandInfo.source = $source

    $json_output_path = "./libs/help_metadata/$($cmdlet_name.tolower())_phwriter_metadata.json"
    $helpdata  | ConvertTo-Json -Depth 5 | Out-File -FilePath $json_output_path -Force -Encoding UTF8
    $interlogger.invoke("generated", "help metadata for {kv:cmdlet=$cmdlet_name} at {kv:path=$json_output_path}", $false, 'info')
}
