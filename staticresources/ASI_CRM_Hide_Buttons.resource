    function addLoadEvent(func) {   
        var oldonload = window.onload;
        if (typeof window.onload != 'function') {   
            window.onload = func;   }   
        else {  window.onload = function() {    
            if (oldonload) {    oldonload();    }   
            func(); }   
        }   
    }   
  
    function checkPage() {  
        if (document.getElementsByName("piSubmit")[0] != null)  
            document.getElementsByName("piSubmit")[0].style.display = 'none';
    }

    addLoadEvent(function() {    checkPage();    }); 