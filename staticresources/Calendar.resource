
var gJQ = jQuery.noConflict();
var tooltip;

gJQ(document).ready(function() {
	
	var date = new Date();
	var d = date.getDate();
	var m = date.getMonth();
	var y = date.getFullYear();

	//tooltip = CreatedToolTip();
	// page is now ready, initialize the calendar...
	
	//Declaro mi objeto calendario
	var calendar = gJQ('#calendar').fullCalendar({
		
		//caracteristicas de mi calendario
		//theme: true,
		header : {
			left : 'prev,next today',
			center : 'title',
			right : 'month,agendaWeek,agendaDay'				
		},
		defaultView: 'month',
		height: 600,
		aspectRatio: 2,
		editable : true,
		selectable : true,
		selectHelper : true,
		firstDay: 1,
		weekMode: 'variable',
		agenda: 'HH:mm{ - HH:mm}',
		unselectAuto: false,
		year: year,
		month: month,
		
		unselect: function() {
			//tooltip.hide()
		},
		//eventResizeStart : function() {
			//tooltip.hide()
		//},
		eventDragStart : function() {
			//tooltip.hide()
		},
		viewDisplay: function() {
			//tooltip.hide()
		},
		eventResize: function(event,dayDelta,minuteDelta,revertFunc) {
			//var sendNotification;
			//confirm("Would you like to notify guests of your changes?") ? sendNotification = true : sendNotification = false;
			//updateEvent(event.id,event.title, event.start, event.end, event.allDay )
			revertFunc();
		},
		// move a event
		eventDrop: function(event, dayDelta, minuteDelta, allDay, revertFunc) {
			
			//if (dayDelta == 0) {
			//var sendNotification;
			//confirm("Would you like to notify guests of your changes?") ? sendNotification = true : sendNotification = false;
			
			updateEvent(event.id, event.title, event.start, event.end, event.allDay, "false", revertFunc );
		},
		select : function(start, end, allDay) {
			/*
			var content = showEvent(undefined,'',start, end,allDay);
			tooltip.set({
				'position.target' : 'event',
				'content.text' : content

			}).reposition(event).show(event);
			FocusOnInput();*/
		},
		eventClick : function(data, event, view) {
			//console.log('data');
			//console.log(data);
			//console.log('event');
			//console.log(event);		
			if(country  && country == 'BR'){
				var url = "/apex/LAT_BR_VFP11_CalenderPopUp?idVisita="+data.id;
				jQuery('a.linkVis').attr("href", url);

				jQuery('a.linkVis').fancybox({                    
				    'height': 380, 
				    'width': 500,  
				    'transitionIn' : 'none',
				    'transitionOut' : 'none',
				    'type' : 'iframe'
				});

				jQuery('a.linkVis').click();
			}else{
				top.window.location.href = '/'+ data.id;
			}
			
			//console.log('eventClick');
			/*
			gJQ('#calendar').fullCalendar( 'unselect' );
			
			var content = showEvent(data.id,data.title,data.start,data.end,data.allDay);

			tooltip.set({
				'position.target' : 'event',
				'content.text' : content
			}).reposition(event).show(event);
			FocusOnInput();*/
		},

		dayClick : function(date, allDay, jsEvent, view) {
			if(country == 'BR'){
				var url = "/apex/LAT_BR_VFP11_CalenderPopUp?IdPlan=" + idPlan + "&Date=" + date;
				jQuery('a.linkVis').attr("href", url);

				jQuery('a.linkVis').fancybox({                    
				    'height': 280, 
				    'width': 500,  
				    'transitionIn' : 'none',
				    'transitionOut' : 'none',
				    'type' : 'iframe'
				});

				jQuery('a.linkVis').click();
			}

		},
		
		// fetch events
		events: function(start, end, callback) {
			
			var aEvents = new Array();
			
			Visualforce.remoting.Manager.invokeAction(
				gGetEvents,
				start, end, idPlan,
		        function(result, event) {				//recibe el resultado de GetEvents nombre funcion, parametros y resultado 
														//(return y status de finalizacion) true ok si no tuvo un problema
					/*
					 * asincronico cuando reciba la respuesta se ejecuta
					 */
		            //console.log(result);
		    		if (event.status) {
		            	
		            	for(var i=0; i < result.length; i++) {
		            		// CONSOLE LOG aEvents
		            		//console.log('aEvents: ' + aEvents);
		            		//console.log(aEvents);
		            		
		            		var dateStart = new Date(result[i].StartDate); 
							var dateEnd = new Date(result[i].EndDate);
							
							//CONSOLES LOGS START Y END
							//console.log('dateStart: ' + dateStart);
							//console.log('dateEnd: ' + dateEnd);
							
							//console.log('dateEnd' + dateEnd);
							//console.log('pepe: ' + result[i].Tittle);

							// CONSOLE LOG Title
							//console.log('Tittle: ' + result[i].Tittle);
							
							aEvents.push({
								id: result[i].Id, 
								title: result[i].Tittle,
								start: dateStart,
								end: dateEnd,
								allDay: result[i].isAllDayEvent, // ponerlo en falso porque en mi caso no va a existir
								isRecurrence: false 
							});
						}		
		            	
		            	// CONSOLE LOG callback(aEvents)
		            	//console.log('callback(aEvents): ' + callback(aEvents));
						callback(aEvents);
						
		            	
		            } else if (event.type === 'exception') {
		                
		            } else {
		                
		            }
		        }, 
		        {escape: true}
		    );
		}, 
	})
});
/*
function CreatedToolTip() {

	//console.log('entro11');
	
	var to = gJQ('<div/>').qtip({
		
		id: 'tooltip',
		prerender : true,
		style: 'qtip-wiki',
		hide: false,
		/*content: {
			text : '',
			title : {
				button : true
			}
		},*/
		/*
		content: {
			//text: gJQ('#LoginForm'),
			text: '',
			button : true,
			title: {
				button : true
			}
		},
		
		position : {
			my : 'bottom center',
			at : 'top center',
			target : 'mouse',
			//viewport : gJQ('#calendar'),
			viewport : gJQ(window),
			adjust : {
				mouse : false,
				scroll : false
			}
		},
		events: {
			
			hide: function(event, api) {
				gJQ('#calendar').fullCalendar( 'unselect' );

	        },
		},
		show: {
			//event: event.type,
			//modal: true
			modal: {
				on: true,
				blur: false
			}
		}
	}).qtip('api');
	//console.log('salio');
	//console.log(to);
	return to;
}

function showEvent(idEvent,title, startDate, endDate,allDay) {
	
	var stringWhen;
	
	if(endDate == null || (allDay && startDate.toString() == endDate.toString())){
		stringWhen = startDate.format("ddd mmm dd yyyy") + ' all Day ';
	}else if(startDate.format("ddd mmm dd yyyy").toString() != endDate.format("ddd mmm dd yyyy").toString()){
		stringWhen = startDate.format("ddd mmm dd yyyy") + ' to ' + new Date(endDate).format("ddd mmm dd yyyy") + ' all days';
	}else{
		stringWhen = startDate.format("ddd mmm dd yyyy HH:MM") + ' to ' + new Date(endDate).format("HH:MM");
	}
	
	var content = '<form>'
			+ 'Event: <BR>'
			+ 'When: ' + stringWhen 
			+ '<input type="hidden" id="idEvent" name="idEventText" Value="'+ idEvent +'"/><br>'
			+ 'Name: <input type="text" id="titleText" name="titleText" Value="'+ title +'"/><br>'
			+ '<input type="hidden" id="startDate" name="startDateText" Value="' + startDate + '"/>'
			+ '<input type="hidden" id="endDate" name="endDateText" Value="' + endDate +'"/>'
			+ '<input type="hidden" id="allDay" name="allDayText" Value="' + allDay +'"/><br>';
			if(idEvent == undefined){
					content = content + '<input id="createEventButton" type="button" value="Create Event" onClick="createEvents(titleText.value,startDateText.value, endDateText.value, allDayText.value );" />' 
			}else{
					content = content + '<input id="updateEventButton" type="button" value="Update Event" onClick="updateEvent(idEventText.value, titleText.value, startDateText.value, endDateText.value, allDayText.value);" />'
					content = content + '<input id="deleteEventButton" type="button" value="Delete Event" onClick="deleteEvent(idEventText.value);" />'
			}
			content = content + '</form>';
			
	return content;
	
}



function createEvents(title, dateStart, dateEnd, allDay) {
	
	Visualforce.remoting.Manager.invokeAction(
			gCreatedEvent,
			title,  new Date(dateStart).getTime(), new Date(dateEnd).getTime(), allDay,
	        function(result, event) {
	            
	    		if (event.status) {
	    			
	    			var bAllDay = allDay === "true" ? true : false;
	    			var evt = {id:result.Id, title:title, start:dateStart, end:dateEnd, allDay:bAllDay};
	    			
	    			gJQ('#calendar').fullCalendar( 'renderEvent', evt);
	    			
	    			tooltip.hide();
	    			
	            }else if (event.type === 'exception') {
	            	//console.log('exception');
	            }else {
	            	//console.log('error');
	            }
	        }, 
	        {escape: true}
	    );
}
*/
function updateEvent(id, title, start, end, allDay, ciente, revertFunc) {
	
	Visualforce.remoting.Manager.invokeAction(
			gupdateEvent,
			id,title, new Date(start).getTime(), new Date(end).getTime(), allDay, ciente,
	        function(result, event) {
	            //console.log(result);
				
				//CONSOLE LOG UPDATE EVENT RESULT 
				//console.log('(metodo) updateEvent - (variable) result: ' + result);
				//console.log(result);
				
				if(result==''){
		    		if (event.status) {
		    			//gJQ('#calendar').fullCalendar( 'removeEvents', id );
		    			var bAllDay = allDay === "true" ? true : false;
		    			var evt = {id:id, title:title, start:start, end:end, allDay:bAllDay};
		    			//gJQ('#calendar').fullCalendar( 'renderEvent', evt);
		    			
		    			//tooltip.hide();
		            }	else if (event.type === 'exception') {
		            	//console.log('exception');
		            } else {
		            	//console.log('error');
		            }
				}else{
					if(String(result).indexOf('cliente não atende')!=-1 || String(result).indexOf('cliente no atiende')!=-1){
						if(confirm(result+' '+labelConfirm)){
							updateEvent(id, title, start, end, allDay, "true", revertFunc);
						}else{
							revertFunc();
						}
					}else if (result != 'null' && result != null){
						alert(result);
						revertFunc();
					}
				}
	        }, 
	        {escape: true}
	    );
}
/*
function deleteEvent(id) {
	
	Visualforce.remoting.Manager.invokeAction(
			gdeleteEvent,
			id,
	        function(result, event) {
	            //console.log(result);
	    		if (event.status) {
	    			//console.log(id);
	    			gJQ('#calendar').fullCalendar( 'removeEvents', [id] );
	    			tooltip.hide()
	    			
	            }	else if (event.type === 'exception') {
	            	//console.log('exception');
	            } else {
	            	//console.log('error');
	            }
	        }, 
	        {escape: true}
	    );
}
*/
function FocusOnInput(){
     document.getElementById("titleText").focus();
}
