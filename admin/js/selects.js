function updateSelect(data,objid, first)
{
    var selectObj = document.getElementById(objid);
    if (selectObj) {
        if (selectObj.type == 'select-one') {
            selectObj.options.length = 0;
            if ((data.length == 0)) {
//                selectObj.disabled = true;
                    opt = new Option('', '', false, false);
                    selectObj.options[0] = opt;
                    selectObj.options[0].innerHTML = s_nofind;
            } else {
                selectObj.disabled = false;
		j=0;
		if (first){
                    opt = new Option('', '', false, false);
                    selectObj.options[0] = opt;
                    selectObj.options[0].innerHTML = first;
		    j=1;
		}
                for (i=0; i < data.length; i++) {
                    opt = new Option('', data[i].id, false, false);
                    selectObj.options[j] = opt;
                    selectObj.options[j].innerHTML = data[i].name;
		    j++;

                }
            }
        }

    }
}

function get_list (url, fn)
{
	ajax({
		url		: url,
		parse_response	: true,
		on_success	: function(params, response_object) { fn(response_object); },
		on_exception	: ajax_elemental_on_exception,
		on_httperror	: ajax_elemental_on_httperror,
		on_timeout	: ajax_elemental_on_timeout,
		on_state	: ajax_elemental_on_state,
		on_start	: ajax_elemental_on_start,
		on_timer	: ajax_elemental_on_timer,
//		on_debug	: ajax_debug,
		interval	: 500,
		timeout		: 10000
//		elemental_id    : prefix+'filter_status',//for ajax_elemental
//		object		: { text: id }
	});
}

function linked_items_update_select(obj, prefix, url)
{
	var row = obj; while (row && row.nodeName.toLowerCase() != 'tr') row = row.parentNode;
	var sel = obj;
	var val = sel.options[sel.selectedIndex].value;
	var txt = sel.options[sel.selectedIndex].text;
	var last = $.data(sel, 'sm_last_val');
	if (val == last)
	{
		// do nothing
	} else
	{
		// clear immediately (service is either empty or nonempty)
		var ele = $('#'+prefix+'items_new').get(0);
		ele.selectedIndex = 0;
		while (ele.options.length > 1) ele.remove(1);
		// call for data (only if service is selected)
		if (val != '')
			ajax({
				url		: ADM_ROOT+url,
				parse_response	: true,
				on_success	: function(params, response_object) {
					ajax_elemental_set(params, '');
					// additional clear (for two concurrent event not to overlap their data)
					var ele = $('#'+prefix+'items_new').get(0);
					ele.selectedIndex = 0;
					while (ele.options.length > 1) ele.remove(1);
					// fulfill control with data
					$.each(response_object, function(key, val)
					{
						$('<option>').val(val.id).html(val.name).appendTo(ele);
					});
					/*
						$.each(response_object.parts_categories, function(key, val)
						{
							$('<option>').val('').html(val.name).each(function(){this.disabled=true;}).appendTo(ele);
							$.each(val.parts, function(key, val)
							{
								$('<option>').val(val.id).html('\u00A0\u00A0\u00A0'+val.name).appendTo(ele);
							});
						});
					*/
				},
				on_exception	: ajax_elemental_on_exception,
				on_httperror	: ajax_elemental_on_httperror,
				on_timeout	: ajax_elemental_on_timeout,
				on_state	: ajax_elemental_on_state,
				on_start	: ajax_elemental_on_start,
				on_timer	: ajax_elemental_on_timer,
//				on_debug	: ajax_debug,
				interval	: 500,
				timeout		: 10000,
				elemental_id    : prefix+'filter_status',//for ajax_elemental
				object		: { category: val }
			});
	}
	return false;
}

