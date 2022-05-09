public class InPersonSigningController {
     public static Id sendWithInPerson(){
        
        //Get the Salesforce account ID
        Opportunity myOpportunity = [SELECT Id FROM Opportunity WHERE Name = 'My Opportunity' LIMIT 1];
        // Create an empty envelope with Opportunity Id as the source Id
        dfsle.Envelope myEnvelope = dfsle.EnvelopeService.getEmptyEnvelope(new dfsle.Entity(myOpportunity.Id));
        //Find your contact to add
       
        dfsle.Recipient InPerson = new dfsle.Recipient(
            null, //Source Id
            'inPersonSigner',//Type of recipient
            1, //Sequence
            2, //routing order
            new dfsle.Recipient.Role('Customer',null), //role -used to match role
            //on template if using a template
            'InPerson Signer', //inPerson Recipient name
            'example@example.com', //inPerson Recipient Email
            null, //signing group
            null, //phone
            //Don't need recipient auth for embedded in SF cause you have SF auth
            //new dfsle.Recipient.Authentication(null, true, new List<String>{'147852369'}),//Authentication - may need to adjust this - can be null
            null,//no Authentication
            null, //note
            null, //EmailSettings
            'Host Name', //host name This is the name of the host for InPerson
            'host@example.com', //host email email of host
            true, //sign now
            null, //source
            false, //read only
            false); //required
            // add Recipient to the Envelope
            myEnvelope = myEnvelope.withRecipients(new List<dfsle.Recipient> { InPerson });
            // myTemplateId contains the DocuSign Id of the DocuSign Template
            dfsle.UUID myTemplateId = dfsle.UUID.parse('801c741b-xxxx-xxxx-xxxx-23a050e0dd51'); 
            // Create a new document for the Envelope
            dfsle.Document myDocument = dfsle.Document.fromTemplate(
                myTemplateId, // templateId in dfsle.UUID format
                'myTemplate'); // Name of the template
        
            myEnvelope = myEnvelope.withDocuments(new List<dfsle.Document> { myDocument });
        
            // Send the envelope
            myEnvelope = dfsle.EnvelopeService.sendEnvelope(
                myEnvelope, // The envelope to send
                true); // Send or Draft
        
            System.debug(myEnvelope.Id);
            return myEnvelope.Id;
    }

}