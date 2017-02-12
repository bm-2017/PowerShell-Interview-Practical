Function Get-WebPage ($webpageUrl) {
    try {
         return Invoke-WebRequest -Uri $webpageUrl    
    }
    Catch     {
        Write-Output "Unable to access the webpage. `nException: $uri, $_.Exception.Response.Statuscode"    
        throw  Exception
    }
}


Function GetStringCount($webResponse, $findString) {
    $matches = [regex]::Matches($webResponse.ParsedHtml.body.innerText, $findString).Count
    return $matches
}

Function GetDomainLinks($domainLinks, $htmlFile) {

    $style = "<style>"
    $style = $style + "BODY{background-color:#dddddd;}"
    $style = $style + "TABLE{border-width: 1px;border-style: solid;border-color: black;border-collapse: collapse;}"
    $style = $style + "TH{text-align:center;width:140px; border-width: 1px;padding: 0px;border-style: solid;border-color: black;background-color:thistle}"
    $style = $style + "TD{text-align:center;border-width: 1px;padding: 0px;border-style: solid;border-color: black;background-color:palegoldenrod}"
    $style = $style + "</style>"

    $Links = $domainLinks | Select-Object OuterHTML | ConvertTo-Html -Head $style 

    Add-Type -AssemblyName System.Web
    [System.Web.HttpUtility]::HtmlDecode($Links) | Out-File $htmlFile

}


Function WebpageTasks {
    $url = "https://en.wikipedia.org/wiki/PowerShell"
    $findString = "PowerShell"
    $findDomain = "microsoft.com"
    $htmlOutFile = "MSLinks.html"

    $webResponse = Get-WebPage($url)    
    $strCount = GetStringCount $webResponse $findString

    Write-Output "The number of times the word '$findString' is found in the page $url : $strCount" 

    $domainLinks = $webResponse.Links | Where-Object href -Match $findDomain
    GetDomainLinks $domainLinks $htmlOutFile
}


#WebpageTasks