<?php

function form_posted_subscriber ($action = null)
{
	$result = array();
	_main_::depend('forms');

	// Always posted fields (text/password/textarea/select/radio/...)
	$fields = array('email');
	fields_fill($result, $fields); 
	fields_find($result, $fields);

	// Conditionally posted fields (checkbox)
	$fields = array('is_active', 'is_tester');
	fields_fill($result, $fields, $action !== null ? 0 : null); 
	fields_find($result, $fields);

	// Conditionally posted fields (lists)
	$fields = array('groups_list');
	fields_fill($result, $fields, $action !== null ? array() : null); 
	fields_find($result, $fields);

	//dom-fixes
	if (is_array($result['groups_list']))
	{
		$tmp = array();
		foreach ($result['groups_list'] as $val)
		{
			$item = array();
			$item['id'    ] = isset($val['id'    ]) && strlen($val['id'    ]) ? $val['id'    ] : null;
			$item['remove'] = isset($val['remove']) && strlen($val['remove']) ? $val['remove'] : null; if ($item['remove']) { $action = 'remove_service'; }
			$item['append'] = isset($val['append']) && strlen($val['append']) ? $val['append'] : null; if ($item['append']) { $action = 'append_service'; }
			if ((strlen($item['id'])) && !$item['remove'])
				$tmp['group:'.count($tmp)] = $item;
		}
		$result['groups_list'] = $tmp;
	}

	return $result;
}

function form_posted_import ($action = null)
{
	$result = array();
	_main_::depend('forms');

	// Always posted fields (text/password/textarea/select/radio/...)
	$fields = array('text');
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
	fields_file($result, 'attach', _config_::$dir_for_linked . 'info/', _config_::$tmp_for_linked, true, false);

	// Conditionally posted fields (lists)
	$fields = array('groups_list');
	fields_fill($result, $fields, $action !== null ? array() : null); 
	fields_find($result, $fields);

	//dom-fixes
	if (is_array($result['groups_list']))
	{
		$tmp = array();
		foreach ($result['groups_list'] as $val)
		{
			$item = array();
			$item['id'    ] = isset($val['id'    ]) && strlen($val['id'    ]) ? $val['id'    ] : null;
			$item['remove'] = isset($val['remove']) && strlen($val['remove']) ? $val['remove'] : null; if ($item['remove']) { $action = 'remove_service'; }
			$item['append'] = isset($val['append']) && strlen($val['append']) ? $val['append'] : null; if ($item['append']) { $action = 'append_service'; }
			if ((strlen($item['id'])) && !$item['remove'])
				$tmp['group:'.count($tmp)] = $item;
		}
		$result['groups_list'] = $tmp;
	}

	return $result;
}

function prepare_subscriber (&$errors, &$data, $config, $enum)
{
}

function prepare_import (&$errors, &$data, $config, $enum)
{
	_main_::depend('validations', 'merges', 'uploads');

        $text = $data['text'];

	if (validate_optional_upload($errors, $data, 'attach') && validate_upload($errors, $data, 'attach', _config_::$ext_for_files, _config_::$dir_for_linked . 'info/', _config_::$tmp_for_linked))
	{
		$text .= file_get_contents($data['attach_path']);
	}

	if (preg_match_all("/[\\w\\d_\\.+-]+@[\\w\\d_\\.-]+/six", $text, $matches))
	{
		$data['emails'] = array_unique($matches[0]);

	}
}

function validate_subscriber (&$errors, &$data, $config, $enum, $ignore_uploads = false)
{
	_main_::depend('validations', 'merges');

	validate_required($errors, $data, 'is_active') && validate_boolean($errors, $data, 'is_active');
	validate_required($errors, $data, 'is_tester') && validate_boolean($errors, $data, 'is_tester');
	validate_required($errors, $data, 'email'    ) && validate_email($errors, $data, 'email');
	validate_required($errors, $data, 'code'     );

	/*
	if (preg_match_all("/[\\w\\d_\\.+-]+@[\\w\\d_\\.-]+/six", $data['email'], $matches))
	{
	        debug($matches); die;
		$data['emails'] = array_unique($matches[0]);

	}
	*/

	if (!$ignore_uploads)
	{
	}
}

function predelete_subscriber (&$errors, &$data, $config, $enum)
{
}

?>