
Function GenerateDirectoryName ($directoryStructure, $directoryItem, $currentPath) {

    $directoryPath = "$currentPath\$(($directoryItem).Name)" 
   
    DoDirectoryActions $directoryPath
    

    #Work through the child items of the current Object
    $subDirectoryObject = $directoryStructure | Select-Object -ExpandProperty $directoryItem.Name
    $subDirectoryItems = $subDirectoryObject | Get-Member -MemberType NoteProperty
    

    if($null -ne $subDirectoryItems) {        
        Foreach($subDirectory in $subDirectoryItems)   { 
            if ($subDirectory.GetType().name -ne "String") {
                GenerateDirectoryName $subDirectoryObject $subdirectory $directoryPath
            }
        }

    } else {
        # At end of the directory tree, create a leaf folder
        $directoryPath = "$currentPath\$(($directoryItem).Name)\$(($directoryStructure).($directoryItem.Name))" 
        DoDirectoryActions $directoryPath
    }
}


Function DoDirectoryActions	($directoryPath) {
        CreateDirectory $directoryPath
        CreateFile $directoryPath
        SetRandomNumber $directoryPath
}

Function CreateDirectory ($directoryPath) {    
    if (! (Test-Path -Path $directoryPath) )     { 
        New-Item  -ItemType Directory -Path $directoryPath | Out-Null
    }
}

Function CreateFile ($filePath) {
    if ( ! (Test-Path -Path "$filePath\$randomFileName" ) )     {
            New-Item -ItemType File -Path "$filePath\$randomFileName" | Out-Null
    }
    
}

Function SetRandomNumber ($filePath) {
    #Write random number into the file
    $randomNumber = Get-Random -Minimum $minRandomNumber -Maximum ($maxRandomNumber + 1)
    Set-Content "$filePath\$randomFileName" $randomNumber


}

$directoryStructureAsJsonFile =  "directories.json"
$workingDir = $(Get-location)

$randomFileName = "random.txt"
$minRandomNumber = 8
$maxRandomNumber = 100


Function DirectoryTasks {
    #Get the directory strucure from JSON file
    $directoryStructureObject = ConvertFrom-Json "$(Get-Content $($directoryStructureAsJsonFile))"


    Foreach($item in $directoryStructureObject | Get-Member -MemberType NoteProperty)   { 
        GenerateDirectoryName  $directoryStructureObject  $item $workingDir  
    }

}

DirectoryTasks