function linked_items_add(obj, prefix, category_id)
{
	var row = obj; while (row && row.nodeName.toLowerCase() != 'tr') row = row.parentNode;
	var sel = obj;
	if (category_id !== undefined)
	var par = document.getElementById(prefix + category_id);
	var val = sel.options[sel.selectedIndex].value;
	var txt = sel.options[sel.selectedIndex].text;
	var last = $.data(sel, 'sm_last_val');
	if (category_id !== undefined)
	var txt = par.options[par.selectedIndex].text.replace('--','') +' -> '+txt;

	var name = obj.name.substring(0, obj.name.indexOf("["));

	if (val != '' && val != last)
	{
		var num = Math.random();
		var struct = $(''
			+'<tr class="flat" id="'+prefix+'parts_row_new'+num+'">'
			+'	<td class="flat insertLine">'
			+'		<input type="hidden" name="'+name+'[new'+num+'][id]"/>'
			+'		<span></span>'
			+'	</td>'
			+'	<td class="flat insertLine" style="padding-left: 5px;">'
			+'		<button class="inlineButton '+prefix+'items_remove" type="submit" name="'+name+'[new'+num+'][remove]" value="1" style="width: 20px; height: 20px;">'
			+'			<img src="'+ADM_ROOT+'img/buttons/delete2.gif" width="20" height="20" alt=""/>'
			+'		</button>'
			+'	</td>'
			+'</tr>'
		);
		$('input', struct).val(val);
		$('span' , struct).text(txt.replace(/(^[\s\u00A0]+)|([\s\u00A0]+$)/g, ''));

		$(row).before(struct);
		sel.selectedIndex = 0;
		$.data(sel, 'sm_last_val', val);
	}
	return false;
}

function linked_items_del(obj)
{
	var row = obj; while (row && row.nodeName.toLowerCase() != 'tr') row = row.parentNode;
	if (row) row.parentNode.removeChild(row);
	return false;
}

function ajax_update_items(prefix, element_id, sub_element_id, url, ajax_elemental, post_var_name)
{
$('#'+prefix+element_id)
.livequery('change', function(){
	var val = this.options[this.selectedIndex].value;

	// clear immediately (service is either empty or nonempty)
	var ele = $('#'+prefix+sub_element_id).get(0);
	ele.selectedIndex = 0;
	while (ele.options.length > 1) ele.remove(1);

	// call for data (only if service is selected)
	if (val != '')
	{
	var o = new Object();
	o[post_var_name] = val;

	ajax({
		url		: ADM_ROOT+url,
		parse_response	: true,
		on_success	: function(params, response_object) {

			ajax_elemental_set(params, '');
			// additional clear (for two concurrent event not to overlap their data)
			var ele = $('#'+prefix+sub_element_id).get(0);
			ele.selectedIndex = 0;
			while (ele.options.length > 1) ele.remove(1);

			// fulfill control with data
			if (response_object != 0)
			$.each(response_object, function(key, val)
			{
				$('<option>').val(val.id).html(val.name).appendTo(ele);
			});
		},
		on_exception	: ajax_elemental_on_exception,
		on_httperror	: ajax_elemental_on_httperror,
		on_timeout	: ajax_elemental_on_timeout,
		on_state	: ajax_elemental_on_state,
		on_start	: ajax_elemental_on_start,
		on_timer	: ajax_elemental_on_timer,
//		on_debug	: ajax_debug,
		interval	: 500,
		timeout		: 10000,
		elemental_id    : prefix+ajax_elemental,//for ajax_elemental
		object		: o
	});
	}
	return false;
});
}

function ajax_add_items(prefix, element_id, parent_element_id) // , element_name
{
//	if (element_name === undefined) element_name = 'items_list';

$('#'+prefix+element_id)
.livequery('change', function(){

	var element_name = this.name.substring(0, this.name.indexOf("["));

	var row = this; while (row && row.nodeName.toLowerCase() != 'tr') row = row.parentNode;
	var sel = this;
	if (parent_element_id !== undefined)
	var par = document.getElementById(prefix+parent_element_id);
	var val = sel.options[sel.selectedIndex].value;
	var txt = sel.options[sel.selectedIndex].text;
	var last = $.data(sel, 'sm_last_val');

	if (parent_element_id !== undefined)
	var txt = par.options[par.selectedIndex].text.replace('--','') +' -> '+txt;

	if (val != '' && $('input[value="'+val+'"]', row.parentNode).length == 0) //val != last
	{
		var num = Math.random();
		var struct = $(''
			+'<tr class="flat" id="'+prefix+'parts_row_new'+num+'">'
			+'	<td class="flat insertLine">'
			+'		<input type="hidden" name="'+element_name+'[new'+num+'][id]"/>'
			+'		<nobr></nobr>'
			+'	</td>'
			+'	<td class="flat insertLine" style="padding-left: 5px;">'
			+'		<button class="inlineButton '+prefix+'items_remove" type="submit" name="'+element_name+'[new'+num+'][remove]" value="1" style="width: 20px; height: 20px;">'
			+'			<img src="'+ADM_ROOT+'img/buttons/delete2.gif" width="20" height="20" alt="исключить"/>'
			+'		</button>'
			+'	</td>'
			+'</tr>'
		);
		$('input', struct).val(val);
		$('nobr' , struct).text(txt.replace(/(^[\s\u00A0]+)|([\s\u00A0]+$)/g, ''));
		if (par)
			$(row).prev().before(struct);
		else
			$(row).before(struct);
		//sel.selectedIndex = 0;
		//$.data(sel, 'sm_last_val', val);
	}
	sel.selectedIndex = 0;
	return false;
});
}

