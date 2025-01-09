# Setting the variables
$ResourceGroup = "rg-resume-prod-uks-001"
$ProfileName = "cdnp-resume-prod-uks-001"
$EndpointName = "cdne-resume-prod-uks-001"
# It is very important the below variable correlates to the cdneDomain variable from the parameters file. This is not the actual FQDN. I wasted nearly 3 hours on this.
$CustomDomain = "portfolio-skyhaven"

# Setting the storage account context for the next command.
Set-AzCurrentStorageAccount -ResourceGroupName $ResourceGroup -Name "stresumeproduks001"

# Deploying the bicep file to the resource group using the parameters file.
az deployment group create -g $ResourceGroup -f "C:\Users\lgoodchild-a\Documents\Cloud Resume Challenge v2\bicep files\frontend deployment\content delivery network\cdn.bicep" -p "C:\Users\lgoodchild-a\Documents\Cloud Resume Challenge v2\bicep files\frontend deployment\content delivery network\cdn-parameters.json"

# Enable HTTPS on the newly created custom domain. 
az cdn custom-domain enable-https -g $ResourceGroup --profile-name $ProfileName --endpoint-name $EndpointName -n $CustomDomain