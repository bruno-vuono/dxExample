jQuery(document).ready(function($){
    // Hide Chatter
    $j = jQuery.noConflict();
    $j('.chatterfeedshell').parent().remove();
    
    // Hide this sidebar module
    $('#sidebarDiv div.linksModule').each(function(){
        var $module = $(this);
        if ($module.find('.brandPrimaryFgr').text() == 'ESN_Home_ChatterRemovalBox'){
            $module.hide();
            return false;
        }
    });
});