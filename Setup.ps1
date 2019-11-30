# Variables
$organization = "https://dev.azure.com/wendelin"
$project = "engage2019"
$servicePrincipalId = "e41a3a91-45b4-4bf7-ae65-c98755c345ca"
$subscriptionId = "10b3c05a-71e7-4408-9130-fe16d0d569de"
$subscriptionName = "Visual Studio Enterprise - MPN"
$tenantId = "bebdf4c5-1357-4a2a-bc6e-85a882be76ae"

## Setup Solution
$repositoryName = "Engage2019.Pipelines"
dotnet new sln -n $repositoryName --force
dotnet new func --name "$repositoryName" -o "./$repositoryName" -A v2 --force
dotnet new http -na "$repositoryName.GetServiceInfo" -A Anonymous -n GetServiceInfo -o "./$repositoryName/GetServiceInfo" --force

# Create Test Function
dotnet new mstest --name "$repositoryName.UnitTests" -o "./$repositoryName.UnitTests" --force

# Fill Solution
dotnet sln "$repositoryName.sln" add "./$repositoryName/$repositoryName.csproj"
dotnet sln "$repositoryName.sln" add "./$repositoryName.UnitTests/$repositoryName.UnitTests.csproj"

## Create Project
az devops project create --name $project --organization $organization --open
$repository = az repos create --name $repositoryName --project $project --organization $organization | ConvertFrom-Json

## Add changes
git remote add devops $repository.remoteUrl
git add .
git commit -m "Initialize Repository"

git push devops master

# Create Service Connection
$serviceConnectionResult = az devops service-endpoint azurerm create --azure-rm-service-principal-id $servicePrincipalId `
                                                                     --azure-rm-subscription-id $subscriptionId `
                                                                     --azure-rm-subscription-name $subscriptionName `
                                                                     --azure-rm-tenant-id $tenantId `
                                                                     --name AzureRM `
                                                                     --project $project `
                                                                     --organization $organization `

$serviceConnection = $serviceConnectionResult | ConvertFrom-Json
Write-Host $serviceConnection

## Create Pipeline
az pipelines create --name engage2019-pipeline `
                    --repository $repositoryName `
                    --repository-type tfsgit `
                    --yaml-path azure-pipelines.yml `
                    --branch master `
                    --organization $organization `
                    --project $project `
                    --service-connection $serviceConnection.id