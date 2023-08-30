//ds-snippet-start:Apex8Step1
public class TransformPDF {
    public static void sendEnvelope() {
//ds-snippet-end:Apex8Step1
        //ds-snippet-start:Apex8Step2
        Id mySourceId = '0034xxxxxxxxxx4QAE'; // The Salesforce Contact ID of the sender
        // Create an empty envelope.
        dfsle.Envelope myEnvelope = dfsle.EnvelopeService.getEmptyEnvelope(
        new dfsle.Entity(mySourceId)); 
		
        // We will use a Salesforce Contact ID as a Recipient here
        Contact myContact = [SELECT Id, Name, Email FROM Contact WHERE Id = '0034xxxxxxxxxxcQAG'];
        // Use the Recipient.fromSource method to create the Recipient
        dfsle.Recipient myRecipient = dfsle.Recipient.fromSource(
            myContact.Name, // Recipient name
            myContact.Email, // Recipient email
            null, //Optional phone number
            'Signer 1', //Role Name. Specify the exact role name from template
            new dfsle.Entity(myContact.Id)); 
        // Add Recipient to the Envelope
        myEnvelope = myEnvelope.withRecipients(new List<dfsle.Recipient> { myRecipient });
        //ds-snippet-end:Apex8Step2

        //ds-snippet-start:Apex8Step3
        Id myFileId = [SELECT id from ContentVersion where ContentDocumentId = '0694xxxxxxxxxxyQAD' LIMIT 1].id; // Content version ID of document to send
        dfsle.Document myDocument = dfsle.DocumentService.getDocuments(ContentVersion.getSObjectType(), new Set<Id> { myFileId }).get(0);
        myDocument.withPdfOptions(new dfsle.Document.PdfOptions(
            true, // Whether to transform PDF form fields
            1)); // The recipient for which to apply the tags
        
        //Add document to the Envelope
        myEnvelope = myEnvelope.withDocuments(new List<dfsle.Document> { myDocument });
        //ds-snippet-end:Apex8Step3

        //ds-snippet-start:Apex8Step4
        // Send the envelope
        myEnvelope = dfsle.EnvelopeService.sendEnvelope(
            myEnvelope, 
            true);
        //ds-snippet-end:Apex8Step4

//ds-snippet-start:Apex8Step1
    }
}
//ds-snippet-end:Apex8Step1