public with sharing class SendEnvelopeWithTabsController {

@AuraEnabled

    public static void sendEnvelopeWithTabs() {
        Id mySourceId = '00XXXXXXXXXXXXXXAM'; // The ID of the initiating Salesforce object

        // Create an empty envelope
        dfsle.Envelope myEnvelope = dfsle.EnvelopeService.getEmptyEnvelope(
        new dfsle.Entity(mySourceId));
        // The initiating Salesforce entity

        Id myDocumentId = '06XXXXXXXXXXXXXXAQ'; // The ID of a document stored in a Salesforce library
        Id myFileId = [SELECT id from ContentVersion where ContentDocumentId = :myDocumentId LIMIT 1].id;
        
        // Add document to the envelope
        myEnvelope = myEnvelope.withDocuments(dfsle.DocumentService.getDocuments(ContentVersion.getSObjectType(), new Set<Id> { myFileId }));

        // Create an Initial Here tab
        dfsle.Tab myInitialHereTab = new dfsle.InitialHereTab()
            .withRequired(true) // Signing optional
            .withPosition(new dfsle.Tab.Position(
                1, // The document to use
                1, // Page number on the document
                320, // X position
                290, // Y position
                null, // Default width
                null)); // Default height

        // Create a Text tab
        dfsle.Tab myTextTab = new dfsle.TextTab()
            .withRequired(true) // Signer must enter value
            .withPosition(new dfsle.Tab.Position(
                1, // The document to use
                1, // Page number on the document
                210, // X position
                305, // Y position
                100, // 100 pixels wide
                null)); // Default height

        // Create a Sign Here tab
        dfsle.Tab mySignHereTab = new dfsle.SignHereTab()
            .withScale(1.5) // 1.5 scale
            .withRequired(true) // Signing mandatory
            .withAnchor(new dfsle.Tab.Anchor(
                'signed', // Anchor string
                false, // Do not allow white space in anchor string
                false, // Anchor string is not case sensitive
                'right', // Horizontal alignment in relation to the anchor text
                true, // Ignore if the anchor text is not present in the document
                true, // Must match the value of the anchor string in its entirety
                'pixels', // Unit of the x and y offset properties
                20, // X offset
                0)); // Y offset

        // Create a Date Signed tab
        dfsle.Tab myDateSignedTab = new dfsle.DateSignedTab()
            .withFormatting(new dfsle.Tab.Formatting(
                'Helvetica', // Font
                'default', // Font color
                14, // 14pt size,
                true, // Bold
                false, // Italic
                false, // Underline
                false, // Conceal value
                false)) // Fixed width
            .withPosition(new dfsle.Tab.Position(
                1, // The document to use
                1, // Page number on the document
                330, // X position
                470, // Y position
                null, // Default width
                null)); // Default height


        // Create a new recipient
        dfsle.Recipient myRecipient = dfsle.Recipient.fromSource(
            'Lily TheGSD', // Signer name
            'lilythegsd@gmail.com', // Signer email
            null, // Signer phone number
            'Signer 1', // Signer role
            null) // No Salesforce association
            .withTabs(new List<dfsle.Tab> { // Associate the tabs with this recipient
                myInitialHereTab,
                myTextTab,
                mySignHereTab,
                myDateSignedTab
            });

        // Add recipient to the envelope
        myEnvelope = myEnvelope.withRecipients(new List<dfsle.Recipient> { myRecipient });

        // Send the envelope
        myEnvelope = dfsle.EnvelopeService.sendEnvelope(
            myEnvelope, // The envelope to send
            true); // Send now?
    }
}