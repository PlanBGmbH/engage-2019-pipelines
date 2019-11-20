Param(
    [string]$location,
    [string]$name
)

$stage = $($env:SYSTEM_STAGENAME)

Write-Host "Creating infrastructure on stage $stage for application $name"

$group = (az group create --location $location --name "$name-$stage-$location") | ConvertFrom-Json
Write-Host "Created ResourceGroup $($group.Name)"
$storage = (az storage account create -n "$name$stage" -g $group.Name -l $location --sku Standard_LRS) | ConvertFrom-Json
Write-Host "Created Storage $($storage.Name)"
$app = az functionapp create --consumption-plan-location $location --name "$name-$stage-$location" --os-type Windows --resource-group $group.Name --runtime dotnet --storage-account $storage.Name 
Write-Host "Created Function $($app.Name)"