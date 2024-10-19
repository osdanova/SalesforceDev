### [SF Book](../README.md)

# Emails

There are multiple ways of sending emails from Salesforce (Apex, Flows, Feed...)

## Apex

[docs](https://developer.salesforce.com/docs/atlas.en-us.apexcode.meta/apexcode/apex_forcecom_email_outbound.htm)

Emails can be set to a list of addresses or to a user. Note that it uses as sender the email of the user that is executing the code.

    Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();

    String[] toAddresses = new String[] {'user@acme.com'}; 
    String[] ccAddresses = new String[] {'smith@gmail.com'};
    mail.setToAddresses(toAddresses);
    mail.setCcAddresses(ccAddresses);

    mail.setReplyTo('support@acme.com');
    mail.setSenderDisplayName('Salesforce Support');

    mail.setSubject('New Case Created : ' + case.Id);
    // Set the body as plain text or HTML
    mail.setPlainTextBody('Your Case: ' + case.Id +' has been created.');
    mail.setHtmlBody('Your case:<b> ' + case.Id +' </b>has been created.<p>'+
        'To view your case <a href=https://MyDomainName.my.salesforce.com/'+case.Id+'>click here.</a>');

    // Set to True if you want to BCC yourself on the email.
    mail.setBccSender(false);

    Messaging.sendEmail(new Messaging.SingleEmailMessage[] { mail });

### Org Wide Emails

Org wide emails can be set via Setup to use as sender instead of the running user. When creating one an email will be sent to the email being set for confirmation. Note that this will override the SenderDisplayName value and will use the one set on the Org wide email.

    mail.setOrgWideEmailAddressId(emailAddressId);

### Attachments

To add attachments to an email, setEntityAttachments(fileIds) can be used.

## Email Templates

Templates can be created and reused in multiple places. They are also editable without the need of a code deployment.

There are Classic templates, which are very basic, and Lightning templates, which use a visual editor for HTML.\
Classic emails are accessed via setup.\
Lightning email are accessed via their app (Make sure to enable them in Setup)

Merge fields can be used to dinamically load data from the Recipient, the Sender or the related record (Target)

To apply in Apex:

    mail.setTemplateId(templateId);
    mail.setTargetObjectId(targetObjectId);

### Signature

    // Optionally append the Salesforce email signature to the email.
    // The email address of the user executing the Apex Code will be used.
    mail.setUseSignature(false);

## Logging

The history for emails can be checked at Setup > Email Logs.



## Considerations

* There's a limit of 5000 emails sent per day