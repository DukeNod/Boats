$(function(){

	$('.approve_button').click(function(){
		var approved = $(this).data('approved') ? 0 : 1;
		var obj = this;
		
		$.get(PUB_ROOT+'pays/approved/' + $(this).data('id') + '/' + approved + '/', function(data)
		{
			if (data.response.result == 'OK' && data.response.id)
			{
				if (approved == 1)
				{
					$(obj).find('img').attr('src', PUB_ROOT+'i/buttons/turnof'+$(obj).data('row')+'.gif');
					$(obj).attr('title', 'Подтверждён');
					$(obj).find('span').text('Подтверждён');
				}
				else
				{
					$(obj).find('img').attr('src', PUB_ROOT+'i/buttons/turnon'+$(obj).data('row')+'.gif');
					$(obj).attr('title', 'Подтвердить');
					$(obj).find('span').text('Не подтверждён');
				}
				
				$(obj).data('approved', approved);
			}
		}, 'json');
		
		return false;
	});
/*	
	$('.request_row').click(function(){
		$(this).siblings().removeClass('current_row');
		$(this).addClass('current_row');
	});
	
	$('.request_row').on('keypress', function(e){
		console.log(e.which);
	});
*/	
	$('.request_row').on('focus', function(e){
		$(this).siblings().removeClass('current_row');
		$(this).addClass('current_row');
	});
});
