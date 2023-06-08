<?php

$fields = array('public');

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

			$m = _main_::fetchModule('pages');
			$m->update_public ($column, $value);

			$dat = array('field' => $value);
			/*
			$m->toggle($errors, $dat, $column, $key, $value);
			if (!count($errors))
			{
				$dat = array('field' => $value);
			}
			*/
		}
	}

_main_::depend('json');
echo put_json($dat);
_main_::commit();
exit;
?>