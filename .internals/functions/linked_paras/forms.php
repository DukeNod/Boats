<?php

function form_posted_linked_para ($action = null)
{
	_main_::depend('forms');
	$result = array();

	// Always posted fields (text/password/textarea/select/radio/...)
	$fields = array('uplink_type', 'uplink_id', 'position', 'clear', 'align', 'float', 'alt', 'name', 'text', 'url');
	fields_fill($result, $fields);
	fields_find($result, $fields);

	// Conditionally posted fields (checkbox)
	$fields = array();
	fields_fill($result, $fields, $action !== null ? 0 : null); 
	fields_find($result, $fields);

	// Full-text fields for auto-typographing.
	$fields = array('alt', 'name', 'text');
	fields_typograph($result, $fields);

	// Fields with uploaded files.
	fields_file($result, 'small', _config_::$tmp_for_linked, false, true);
	fields_file($result, 'large', _config_::$tmp_for_linked, false, true);

	return $result;
}

function prepare_linked_para (&$errors, &$data, $config, $enums, $uplink)
{
	_main_::depend('uploads');

	put_uploaded_image_if_needed($data, 'small', 'large');
	fit_uploaded_image_to_limits($data, 'small', $config['small_limit_w'], $config['small_limit_h']);
	fit_uploaded_image_to_limits($data, 'large', $config['large_limit_w'], $config['large_limit_h']);
}

function validate_linked_para (&$errors, &$data, $config, $enums, $uplink, $ignore_uploads = false)
{
	_main_::depend('validations', 'merges');

	if ($uplink === null) validate_add_error($errors, 'uplink', 'absent');//NB: ignoring specific value, just by readability.
	validate_required($errors, $data, 'position') && validate_position($errors, $data, 'position', get_fields($enums['siblings'], 'id'), false);
	validate_required($errors, $data, 'clear'   ) && validate_enum($errors, $data, 'clear', array('both','left','right','none'));
	validate_required($errors, $data, 'align'   ) && validate_enum($errors, $data, 'align', array('left','right','center','justify'));
	validate_required($errors, $data, 'float'   ) && validate_enum($errors, $data, 'float', array('above_center','above_left','above_right','below_center','below_left','below_right','float_left','float_right','table_left','table_right'));
	validate_optional($errors, $data, 'alt'     );
	validate_optional($errors, $data, 'name'    );
	validate_optional($errors, $data, 'text'    );
	validate_optional($errors, $data, 'url'    );

	if (!$ignore_uploads)
	{
	        if (!if_delete_para_img($data, 'small'))
		if (validate_optional_upload($errors, $data, 'small') && validate_upload($errors, $data, 'small', _config_::$ext_for_images, _config_::$dir_for_linked . 'paras/small/' . $data['uplink_type'] . '/' . $data['uplink_id'] . '/', _config_::$tmp_for_linked))
		{
			validate_required($errors, $data, 'small_w') && validate_number($errors, $data, 'small_w', 1, $config['small_limit_w']);
			validate_required($errors, $data, 'small_h') && validate_number($errors, $data, 'small_h', 1, $config['small_limit_h']);
		}
	        if (!if_delete_para_img($data, 'large'))
		if (validate_optional_upload($errors, $data, 'large') && validate_upload($errors, $data, 'large', _config_::$ext_for_images, _config_::$dir_for_linked . 'paras/large/' . $data['uplink_type'] . '/' . $data['uplink_id'] . '/', _config_::$tmp_for_linked))
		{
			validate_optional($errors, $data, 'large_w') && validate_number($errors, $data, 'large_w', 1, $config['large_limit_w']);
			validate_optional($errors, $data, 'large_h') && validate_number($errors, $data, 'large_h', 1, $config['large_limit_h']);
		}
	}
}

function if_delete_para_img(&$data, $field)
{
        // Проверяем на загрузку нового файла.
//		&&((!$data[$field.'_temp'])||($data[$field.'_name']==basename($data[$field.'_temp']))))
	if ($data[$field.'_delete']&&(!$data[$field.'_path']))
		return true;

	// Если загрузили новый файл, отменяем признак удаление файла. Старый и так удалится.
	$data[$field.'_delete'] = null;
	return false;
}

function predelete_linked_para (&$errors, &$data, $config, $enums, $uplink)
{
}

?>