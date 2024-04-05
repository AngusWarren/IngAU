function Invoke-IngApi {
    [CmdletBinding(SupportsShouldProcess)]
    param(
        [Parameter(Mandatory)]
        [String]
        $Endpoint,

        # used to construct a query string. e.g. @{type="device"} would be appended to the URI as ?type=device
        [Collections.IDictionary]
        $Query = @{},

        # Body of the request. Strings are passed through as-is, any other object will be converted to JSON.
        [Object]
        $Body,

        [ValidateSet('GET', 'POST')]
        [String]
        $Method = 'POST',

        # Returns the raw web request object
        [Switch]
        $WebRequest
    )

    begin {
        $ctx = Get-IngContext
    }

    process {
        $uri = $ctx.FullUri($Endpoint, $Query)
        $splat = @{
            WebSession = $ctx.Session
            Method = $Method
            Uri = $Uri
            ContentType = "application/json"
        }
        if ($null -ne $Body) {
            if ($Body -is [String]) {
                $splat['Body'] = $Body
            } else {
                $splat['Body'] = ConvertTo-Json -Depth 10 -Compress -InputObject $body
            }
        }

        $splat['Headers'] = @{
            'x-AuthToken' = $ctx.AccessTokenPlain()
            'x-MessageSignature' = ConvertTo-SignedString -Rsa $ctx.Rsa -Message (
                "X-AuthToken:$( $ctx.AccessTokenPlain() )$( $splat['Body'] )"
            )
        }
        if ($PSCmdlet.ShouldProcess($uri, "$Method")) {
            if ($WebRequest) {
                Invoke-WebRequest -UseBasicParsing @splat
            } else {
                Invoke-RestMethod @splat
            }
        }
        if ($ctx.TokenExpiry -lt (Get-Date).AddSeconds(300)) {
            Update-IngToken
        }
    }
}
