<?php

$fields = array('required');

$dat=array();

	if (!empty($_GET['toggle']))
	{
		$column	= (int) $_GET['toggle'];
		if (0 < $column)
		{
			$key = '';
			if (isset($_GET['hidden']))
			{
				$key = (in_array($_GET['field'], $fields)) ? $_GET['field'] : '';
				$value	= ((int)$_GET['hidden'] > 0) ? 1 : 0;
			}

			$m = _main_::fetchModule('form_fields');
			$m->toggle($errors, $column, $key, $value);
			if (!count($errors))
			{
				$dat = array('field' => $value);
			}
		}
	}

_main_::depend('json');
echo put_json($dat);
_main_::commit();
exit;
?>