<#	
    .NOTES
    
     Created with: 	Plaster
     Created on:   	6/1/2017 2:38 PM
     Edited on:     6/1/2017
     Created by:   	Mark Kraus
     Organization: 	 
     Filename:     	006-RedditDate.ps1
    
    .DESCRIPTION
        RedditDate Class
#>
[Diagnostics.CodeAnalysis.SuppressMessageAttribute(
    "PSAvoidUsingEmptyCatchBlock", 
    "", 
    Justification = "Exception handled through presence of boolean test."
)]
Class RedditDate {
    [double]$Unix = 0
    [DateTime]$Date = '1970/1/1'
    static [DateTime]$UnixEpoch = '1970/1/1'
    RedditDate () { }
    RedditDate ([String]$String) {
        $Set = $false
        try {
            $This.Unix = [double]::Parse($string)
            $This.date = [RedditDate]::UnixEpoch.AddSeconds($This.Unix)
            $Set = $true
        }
        catch { }
        Try {
            $ParsedDate = [dateTime]::Parse($string)
            $Difference = $ParsedDate - [RedditDate]::UnixEpoch
            $This.Date = $ParsedDate
            $This.Unix = $Difference.TotalSeconds
            $Set = $true
        }
        catch { }
        if (-not $Set) {
            $Exception = [System.ArgumentException]::new(
                'Unable to parse string as System.DateTime or System.Double.'
            )
            throw $Exception
        }
    }
    RedditDate ([Double]$Double) {
        $This.Unix = $Double
        $This.date = [RedditDate]::UnixEpoch.AddSeconds($This.Unix)
    }
    RedditDate ([DateTime]$Date) { 
        $Difference = $Date - [RedditDate]::UnixEpoch
        $This.Date = $Date
        $This.Unix = $Difference.TotalSeconds
    }
}
