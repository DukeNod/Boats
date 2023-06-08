		        function refresh_list()
		        {
                		$("#popup_window").hide();
				$("#ImageBoxOverlay").hide();

				var url = window.location.href;
				if (url.substr(-1) == '#') url = url.substr(0, url.length-1);

				if (url.indexOf('?') != -1) url += '&ajax=1';
				else url += '?ajax=1';

		        	$.ajax({
		        		url: url,
		        		success: function(data){
						$('#listTableHide').hide();
		        			$('#listDiv').html(data);
						sorters_update();
		        		//	catch_list();
		        		},
		        		beforeSend: function(){
		        			list_wait();
		        		}
		        	});
		        }

			function cancel_all()
			{
			        if (window.edit_start == 1)
			        {
				$('.cancel').each(function(){
					var td = this; while (td && (td.nodeName.toLowerCase() != 'td' || !$(td).hasClass('listCellData') )) td = td.parentNode;
					$(td).html(window.old_content);
				});
					window.old_content = ''
					window.edit_start = 0;
				}
			}

			function list_wait()
			{
				$('#listTableHide').height($('#listDiv').height());
				$('#listTableHide').width($('#listDiv').width());
				var p = $('#listDiv').offset();
				$('#listTableHide').css({'left': p.left, 'top': p.top});
				$('#listTableHide').show();
			}

			function error_message(msg)
			{
				var content = $('#popup__content');
				content.html(msg);
				set_ajax_window_coord();
				$("#popup_window").show();
			        $("#ImageBoxOverlay").height($(document).height());
	        		$("#ImageBoxOverlay").width($(document).width());
				$("#ImageBoxOverlay").show();
			}

			function toggleCheckBox(field, value)
			{

				var tr = parentTag(this, 'tr'); // this; while (tr && tr.nodeName.toLowerCase() != 'tr') tr = tr.parentNode;
			        var current_id = tr.id.substr(3);

				var table = parentTag(row, 'table');
				var module_url = $(table).attr('data-url');

		        	$.ajax({
					url: module_url + '/toggle/' + current_id + '/' + field + '/' + value +'?ajax=1',
	        			success: function(data){
					        refresh_list();
	        			},
		        		beforeSend: function(){
						list_wait();
	        			}
				});

				return false;
			}

	function TextEditSubmit(obj, button)
	{
		        //var button = $(this);
			var form = obj; while (form && form.nodeName.toLowerCase() != 'form') form = form.parentNode;
			var options = { 
			        //target:	'#popup__content',   // target element(s) to be updated with server response 
				//url:	url,        // override for form's 'action' attribute 
				type:	'POST',  // 'get' or 'post', override for form's 'method' attribute 
			        //dataType:  'xml'        // 'xml', 'script', or 'json' (expected server response type) 
		        	//beforeSubmit:  formWait,  // pre-submit callback 
			        //success:       formSuccess  // post-submit callback 
		        	// other available options: 
		        	//clearForm: true        // clear all form fields after successful submit 
			        //resetForm: true        // reset the form after successful submit 
			 
		        	// $.ajax options can be used here too, for example: 
		        	//timeout:   3000 
		        
			        beforeSubmit: function() {
					//var content = $('#popup__content');
                			button.html('<img class="ajax-loader" style="vertical-align: middle;" src="'+ADM_ROOT+'img/ajax-loader2.gif">');
			        },

			        success: function(response_text) {
			                $('body').append(response_text);
                			button.html('<a href="#" class="confirm"><img src="'+ADM_ROOT+'img/icons/button_ok.png" style="vertical-align: middle;"/>');
					//ajax_elemental_set(params, '');
					//catch_ajax_window(params, response_text);
			        }
			}; 

		        $(form).ajaxSubmit(options);
			return false;
	}

function sorters_update()
{
				$(".listTable").tableDnD({
					onDragClass: "myDragClass",
					onDrop: function(table, row) {

					        var value = '';
					        var current_id = row.id.substr(3);

						prev = previousTag(row);
					        if (prev.cells[0].tagName != 'TH')
					        {
					                value = '>' + prev.id.substr(3);
					        }else
					        if  (next = nextTag(row))
					        {
					                value = '<' + next.id.substr(3);
					        }

					        if (value)
					        {
							var module_url = $(table).attr('data-url');
					        	$.ajax({
		        					url: module_url + '/toggle/' + current_id + '/position/' + value +'?ajax=1',
					        		success: function(data){
								        refresh_list();
					        		},
					        		beforeSend: function(){
		        						list_wait();
					        		}
		        				});
					        }
					},
					dragHandle: ".dragHandle"
					/*
					onDragStart: function(table, row) {
					},
					*/
				});
}

