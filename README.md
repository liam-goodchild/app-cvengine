## CVEngine – Git-Controlled Online CV

This is a lightweight solution for hosting an online CV using Azure Static Web Apps, Azure-managed Functions, and CosmosDB.

I built this because I wanted a simple, version-controlled way to keep my CV online without relying on third-party builders or manual uploads. Everything is deployed automatically from Git, making it easy to update and maintain.

### How It Works

- The CV lives in GitHub and is deployed to an Azure Static Web App.

- A CosmosDB database tracks visitor counts.

- An Azure-managed Function updates and retrieves the count on page load.

- A CNAME record is created, mapping the Static Web App name to a custom domain.

- All resources are defined in Bicep for consistent, repeatable deployment.

### Features

- Online CV that updates with each Git commit

- Built-in visitor counter

- Fully serverless – no VMs or heavy frameworks

- Deployable end-to-end with Bicep

- Easy to extend for new functionality

### Why Use This?

- No reliance on third-party CV platforms

- Runs entirely on Azure PaaS services

- Clean, minimal setup that’s easy to maintain

- Everything under source control

This was designed to do one thing well: keep a CV online, versioned, and automatically updated with minimal overhead.
