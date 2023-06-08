<?php

function form_posted_linked_pict ($action = null)
{
	_main_::depend('forms');
	$result = array();

	// Always posted fields (text/password/textarea/select/radio/...)
	$fields = array('uplink_type', 'uplink_id', 'position', 'alt');
	fields_fill($result, $fields); 
	fields_find($result, $fields);

	// Conditionally posted fields (checkbox)
	$fields = array();
	fields_fill($result, $fields, $action !== null ? 0 : null); 
	fields_find($result, $fields);

	// Full-text fields for auto-typographing.
	$fields = array('alt');
	fields_typograph($result, $fields);

	// Fields with uploaded files.
	fields_file($result, 'small', _config_::$tmp_for_linked, false, true);
	fields_file($result, 'middle', _config_::$tmp_for_linked, false, true);
	fields_file($result, 'large', _config_::$tmp_for_linked, false, true);

	return $result;
}

function form_posted_linked_pict_import ($action = null)
{
	_main_::depend('forms');
	$result = array();

	if ($action == 'do')
	{
		// Always posted fields (text/password/textarea/select/radio/...)
		$fields = array('uplink_type', 'uplink_id', 'path', 'images');
		fields_fill($result, $fields); 
		fields_find($result, $fields);

	if (is_array($result['images']))
	{
		$tmp = array();
		foreach ($result['images'] as $val)
		{
			$delete = isset($val['delete']) && strlen($val['delete']) ? $val['delete'] : null;

		        if (!isset($val['large_name'])) $val['large_name'] = $val['real_name'];

			if ((strlen($val['large_name'])) && !$delete)
				$tmp['image:'.count($tmp)] = $val;
		}
		$result['images'] = $tmp;
	}
	
	}else
	{
		// Always posted fields (text/password/textarea/select/radio/...)
		$fields = array('uplink_type', 'uplink_id', 'path');
		fields_fill($result, $fields); 
		fields_find($result, $fields);
	}

	return $result;
}

function form_posted_linked_pict_upload ($action = null)
{
	_main_::depend('forms');
	$result = array();

	if ($action == 'do')
	{
		// Always posted fields (text/password/textarea/select/radio/...)
		$fields = array('uplink_type', 'uplink_id', 'path');
		fields_fill($result, $fields); 
		fields_find($result, $fields);

		fields_file($result, 'Filedata', _config_::$tmp_for_linked, false, true);
	}

	return $result;
}

function prepare_linked_pict_import (&$errors, &$data, $config, $enums, $uplink)
{
	$data['position'] = '<';

	if ($data['images']) foreach($data['images'] as &$v)
	{
		$v['large_path'] = realpath('../../uploads/'.$data['path'].'/'.$v['real_name']);
		$size = getimagesize($v['large_path']);
		$v['large_w'] = $size[0];
		$v['large_h'] = $size[1];
		$v['position'] = $data['position'];
		$v['uplink_type'] = $data['uplink_type'];
		$v['uplink_id'] = $data['uplink_id'];
		prepare_linked_pict($errors, $v, $config, $enums, $uplink);
	}
}

function prepare_linked_pict (&$errors, &$data, $config, $enums, $uplink)
{
	if ($config['resize'])
	{
		_main_::depend('uploads');

		if ($config['count'] > 1)
		{
			put_uploaded_image_if_needed($data, 'small', 'large');

			if ($config['large_limit_w']||$config['large_limit_h'])
				fit_uploaded_image_to_limits($data, 'large', $config['large_limit_w'], $config['large_limit_h']);

			if ($config['count'] == 3)
			{
				put_uploaded_image_if_needed($data, 'middle', 'large');
	
				if ($config['middle_limit_w']||$config['middle_limit_h'])
					fit_uploaded_image_to_limits($data, 'middle', $config['middle_limit_w'], $config['middle_limit_h']);

			}
		}

		if ($config['small_limit_w']||$config['small_limit_h'])
			fit_uploaded_image_to_limits($data, 'small', $config['small_limit_w'], $config['small_limit_h'], $config['cut']);

	}
}

function validate_linked_pict (&$errors, &$data, $config, $enums, $uplink, $ignore_uploads = false)
{
	_main_::depend('validations', 'merges');

	if ($uplink === null) validate_add_error($errors, 'uplink', 'absent');//NB: ignoring specific value, just by readability.
	validate_required($errors, $data, 'uplink_id');
	validate_required($errors, $data, 'position') && validate_position($errors, $data, 'position', get_fields($enums['siblings'], 'id'), false);
	validate_optional($errors, $data, 'alt'     );

	if (!$ignore_uploads)
	{
	        if (!if_delete_img($data, 'small'))
		if (validate_optional_upload($errors, $data, 'small') && validate_upload($errors, $data, 'small', _config_::$ext_for_images, _config_::$dir_for_linked . 'picts/small/' . $data['uplink_type'] . '/' . $data['uplink_id'] . '/', _config_::$tmp_for_linked))
		{
			validate_required($errors, $data, 'small_w') && validate_number($errors, $data, 'small_w', 1, $config['small_limit_w']);
			validate_required($errors, $data, 'small_h') && validate_number($errors, $data, 'small_h', 1, $config['small_limit_h']);
		}
	        if (!if_delete_img($data, 'middle'))
		if (validate_optional_upload($errors, $data, 'middle') && validate_upload($errors, $data, 'middle', _config_::$ext_for_images, _config_::$dir_for_linked . 'picts/middle/' . $data['uplink_type'] . '/' . $data['uplink_id'] . '/', _config_::$tmp_for_linked))
		{
			validate_optional($errors, $data, 'middle_w') && validate_number($errors, $data, 'middle_w', 1, $config['middle_limit_w']);
			validate_optional($errors, $data, 'middle_h') && validate_number($errors, $data, 'middle_h', 1, $config['middle_limit_h']);
		}
	        if (!if_delete_img($data, 'large'))
		if (validate_optional_upload($errors, $data, 'large') && validate_upload($errors, $data, 'large', _config_::$ext_for_images, _config_::$dir_for_linked . 'picts/large/' . $data['uplink_type'] . '/' . $data['uplink_id'] . '/', _config_::$tmp_for_linked))
		{
			validate_optional($errors, $data, 'large_w') && validate_number($errors, $data, 'large_w', 1, $config['large_limit_w']);
			validate_optional($errors, $data, 'large_h') && validate_number($errors, $data, 'large_h', 1, $config['large_limit_h']);
		}
	}
}