function disableSelectiong(obj)
{
	if($.browser.mozilla){//Firefox
                $(obj).css('MozUserSelect','none');
            }else if($.browser.msie){//IE
                $(obj).bind('selectstart',function(){return false;});
            }else{//Opera, etc.
                $(obj).mousedown(function(){return false;});
            }
}
function clearSelection() {
    if(document.selection && document.selection.empty) {
        document.selection.empty();
    } else if(window.getSelection) {
        var sel = window.getSelection();
        sel.removeAllRanges();
    }
}

$(function(){
	/*
				$('.delete_link').livequery('click', function(){
					ajax_window(this.href);
					return false;
				});
				
				$('.a-moveup').livequery('click', function(){
					var row = this; while (row && row.nodeName.toLowerCase() != 'tr') row = row.parentNode;
				        var current_id = row.id.substr(3);
					var table = parentTag(row, 'table');
					var module_url = $(table).attr('data-url');

			        	$.ajax({
        					url: module_url + '/moveup/' + current_id +'?ajax=1',
			        		success: function(data){
						        refresh_list();
			        		}
        				});
					return false;
				});

				$('.a-movedn').livequery('click', function(){
					var row = parentTag(this, 'tr'); // this; while (row && row.nodeName.toLowerCase() != 'tr') row = row.parentNode;
				        var current_id = row.id.substr(3);
					var table = parentTag(row, 'table');
					var module_url = $(table).attr('data-url');

			        	$.ajax({
        					url: module_url + '/movedn/' + current_id +'?ajax=1',
			        		success: function(data){
						        refresh_list();
			        		}
        				});
					return false;
				});
				
				*/
				sorters_update();
	
	$('.controlString').livequery('click', function(event){
		event.stopPropagation();
	});
	$('.controlSelect').livequery('click', function(event){
		event.stopPropagation();
	});
	$('.controlDateOnly').livequery('click', function(event){
		event.stopPropagation();
	});
	$('#calendarDiv').livequery('click', function(event){
		event.stopPropagation();
	});

	$('.cancel', this).livequery('click', function(){
		cancel_all();
		return false;
	});

	$('.confirm', this).livequery('click', function(event){
		event.stopPropagation();
		TextEditSubmit(this, $(this));
		return false;
	});

	$('.typeTextField').livequery('dblclick', function(event){

		window.old_content = $(this).html();
		window.edit_start = 1;
		
		var tr = parentTag(this, 'tr');
	        var current_id = tr.id.substr(3);
		var table = parentTag(tr, 'table');
		var module_url = $(table).attr('data-url');

		$(this).html('<form action="'+module_url+'/toggle/'+current_id+'?ajax=1"><nobr><input class="controlString" type="text" name="'+$(this).attr('data-name')+'" value="'+$(this).attr('data-value')+'" style="width: 150px;" /><a href="#" class="confirm"><img src="'+ADM_ROOT+'img/icons/button_ok.png" style="vertical-align: middle;"/></a> <a href="#" class="cancel"><img src="'+ADM_ROOT+'img/icons/button_cancel.png" style="vertical-align: middle;" /></a></nobr></form>');

		$('.controlString', this).livequery('keypress', function(e) {
			var code = e.keyCode || e.which;
			if(code == 13) { //Enter keycode
				TextEditSubmit(this, $('.confirm', this.parentNode));
				return false;
			}
		});

		clearSelection();
		return false;
	});
	
	$('.typeDataField').livequery('dblclick', function(event){

		window.old_content = $(this).html();
		window.edit_start = 1;

		var value = $('nobr', this).html();
		
		var tr = parentTag(this, 'tr');
	        var current_id = tr.id.substr(3);
		var table = parentTag(tr, 'table');
		var module_url = $(table).attr('data-url');

		$(this).html('<form action="'+module_url+'/toggle/'+current_id+'?ajax=1">\
					<table class="flatTable"><tr class="flatRow">\
						<td class="flatCell">\
							<input class="controlDateOnly" type="text" name="'+$(this).attr('data-name')+'" id="'+prefix+$(this).attr('data-name')+'" value="'+value+'"/>\
						</td>\
						<td class="flatCell">\
							<img src="'+PUB_ROOT+'images/calendar.gif" width="24" height="18" alt=""\
							 onclick="event.stopPropagation();displayCalendar(document.getElementById(\''+prefix+$(this).attr('data-name')+'\'), \'dd.mm.yyyy\', this, false)"/>\
						</td>\
						<td class="flatCell">\
							<a href="#" class="confirm"><img src="'+ADM_ROOT+'img/icons/button_ok.png" style="vertical-align: middle;"/></a>\
						</td>\
						<td class="flatCell">\
							<a href="#" class="cancel"><img src="'+ADM_ROOT+'img/icons/button_cancel.png" style="vertical-align: middle;" /></a>\
						</td>\
					</tr></table>\
		</form>');

		$('.controlDateOnly', this).livequery('keypress', function(e) {
			var code = e.keyCode || e.which;
			if(code == 13) { //Enter keycode
				TextEditSubmit(this, $('.confirm', this.parentNode));
				return false;
			}
		});

		clearSelection();
		return false;
	});

	$('.typeSelectList').livequery('dblclick', function(event){

		window.old_content = $(this).html();
		window.edit_start = 1;

		var value = $(this).attr('data-value');
		
		var tr = parentTag(this, 'tr');
	        var current_id = tr.id.substr(3);
		var table = parentTag(tr, 'table');
		var module_url = $(table).attr('data-url');

		$(this).html('<form action="'+module_url+'/toggle/'+current_id+'?ajax=1"><nobr>\
					<select class="controlSelect" name="'+$(this).attr('data-name')+'">\
					</select>\
					<a href="#" class="confirm"><img src="'+ADM_ROOT+'img/icons/button_ok.png" style="vertical-align: middle;"/></a>\
					<a href="#" class="cancel"><img src="'+ADM_ROOT+'img/icons/button_cancel.png" style="vertical-align: middle;" /></a>\
		</nobr></form>');

		var ele = $('select', this).get(0);

		$.each(lists[$(this).attr('data-name')], function(key, val)
		{
			var op = $('<option>').val(val.id).html(val.name);
			if (val.id == value) op.attr('selected', 'selected');
			op.appendTo(ele);
		});

		clearSelection();
		return false;
	});

	$('.typeSelect').livequery('dblclick', function(event){

		window.old_content = $(this).html();
		window.edit_start = 1;

		var value = $(this).attr('data-value');
		
		var tr = parentTag(this, 'tr');
	        var current_id = tr.id.substr(3);
		var table = parentTag(tr, 'table');
		var module_url = $(table).attr('data-url');

		$(this).html('<form action="'+module_url+'/toggle/'+current_id+'?ajax=1"><nobr>\
					<select class="controlSelect" name="'+$(this).attr('data-name')+'">\
					</select>\
					<a href="#" class="confirm"><img src="'+ADM_ROOT+'img/icons/button_ok.png" style="vertical-align: middle;"/></a>\
					<a href="#" class="cancel"><img src="'+ADM_ROOT+'img/icons/button_cancel.png" style="vertical-align: middle;" /></a>\
		</nobr></form>');

		var ele = $('select', this).get(0);

		if (lists[$(this).attr('data-name')+'_empty'] != '')
		{
			var op = $('<option>').val("").html(lists[$(this).attr('data-name')+'_empty']);
			op.appendTo(ele);
		}

		$.each(lists[$(this).attr('data-name')], function(key, val)
		{
			var op1 = $('<option>').val(val.id).html(val.name);
			if (val.id == value) op1.attr('selected', 'selected');
			op1.appendTo(ele);
		});

		clearSelection();
		return false;
	});

	$('.typeSelectText').livequery('dblclick', function(event){

		window.old_content = $(this).html();
		window.edit_start = 1;

		var value = $(this).attr('data-value');
		
		var tr = parentTag(this, 'tr');
	        var current_id = tr.id.substr(3);
		var table = parentTag(tr, 'table');
		var module_url = $(table).attr('data-url');

		$(this).html('<form action="'+module_url+'/toggle/'+current_id+'?ajax=1"><nobr>\
					<select class="controlSelect" name="'+$(this).attr('data-name')+'">\
					</select>\
					<a href="#" class="confirm"><img src="'+ADM_ROOT+'img/icons/button_ok.png" style="vertical-align: middle;"/></a>\
					<a href="#" class="cancel"><img src="'+ADM_ROOT+'img/icons/button_cancel.png" style="vertical-align: middle;" /></a>\
		</nobr></form>');

		var ele = $('select', this).get(0);

		if (lists[$(this).attr('data-name')+'_empty'] != '')
		{
			var op = $('<option>').val("").html(lists[$(this).attr('data-name')+'_empty']);
			op.appendTo(ele);
		}

		$.each(lists[$(this).attr('data-name')], function(key, val)
		{
			var op1 = $('<option>').html(val); //.val(val)
			if (val == value) op1.attr('selected', 'selected');
			op1.appendTo(ele);
		});

		clearSelection();
		return false;
	});

	$('.typeCheckBox a').livequery('click', function(event){
		var tr = parentTag(this, 'tr');
	        var current_id = tr.id.substr(3);
		var table = parentTag(tr, 'table');
		var module_url = $(table).attr('data-url');

        	$.ajax({
			url: module_url + '/toggle/' + current_id + '/' + $(this).attr('data-name') + '/' + $(this).attr('data-value') +'?ajax=1',
       			success: function(data){
				$('#listTableHide').hide();
			        // refresh_list();
		                $('body').append(data);
       			},
        		beforeSend: function(){
				list_wait();
       			}
		});

		clearSelection();
		return false;
	});

	$('body').click(function(){
			cancel_all();
	});
});
