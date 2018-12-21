/*Filename:       ASI_FOC_TW_SubmitFOCController.cls
* Author:         Elufa
* Purpose:        Submit for approval - TW FOC
* Created Date:   2016-12-12
* Testing Record: https://pernod-ricard--asisb6conf--c.cs8.visual.force.com/apex/ASI_FOC_TW_SubmitFOCPage?scontrolCaching=1&id=a87L00000004Ei0
				  One FOC will have one Plan
* -----------------------------------------------------------------------------
*/

public class ASI_FOC_TW_SubmitFOCController {
    public ASI_FOC_Free_Goods_Request__c foc = new ASI_FOC_Free_Goods_Request__c();
    public String Msg {set;get;} {Msg='';}
    public Boolean IsProcess {set;get;} {IsProcess=true;}
    
    
    public ASI_FOC_TW_SubmitFOCController(apexpages.standardController sc) 
    {
        foc = (ASI_FOC_Free_Goods_Request__c)sc.getRecord();
        foc=[select Id,Name,recordTypeId,RecordType.DeveloperName,ASI_CRM_Plan__r.Name,ASI_CRM_Plan__r.ASI_MFM_Plan_Amount__c,ASI_CRM_Plan__r.ASI_MFM_Prefix__r.ASI_MFM_Over_Spending_Checking__c,ASI_CRM_Plan__r.ASI_MFM_Prefix__r.ASI_MFM_Tolerance__c,ASI_CRM_Plan__c,ASI_CRM_Plan__r.ASI_MFM_Plan_Balance__c,ASI_CRM_Plan__r.ASI_MFM_TnE_Non_A_D_Amount__c ,ASI_CRM_Plan__r.ASI_MFM_Total_without_PO_Actual_Amount__c from ASI_FOC_Free_Goods_Request__c where id = :sc.getId()];
    }
    
