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
    page-break-inside: avoid !important;
     -fs-table-paginate: paginate;
 }

 th, td {
    padding: 4px;
}
 
 body{
     font-family: Arial Unicode MS;
     font-size: 12px;
     line-height: 12px;
 }
             
 tbody {
     display:table-row-group;
 }              

@media print{
    thead{
        display:table-header-group;
    }
}

#footer {
    position : absolute;
    bottom : 0;
    height : 40px;
    margin-top : 40px;
}

@page {
    margin-left : 1cm;
    margin-right : 1cm;
    margin-bottom : 1.5cm;
    size:A4 landscape;
}