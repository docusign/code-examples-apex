public class BulkSendWriteback {
   @AuraEnabled
   public static Id buildList(){
       
       List<dfsle.Envelope> myBulkCopies = new List<dfsle.Envelope>();  
       //SOQL is used to gather up the list of recipients to send to. In this case we get all contacts who have the bulk send checkbox set as true 
       for (Contact m : [SELECT Contact.FirstName, Contact.LastName, Contact.Email, Contact.Id FROM contact where contact.Bulk_Send__c = true LIMIT 5]) 
       {

           //To use merge fields and document writeback with bulk sending we have to add in the following custom fields. You first need to add them to your account under "Settings" -> "Envelope Custom Fields"
           // You need to create two envelope custom fields with the Field Name set as ##SFSource and ##SFDocumentWriteBack
           // https://developers.docusign.com/docs/salesforce/apex-toolkit-reference/customfield.html
           dfsle.CustomField sourceId = new dfsle.CustomField('text', '##SFSource', m.Id+'~Contact', null, false, true); // DocuSign custom field to capture Salesforce record Id. Replace ##SFSource with the name for your custom field
           dfsle.CustomField writeBackId = new dfsle.CustomField('text', '##SFDocumentWriteBack', m.Id+'~NamePDF~0~1', null, false, true); // DocuSign custom field to initiate document write back to Salesforce.
           
           //Create our recipients for the envelope
           myBulkCopies.add(dfsle.Envelope.newBulkCopy(
               dfsle.Recipient.newBulkRecipient(
                   m.FirstName + ' ' + m.LastName,
                   m.Email,
                   null) // Source Salesforce object
               //The role needs to match up exactly with the role on your template. 
               .withRole('Signer'))
               .withCustomFields(new List<dfsle.CustomField>{ sourceId, writeBackId })); // DocuSign Custom Fields
       }
       // Create the bulk list. This list persists after sending and may be reused for multiple batches of envelopes
       dfsle.BulkList myList = dfsle.BulkSendService.createLists(new List<dfsle.BulkList> {
           dfsle.BulkList.newList(
               'My bulk list', // List name
               myBulkCopies, // Envelope copies
               null) // The Salesforce source object
               })[0];
       // Save the ID for later operations
       Id myListId = myList.id;
       System.debug(LoggingLevel.INFO, myListId);
       return myListId;
       
   }	
   
   @future(callout=true)    
   /**
*  bulkSendEnvelopes method
*    Use myListId from buildList method
*    Assign myStatusId to the result of the BulkSendService call
*/
   public static void bulkSendEnvelopes(Id myListId){
       
       dfsle.UUID myTemplateId = dfsle.UUID.parse('3df1fb4c-xxxx-xxxx-xxxx-cdf3cb0fe6b1'); // Substitute with your template ID
       dfsle.Document myDocument = dfsle.Document.fromTemplate(
           myTemplateId, // templateId in dfsle.UUID format
           'myTemplate'); // name of the template
       
       // Create the draft bulk envelope. This will have exactly one placeholder bulk recipient
       dfsle.Envelope myEnvelope = dfsle.BulkSendService.getDraftEnvelope(
           new List<dfsle.Document> { myDocument },	null); // Optional Salesforce source entity
       
       // Send envelope with a placeholder bulk recipient
       dfsle.BulkList.Result myResult = dfsle.BulkSendService.sendEnvelope(myListId, myEnvelope);
       System.debug(myResult);
   }
   
}