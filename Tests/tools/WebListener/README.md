# WebListener App

ASP.NET Core 2.0 app for testing HTTP Requests. The default page will return a list of available tests.

# Run with `dotnet`

```
dotnet restore
dotnet publish --output bin --configuration Release
cd bin
dotnet WebListener.dll 8080
```

The test site can then be accessed via `http://localhost:8080/` 

The `WebListener.dll` takes 1 arguments: 

* The TCP Port to bind on for HTTP

# Run With WebListener Module

```powershell
. .\BuildTools\build.ps1 -Task BuildTestTools
$Listener = Start-WebListener -HttpPort 8080
```
