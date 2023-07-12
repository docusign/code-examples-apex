public with sharing class CreateMergeFieldInEnvelope {
    public CreateMergeFieldInEnvelope() {
        Id mySourceId = '00XXXXXXXXXXXXXXAM'; // The ID of the initiating Salesforce Opportunity

        // Create an empty envelope
        dfsle.Envelope myEnvelope = dfsle.EnvelopeService.getEmptyEnvelope(
        new dfsle.Entity(mySourceId));
        // The initiating Salesforce entity
        
        Contact myContact = [SELECT Id, Name, Email FROM Contact WHERE Id = '00XXXXXXXXXXXXXXAB'];

        Id myDocumentId = '00XXXXXXXXXXXXXXA4'; // The ID of a document stored in a Salesforce library
        Id myFileId = [SELECT id from ContentVersion where ContentDocumentId = :myDocumentId LIMIT 1].id;
        
        // Add document to the envelope
        myEnvelope = myEnvelope.withDocuments(dfsle.DocumentService.getDocuments(ContentVersion.getSObjectType(), new Set<Id> { myFileId }));

        dfsle.Tab mySignHereTab = new dfsle.SignHereTab()
            .withScale(1.5) // 1.5 scale
            .withRequired(true) // Signing mandatory
            .withAnchor(new dfsle.Tab.Anchor(
                '/SignHere/', // Anchor string
                false, // Do not allow white space in anchor string
                false, // Anchor string is not case sensitive
                'right', // Horizontal alignment in relation to the anchor text
                true, // Ignore if the anchor text is not present in the document
                true, // Must match the value of the anchor string in its entirety
                'pixels', // Unit of the x and y offset properties
                20, // X offset
                0)); // Y offset
        
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
    		.withAnchor(new dfsle.Tab.Anchor('/MergeFieldHere/', true, true, null, true, true, 'pixels', 80, -5))    
    		.withDataLabel('Contact Name');


        // Create a new recipient
        dfsle.Recipient myRecipient = dfsle.Recipient.fromSource(
            myContact.Name, // Signer name
            myContact.Email, // Signer email
            null, // Signer phone number
            'Signer 1', // Signer role
            null) // No Salesforce association
            .withTabs(new List<dfsle.Tab> { // Associate the tabs with this recipient
                myTextTab,
                mySignHereTab
            });

        // Add recipient to the envelope
        myEnvelope = myEnvelope.withRecipients(new List<dfsle.Recipient> { myRecipient });

        // Send the envelope
        myEnvelope = dfsle.EnvelopeService.sendEnvelope(
            myEnvelope, // The envelope to send
            true); // Send now?

    }
}