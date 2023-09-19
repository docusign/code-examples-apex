//ds-snippet-start:Apex9Step1
public class SendToNewContact {
//ds-snippet-end:Apex9Step1

    //ds-snippet-start:Apex9Step4
    @InvocableMethod
    public static List<String> sendEnvelope(List<Contact> record) {
      Contact mySource = record.get(0);
      sendEnvelopeInFuture(mySource.Id);
      return Null;
    }
    //ds-snippet-end:Apex9Step4
  
    //ds-snippet-start:Apex9Step3
    @future(callout = true)
    public static void sendEnvelopeInFuture(Id mySourceId) {
      createAndSendEnvelope(mySourceId);
    }
    //ds-snippet-end:Apex9Step3
  
    //ds-snippet-start:Apex9Step2
    public static Id createAndSendEnvelope(Id mySourceId) {
        dfsle.Envelope myEnvelope = dfsle.EnvelopeService.getEmptyEnvelope(
          new dfsle.Entity(mySourceId)
        );
        Contact myContact = [SELECT Name, Email FROM Contact WHERE Id = :mySourceId LIMIT 1];
        dfsle.Recipient myRecipient = dfsle.Recipient.fromSource(
          myContact.Name,
          myContact.Email,
          null,
          'Signer1',
          new dfsle.Entity(myContact.Id)
        );
        myEnvelope = myEnvelope.withRecipients(new List<dfsle.Recipient> { myRecipient });
        dfsle.UUID myTemplateId = dfsle.UUID.parse('8dafd5dd-xxxx-xxxx-xxxx-542f35b227f7');
        dfsle.Document myDocument = dfsle.Document.fromTemplate(
          myTemplateId,
          'Services Framework Agreement'
        );
        myEnvelope = myEnvelope.withDocuments(
          new List<dfsle.Document> { myDocument }
        );
        myEnvelope = dfsle.EnvelopeService.sendEnvelope(
          myEnvelope,
          true
        );
        return myEnvelope.Id;
      }
      //ds-snippet-end:Apex9Step2

//ds-snippet-start:Apex9Step1
}
//ds-snippet-end:Apex9Step1