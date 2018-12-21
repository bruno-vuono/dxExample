public with sharing class MMPJ_TOPG_LoadMileStoneController {
    public List <MMPJ_TOPG_ProjectMilestone__c> milesStonesListToAdd {get;set;}
    public List <MMPJ_TOPG_ProjectMilestone__c> milesStonesListToEdit {get;set;}
    public List <MMPJ_TOPG_ProjectMilestone__c> milesStonesListToDelete {get;set;}
    public List <MMPJ_TOPG_ProjectMilestone__c> listMilesStonesToShow{get;set;}
    //public List <MMPJ_TOPG_ProjectMilestones__c> ListMSFromCustom {get;set;}
    public List <MMPJ_TOPG_ProjectMilestone__c> MilesStonesList = new List <MMPJ_TOPG_ProjectMilestone__c>();
    public boolean displayMSPopUp {get;set;} // Edit Mile stone Popup Panel
    public boolean NewMileStone {get;set;} // New Mile Stone Popup (displayMSPopUp = true)
    public boolean EditMileStone {get;set;}
    public boolean isEditMode{get;set;}
    public Id editMileStoneId{get;set;}
    public Integer theCounter{get;set;}
    public integer SelectedCounter{get;set;}
    public integer saveComp{get;set;}
    private integer ShowSaveMessage_oldCounter = 0;
    private integer ShowSaveMessage_newCounter = 0;
    public boolean ShowSaveMessage{
        get{
            if(ShowSaveMessage_newCounter > ShowSaveMessage_oldCounter){
                ShowSaveMessage = true;
                ShowSaveMessage_newCounter = ShowSaveMessage_oldCounter;
            }
            else
                ShowSaveMessage = false;

            return ShowSaveMessage;
        }
        set;
    }
    public MMPJ_TOPG_ProjectMilestone__c MilestonePopup {get;set;}  
    public List <MMPJ_TOPG_ProjectMilestones__c> getMilesFromCustom(){
        return MMPJ_TOPG_ProjectMilestones__c.getall().values();
    }    
    public List<MMPJ_TOPG_ProjectMilestone__c> listMilesStones{get;set;}

   
    public MMPJ_TOPG_Project__c project{
        get;
        set{
            if(this.project == null){
                this.project = value;
                if(this.project.Milestones__r!= null)
                    listMilesStones = this.project.Milestones__r;
                   /* for (MMPJ_TOPG_ProjectMilestones__c ms :ListMSFromCustom ){
                     MMPJ_TOPG_ProjectMilestone__c  m = new MMPJ_TOPG_ProjectMilestone__c ();
                     m.MMPJ_TOPG_MilestoneTitle__c = ms.MilestoneName__c;
                     m.MMPJ_TOPG_IsDefault__c=true;
                     m.MMPJ_TOPG_A__c =ms.MMPJ_TOPG_A__c;
                     m.MMPJ_TOPG_C__c =ms.MMPJ_TOPG_C__c;
                     m.MMPJ_TOPG_R__c= ms.MMPJ_TOPG_R__c;
                     m.MMPJ_TOPG_I__c=ms.MMPJ_TOPG_I__c;
                     m.MMPJ_TOPG_Date__c = ms.MMPJ_TOPG_Date__c;
                     m.MMPJ_TOPG_DeliverableDescription__c=ms.MMPJ_TOPG_Description__c;
                     m.MMPJ_TOPG_MMPJ_Status__c=ms.MMPJ_TOPG_Status__c;
                     m.MMPJ_TOPG_Project__c =this.project.id;
                     listMilesStones.add(m);
                    }*/     
            } 
            
        }
    }
 
public MMPJ_TOPG_LoadMileStoneController() {
        //ListMSFromCustom = new List<MMPJ_TOPG_ProjectMilestones__c>();
       // ListMSFromCustom =getMilesFromCustom();
        saveComp=0;
        listMilesStones = new List<MMPJ_TOPG_ProjectMilestone__c>();
        milesStonesListToEdit= new List<MMPJ_TOPG_ProjectMilestone__c>();
        milesStonesListToDelete= new List<MMPJ_TOPG_ProjectMilestone__c>();
        listMilesStonesToShow= new List<MMPJ_TOPG_ProjectMilestone__c>();
    }    
    
    public void LeavingMilestones(){
        try{
            saveMilestones();
        }
        catch(exception ex)
        {
            saveComp=0;
        }
        saveComp=1;
    }
    public PageReference saveMilestones(){
    //List<MMPJ_TOPG_ProjectMilestones__c> ListCustomToUpdate = new List<MMPJ_TOPG_ProjectMilestones__c>();
        for(integer i = 0; i < listMilesStones.size(); i++){
            listMilesStones[i].MMPJ_TOPG_Rank__c = i;
        }
        /*for (integer i=0;i<listMilesStones.size();i++){
           MMPJ_TOPG_ProjectMilestone__c mile =listMilesStones[i]; 
           if(mile.MMPJ_TOPG_IsDefault__c==true){
            system.debug ('in remove ==');
                //ListCustomToUpdate.add(mile);  
                listMilesStones.remove(i);
                i--;   
           }
        }*/
       // if (ListCustomToUpdate.size()>0)
       // {
       //  update ListCustomToUpdate ;
       // }
       // system.debug ('in save milestone =='+listMilesStones.size());        
        if (listMilesStones.size()>0){
       // system.debug('in upsert=='+listMilesStones.size());
        upsert listMilesStones;
        }
        for (MMPJ_TOPG_ProjectMilestone__c mile:listMilesStones){
        mile.recalculateFormulas();
        }
        if (milesStonesListToDelete.size()>0){
            delete milesStonesListToDelete;
            milesStonesListToDelete= new List<MMPJ_TOPG_ProjectMilestone__c>();
        }
        //PageReference page = new PageReference('/apex/MMPJ_TOPG_NewProject?core.apexpages.devmode.url=1&tabname=Milestones&id='+project.id);
        //page.setRedirect(true);
        //return page;
        SelectedCounter = -1;
        ShowSaveMessage_newCounter++;
        
        return null;
    }
    
    public PageReference addMileStone() {
      MilestonePopup = new MMPJ_TOPG_ProjectMilestone__c();
      MilestonePopup.MMPJ_TOPG_Project__c=project.id; 
      SelectedCounter = listMilesStones.size();
      listMilesStones.add(MilestonePopup);
      
      //displayMSPopUp = true;
      //NewMileStone=false;
      return null;
    }/*
    public PageReference EditMileStone() {
     if(SelectedCounter!=null){  
      MilestonePopup  = listMilesStones[SelectedCounter];
      }
      displayMSPopUp = true;
      NewMileStone=false;
      return null;
    }
    public PageReference SaveEditMileStone() {
      if (isEditMode==true){
      milesStonesListToEdit.add(MilestonePopup);
      isEditMode=false;
      }
      else {
      MilestonePopup.MMPJ_TOPG_Project__c=project.id;
      listMilesStones.add(MilestonePopup);
      }
      displayMSPopUp = false;
      NewMileStone=true;
      return null;
    }*/
    public PageReference deletetMileStone() {
      //delete MilestonePopup;
      displayMSPopUp = false;
      NewMileStone=true;
      if(listMilesStones.get(SelectedCounter).id!=null){ 
          milesStonesListToDelete.add(listMilesStones.get(SelectedCounter));
      }
      listMilesStones.remove(SelectedCounter);
      SelectedCounter = -1;
      return null;
    }
    
    public pagereference hideMilesStonePopup()
    {
        system.debug('theProject.Milestones__r.size() ' +Project.Milestones__r.size());
        if(Project.id != null /*&& Project.Milestones__r.size() < 1*/)
        {
            MMPJ_TOPG_Project__c theProject =[SELECT Id,
                                             (SELECT Id, Name, MMPJ_TOPG_A__c, MMPJ_TOPG_C__c, MMPJ_TOPG_Date__c, MMPJ_TOPG_DeliverableDescription__c, MMPJ_TOPG_Flag__c, MMPJ_TOPG_I__c, MMPJ_TOPG_MilestoneTitle__c, MMPJ_TOPG_Project__c, MMPJ_TOPG_R__c, MMPJ_TOPG_RemainingTime__c, MMPJ_TOPG_MMPJ_Status__c, MMPJ_TOPG_Rank__c,MMPJ_TOPG_IsDefault__c  FROM Milestones__r ORDER BY MMPJ_TOPG_Rank__c)
                                            FROM MMPJ_TOPG_Project__c
                                            WHERE Id =:Project.Id
                                        ];
            if(theProject.Milestones__r.size() > 0)
                listMilesStones = theProject.Milestones__r;

        }
        return null;
    }
     public PageReference MoveUpMilesStones() {
        if(SelectedCounter> 0)
            listMilesStones.add(SelectedCounter-1, listMilesStones.remove(SelectedCounter)); 
        return null;
    }
    
    public Pagereference ChangeRACI()
    {
        return null;
    }
    
    public pageReference EditMileStones(){
        listMilesStones[SelectedCounter].MMPJ_TOPG_IsDefault__c = false;
        return null;
    }

}