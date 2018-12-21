global class CustomFacebookSocialItemScheduler implements Schedulable{
    private SchedulableContext SC;
    
    global void Execute(SchedulableContext SC){
        this.SC = SC;
        init();
        //CustomFacebookSocialItemFactory.init(); 
    }
    
    @future(callout=true)
    public static void init() {
        //CustomFacebookSocialItemFactory factory = new CustomFacebookSocialItemFactory();
        //factory.init();
        CustomFacebookSocialItemFactory.init();
    }
    
    global static void start() {
        System.schedule('Pernod facebook', '0 30 * * * ?', new CustomFacebookSocialItemScheduler());
    }
}