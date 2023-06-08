<?php

function form_posted_linked_video ($action = null)
{
	_main_::depend('forms');
	$result = array();

	// Always posted fields (text/password/textarea/select/radio/...)
	$fields = array('uplink_type', 'uplink_id', 'position', 'name', 'code');
	fields_fill($result, $fields); 
	fields_find($result, $fields);

	// Conditionally posted fields (checkbox)
	$fields = array();
	fields_fill($result, $fields, $action !== null ? 0 : null); 
	fields_find($result, $fields);

	// Full-text fields for auto-typographing.
	$fields = array('name');
	fields_typograph($result, $fields);

	return $result;
}

function prepare_linked_video (&$errors, &$data, $config, $enums, $uplink)
{
	_main_::depend('youtube');

	if ($data['code'])
	{
		$tmp = get_youtube_video_info($data['code']);
		if (!$data['name']) $data['name'] = $tmp['name'];
		$data['time'] = $tmp['time'];
		$data['preview'] = $tmp['preview'];
	}

}

function validate_linked_video (&$errors, &$data, $config, $enums, $uplink, $ignore_uploads = false)
{
	_main_::depend('validations', 'merges');

	if ($uplink === null) validate_add_error($errors, 'uplink', 'absent');//NB: ignoring specific value, just by readability.
	validate_required($errors, $data, 'position') && validate_position($errors, $data, 'position', get_fields($enums['siblings'], 'id'), false);
	validate_optional($errors, $data, 'name'    );
	validate_required($errors, $data, 'code'    );
	validate_optional($errors, $data, 'preview' );
	validate_optional($errors, $data, 'time'    );

	if (!$ignore_uploads)
	{
	}
}

function predelete_linked_video (&$errors, &$data, $config, $enums, $uplink)
{
}

?>