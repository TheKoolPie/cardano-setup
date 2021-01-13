function copyPoolIdToClipboard() {
    var poolId = document.getElementById("pool-id-input");
    poolId.select();
    poolId.setSelectionRange(0, 99999); //for mobile devices
    var success = document.execCommand('copy');
    var message = success ? '[SUCCESS]: Copied pool id to clipboard' : '[ERROR]: Could not copy pool id'
    alert(message)
}