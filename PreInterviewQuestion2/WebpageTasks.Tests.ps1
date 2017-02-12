$here = Split-Path -Parent $MyInvocation.MyCommand.Path
$sut = (Split-Path -Leaf $MyInvocation.MyCommand.Path) -replace '\.Tests\.', '.'
. "$here\$sut"



Describe "GetStringCount" {

        Mock Get-WebPage {
            Return @{ParsedHtml = (Get-Content -Raw -Path "Mock_Wikipage_Parsed_Html.json" | ConvertFrom-Json).ParsedHtml}
        } -Verifiable

        $webpageObject = Get-WebPage

        $textMatch = "PowerShell" 
        $textNonMatch = "Bio-Mechanics" 
        $wordCount1 = GetStringCount $webpageObject $textMatch
        $wordCount2 = GetStringCount $webpageObject $textNonMatch

        Assert-MockCalled Get-WebPage 1

        It "counts the words PowerShell file" {
            $wordCount1 | Should be 267
        }    
        It "It counts the words PowerShell file" {
            $wordCount2 | Should be 0
        }
}

Describe "WebpageTasks" {

    Context "Webpage has no links" {
        Mock Get-WebPage {
            Return @{Links = (Get-Content -Raw -Path "Mock_Wikipage_NoLinks_File.json" | ConvertFrom-Json).Links}
        } -Verifiable

        It "generates a file with no links" {
            WebpageTasks
            Assert-MockCalled Get-WebPage 1

            "MSLinks.html" | Should Exist
            "MSLinks.html" | Should Not Contain "PowerShell and WPF: WTF"
        }

    }
    Context "Webpage includes many links" {
        Mock Get-WebPage {
            Return @{Links = (Get-Content -Raw -Path "Mock_Wikipage_Links_File.json" | ConvertFrom-Json).Links}
        } -Verifiable

        It "generates a file with links for search domain" {
            WebpageTasks
            Assert-MockCalled Get-WebPage 1

            "MSLinks.html" | Should Exist
            "MSLinks.html" | Should Contain "PowerShell and WPF: WTF"
        }
    }


}
