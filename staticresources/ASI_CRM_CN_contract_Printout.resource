@page {
	size: A4;
}
@page {
	@bottom-right {
		content: element(footer);
	}
}

div.footer {
	display: block;
	padding: 5px;
	position: running(footer);
}

.pagenumber:before {
	content: counter(page);
}
.pagecount:before {
	content: counter(pages);
}

.savingRecord .fullScreenLoading{
	display : block;
}

.fullScreenLoading {
	display    : none;
	position   : fixed;
	z-index    : 1000;
	top        : 0;
	left       : 0;
	height     : 100%;
	width      : 100%;
	background : rgba( 255, 255, 255, .8 ) 
				 url('../images/loading.gif')  
				 50% 50% 
				 no-repeat;
}
	