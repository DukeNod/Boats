<?php

function form_posted_mailer_task ($action = null)
{
	_main_::depend('forms');
	$result = array();

	// Always posted fields (text/password/textarea/select/radio/...)
	$fields = array('subject', 'message');
	fields_fill($result, $fields); 
	fields_find($result, $fields);

	// Conditionally posted fields (checkbox)
	$fields = array('is_test');
	fields_fill($result, $fields, $action !== null ? 0 : null); 
	fields_find($result, $fields);

	// Full-text fields for auto-typographing.
	$fields = array('subject', 'message');
	fields_typograph($result, $fields);

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

function prepare_mailer_task (&$errors, &$data, $config, $enum)
{
}

function validate_mailer_task (&$errors, &$data, $config, $enum, $ignore_uploads = false)
{
	_main_::depend('validations', 'merges');

	validate_required($errors, $data, 'subject');
	validate_required($errors, $data, 'message');
	validate_required($errors, $data, 'groups_list');
	validate_required($errors, $data, 'is_test') && validate_boolean($errors, $data, 'is_test');

	if (!$ignore_uploads)
	{
	}
}

function predelete_mailer_task (&$errors, &$data, $config, $enum)
{
}

?>