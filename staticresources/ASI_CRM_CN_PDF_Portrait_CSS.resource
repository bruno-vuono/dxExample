.border{
                width: 100%;border: 1px solid #000000;          
            }
        
             .bold{
                 font-weight:bold;   
             }   
                     
             h1{
                 font-size:15px; 
                 font-family: Arial Unicode MS;    
             }
             
             h2{
                font-weight:bold;
             }
             
             table {
                 -fs-table-paginate: paginate;
             }
             @page {                       
                 size: Portrait;
                 margin-top: 5.5cm;
             
                 @PageBreak{
                      page-break:always;
                      page-break-inside:avoid;
                 }                   
                 
                 @top-center {
                    content: element(header);
                 }
                     
                 @bottom-right {
                    content: counter(page);
                    font-family: Arial Unicode MS;
                    font-size: 10px;
                    line-height: 11px;
                 } 
                 @bottom-left {
                    font-family: Arial Unicode MS;
                    font-size: 10px;
                    line-height: 11px;
                 }              
             }
             
             div.header {
                position: running(header);
                font-family: Arial Unicode MS;
                font-size: 10px;
                line-height: 11px;
                padding: 0px 0px 0px 0px;
             }
             
             body{
                 font-family: Arial Unicode MS;
                 font-size: 10px;
                 line-height: 11px;
             }
                         
             tbody {display:table-row-group;
             }            
                 .nobreak{
                     page-break-inside: avoid;
                 }
            }    
			@media print{
                thead{
                    display:table-header-group;
                }
            }
