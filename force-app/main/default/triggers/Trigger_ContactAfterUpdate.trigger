//ds-snippet-start:Apex11Step4
trigger Trigger_ContactAfterUpdate on Contact (after insert, after update, after delete) { 
    if (trigger.isUpdate)
{   
    for(contact aC : trigger.new)
    {
        if (aC.DocuSign_Status__c=='Email DocuSign') // Test Field called on the contact. This is not a DocuSignStatus Object
        {
             DocuSignStatusTriggerHandler.handleOrderComplete(aC.Id); 
        }            
    }        
}  
}
//ds-snippet-end:Apex11Step4