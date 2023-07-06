@IsTest
public with sharing class UnitTestExample {
    
    @IsTest
    public static void testSendEnvelope() {
        // Mock the DocuSign eSignature API
        dfsle.TestUtils.setMock(new dfsle.ESignatureAPIMock());
		
        // Run the test as a DocuSign Sender. This is required by dfsle.EnvelopeService.sendEnvelope
        System.runAs(dfsle.UserMock.createDocuSignSender()) {

        // Create test data
        Account myAccount = new Account(Name = 'Test Account');
        insert myAccount;
             
        Contact myContact = new Contact(
            AccountId = myAccount.Id,
            FirstName = 'Test',
            LastName = 'Contact',
            Phone = '555-1234-5678',
            Email = 'test.contact@example.com');
        insert myContact;
        
        // Create a test envelope with one document and one recipient
        dfsle.Envelope myEnvelope = dfsle.EnvelopeService.getEmptyEnvelope(new dfsle.Entity(myAccount.Id))
            .withDocuments(new List<dfsle.Document> { 
                dfsle.Document.fromTemplate(
                    dfsle.UUID.randomUUID(),
                    'test template')
            })
            .withRecipients(new List<dfsle.Recipient> {
                dfsle.Recipient.fromSource(
                    myContact.FirstName + ' ' + myContact.LastName,
                    myContact.Email,
                    myContact.Phone,
                    'Signer 1',
                    new dfsle.Entity(myContact.Id))
            });
      } 
   }
}
