# azure-sql-data-warehouse-deployment

<a href="https://portal.azure.com/#create/Microsoft.Template/uri/https%3A%2F%2Fraw.githubusercontent.com%2Fjohnmanaloto%2Fazure-sql-data-warehouse-deployment%2Fmaster%2Fazuredeploy.json" target="_blank">
    <img src="http://azuredeploy.net/deploybutton.png"/>
</a>

Sample deployment of Azure SQL Data Warehouse and supporting services using ARM templates and PowerShell. Azure services include:

+ Azure SQL Server (auditing and threat detection enabled)
+ Azure SQL Data Warehouse (default of 100 DWU)
+ Azure SQL Database (V12, default of Basic service tier)
+ Azure Storage account (used for all storage needs within the resource group including auditing and VM storage)
+ automation account (empty)
+ Azure Data Factory (empty)
+ Azure VM (currently bare)

##### Deploy using PowerShell
The ARM template can be deployed as a link to github, or, as a local file on your machine. You can clone or download this repository to your local machine. Open a PowerShell session and execute the following commands:

```PowerShell
Login-AzureRmAccount
New-AzureRmResourceGroup -Name ExampleResourceGroup -Location "South Central US"
New-AzureRmResourceGroupDeployment -Name ExampleDeployment -ResourceGroupName ExampleResourceGroup `
  -TemplateFile filepath\azuredeploy.json -TemplateParameterFile filepath\azuredeploy.parameters.json
```
For more details, refer to [Deploy resources with Resource Manager templates and Azure PowerShell](https://docs.microsoft.com/en-us/azure/azure-resource-manager/resource-group-template-deploy)

##### Deploy using Visual Studio

##### Deploy using Visual Studio Team Services