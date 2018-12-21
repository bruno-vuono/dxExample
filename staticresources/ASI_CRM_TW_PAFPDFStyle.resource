border{
    width: 100%;border: 1px solid #000000;          
}

 .bold{
     font-weight:bold;   
 }   
         
 h1{
     font-size:20px; 
     font-family: Arial Unicode MS;    
 }
 
 h2{
    font-weight:bold;
 }
 
 table {
     -fs-table-paginate: paginate;
 }
 
 body{
     font-family: Arial Unicode MS;
     font-size: 13px;
     line-height: 20px;
 }
             
 tbody {
    display:table-row-group;
 }            
   

@media print{
    thead{
        display:table-header-group;
    }
}

@page {
        size: 21.0cm 29.7cm;
        margin-top: 3.5cm;
        margin-bottom: 1cm;
        margin-left: 0.9cm;
        margin-right: 0.9cm;
        padding: 0cm;

    @top-center {
        width:100%;
        
        content: element(header);
    }

    @bottom-right {
    	font-size: 80%; 
		content: counter(page) "/" counter(pages);
	}

  
}

div.header {
    margin: 0cm;
    padding: 0cm;
    position: running(header);
}

div.content {               
    display: block;
    margin: 0cm;
    padding: 0cm;
}