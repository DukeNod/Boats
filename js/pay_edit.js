$(function()
{
	$.validator.addMethod("check_date_pay", function(value, element)
	{
		var date_str = $("input[name='date']").val();
		
		if (date_str)
		{
			var d = date.split('.');
			var date = new Date(d[2], d[1], d[0]);
			
			var tomorrow = new Date();
			tomorrow.setDate(tomorrow.getDate() + 1);
			
			return date <= tomorrow;
		}
		return true;
	}, "Дата подтвержденного платежа не может больше чем завтра");

	var formAdd = $("#form_add").validate(
	{
		submitHandler: function(form)
		{
			form.find('button[type=submit]').attr('disabled', true);
			form.submit();
		},
		invalidHandler: function(event, validator, form)
		{
			$(this).find('button[type=submit]').attr('disabled', false);
		},
		rules:
		{
			"date": {
				required: true
			},
			"summ": {
				required: true
			},
			"status": {
				check_date_pay: true
			}
		},
		errorElement: "div",
		errorPlacement: function ( error, element )
		{
			// Add the `help-block` class to the error element
			error.addClass( "help-block" );

			if ( element.prop( "type" ) === "checkbox" ) error.insertAfter( element.parent( "label" ) );
			else if ( element.parent().hasClass('input-group') ) error.insertAfter( element.parent( ".input-group" ) );
			else error.insertAfter( element );
		},
		highlight: function ( element, errorClass, validClass )
		{
			if ( $(element).hasClass('date-input') ) $( element ).parent().parent().addClass( "has-error" ).removeClass( "has-success" );
			else $( element ).parent().addClass( "has-error" ).removeClass( "has-success" );
		},
		unhighlight: function (element, errorClass, validClass)
		{
			if ( $(element).nextAll('[type="hidden"][strict="strict"]').val() == '' ) $( element ).parent().addClass( "has-error" ).removeClass( "has-success" );
			else if ( $(element).hasClass('date-input') ) $( element ).parent().parent().addClass( "has-success" ).removeClass( "has-error" );
			else $( element ).parent().addClass( "has-success" ).removeClass( "has-error" );
		},
		submitHandler: function(form)
		{
			$('button[type=submit]').attr('disabled', true);
			form.submit();
		}
	});

});