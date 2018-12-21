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
     font-size: 10px;
     line-height: 11px;
 }
             
 tbody {display:table-row-group;
 }            
}   

@media print{
    thead{
        display:table-header-group;
    }
}

@page {
        size: 21.0cm 29.7cm;
        margin-top: 4.5cm;
        margin-bottom: 3cm;

    @top-center {
        width:100%;
        content: element(header);
    }
}

div.header {
    padding-bottom: 10px;
    position: running(header);
}

div.content {               
    display: block;
    padding: 20px;
}