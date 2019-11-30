# Variables
$organization = "https://dev.azure.com/wendelin"
$project = "engage2019"

## Setup Solution
$repositoryName = "Engage2019.Pipelines"
dotnet new sln -n Engage2019.Pipelines --force
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

## Create Pipeline
az pipelines create --name engage2019-pipeline --repository $repositoryName --repository-type tfsgit --yaml-path azure-pipelines.yml --branch master --organization $organization --project $project