public class DocuSignStatusTriggerHandler{
    @future (callout=true)
      // Handler for Order complete
      public static void handleOrderComplete(final Id contactId) {
          // Call the SendEnvelopeFromTriggerController class sendEnvelope method to invoke the DocuSign API's for sending envelope
          SendEnvelopeFromTriggerController.sendEnvelope(contactId);
      }
  }

