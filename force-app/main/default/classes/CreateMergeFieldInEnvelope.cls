//ds-snippet-start:Apex10Step1
public with sharing class CreateMergeFieldInEnvelope {
    
    @AuraEnabled
    public static void sendEnvelope() {
//ds-snippet-end:Apex10Step1

        //ds-snippet-start:Apex10Step2
        Id mySourceId = '00XXXXXXXXXXXXXXAM'; // The ID of the initiating Salesforce Opportunity

        // Create an empty envelope
        dfsle.Envelope myEnvelope = dfsle.EnvelopeService.getEmptyEnvelope(
        new dfsle.Entity(mySourceId));
        // The initiating Salesforce entity
        
        // Add document to the envelope
        Id myDocumentId = '00XXXXXXXXXXXXXXA4'; // The ID of a document stored in a Salesforce library
        Id myFileId = [SELECT id from ContentVersion where ContentDocumentId = :myDocumentId LIMIT 1].id;
        myEnvelope = myEnvelope.withDocuments(dfsle.DocumentService.getDocuments(ContentVersion.getSObjectType(), new Set<Id> { myFileId }));
        //ds-snippet-end:Apex10Step2
        
        //ds-snippet-start:Apex10Step3
        //Define a merge field
        //This field will be associated with the initiating source object represented by mySourceId
		dfsle.Tab.MergeField myMergeField = new dfsle.Tab.MergeField (
            'opportunity.name', //The data that this merge field will pull its value from
            null, //N/A
            null, //N/A
            true, //Allows writeback to the Salesforce object
            false //Whether or not the field is read only for the sender
        );

		//Create a text tab that will be mapped to the merge field        
		dfsle.Tab myTextTab = new dfsle.TextTab()
    	    .withMergeField(myMergeField) //Associate this tab with the mergeField
    		.withReadOnly(false) //true = read only or locked
    		.withPosition(new dfsle.Tab.Position(1, 1, 200, 300, null, null))    
    		.withDataLabel('Contact Name');
        //ds-snippet-end:Apex10Step3


        //ds-snippet-start:Apex10Step4
        // Create a new recipient
        Id myContactId = '00XXXXXXXXXXXXXXA4';
        Contact myContact = [SELECT Id, Name, Email FROM Contact WHERE Id = :myContactId];

        dfsle.Recipient myRecipient = dfsle.Recipient.fromSource(
            myContact.Name, // Signer name
            myContact.Email, // Signer email
            null, // Signer phone number
            null, // Template role n/a
            null) // No Salesforce association
            .withTabs(new List<dfsle.Tab> { // Associate the tabs with this recipient
                myTextTab
            });

        // Add recipient to the envelope
        myEnvelope = myEnvelope.withRecipients(new List<dfsle.Recipient> { myRecipient });
        //ds-snippet-end:Apex10Step4

        //ds-snippet-start:Apex10Step5
        // Send the envelope
        myEnvelope = dfsle.EnvelopeService.sendEnvelope(
            myEnvelope, // The envelope to send
            true); // Send now?
        //ds-snippet-end:Apex10Step5

//ds-snippet-start:Apex10Step1
    }
}
//ds-snippet-end:Apex10Step1