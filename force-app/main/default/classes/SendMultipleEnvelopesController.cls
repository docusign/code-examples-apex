public with sharing class SendMultipleEnvelopesController {
    public static void SendMultipleEnvelopes() {
        // Get up to 99 contacts in the "Prepared" offer stage
        List<Contact> contacts = [SELECT Id, Name FROM Contact WHERE OfferStage__c = 'Prepared' LIMIT 99];

        // Build a list of offer envelopes to send
        List<dfsle.Envelope> envelopes = new List<dfsle.Envelope>();
        for (Contact c : contacts) {
            // Get an empty envelope with org defaults
            envelopes.add(dfsle.EnvelopeService.getEmptyEnvelope(new dfsle.Entity(c.Id))
                // Customize the email subject and message
                .withEmail('Offer Letter for ' + c.Name, c.Name + ', please review and sign the enclosed offer letter.')
                // Add linked offer letter to envelope
                .withDocuments(dfsle.DocumentService.getLinkedDocuments(
                    ContentVersion.getSObjectType(),
                    new Set<Id> { c.Id },
                    true))
                // Add the contact as a recipient
                .withRecipients(dfsle.RecipientService.getRecipients(
                    Contact.getSObjectType(), 
                    new Set<Id> { c.Id })));
        }

        // Send the envelopes and determine which envelopes were sent successfully
        // Filter out unsuccessfully sent envelopes
        List<Contact> contactsToUpdate = new List<Contact>();
        List<dfsle.Envelope> sentEnvelopes = new List<dfsle.Envelope>();
        for (dfsle.Envelope envelope : dfsle.EnvelopeService.sendEnvelopes(envelopes)) {
            if (envelope.error == null) {
                // Envelope sent successfully
                sentEnvelopes.add(envelope);
                contactsToUpdate.add(new Contact(
                Id = envelope.source.id,
                OfferStage__c = 'Out for Signature'));
            } else {
                // Handle send error
                System.debug('Envelope error: ' + envelope.error);
            } 
        }

        // Update the Contact offer stage to "Out for Signature"
        update contactsToUpdate;    
        
        List<dfsle.Envelope> savedEnvelopes = dfsle.EnvelopeService.saveSentEnvelopes(sentEnvelopes);

    // Build a list of Contact IDs to query
    Set<Id> contactIds = new Set<Id>();
    for (dfsle.Envelope envelope : savedEnvelopes) {
        contactIds.add(envelope.source.id);
    }

    // Retrieve the most recent envelope statuses from the Salesforce source objects
    // The status results are sorted oldest to newest
    List<dfsle.Envelope.Status> statuses = dfsle.StatusService.getStatus(
        contactIds, // Envelope source object IDs
        99); // Maximum number of records to return

    // Display or take action on the returned statuses        
    }

}
