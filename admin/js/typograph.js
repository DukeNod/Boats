function typograph (input_element_id, state_element_id, url)
{
	var input_element = document.getElementById(input_element_id);
	var input_text    = get_text_of_control(input_element);
	ajax({
		url		: url,
		parse_response	: false,
		on_rawtext	: typograph_rawtext,
		on_exception	: ajax_elemental_on_exception,
		on_httperror	: ajax_elemental_on_httperror,
		on_timeout	: ajax_elemental_on_timeout,
		on_state	: ajax_elemental_on_state,
		on_start	: ajax_elemental_on_start,
		on_timer	: ajax_elemental_on_timer,
//		on_debug	: ajax_debug,
		interval	: 500,
		timeout		: 10000,
		elemental_id    : state_element_id,//for ajax_elemental
		input_element_id: input_element_id,//for typograph_rawtext
		rawtext		: input_text
		});
	return false;
}

function typograph_rawtext (params, response_text)
{
	ajax_elemental_on_rawtext(params, response_text);
	var input_element = document.getElementById(params.input_element_id);
	set_text_of_control(input_element, response_text);
	if ($) $(input_element).change();
}
