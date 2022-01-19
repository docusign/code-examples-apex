public with sharing class SendEnvelopeFromTriggerController {
    public class EnvelopeSendResponse {
        public String message {get; private set;}
        public Boolean status {get; private set;}
            
        public EnvelopeSendResponse(final String message, final Boolean status){
            this.message = message;
            this.status = status;
        }
    }

    public static EnvelopeSendResponse sendEnvelope(final Id mySourceId) {
        EnvelopeSendResponse response;
        try {
                
        // Capture customer details
        Contact myCustomer = [SELECT Id, Name, Email FROM Contact WHERE Id =:mySourceId];
                
        // Create an empty envelope
        dfsle.Envelope myEnvelope = dfsle.EnvelopeService.getEmptyEnvelope
        (new dfsle.Entity(mySourceId));
                
        // Setup recipient data
        dfsle.Recipient myRecipient = dfsle.Recipient.fromSource
        (myCustomer.Name, myCustomer.Email, null, 'Signer 1', new dfsle.Entity(mySourceId));
                
                
        // Add Recipient to the Envelope
        myEnvelope = myEnvelope.withRecipients(new List<dfsle.Recipient> { myRecipient });
                
        // myTemplateId contains the DocuSign Id of the DocuSign Template
        dfsle.UUID myTemplateId = dfsle.UUID.parse('bf7ca600-XXXX-XXXX-XXXX-06e7f3b9e8ce');

        // Create a new document for the Envelope
        dfsle.Document myDocument = dfsle.Document.fromTemplate(
            myTemplateId, // templateId in dfsle.UUID format
            'myTemplate'); // The name of the template

        // Add document to the Envelope
        myEnvelope = myEnvelope.withDocuments(new List<dfsle.Document> { myDocument });
                
        // Send the envelope
        myEnvelope = dfsle.EnvelopeService.sendEnvelope(
            myEnvelope, // The envelope to send
            true); // Send now?
                
        response = new EnvelopeSendResponse('Envelope sent successfully', true);
        }
        catch(Exception ex) {
            response = new EnvelopeSendResponse(ex.getMessage(), false);
        }
        return response;     
    }
}