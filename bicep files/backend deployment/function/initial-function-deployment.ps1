$rgName = "rg-resume-prod-uks-001"
$functionName = "func-resume-prod-uks-001"

# Deploying the bicep file to the resource group using the parameters file.
az deployment group create -g $rgName -f "C:\Users\lgoodchild-a\Documents\Cloud Resume Challenge v2\bicep files\backend deployment\function\function.bicep" -p "C:\Users\lgoodchild-a\Documents\Cloud Resume Challenge v2\bicep files\backend deployment\function\function-parameters.json"

# Enable CORS, allowing the JavaScript in the website to call the URL of the function.
az functionapp cors add -g $rgName -n $functionName --allowed-origins https://portfolio.skyhaven.ltd

# Zip the "C:\Users\lgoodchild-a\Documents\Cloud Resume Challenge v2\githubrepo\backend\api" folder that was cloned locally from the repo. This will be used in the next command.
Compress-Archive -Path "C:\Users\lgoodchild-a\Documents\Cloud Resume Challenge v2\githubrepo\code files\backend code\*" -DestinationPath "C:\Users\lgoodchild-a\Documents\Cloud Resume Challenge v2\bicep files\backend deployment\function\functionapp.zip"

# Deploy the code to the function app.
az functionapp deployment source config-zip -g $rgName -n $functionName --src "C:\Users\lgoodchild-a\Documents\Cloud Resume Challenge v2\bicep files\backend deployment\function\functionapp.zip"