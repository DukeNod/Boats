<?php

Class Forms
{

	var $fields = array();

	function __construct($fields = [])
	{
		if (is_array($fields))
		foreach($fields as &$v)
		{
			if ($v) $this->fields[$v->name]=$v;
		}
	}

	function form_posted ($action = null)
	{
		$result = array();
		_main_::depend('forms');

		foreach($this->fields as $f=>&$v) $v->form_posted($result,$action);
	
		return $result;
	}


	function defs ()
	{
        $return = array();
		foreach($this->fields as $f=>$v)
		{
			if ($v->is_group)
			{
				if ($defs = $v->defs())
				{
					$return[$f] = $defs;
				}
			}
			else
			{
				if ($v->value !== null) $return[$f] = $v->value;
			}
		}

		return $return;
	}

	function prepare (&$errors, &$data, $config, $enums)
	{
		foreach($this->fields as $f=>&$v) $v->prepare($errors, $data, $config, $enums);
	}


	function validate (&$errors, &$data, $config, $enums, $ignore_uploads = false)
	{
		_main_::depend('validations', 'merges');

		foreach($this->fields as $f=>&$v) $v->validate($errors, $data, $config, $enums, $ignore_uploads);

	}


	function fetch_enums ($enums, $data)
	{
		$enums = [];

		foreach($this->fields as $f=>$v) $v->fetch_enums($enums, $data);

		_main_::put2dom('enums', $enums);
	}

	function post_update($id, &$data, &$orig = null)
	{
		foreach($this->fields as $f=>$v) $v->post_update($id, $data, $orig);
	}
	
	function remember (&$data)
	{
		foreach($this->fields as $f=>&$v) $v->remember($data);
	}


	function mail (&$errors, &$data, $doc, $email, $template, $files=array(), $send_copy=false)
	{

		// Потому как /*/done добавляется уже ПОСЛЕ операции, мы пихаем туда своё, а потом удалим.
		$node = _main_::put2dom('mail', $data);
		$node1 = _main_::put2dom('fields', $this->fields2dom($data));
		$node2 = _main_::put2dom('form', $this);

		$files = array();
		foreach($this->fields as $f=>&$v) if (get_class($v) == 'UploadFile')
		{
			if (strlen($data[$v->name.'_path'])) $files[$data[$v->name.'_name']] = file_get_contents(                            $data[$v->name.'_path']); else
			if (strlen($data[$v->name.'_temp'])) $files[$data[$v->name.'_name']] = file_get_contents(_config_::$tmp_for_linked . $data[$v->name.'_temp']); else
			if (strlen($data[$v->name.'_name'])) $files[$data[$v->name.'_name']] = file_get_contents(_config_::$dir_for_linked . 'forms/' . $v->name . '/' . $data[$v->name.'_name']);
		}

		_main_::depend('mail');
		$txt = _main_::transform_by_file($doc, _config_::$messages_dir . $template . _config_::$messages_ext);
		send_multipart_mail(_config_::$mail_from, $email, null, $txt, $files);
		if ($send_copy)
		send_multipart_mail(_config_::$mail_from, _config_::$mail_copy, null, $txt, $files);

		// Удаляем временный элемент, созданный для шаблона сообщения.
		$node->parentNode->removeChild($node);
		$node1->parentNode->removeChild($node1);
		$node2->parentNode->removeChild($node2);
	}

	function fields2dom($data)
	{
	        $res=array();

		foreach($this->fields as $f=>&$v) $res[get_class($v).":$f"] = clone $v->field2dom($data);

		/*
		foreach($this->fields as $f=>&$v)
		{
		        $v->value=$data[$v->name];
			$res[get_class($v).":$f"]=$v;
		}
		*/

		return ($res) ? $res : null;
	}

	// Обёртка для удобного создания полей форм
	public static function MakeField ($data)
	{
		if (!isset($data['value'])) $data['value'] = null;
		if (!isset($data['required'])) $data['required'] = null;
		
		$field = new $data['type']($data['name'], $data['value'], $data['required']);
		
		foreach($data as $f=>$v)
		{
			$field->{$f} = $v;
		}
		
		return $field;
	}
}

?>