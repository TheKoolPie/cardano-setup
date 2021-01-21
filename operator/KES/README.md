# Rotate pools KES keys
Updating the operational cert with a new KES period.

1. Create new KES key pair
    
    On block producer node run the script to create keys
    ```
    scripts/createKesKeyPair.sh
    ```

2. Copy **kes.vkey** from the block producer node to the **cold environment**.

3. Create a new **node.cert** file.
    
    ```
    scripts/createNodeCert.sh
    ```

4. Copy **node.cert** back to your block producer node. It has to be at the same location as the current certificate.

5. Restart node
    ```
    sudo systemctl restart cardano-node
    ```