# Apex Toolkit Code Examples

### Github repo: https://github.com/docusign/code-examples-apex

This GitHub repo includes code examples for DocuSign's Apex Toolkit. The Apex Toolkit is a set of predefined Apex methods, classes, and utilities that encapsulate a set of the DocuSign eSignature API functionality similar to an SDK, enabling you to integrate DocuSign and Salesforce functionality into your Apex code.

## Installation

### Prerequisites

1. A free [DocuSign developer account](https://go.docusign.com/o/sandbox/); create one if you don't already have one.
1. A Salesforce Developer Edition (account).
1. [Install the Apex Toolkit](https://developers.docusign.com/docs/salesforce/how-to/apex-toolkit-install/). 
1. Visual Studio Code. Your Visual Studio Code should be set up with the necessary [Salesforce development tools](https://trailhead.salesforce.com/content/learn/projects/set-up-your-lightning-web-components-developer-tools/install-development-tools) including the [Salesforce CLI](https://developer.salesforce.com/tools/sfdxcli). 
1. The [Salesforce Extension Pack for Visual Studio Code](https://marketplace.visualstudio.com/items?itemName=salesforce.salesforcedx-vscode)

### Installation steps

1. Authorize your Salesforce Developer Account within Visual Studio Code. To do this press command + shift + P (on a Mac) or Ctrl + Shift + P (on Windows) to open the Command Palette. Then type SFDX:Authorize an Org and press Enter. In the browser window that opens, log into your Salesforce Developer Organization, then on
the next screen, click Allow to grant access.
1. Download or clone the **code-examples-apex** repo.
1. Replace any placeholder IDs from the example code with template IDs or other IDs corresponding with your DocuSign and Salesforce accounts. 
1. Deploy the code to Salesforce. To do this, navigate to the force-app/main/default folder in the menu on the left and right-click default, then select SFDX: Deploy Source to Org. Now when you sign into your Salesforce Developer Edition (account) you will find the clases and Lightning Web Components defined in this project.