function ajax_del_items(prefix, element_id)
{
$('.'+prefix+element_id)
.livequery('click', function(){
	var row = this; while (row && row.nodeName.toLowerCase() != 'tr') row = row.parentNode;
	if (row) row.parentNode.removeChild(row);
	return false;
});
}

function ajax_add_field(prefix, element_id, element_name)
{
	if (element_name === undefined) element_name = 'items_list';

$('#'+prefix+element_id)
.livequery('click', function(){
	var row = this; while (row && row.nodeName.toLowerCase() != 'tr') row = row.parentNode;
	var sel = this;

		var num = Math.random();
		var struct = $(''
			+'<tr class="flat" id="'+prefix+'parts_row_new'+num+'">'
			+'	<td class="flat">'
			+'		<input class="controlString" type="text" name="'+element_name+'[]" value="" />'
			+'	</td>'
			+'	<td class="flat" style="padding-left: 5px;">'
			+'		<button class="inlineButton '+prefix+'items_remove" type="submit" value="1" style="width: 20px; height: 20px;">'
			+'			<img src="'+ADM_ROOT+'img/buttons/delete2.gif" width="20" height="20" alt="исключить"/>'
			+'		</button>'
			+'	</td>'
			+'</tr>'
		);
//			$(row).prev().before(struct);
			$(row).before(struct);
	return false;
});
}

function ajax_update_tree(prefix, element_id, sub_element_id, url, ajax_elemental, post_var_name)
{
$('#'+prefix+element_id)
.livequery('change', function(){
	var val = this.options[this.selectedIndex].value;

	// clear immediately (service is either empty or nonempty)
	var ele = $('#'+prefix+sub_element_id).get(0);
	ele.selectedIndex = 0;
	while (ele.options.length > 1) ele.remove(1);

	// call for data (only if service is selected)
	if (val != '')
	{
	var o = new Object();
	o[post_var_name] = val;

	ajax({
		url		: ADM_ROOT+url,
		parse_response	: true,
		on_success	: function(params, response_object) {

			ajax_elemental_set(params, '');
			// additional clear (for two concurrent event not to overlap their data)
			var ele = $('#'+prefix+sub_element_id).get(0);
			ele.selectedIndex = 0;
			while (ele.options.length > 1) ele.remove(1);

			// fulfill control with data
			if (response_object != 0)
			{
			        return_array = {val: new Array()};
				requrse_ajax_to_array(response_object, return_array, '');
				$.each(return_array.val, function(key, val)
				{
					$('<option>').val(val.id).html(val.name).appendTo(ele);
				});
			}
		},
		on_exception	: ajax_elemental_on_exception,
		on_httperror	: ajax_elemental_on_httperror,
		on_timeout	: ajax_elemental_on_timeout,
		on_state	: ajax_elemental_on_state,
		on_start	: ajax_elemental_on_start,
		on_timer	: ajax_elemental_on_timer,
//		on_debug	: ajax_debug,
		interval	: 500,
		timeout		: 10000,
		elemental_id    : prefix+ajax_elemental,//for ajax_elemental
		object		: o
	});
	}
	return false;
});
}

function requrse_ajax_to_array(response_object, return_array, level)
{
	$.each(response_object, function(key, val)
	{
	        return_array.val[return_array.val.length] = {'id': val.id, 'name': level+val.name}
	        if (val.category_tree != null)
		        requrse_ajax_to_array(val.category_tree, return_array, level+'--');
	});
}
