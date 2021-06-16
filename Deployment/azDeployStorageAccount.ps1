#Requires -Version 3.0
#Requires -Module Az.Resources
#Requires -Module Az.Storage

$deploymentScope = 'ResourceGroup'
$Location = 'westeurope'
$ResourceGroupName = 'rg-lp-testLab'

# Create the resource group only when it doesn't already exist - and only in RG scoped deployments
if ($deploymentScope -eq "ResourceGroup") {
    if ((Get-AzResourceGroup -Name $ResourceGroupName -Location $Location -Verbose -ErrorAction SilentlyContinue) -eq $null) {
        New-AzResourceGroup -Name $ResourceGroupName -Location $Location -Verbose -Force -ErrorAction Stop
    }
}

#Chech if storage account already exist
$StorageAccountName = 'azlpsatl'

$StorageAccount = (Get-AzStorageAccount | Where-Object { $_.StorageAccountName -eq $StorageAccountName })

# Create the storage account if it doesn't already exist
if ($StorageAccount -eq $null) {
    if ((Get-AzResourceGroup -Name $ResourceGroupName -Verbose -ErrorAction SilentlyContinue) -eq $null) {
        New-AzResourceGroup -Name $ResourceGroupName -Location $Location -Verbose -Force -ErrorAction Stop
    }
    $StorageAccount = New-AzResourceGroupDeployment -ResourceGroupName $ResourceGroupName -TemplateFile '../templates/azuredeploy.json' -TemplateParameterFile '../templates/azuredeploy.parameters.json'
}