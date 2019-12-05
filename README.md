# engage2019-pipelines
A repository for collection resources for the Azure Multistage Pipelines

## Preparation
Make sure to run:
```   
code --install-extension ms-vscode.azurecli
code --install-extension ms-azure-devops.azure-pipelines
az extension add --name azure-devops
```

Get a service principal on your desired subscription and grab a client secret for the Azure DevOps Service Connection.


## Getting Started
1. Log in to Azure: az login
2. Run this script: .\Setup.ps1 -location westeurope
3. Enjoy!