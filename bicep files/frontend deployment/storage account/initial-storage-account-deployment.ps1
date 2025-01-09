# This script is complete and ready for produciton use. No further changes are needed.

# Creating the resource group.
az group create -l "uksouth" -n "rg-resume-prod-uks-001"

# Deploying the bicep file to the resource group using the parameters file.
az deployment group create -g "rg-resume-prod-uks-001" -f "C:\Users\lgoodchild-a\Documents\Cloud Resume Challenge v2\frontend\storage account\storage.bicep" -p "C:\Users\lgoodchild-a\Documents\Cloud Resume Challenge v2\frontend\storage account\storage-parameters.json"

# Setting the storage account context for the next command.
Set-AzCurrentStorageAccount -ResourceGroupName "rg-resume-prod-uks-001" -Name "stresumeproduks001"

# Enabling static websites on the storage account.
Enable-AzStorageStaticWebsite -IndexDocument "index.html"

# Cloning the repository to a specified directory.
git clone "https://github.com/liam-goodchild/Cloud-Resume-Challenge.git" "C:\Users\lgoodchild-a\Documents\Cloud Resume Challenge v2\githubrepo"

# Uploading the frontend files to the $web container.
az storage blob upload-batch -d `$web -s "C:\Users\lgoodchild-a\Documents\Cloud Resume Challenge v2\githubrepo\frontend" --account-name "stresumeproduks001"