function validate_linked_pict_import (&$errors, &$data, $config, $enums, $uplink, $ignore_uploads = false)
{
	_main_::depend('validations', 'merges');

	if ($uplink === null) validate_add_error($errors, 'uplink', 'absent');//NB: ignoring specific value, just by readability.
	validate_required($errors, $data, 'uplink_id');
	validate_required($errors, $data, 'position') && validate_position($errors, $data, 'position', get_fields($enums['siblings'], 'id'), false);
//	validate_optional($errors, $data, 'alt'     );

	if (!$ignore_uploads && $data['images'])
	foreach($data['images'] as &$v)
	{
	        if (!if_delete_img($v, 'small'))
		if (validate_optional_upload($errors, $v, 'small') && validate_upload($errors1, $v, 'small', _config_::$ext_for_images, _config_::$dir_for_linked . 'picts/small/' . $data['uplink_type'] . '/' . $data['uplink_id'] . '/', _config_::$tmp_for_linked))
		{
			validate_required($errors, $v, 'small_w') && validate_number($errors, $v, 'small_w', 1, $config['small_limit_w']);
			validate_required($errors, $v, 'small_h') && validate_number($errors, $v, 'small_h', 1, $config['small_limit_h']);
		}
	        if (!if_delete_img($v, 'middle'))
		if (validate_optional_upload($errors, $v, 'middle') && validate_upload($errors1, $v, 'middle', _config_::$ext_for_images, _config_::$dir_for_linked . 'picts/middle/' . $data['uplink_type'] . '/' . $data['uplink_id'] . '/', _config_::$tmp_for_linked))
		{
			validate_optional($errors, $v, 'middle_w') && validate_number($errors, $v, 'middle_w', 1, $config['middle_limit_w']);
			validate_optional($errors, $v, 'middle_h') && validate_number($errors, $v, 'middle_h', 1, $config['middle_limit_h']);
		}
	        if (!if_delete_img($v, 'large'))
		if (validate_optional_upload($errors, $v, 'large') && validate_upload($errors1, $v, 'large', _config_::$ext_for_images, _config_::$dir_for_linked . 'picts/large/' . $data['uplink_type'] . '/' . $data['uplink_id'] . '/', _config_::$tmp_for_linked))
		{
			validate_optional($errors, $v, 'large_w') && validate_number($errors, $v, 'large_w', 1, $config['large_limit_w']);
			validate_optional($errors, $v, 'large_h') && validate_number($errors, $v, 'large_h', 1, $config['large_limit_h']);
		}
	}
}

function validate_linked_pict_import_first (&$errors_list, &$data, $config, $enums, $uplink)
{
	_main_::depend('validations', 'merges');

	if ($data['images'])
	foreach($data['images'] as $f=>&$v)
	{
		$errors = array();
		validate_optional_upload($errors, $v, 'large');
		validate_upload($errors, $v, 'large', _config_::$ext_for_images, _config_::$dir_for_linked . 'picts/large/' . $data['uplink_type'] . '/' . $data['uplink_id'] . '/', _config_::$tmp_for_linked);
		if ($errors['large_exists::'])
		{
			$errors_list['image:'.count($errors_list)] = array(
				'large_name' => $v['large_name']
			,	'real_name' => $v['real_name']
			,	'exists' => true
			);
			unset($data['images'][$f]);
		}
	}
}

function if_delete_img(&$data, $field)
{
        // Проверяем на загрузку нового файла.
//		&&((!$data[$field.'_temp'])||($data[$field.'_name']==basename($data[$field.'_temp']))))
	if ($data[$field.'_delete']&&(!$data[$field.'_path']))
		return true;

	// Если загрузили новый файл, отменяем признак удаление файла. Старый и так удалится.
	$data[$field.'_delete'] = null;
	return false;
}

function predelete_linked_pict (&$errors, &$data, $config, $enums, $uplink)
{
}

function list_linked_pict_import (&$dat, $path)
{
        _main_::depend('texts');

        $directory = '../../uploads/'.$path;
        $dat = array();

	if (($d = opendir($directory)) !== false)
	{
		while (($filename = readdir($d)) !== false)
		{
			$filepath = $directory . '/' . $filename;

			if (($filename == '.') 
				|| ($filename == '..') 
				|| (is_dir($filepath))
				|| (($p = strrpos($filename, '.')) === false)
				|| (!in_array(substr($filename, $p), _config_::$ext_for_images_only))
			)
				continue;

			$old_path = $filepath;
			$filename = transliterate($filename);
			$filepath = $directory . '/' . $filename;

			rename($old_path, $filepath);

			$dat['image:'.count($dat)] = array(
				'large_name' => $filename
			,	'real_name' => $filename
			,	'large_path' => $filepath
			);
		}
		closedir($d);
	}
}

?>