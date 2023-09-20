//ds-snippet-start:Apex1Step1
public class SendEnvelope {
    public static void sendEnvelopeMethod(){
//ds-snippet-end:Apex1Step1

        //ds-snippet-start:Apex1Step2
        Id mySourceId; // The ID of the initiating Salesforce object
        String templateId; // The ID of the DocuSign template

        // Create an empty envelope
        dfsle.Envelope myEnvelope = dfsle.EnvelopeService.getEmptyEnvelope(
        new dfsle.Entity(mySourceId));
        // The initiating Salesforce entity
        //ds-snippet-end:Apex1Step2

        //ds-snippet-start:Apex1Step3
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
        //ds-snippet-end:Apex1Step3

        //ds-snippet-start:Apex1Step4
        // myTemplateId contains the DocuSign Id of the DocuSign Template
        dfsle.UUID myTemplateId = dfsle.UUID.parse(templateId);

        // create a new document for the Envelope
        dfsle.Document myDocument = dfsle.Document.fromTemplate(
            myTemplateId, // Template Id in dfsle.UUID format
            'myTemplate'); // Name of the template

        //add document to the envelope
        myEnvelope = myEnvelope.withDocuments(new List<dfsle.Document> { myDocument });
        //ds-snippet-end:Apex1Step4

        //ds-snippet-start:Apex1Step5
        // Send the envelope
        myEnvelope = dfsle.EnvelopeService.sendEnvelope(
            myEnvelope, // The envelope to send
            true); // True to send the envelope now
        //ds-snippet-end:Apex1Step5
    //ds-snippet-start:Apex1Step1
    }
}
//ds-snippet-end:Apex1Step1