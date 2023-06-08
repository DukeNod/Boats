<?php

function form_posted_linked_file ($action = null)
{
	_main_::depend('forms');
	$result = array();

	// Always posted fields (text/password/textarea/select/radio/...)
	$fields = array('uplink_type', 'uplink_id', 'position', 'name');
	fields_fill($result, $fields); 
	fields_find($result, $fields);

	// Conditionally posted fields (checkbox)
	$fields = array();
	fields_fill($result, $fields, $action !== null ? 0 : null); 
	fields_find($result, $fields);

	// Full-text fields for auto-typographing.
	$fields = array('name');
	fields_typograph($result, $fields);

	// Fields with uploaded files.
	fields_file($result, 'attach' , _config_::$tmp_for_linked, true, true);
	fields_file($result, 'preview', _config_::$tmp_for_linked, false, true);

	return $result;
}

function prepare_linked_file (&$errors, &$data, $config, $enums, $uplink)
{
	_main_::depend('uploads');

	put_uploaded_image_as_preview($data, 'preview', 'attach');
	fit_uploaded_image_to_limits ($data, 'preview', $config['preview_limit_w'], $config['preview_limit_h']);
}

function validate_linked_file (&$errors, &$data, $config, $enums, $uplink, $ignore_uploads = false)
{
	_main_::depend('validations', 'merges');

	if ($uplink === null) validate_add_error($errors, 'uplink', 'absent');//NB: ignoring specific value, just by readability.
	validate_required($errors, $data, 'position') && validate_position($errors, $data, 'position', get_fields($enums['siblings'], 'id'), false);
	validate_optional($errors, $data, 'name'    );

	if (!$ignore_uploads)
	{
		if (validate_required_upload($errors, $data, 'attach') && validate_upload($errors, $data, 'attach', _config_::$ext_for_files, _config_::$dir_for_linked . 'files/attach/' . $data['uplink_type'] . '/' . $data['uplink_id'] . '/', _config_::$tmp_for_linked))
		{
			validate_required($errors, $data, 'attach_size') && validate_number($errors, $data, 'attach_size', 0, $config['attach_limit_size']);
			validate_optional($errors, $data, 'attach_type');
		}
		if (validate_optional_upload($errors, $data, 'preview') && validate_upload($errors, $data, 'preview', _config_::$ext_for_images, _config_::$dir_for_linked . 'files/preview/' . $data['uplink_type'] . '/' . $data['uplink_id'] . '/', _config_::$tmp_for_linked))
		{
			validate_optional($errors, $data, 'preview_w') && validate_number($errors, $data, 'preview_w', 1, $config['preview_limit_w']);
			validate_optional($errors, $data, 'preview_h') && validate_number($errors, $data, 'preview_h', 1, $config['preview_limit_h']);
		}
	}
}

function predelete_linked_file (&$errors, &$data, $config, $enums, $uplink)
{
}

?>