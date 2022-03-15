public class SendEnvelopeWithReminderController {
    public static void sendEnvelopeMethod(){
        Id mySourceId = '0XXXXXXXXXXXXXXXXE'; // The ID of the initiating Salesforce object.

        // Set up notification
        dfsle.Notifications notifySigner = new dfsle.Notifications(
            true, // Indicates that the recipient should be reminded to sign
            2, // Number of days to wait before sending a reminder
            1, // Number of days between reminders
            true, // Whether or not the envelope expires and is voided
            90, // How many days before the envelope expires
            10, // Number of days before expiration to remind the recipient
            false // Placeholder for deprecated field
        );
        
		// Create an empty envelope.
		dfsle.Envelope myEnvelope = dfsle.EnvelopeService.getEmptyEnvelope(
    	new dfsle.Entity(mySourceId));
 		// The initiating Salesforce entity.
		
        // We will use a Salesforce contact record as a Recipient here
		// We will use a Salesforce contact record as a Recipient here
		Contact myContact = [SELECT Id, Name, Email FROM Contact WHERE Id = '00xxxxxxxxxxxxxxAR'];

		// Use the Recipient.fromSource method to create the Recipient
		dfsle.Recipient myRecipient = dfsle.Recipient.fromSource(
            myContact.Name, // Recipient name
            myContact.Email, // Recipient email
            null, // Optional phone number
            'Signer 1', // Role Name. Specify the exact role name from template
            new dfsle.Entity(myContact.Id)); // Source object for the Recipient

		// Add Recipient to the Envelope
		myEnvelope = myEnvelope.withRecipients(new List<dfsle.Recipient> { myRecipient });
        
        // myTemplateId contains the DocuSign Id of the DocuSign Template
		dfsle.UUID myTemplateId = dfsle.UUID.parse('8dafxxxx-xxxx-xxxx-xxxx-xxxxxxxx27f7');

		// Create a new document for the Envelope
		dfsle.Document myDocument = dfsle.Document.fromTemplate(
    		myTemplateId, // templateId in dfsle.UUID format
    		'myTemplate'); // name of the template

		// Add document to the Envelope
		myEnvelope = myEnvelope.withDocuments(new List<dfsle.Document> { myDocument });
        // Add notification to the envelope
        myEnvelope = myEnvelope.withNotifications(notifySigner);
        
        // Send the envelope
		myEnvelope = dfsle.EnvelopeService.sendEnvelope(
    		myEnvelope, // The envelope to send
    		true); // Indicates that the envelope should be sent now
    }
}
