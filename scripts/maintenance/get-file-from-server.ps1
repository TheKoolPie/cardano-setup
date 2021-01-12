$SERVER_FILE_PATH = Read-Host "Please enter path of remote file"
$LOCAL_FILE_PATH = Read-Host "Please enter local target path"

scp cardano@core1.ada-cadabra.com:$SERVER_FILE_PATH $LOCAL_FILE_PATH