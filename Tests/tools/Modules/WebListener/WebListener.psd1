@{
    ModuleVersion = '1.0.0'
    GUID = '90572e25-3f15-49b0-8f25-fb717d3ef46a'
    Author = 'Mark Kraus'
    Description = 'An HTTP Listener for testing purposes'
    RootModule = 'WebListener.psm1'
    FunctionsToExport = @(
        'Get-WebListener'
        'Get-WebListenerUrl'
        'Start-WebListener'
        'Stop-WebListener'
    )
}
