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
Class RedditDate {
    [double]$Unix
    [DateTime]$Date
    static [DateTime]$UnixEpoch = '1970/1/1'
    RedditDate () { }
    RedditDate ([String]$String) {
        $This.Unix = $String
        $This.date = [RedditDate]::UnixEpoch.AddSeconds($This.Unix)
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
