# Bicep - Performance analysis and comparison of Infrastructure as Code (IaC) Tools

The lab environment used for this research was built by following the best practices towards having a practical workbench that would allow the benchmark tests to be conducted in consideration of an impartial implementation, avoiding noise by external factors like variations in the network bandwidth external to the cloud platform, the use of a single command line interface for both implementation and the definition of the very same cloud services with the very same configurations.

## Pre-requisites

If you're using Azure Cloud Shell, Bicep is already installed by default. In case you want to execute the commands from your local CLI tool (bash, Windows CMD), you have to install the Azure CLI as a first step.

* [Azure CLI - installation](https://docs.microsoft.com/en-us/cli/azure/install-azure-cli)

Check the Azure CLI installation:

```powershell

az version

```

If you're using a local installation on your own workstation, remember that you also have to be logged in to Azure.
Otherwise, if you're  using Azure Cloud Shell you can proceed to the next topic.

```powershell

az login

```


## Test workbench
A representation of our benchmark workbench is below. Visual Studio Code was used to implement the Bicep scripts. Then Azure Cloud Shell was used to execute the scripts.
<p align="center">
  <img alt ="Test workbench" width="275" height="175" src="/media/test-workbench.png">
</p>

## Azure cloud services
The following Azure cloud services have been specified and the respective scripts for Bicep have been implemented:

* Azure Application Insights (part of Azure Monitor)
* Azure Spring Apps – runtime environment for Java workloads, Kubernetes-based
* Azure Database for MySQL single server
* Azure Blob Storage

Azure Spring Cloud runtime, one Azure storage account, one MySQL server, and one Azure App Insights component was used for all the scenarios with both IaC tools. The services for Biceps are below. 

<p align="center">
  <img alt ="Azure Services – Bicep definitions" src="/media/azure-services-biceps-definitions.png">
</p>

## Command line interface
The executions were controlled and timed with Powershell and the Measure-Command cmdlet. A cmdlet is a lightweight command used in the PowerShell environment. Such strategy also provided an impartial way of starting the execution scripts for Bicep.

<p align="center">
  <img alt ="Azure Services – Bicep definitions" src="/media/lyit-perf-bcp-RUNNING.png">
</p>

## Bicep scripts
Bicep modules were used to promote isolation, reusability, and modularity. Below we have the scripts for each Azure cloud service as implemented.

### Main Bicep project files
The following Bicep scripts were created for the main Bicep project:
* main.bicep

### Azure Application Insights
The following Bicep scripts were created for Azure Application Insights:
* app-insights.bicep


### MySQL database
The following Bicep scripts were created for MySQL:
* mysql.bicep


### Azure Spring Cloud
The following Bicep scripts were created for Azure Spring Cloud:
* spring-cloud.bicep

### Azure Storage
The following Bicep scripts were created for Azure Storage Blob:
* storage.bicep

The benchmarks considered a warm-up run to make sure that internally the components would be ready as expected, and then a test harness with 40 executions for each implemented was executed. 

## Architectural representation - Bicep

An architectural representation was created as seen below for Bicep as well. To create the diagram, Visual Studio Code and the respective extension for Bicep can be used. 

<p align="center">
  <img alt ="Bicep - Architectural representation" src="/media/lyit-perf-bcp-DIAGRAM.png">
</p>


## Tests and metrics - Bicep

To execute the deployment scripts for Bicep, it is required to access the Azure Portal, then start a session with the Azure Cloud Shell. Select the option to use Powershell instead of the standard bash option as shown below.

<p align="center">
  <img alt ="Bicep - Architectural representation" src="/media/azure-portal-powershell.png">
</p>

Then create an empty directory, and then clone the respective GitHub repository:

```powershell

mkdir lyit-perf-bcp
cd lyit-perf-bcp
git clone https://github.com/L00162879/lyit-perf-bcp.git

```

Note that when you're using Azure Cloud Shell, you're already logged in. In case you want to execute the commands from your local CLI tool (bash, Windows CMD), remember to login in first:

```powershell

az login


```


After that, it is possible to start the benchmark tests. They will be timed with the support of a cmdlet provided by Powershell called Measure-Command as shown below. So, the next step is to start the provisioning of the desired Azure services:

```powershell

Measure-Command { az deployment sub create --name 'lyit-perf-bcpdev' --location westeurope --template-file main.bicep }

```

As soon as the execution completes, a message is shown as below. You can then extract the metrics to compose the benchmark analysis:

<p align="center">
  <img alt ="Bicep - Architectural representation" src="/media/lyit-perf-bcp-SUCCESS.png">
</p>

After many runs, you can aggregate and analyse the results as required. A sample Excel spreadsheet is below along
with a couple of charts.

<p align="center">
  <img alt ="Bicep - Architectural representation" src="/media/bicep-SAMPLES.png">
</p>

<p align="center">
  <img alt ="Bicep - Architectural representation" src="/media/bicep-CHART-1.png">
</p>

<p align="center">
  <img alt ="Bicep - Architectural representation" src="/media/bicep-CHART-2.png">
</p>
