public class SendEnvelope {

    public static void sendEnvelopeMethod(){
        Id mySourceId; // The ID of the initiating Salesforce object
        String templateId; // The ID of the DocuSign template

        // Create an empty envelope
        dfsle.Envelope myEnvelope = dfsle.EnvelopeService.getEmptyEnvelope(
        new dfsle.Entity(mySourceId));
        // The initiating Salesforce entity

        // Use myEnvelope for later 
        // We will use a Salesforce contact record as a Recipient here
        Contact myContact = [SELECT Id, Name, Email FROM Contact LIMIT 1];

        //use the Recipient.fromSource method to create the Recipient
        dfsle.Recipient myRecipient = dfsle.Recipient.fromSource(
            myContact.Name, // Recipient name
            myContact.Email, // Recipient email
            null, // Optional phone number
            'Signer 1', // Role Name. Specify the exact role name from template
            new dfsle.Entity(myContact.Id)); // Source object for the recipient

        // Add a recipient to the envelope
        myEnvelope = myEnvelope.withRecipients(new List<dfsle.Recipient> { myRecipient });

        // myTemplateId contains the DocuSign Id of the DocuSign Template
        dfsle.UUID myTemplateId = dfsle.UUID.parse(templateId);

        // create a new document for the Envelope
        dfsle.Document myDocument = dfsle.Document.fromTemplate(
            myTemplateId, // Template Id in dfsle.UUID format
            'myTemplate'); // Name of the template

        //add document to the envelope
        myEnvelope = myEnvelope.withDocuments(new List<dfsle.Document> { myDocument });

        // Send the envelope
        myEnvelope = dfsle.EnvelopeService.sendEnvelope(
            myEnvelope, // The envelope to send
            true); // True to send the envelope now
    }
}