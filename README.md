# San Marcos GIS in Azure

## To contribute to this repo:

Pipeline is organized as a multistaged deployment with nested folder structure matching the name of each Stage. 

root
├─ modules/
│  ├─ cosm/
│  ├─ gis/
├─ stages/
│  ├─ db/
│  │  ├─ main.bicep
│  │  ├─ parameters.json
│  ├─ nsg/
│  │  ├─ main.bicep
│  │  ├─ parameters.json
│  ├─ vm/
│  │  ├─ main.bicep
│  │  ├─ parameters.json
│  ├─ vnet/
│  │  ├─ main.bicep
│  │  ├─ parameters.json
│  ├─ package.json
│  ├─ README.md
├─ azurepipelines.yaml

### Clone the repo

1. Browse to: https://dev.azure.com/sanmarcosgov/GIS/_git/cosm-gis-azure
1. Click the Clone button
1. Copy clone URL to clipboard
1. In your repos folder, create a "gis" folder
1. In the "gis" folder, run: `git clone <clone URL>`

### Create local branch

1. Create a local development or feature branch

### Commit local branch

### Create pull request
