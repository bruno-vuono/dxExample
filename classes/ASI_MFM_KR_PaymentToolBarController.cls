public class ASI_MFM_KR_PaymentToolBarController {

    public ASI_MFM_Payment__c header              	{set;get;}
    public Id headerId                                          {set;get;}
    public Set<String>  brandGroups                             {set;get;}
    public List<String> brandGroupNames                         {set;get;}
    public Boolean checkAttachNeed                              {set;get;} 
    public Set<String> brandSet;
  //  public Map<Id,GGGWP> brandMap {set;get;}//brand name
  /* 
    public Class GGGWP
    {
        public String name{set;get;}
        public String url{set;get;}
        public Boolean over{set;get;}
    }
    */
    public ASI_MFM_KR_PaymentToolBarController (ApexPages.StandardController controller) {
        
        this.header = (ASI_MFM_Payment__c)controller.getRecord();
        this.headerId = this.header.Id;
        this.brandGroups = new Set<String>();
        this.brandGroupNames = new List<String>();
        
        this.brandSet = new Set<String>();
        //this.brandMap = new Map<Id,GGGWP>();
        
    }
     
    public void init(){
        
        checkAttachNeed = false;
        
       header = [Select id , ASI_MFM_Status__c, ASI_MFM_PO__c , Name, ASI_MFM_Need_Attachment__c,	ASI_MFM_Is_Direct_Payment__c, ASI_MFM_Pre_payment__c, ASI_MFM_Offset_Payment__c  from ASI_MFM_Payment__c where id=: this.headerId];
        // header = [Select id , ASI_MFM_Payment__r.ASI_MFM_Status__c, ASI_MFM_PO_Line_Item__c  from ASI_MFM_Payment_Line_Item__c where ASI_MFM_Payment__c=: this.headerId];
       //   system.assertEquals(header.ASI_MFM_PO_Line_Item__c,null); 
        checkAttachNeed = header.ASI_MFM_Need_Attachment__c;
       
        /*for(ASI_MFM_Payment_Line_Item__c payLine : [Select id ,ASI_MFM_PO_Line_Item__r.ASI_MFM_PO__c , ASI_MFM_PO_Line_Item__r.ASI_MFM_Sub_brand_Code__r.ASI_MFM_Brand__c,ASI_MFM_PO_Line_Item__r.ASI_MFM_Sub_brand_Code__r.ASI_MFM_Brand__r.ASI_CRM_CN_Brand_Group_c__r.Name 
                                              from ASI_MFM_Payment_Line_Item__c where ASI_MFM_PO_Line_Item__r.ASI_MFM_Sub_brand_Code__r.ASI_MFM_Brand__r.ASI_CRM_CN_Brand_Group_c__c!=null and ASI_MFM_Payment__c =: header.id] ){
                                                  
                                                  brandGroups.add(payLine.ASI_MFM_PO_Line_Item__r.ASI_MFM_Sub_brand_Code__r.ASI_MFM_Brand__r.ASI_CRM_CN_Brand_Group_c__r.Name);
                                              }
        
        brandGroupNames = new List<String>(brandGroups);*/
        
        
        /*
        for(ASI_MFM_Payment_Line_Item__c payLine: [SELECT id,
                                                   ASI_MFM_PO_Line_Item__r.ASI_MFM_Sub_brand_Code__r.ASI_MFM_Brand__c,
                                                   ASI_MFM_PO_Line_Item__r.ASI_MFM_Sub_brand_Code__r.ASI_MFM_Brand__r.Name
                                                   FROM ASI_MFM_Payment_Line_Item__c 
                                                   WHERE ASI_MFM_PO_Line_Item__r.ASI_MFM_Sub_brand_Code__r.ASI_MFM_Brand__c !=null
                                                   AND ASI_MFM_Payment__c =: header.id] ){
                                                       GGGWP gg = new GGGWP();
                                                       gg.name = payLine.ASI_MFM_PO_Line_Item__r.ASI_MFM_Sub_brand_Code__r.ASI_MFM_Brand__r.Name;
                                                       gg.url = '';
                                                       brandMap.put(payLine.ASI_MFM_PO_Line_Item__r.ASI_MFM_Sub_brand_Code__r.ASI_MFM_Brand__c, gg);
                                                       brandSet.add(payLine.ASI_MFM_PO_Line_Item__r.ASI_MFM_Sub_brand_Code__r.ASI_MFM_Brand__c);
                                                   }//end for
        
        List<ASI_Attachment__c> attList = ([SELECT Id,ASI_Image_URL__c,
                                            ASI_MFM_Brand__c
                                            FROM ASI_Attachment__c
                                            WHERE ASI_MFM_Brand__c IN:brandSet]);
        
        for(ASI_Attachment__c att: attList)
        {
            Integer i = 1;
            GGGWP gg = brandMap.get(att.ASI_MFM_Brand__c);
            gg.url = att.ASI_Image_URL__c;
            Integer rand = Math.round(Math.random()*100);
            if(Math.mod(rand, 2) == 0)
                gg.over = false;
            else
                gg.over = true;
            
            brandMap.put(att.ASI_MFM_Brand__c, gg);
            i++;
        }
       */
            
         //system.assertEquals(Trigger.New, null);
        List<Attachment> noOfAttachment = new List<Attachment>();
        
        noOfAttachment = [Select id from Attachment where parentId =: headerId];
        
        if(checkAttachNeed  && (noOfAttachment == null || noOfAttachment.size()==0))checkAttachNeed = true; else checkAttachNeed = false;         
        
    }
    

}