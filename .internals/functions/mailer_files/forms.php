<?php

function form_posted_mailer_file ($action)
{
	_main_::depend('forms');
	$result = array();

	// Always posted fields (text/password/textarea/select/radio/...)
	$fields = array('mailer_task', 'position', 'name');
	fields_fill($result, $fields); 
	fields_find($result, $fields);

	// Conditionally posted fields (checkbox)
	$fields = array();
	fields_fill($result, $fields, $action !== null ? 0 : null); 
	fields_find($result, $fields);

	// Full-text fields for auto-typographing.
	$fields = array();
	fields_typograph($result, $fields);

	// Fields with uploaded files.
	fields_file($result, 'attach', _config_::$dir_for_linked . 'mailer/', _config_::$tmp_for_linked, true, false);

	return $result;
}

function prepare_mailer_file (&$errors, &$data, $config, $enum, $uplink)
{
}

function validate_mailer_file (&$errors, &$data, $config, $enum, $uplink, $ignore_uploads = false)
{
	_main_::depend('validations', 'merges');

	if ($uplink === null) validate_add_error($errors, 'uplink', 'absent');//NB: ignoring specific value, just by readability.
	validate_required($errors, $data, 'position') && validate_position($errors, $data, 'position', get_fields($enum['siblings'], 'id'), false);
	validate_optional($errors, $data, 'name'    );

	if (!$ignore_uploads)
	{
		if (validate_required_upload($errors, $data, 'attach') && validate_upload($errors, $data, 'attach', _config_::$ext_for_files, _config_::$dir_for_linked . 'mailer/', _config_::$tmp_for_linked))
		{
			validate_required($errors, $data, 'attach_size') && validate_number($errors, $data, 'attach_size', 0, $config['attach_limit_size']);
			validate_optional($errors, $data, 'attach_type');
		}
	}
}

function predelete_mailer_file (&$errors, &$data, $config, $enum, $uplink)
{
}

?>