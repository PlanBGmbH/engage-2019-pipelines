# Variables
$organization = "https://dev.azure.com/wendelin"
$project = "engage2019"
$servicePrincipalId = "e41a3a91-45b4-4bf7-ae65-c98755c345ca"
$subscriptionId = "10b3c05a-71e7-4408-9130-fe16d0d569de"
$subscriptionName = "Visual Studio Enterprise - MPN"
$tenantId = "bebdf4c5-1357-4a2a-bc6e-85a882be76ae"

$serviceConnectionResult = az devops service-endpoint azurerm create --azure-rm-service-principal-id $servicePrincipalId `
                                                                     --azure-rm-subscription-id $subscriptionId `
                                                                     --azure-rm-subscription-name $subscriptionName `
                                                                     --azure-rm-tenant-id $tenantId `
                                                                     --name AzureRM `
                                                                     --project $project `
                                                                     --organization $organization `

$serviceConnectionResult