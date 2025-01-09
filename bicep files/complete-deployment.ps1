# Define the list of PowerShell scripts in order
$scripts = @(
    "C:\Users\lgoodchild-a\Documents\Cloud Resume Challenge v2\bicep files\frontend deployment\storage account\initial-storage-account-deployment.ps1",
    "C:\Users\lgoodchild-a\Documents\Cloud Resume Challenge v2\bicep files\frontend deployment\content delivery network\initial-cdn-deployment.ps1",
    "C:\Users\lgoodchild-a\Documents\Cloud Resume Challenge v2\bicep files\backend deployment\cosmosdb\initial-cosmosdb-deployment.ps1"
    "C:\Users\lgoodchild-a\Documents\Cloud Resume Challenge v2\bicep files\backend deployment\function\initial-function-deployment.ps1"
)

# Loop through each script and execute it
foreach ($script in $scripts) {
    if (Test-Path $script) {
        Write-Host "Running script: $script" -ForegroundColor Green
        try {
            & $script
            Write-Host "Successfully executed $script" -ForegroundColor Cyan
        } catch {
            Write-Host "Error executing $script : $_" -ForegroundColor Red
        }
    } else {
        Write-Host "Script not found: $script" -ForegroundColor Yellow
    }
}
