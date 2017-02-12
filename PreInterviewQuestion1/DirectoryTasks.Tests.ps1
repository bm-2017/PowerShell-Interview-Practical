$here = Split-Path -Parent $MyInvocation.MyCommand.Path
$sut = (Split-Path -Leaf $MyInvocation.MyCommand.Path) -replace '\.Tests\.', '.'
. "$here\$sut"


Describe "DirectoryTasks" {
    param (
        $directoryStructureAsJsonFile = "testDirectories.json"
    )

    It "Creates all the folders" {
        DirectoryTasks 
        "Parent" | Should Exist
        ".\Parent\Child\GrandChild" | Should Exist 
        ".\Grandmother" | Should Exist 
        ".\Grandmother\Mother" | Should Exist 
        ".\Grandmother\Mother\Daughter" | Should Exist 
        ".\Grandmother\Mother\Daughter\GrandDaughter" | Should Exist 
    }

    It "Creates a random.txt in each folder" {
        DirectoryTasks 
        ".\Parent\random.txt" | Should Exist 
        ".\Parent\Child\random.txt" | Should Exist 
        ".\Parent\Child\Grandchild\random.txt" | Should Exist 
        ".\Grandmother\random.txt" | Should Exist 
        ".\Grandmother\Mother\random.txt" | Should Exist 
        ".\Grandmother\Mother\Daughter\random.txt" | Should Exist 
        ".\Grandmother\Mother\Daughter\GrandDaughter\random.txt" | Should Exist 
    }

    It "Writes a random number in the file" {
        $strNum = Get-Content ".\Parent\Child\random.txt"
        $value = [convert]::ToInt32($strNum, 10)
        $value | Should BeGreaterThan 7
        $value | Should BeLessThan 101
    }


}
