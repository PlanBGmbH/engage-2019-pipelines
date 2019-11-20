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

## Create Pipeline
az pipelines create --name engage2019-pipeline --repository DSpirit/engage2019-pipelines --repository-type github --yaml-path azure-pipelines.yml --branch master --organization https://dev.azure.com/wendelin --project dsdev --service-connection "849386f3-11ef-4659-ab84-4ec6538434622"

