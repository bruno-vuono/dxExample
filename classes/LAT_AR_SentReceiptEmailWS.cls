@RestResource(urlMapping='/LAT_AR_SentReceiptEmaiL/*')

global with sharing class  LAT_AR_SentReceiptEmailWS {
    

    @HttpPost  
    global static void sendEmail(List<String> emailList,String body, string subject, Id recieptId) {
        //query contact  d

        String mensaje = 'Success';
        Boolean resultado = true;
        Boolean esRest = !(RestContext.response==null);
        Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();

        mail.setToAddresses(emailList);
        mail.setReplyTo(UserInfo.getUserEmail());
        mail.setSenderDisplayName(UserInfo.getName());
        mail.setSubject(subject);
        mail.setBccSender(false);
        mail.setUseSignature(false);
        mail.setPlainTextBody(body);
    
        
      //Set email file attachments
        List<Messaging.Emailfileattachment> fileAttachments = new List<Messaging.Emailfileattachment>();
        List<Attachment> al = [select Name, Body, BodyLength from Attachment where ParentId = :recieptId ORDER BY CreatedDate desc LIMIT 1];
        // Add to attachment file list
        if (al.size() > 0) {
            Attachment a = al.get(0);
            Messaging.Emailfileattachment efa = new Messaging.Emailfileattachment();
            efa.setFileName(a.Name);
            efa.setBody(a.Body);
            fileAttachments.add(efa);
            mail.setFileAttachments(fileAttachments);
        } else {
            mensaje        = 'No existe un Attachment (Impresión) para el recibo ingresado.';
            resultado      = false;
            
        }
        if (resultado) {
            Messaging.sendEmail(new Messaging.SingleEmailMessage[] { mail });
        }
        //Si estoy en REST devuelvo.s
        if (esRest) {
            if (resultado) {
                RestContext.response.statusCode = 200;
            } else {
                RestContext.response.statusCode = 404;
            }
            
            RestContext.response.addHeader('Content-Type', 'application/json');
            RestContext.response.responseBody = Blob.valueOf('{ "id" : "'+recieptId+'", "success": "'+resultado+'", "message": "'+mensaje+'" }');
        }

        
        
    }




}