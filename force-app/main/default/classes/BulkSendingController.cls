public with sharing class BulkSendingController{

/**
 *  buildList Method
 *    Requires Chatter group ID
 *    Create a persistant list of group members
 *    Return an ID of the list
 */
@AuraEnabled

public static Id buildList(){

            Id myGroupId = '0FXXXXXXXXXXXXX0r'; // A Chatter group ID
            // Build a list membership from a Chatter group
            // Recipient authentication, email settings, or private notes may be overridden using the Recipient.with* methods
            // Envelope email settings and notifications may also be overridden per copy using the Envelope.with* methods
            
            List<dfsle.Envelope> myBulkCopies = new List<dfsle.Envelope>();
            for (CollaborationGroupMember m : [
                SELECT Member.Id, Member.Name, Member.Email
                FROM CollaborationGroupMember
                WHERE CollaborationGroupId = :myGroupId
            ]) {
                myBulkCopies.add(dfsle.Envelope.newBulkCopy(
                    dfsle.Recipient.newBulkRecipient(
                        m.Member.Name, // Name
                        m.Member.Email, // Email
                        new dfsle.Entity(m.Member.Id)))); // Source Salesforce object
            }
            
            // Create the bulk list. This list persists after sending and may be reused for multiple envelopes
            dfsle.BulkList myList = dfsle.BulkSendService.createLists(new List<dfsle.BulkList> {
                dfsle.BulkList.newList(
                    'My bulk list', // List name
                    myBulkCopies, // Envelope copies
                    new dfsle.Entity(myGroupId)) // The Salesforce source object
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
    

            Id myDocumentId = '06XXXXXXXXXXXXXAQ'; //The id of a document stored in a Salesforce library
    
            Id myFileId = [SELECT id from ContentVersion where ContentDocumentId = :myDocumentId LIMIT 1].id; // Content version ID of document to send
            // Create the draft bulk envelope. This will have exactly one placeholder bulk recipient
            dfsle.Envelope myEnvelope = dfsle.BulkSendService.getDraftEnvelope(
                dfsle.DocumentService.getDocuments(ContentVersion.getSObjectType(), new Set<Id> { myFileId }), // Documents to send
                null); // Optional Salesforce source entity
            
            // Send envelope with a placeholder bulk recipient
            dfsle.BulkList.Result myResult = dfsle.BulkSendService.sendEnvelope(myListId, myEnvelope);
            
            // Save bulkStatusId to query status later
            Id myStatusId = myResult.bulkStatusId;

}