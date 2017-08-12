# RedditDate
## about_RedditDate

# SHORT DESCRIPTION
Describes the RedditDate Class

# LONG DESCRIPTION
Reddit uses Unix Epoch dates in a Double. The `RedditDate` class provides easy translation between a Unix date and a `DateTime` object. This object does not automatically update after it is initialized.

The `RedditDate` class is imported automatically when you import the PSRAW module.

# Constructors
## RedditDate()
Creates a `RedditDate` at the Unix Epoch.

```powershell
[RedditDate]::new()
```

## RedditDate(DateTime Date)
Creates a `RedditDate` from a `DateTime` object.

```powershell
[RedditDate]::new([DateTime]$Date)
```

## RedditDate(Double Double)
Creates a `RedditDate` from a `Double`

```powershell
[RedditDate]::new([Double]$Double)
```

## RedditDate(String String)
Creates a `RedditDate` from a parsable `Double` or `DateTime` `String`.

```powershell
[RedditDate]::new([String]$String)
```


# Properties
## Date
The `DateTime` of the `RedditDate`

```yaml
Name: Date
Type: DateTime
Hidden: False
Static: False
```

## Unix
The Unix Timestamp in seconds.

```yaml
Name: Unix
Type: Double
Hidden: False
Static: False
```

## UnixEpoch
The Unix Epoch time used in creating the `RedditDate`

```yaml
Name: UnixEpoch
Type: DateTime
Hidden: False
Static: True
```


# Methods

# EXAMPLES
```powershell
$Date = [dateTime]'7/27/2017'
[RedditDate]::New($Date)
[RedditDate]::New(1501113600)
[RedditDate]::New('7/27/2017')
[RedditDate]::New('1501113600')
$UnixDate = ([RedditDate]$Date).Unix
$UnixDate = ([RedditDate]'7/27/2017').Unix
$DateTime = ([RedditDate]1501113600).Date
$DateTime = ([RedditDate]'1501113600').Date
```

# SEE ALSO

[about_RedditDate](https://psraw.readthedocs.io/en/latest/Module/about_RedditDate)

[https://psraw.readthedocs.io/](https://psraw.readthedocs.io/)