    public pageReference submitRequest2() {
        if(foc.RecordType.DeveloperName.contains('ASI_CRM_TW_FOC_Request')) {
            IsProcess=true;
            //SQL
            List<ASI_FOC_Request_Item__c> FOCLines = [select Id, Name,ASI_FOC_Cancel_Qty__c,ASI_FOC_Reason__c,ASI_CRM_Plan_Line_Item__r.ASI_MFM_Plan__r.name,ASI_FOC_Request_Order__c,
                                                      ASI_FOC_Request_Quantity_Bottle__c,ASI_CRM_Plan_Line_Item__r.ASI_MFM_Unit_Cost__c,ASI_CRM_TW_Amount__c,ASI_FOC_Request_Order__r.ASI_FOC_Request_Status__c,
                                                      ASI_CRM_Plan_Line_Item__r.ASI_MFM_A_C_Code__r.ASI_MFM_A_and_P_Tree__c,ASI_CRM_Plan_Line_Item__r.ASI_MFM_A_C_Code__c,
                                                      ASI_CRM_Plan_Line_Item__r.ASI_MFM_Plan__c,ASI_CRM_Plan_Line_Item__c,ASI_CRM_Plan_Line_Item__r.ASI_MFM_Total_Cost__c 
                                                      from ASI_FOC_Request_Item__c where ASI_CRM_Plan_Line_Item__r.ASI_MFM_Plan__c=:foc.ASI_CRM_Plan__c ];

            IsProcess=ValdationChecking(FOCLines);
            if(IsProcess){
                // Running Update Plan FOC Amount  *** Added by 2018-07-06 Linus@introv
                if(!Test.isRunningTest())
                    update FOCLines;
                submitforapproval();
                return new pageReference('/' + foc.Id);
            }else{
                Msg='☹ We cannot submit for approval.<br/>'+Msg;
                return null;
            }
        }else{
            submitforapproval();
            return new pageReference('/' + foc.Id);
        }
        
    }
    
    
    public Boolean ValdationChecking(List<ASI_FOC_Request_Item__c> FOCLines){
        Boolean isProcess = true;
        
        Decimal FOCAmount=0; //  (w/o A&D) 
        Decimal TotalAPFOCAmt=0;
        Decimal TotalAPPlanAmount=0;
        Decimal TotalAPPOAmount=0; //  (Approved/Completed)  
        Decimal TotalwoPOActual=foc.ASI_CRM_Plan__r.ASI_MFM_Total_without_PO_Actual_Amount__c ;  // Amount used and synced from JDE   *** Added by 2018-07-05 Linus@introv
        
        
        set<Id> PlanIdSet = new set<Id>();
        Boolean HasLines= false; //for current FOC
        Map<String,ASI_MFM_Plan_Line_Item__c> PlanLineMap = new Map<String,ASI_MFM_Plan_Line_Item__c>();
        Map<String,ASI_MFM_PO_Line_Item__c> POLineMap = new Map<String,ASI_MFM_PO_Line_Item__c>();
        
        Map<String,ASI_FOC_Request_Item__c> CurrentLineMap = new Map<String,ASI_FOC_Request_Item__c>();
        
        for(ASI_FOC_Request_Item__c focl:FOCLines){
            //Checking 1: check FOC Amount 
            if(focl.ASI_CRM_TW_Amount__c ==null && focl.ASI_FOC_Request_Order__c == foc.id){
                Msg+='Free Goods Request Line (<a href="/'+focl.Id+'">'+focl.Name+ '</a>) Error:  Amount in FOC Line is Blank. <br/>';
                IsProcess=false;
            }
            
            //Checking 2: check Plan Number
            if(focl.ASI_CRM_Plan_Line_Item__c !=null){
                PlanIdSet.add(focl.ASI_CRM_Plan_Line_Item__r.ASI_MFM_Plan__c);
            }else if(focl.ASI_FOC_Request_Order__c == foc.id && focl.ASI_CRM_Plan_Line_Item__c ==null){
                Msg+='Free Goods Request Line (<a href="/'+focl.Id+'">'+focl.Name+ '</a>) Error:  Please input Plan line number. <br/>';
                IsProcess=false;
            }
            
            
            
            
            //checking 3: check if there have  foc line 
            if(focl.ASI_FOC_Request_Order__c == foc.id){
                HasLines=true;
            }
            
            //Start calculation    
          
            if(IsProcess && focl.ASI_FOC_Request_Order__c == foc.id && focl.ASI_CRM_TW_Amount__c!=null){
                FOCAmount+=focl.ASI_CRM_TW_Amount__c;
            }
            
            if(IsProcess && focl.ASI_CRM_TW_Amount__c!=NULL && ((focl.ASI_CRM_Plan_Line_Item__r.ASI_MFM_A_C_Code__r.ASI_MFM_A_and_P_Tree__c =='TOTAL A&P'))){ // &&  (focl.ASI_CRM_Plan_Line_Item__r.ASI_MFM_Plan__r.Name.substring(0,1)=='F' || focl.ASI_CRM_Plan_Line_Item__r.ASI_MFM_Plan__r.name.substring(0,1)=='M'))){
                if((focl.ASI_FOC_Request_Order__r.ASI_FOC_Request_Status__c!='Draft' && focl.ASI_FOC_Request_Order__c != foc.id ) ||focl.ASI_FOC_Request_Order__c == foc.id   ){ 
                     TotalAPFOCAmt+=focl.ASI_CRM_TW_Amount__c;
                     string mapkey=string.valueOf(focl.ASI_CRM_Plan_Line_Item__r.ASI_MFM_Plan__c)+focl.ASI_CRM_Plan_Line_Item__r.ASI_MFM_A_C_Code__c;
                     if(!CurrentLineMap.containsKey(mapkey)){
                         focl.ASI_FOC_Cancel_Qty__c=focl.ASI_CRM_TW_Amount__c;
                         focl.ASI_FOC_Reason__c='The related FOC Line is : <a href="/'+focl.Id+'">'+focl.Name+ '</a>';
                         CurrentLineMap.put(mapkey,focl);
                     }else{
                         ASI_FOC_Request_Item__c FOCline= new ASI_FOC_Request_Item__c();FOCline=focl.clone(false, true);FOCline.ASI_FOC_Cancel_Qty__c=CurrentLineMap.get(mapkey).ASI_FOC_Cancel_Qty__c+focl.ASI_CRM_TW_Amount__c;FOCline.ASI_FOC_Reason__c=focl.ASI_FOC_Reason__c+';<a href="/'+focl.Id+'">'+focl.Name+ '</a>';CurrentLineMap.remove(mapkey);CurrentLineMap.put(mapkey,FOCline);
                     }// AC Code level Map
                        
                }
                
                
            }
            
        }//end of FOC Line for loop
        
        //Get Plan line
        List<ASI_MFM_Plan_Line_Item__c> PlanLines= [select id, Name,ASI_MFM_A_C_Code__c,ASI_MFM_Plan__c,ASI_MFM_Total_Cost__c,ASI_MFM_A_C_Code__r.ASI_MFM_A_C_Code__c,ASI_MFM_A_C_Code__r.ASI_MFM_A_and_P_Tree__c   from ASI_MFM_Plan_Line_Item__c 
                                                        where ASI_MFM_Plan__c =: foc.ASI_CRM_Plan__c and ASI_MFM_A_C_Code__r.ASI_MFM_A_and_P_Tree__c ='TOTAL A&P' ];
                                                        
        
          for(ASI_MFM_Plan_Line_Item__c pl:PlanLines){
              if(pl.ASI_MFM_A_C_Code__r.ASI_MFM_A_and_P_Tree__c=='TOTAL A&P'){
                  TotalAPPlanAmount+=pl.ASI_MFM_Total_Cost__c;
              }
              
                string mapkey=string.valueOf(pl.ASI_MFM_Plan__c)+pl.ASI_MFM_A_C_Code__c;
                if(!PlanLineMap.containsKey(mapkey)){
                    PlanLineMap.put(mapkey, pl);
                }else{// Contain in Map
                    ASI_MFM_Plan_Line_Item__c planline= new ASI_MFM_Plan_Line_Item__c();
                    planline=pl.clone(false, true);
                    
                    if(pl.ASI_MFM_Total_Cost__c!=null){
                        planline.ASI_MFM_Total_Cost__c=PlanLineMap.get(mapkey).ASI_MFM_Total_Cost__c+pl.ASI_MFM_Total_Cost__c;
                    }
                    PlanLineMap.remove(mapkey);
                    PlanLineMap.put(mapkey,planline);
                    
                }
            }// end of for loop Plan line 
            
            
            //Get PO line 
            List<ASI_MFM_PO_Line_Item__c> poList = [select id ,name,ASI_MFM_PO__c,ASI_MFM_PO__r.ASI_MFM_Plan__c, ASI_MFM_Amount__c,ASI_MFM_Base_Currency_Amount__c,
                                                    ASI_MFM_A_C_Code__c,ASI_MFM_A_C_Code__r.Name,ASI_MFM_A_C_Code__r.ASI_MFM_A_and_P_Tree__c
                                                    from ASI_MFM_PO_Line_Item__c  
                                                    where ASI_MFM_PO__r.ASI_MFM_Plan__c in : PlanIdSet  and ASI_MFM_PO__r.ASI_MFM_Status__c !='Draft' and ASI_MFM_Base_Currency_Amount__c !=null and
                                                    ASI_MFM_PO__r.ASI_MFM_Accrual_PO__c = false ]; /* Added by 2018-05-02 Linus@introv*/
            //and ASI_MFM_PO__r.ASI_MFM_Status__c !='Submitted'
            for(ASI_MFM_PO_Line_Item__c pol : poList){
                
                if(pol.ASI_MFM_A_C_Code__r.ASI_MFM_A_and_P_Tree__c=='TOTAL A&P'){
                    TotalAPPOAmount+=pol.ASI_MFM_Base_Currency_Amount__c;
                }
                string mapkey=string.valueOf(pol.ASI_MFM_PO__r.ASI_MFM_Plan__c)+pol.ASI_MFM_A_C_Code__c;
                //POLineMap
                if(!POLineMap.containsKey(mapkey)){
                    POLineMap.put(mapkey, pol);
                }else{// Contain in Map
                    ASI_MFM_PO_Line_Item__c POline= new ASI_MFM_PO_Line_Item__c();
                    POline=pol.clone(false, true);
                    if(pol.ASI_MFM_Amount__c!=null){
                        POline.ASI_MFM_Amount__c=POLineMap.get(mapkey).ASI_MFM_Amount__c+pol.ASI_MFM_Base_Currency_Amount__c;
                    }
                    POLineMap.remove(mapkey);
                    POLineMap.put(mapkey,POline);
                }
                
            }// end of for loop PO line
            
        	/* check A&P instead of checking each A/C Code           *******Hided by 2018-07-06 Linus@introv 
            integer num=1;
            //AC Code level checking 
            for (string k : CurrentLineMap.keySet()){
                if(PlanLineMap.containsKey(k)){
                    decimal CostAmount=0;
                    if(POLineMap.containsKey(k)){
                        CostAmount=CurrentLineMap.get(k).ASI_FOC_Cancel_Qty__c+POLineMap.get(k).ASI_MFM_Amount__c;
                    }else{
                        CostAmount=CurrentLineMap.get(k).ASI_FOC_Cancel_Qty__c;
                    }
                    //*(1/100)
                    if(PlanLineMap.get(k).ASI_MFM_Total_Cost__c<CostAmount){
                        IsProcess=false;if(num==1){Msg+='<b>A/C Code level Checking</b>: <br/>';}num++;Msg+=' A/C Code: '+ PlanLineMap.get(k).ASI_MFM_A_C_Code__r.ASI_MFM_A_C_Code__c+': Total spending amount ( $'+CostAmount.intValue().format()+ ') greater than plan amount :( $' +(PlanLineMap.get(k).ASI_MFM_Total_Cost__c).intValue().format()+'). <br/>'+CurrentLineMap.get(k).ASI_FOC_Reason__c+'<br/>';
                    }
                }
                
            }//end of for loop
        	*/
        
        //Total AP Balance checking : Total AP Balance = total A&P Plan Amount - total w/o PO Actual amount - total A&P PO Amount (Approved/Completed/Non-Accural)-Total FOC Amount (w/o A&D) – Total T&E Amount (w/o A&D). 
        system.debug('Plan Amount: ' + TotalAPPlanAmount);
        system.debug('Without PO Actual: ' + TotalwoPOActual);
        system.debug('AP PO Amount: ' + TotalAPPOAmount);
        system.debug('AP FOC Amount: ' + TotalAPFOCAmt);
        decimal TotalAPBalanceChecking= TotalAPPlanAmount-TotalwoPOActual-TotalAPPOAmount-TotalAPFOCAmt;
        Decimal TnENon_AD_Amount=0;
        if(foc.ASI_CRM_Plan__r.ASI_MFM_TnE_Non_A_D_Amount__c!=null){
            TnENon_AD_Amount=foc.ASI_CRM_Plan__r.ASI_MFM_TnE_Non_A_D_Amount__c;
        }
        TotalAPBalanceChecking=TotalAPBalanceChecking-TnENon_AD_Amount; system.debug('AP Balance: ' + TotalAPBalanceChecking);
        if((TotalAPBalanceChecking)<0){  // && (foc.ASI_CRM_Plan__r.Name.substring(0,1)=='F' || foc.ASI_CRM_Plan__r.name.substring(0,1)=='M')){
            IsProcess=false;
            Msg+='<br/> <b>A&P Checking</b>: Total AP Amount Balance('+TotalAPBalanceChecking.format()+')=Total A&P Plan Amount('+TotalAPPlanAmount.format()+')  -Total A&P PO Amount (Non-Accural/Non-Draft)('+TotalAPPOAmount.format()+')  -Total FOC Amount (w/o A&D) ('+TotalAPFOCAmt.format()+') -Total TnE Amount (w/o A&D) ('+TnENon_AD_Amount.format()+')  <0. <br/>';
        }

        
        //Plan Balance level checking 
        Decimal Tolerance = 0;
        if(foc.ASI_CRM_Plan__r.ASI_MFM_Prefix__r.ASI_MFM_Over_Spending_Checking__c){
            Tolerance = foc.ASI_CRM_Plan__r.ASI_MFM_Prefix__r.ASI_MFM_Tolerance__c == null ? 0: foc.ASI_CRM_Plan__r.ASI_MFM_Prefix__r.ASI_MFM_Tolerance__c;
            double balance =(foc.ASI_CRM_Plan__r.ASI_MFM_Plan_Balance__c-FOCAmount)/foc.ASI_CRM_Plan__r.ASI_MFM_Plan_Amount__c;
            if(balance<0 && (math.abs(balance)>(foc.ASI_CRM_Plan__r.ASI_MFM_Prefix__r.ASI_MFM_Tolerance__c/100))){
                IsProcess=false;
                Decimal OverAmount=(foc.ASI_CRM_Plan__r.ASI_MFM_Plan_Balance__c-FOCAmount);
                Msg+='<br/> <b>Plan Balance Checking</b>: Plan Balance('+OverAmount.format()+')<0. <br/>';
            }
        }
        
        
        
        if(!HasLines){
            IsProcess=false;
            Msg+='Please input FOC Line. <br/>';
        }
        return isProcess;
    }//**********************end of checking ***********************************************
        
    public void submitforapproval(){ 
        Approval.ProcessSubmitRequest req1 = new Approval.ProcessSubmitRequest();
        req1.setObjectId(foc.id);
        if(!Test.isRunningTest()){ Approval.ProcessResult result = Approval.process(req1);}
        
    }
    
    public pageReference goBack() {
        return new pageReference('/' + foc.id);
    }
    
    
}