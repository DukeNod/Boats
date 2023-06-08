function save_row(obj)
{
	$tr = $(obj).closest('tr');
	
	var data = {};
	
	$tr.find('input').each(function() { 
		data[this.name] = this.value;
	});
	
	$.post(PUB_ROOT+'daily/edit/' + ($tr.data('id')?$tr.data('id')+'/':''), data, function(data)
	{
		if (data.response.result == 'OK' && data.response.id)
		{
			$(obj).closest('tr').data('id', data.response.id);
		}
	}, 'json');
}

$(function(){

	$('#daily-table .daily_input').on('input', function(){
	
		if ($(this).data('save_time')) clearTimeout($(this).data('save_time'));
		
		$(this).data('save_time', setTimeout(save_row, 500, this));
	});
	
});
