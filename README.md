# deploy-cowrie-farm
* IaC deployment of Cowrie honeypots
* Console access via AWS' SSM:Connect
* Deploys "out of the box", standalone Cowrie instance

## (Manual) Deployment Testing
1. Run the SSH command contained within output *Cowris_HoneyPot_SSH*
    * Console should request interactive password
2. Connection logs should be seen in _/home/cowrie/cowrie/var/log/cowrie/cowrie.log_
    * or _cowrie.json_ if you prefer.