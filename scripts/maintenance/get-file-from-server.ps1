param (
    [Parameter(Mandatory=$true)]
    [string]
    $SERVER_FILE_PATH,
    [Parameter(Mandatory=$true)]
    [string]
    $LOCAL_FILE_PATH
)


scp cardano@core1.ada-cadabra.com:"/home/cardano/$SERVER_FILE_PATH" $LOCAL_FILE_PATH