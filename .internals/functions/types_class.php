<?php
// Version 1.1

Class BaseType
{
	var $name;
	var $input_name;
	var $value;
	var $text;
	var $required;
	var $comment;
	var $title;
	var $list = 0;
	var $listedit = 0;
	var $edit = 1;
	var $notitle = 0;
	var $nodb = 0;
	var $field_comment;
	var $is_group = 0;

	function __construct($name,$value=null,$required=false)
	{
		$this->name=$name;
		$this->input_name = $name;
		$this->element_id = $name;
		$this->value = $value;
		$this->required = $required;
	}

	function form_posted(&$result, $action=null, $arrays = null)
	{
		fields_fill($result, $this->name); 
		fields_find($result, $this->name, $arrays);
	}

	function set_filter(&$errors, &$data)
	{
		$this->value = $data[$this->name];
	}

	function prepare(&$errors, &$data, $config, $enums)
	{
	}

	function predelete (&$errors, &$data, $config, $enums)
	// errors - ошибки обработки формы
	// data - данные формы $data[$this->name]
	// config - атавизм
	// enums - бизнес логика
	{
	}

	function fetch_enums (&$enums, &$data)
	{
	}

	function validate (&$errors, &$data, $config, $enums, $ignore_uploads = false)
	{
	        if ($this->required)
			validate_required($errors, $data, $this->name);
		else
			validate_optional($errors, $data, $this->name);

		if (!$ignore_uploads)
		{
		}
	}

	function remember (&$data)
	{
	}

	function post_update($id, &$data)
	{
	}

	function post_select(&$data)
	{
	}

	function sql_set(&$data)
	{
	}

	function sql_list($table = '')
	{
		if ($this->nodb)
		{
			return "";
		}
		else
		{
			if ($table) $table .= '.';
			return " {$table}`{$this->name}` ";
		}
	}

	function delete($ids)
	{
	}

	function prepare_filter(&$filters)
	{
		$filters[$this->name] = $this->value;
	}

	function field2dom(&$data)
	{
		$this->value = isset($data[$this->name]) ? $data[$this->name] : null;
		return $this;
	}
	
    public function __call($closure, $args)
    {
        return call_user_func_array($this->{$closure}->bindTo($this),$args);
    }

    public function __toString()
    {
        return call_user_func($this->{"__toString"}->bindTo($this));
    }
}

Class TextField extends BaseType
{
	var $cssClass;

	function __construct($name,$value=null,$required=false)
	{
		parent::__construct($name, $value, $required);
		$this->list = 1;
		$this->listedit = 1;
		$this->cssClass = 'controlString';
	}

	var $typograph = false;

	function form_posted(&$result, $action=null, $arrays = null)
	{
		fields_fill($result, $this->name); 
		fields_find($result, $this->name, $arrays);

		if ($this->typograph) fields_typograph($result, $this->name);
	}

	function sql_set(&$data)
	{
		if ($this->nodb)
		{
			return "";
		}
		else
		{
			return " `{$this->name}` = "._main_::sql_quote($data[$this->name])."\n";
		}
	}
}

Class GroupField extends BaseType
{
	var $fields;

	function __construct($name,$value=null,$required=false)
	{
		parent::__construct($name, $value, $required);
		$this->is_group = 1;
	}
	
	function form_posted(&$result, $action=null, $arrays = null)
	{
		if ($arrays === null) $arrays = array($_POST, $_GET);
		
		foreach ($arrays as $array)
			if (array_key_exists($this->name, $array))
			{
				$result[$this->name] = [];
				foreach($this->fields as $field)
				{
					$field->form_posted($result[$this->name], $action, [ $array[$this->name] ]);
				}
				break;
			}
			
	}

	function set_filter(&$errors, &$data)
	{
		if (isset($data[$this->name]))
		foreach($this->fields as $field)
		{
			$field->set_filter($errors, $data[$this->name]);
		}
	}

	function prepare(&$errors, &$data, $config, $enums)
	{
		foreach($this->fields as $field)
		{
			$field->prepare($errors, $data[$this->name], $config, $enums);
		}
	}

	function predelete (&$errors, &$data, $config, $enums)
	{
		foreach($this->fields as $field)
		{
			$field->predelete($errors, $data[$this->name], $config, $enums);
		}
	}

	function fetch_enums (&$enums, &$data)
	{
		foreach($this->fields as $field)
		{
			$field->fetch_enums($enums, $data[$this->name]);
		}
	}

	function validate (&$errors, &$data, $config, $enums, $ignore_uploads = false)
	{
		foreach($this->fields as $field)
		{
			$field->validate($errors, $data[$this->name], $config, $enums, $ignore_uploads);
		}
	}

	function remember (&$data)
	{
		foreach($this->fields as $field)
		{
			$field->remember($data[$this->name]);
		}
	}

	function post_update($id, &$data)
	{
		foreach($this->fields as $field)
		{
			$field->post_update($id, $data[$this->name]);
		}
	}

	function post_select(&$data)
	{
		foreach($this->fields as $field)
		{
			$field->post_select($data[$this->name]);
		}
	}

	function sql_set(&$data)
	{
		$val = [];
		foreach($this->fields as $field)
		{
			if($tmp = $field->sql_set($data[$this->name]))
			{
				$val[] = $tmp;
			}
		}
		
		return ($val) ? ' '.join(',', $val).' ' : '';
	}

	function sql_list($table = '')
	{
		$val = [];
		foreach($this->fields as $field)
		{
			if($tmp = $field->sql_list($table))
			{
				$val[] = $tmp;
			}
		}
		
		return ($val) ? ' '.join(',', $val).' ' : '';
	}

	function delete($ids)
	{
		foreach($this->fields as $field)
		{
			$field->delete($ids);
		}
	}

	function prepare_filter(&$filters)
	{
		foreach($this->fields as $field)
		{
			$field->prepare_filter($filters);
		}
	}

	function field2dom(&$data)
	{
		#if (!$this->input_name) $this->input_name = $this->name;
		#else $this->input_name .= '['.
		$res = [];
		foreach($this->fields as $f=>&$v)
		{
			$v->input_name = $this->input_name.'['.$v->name.']';
			$v->element_id = $this->element_id.'_'.$v->element_id;
			
			$field = get_class($v).":".$v->name;
			
			$res[$field] = clone $v->field2dom($data[$this->name]);
			
			$res[$field]->name = $res[$field]->input_name;
		}
		$this->fields = $res;
		
		return $this;
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
}

Class TextFieldPrefix extends TextField
{
	var $prefix = "";
}

// Текстовая область. Отличается от тексового поля только в отображении в шаблоне.
Class TextArea extends TextField
{
	var $rows;

	function __construct($name,$value=null,$required=false)
	{
		parent::__construct($name, $value, $required);
		$this->list = 0;
		$this->listedit = 0;
		$this->rows = 10;
	}
}

Class TextButton extends TextField
{
	var $rows;

	function __construct($name,$value=null,$required=false)
	{
		parent::__construct($name, $value, $required);
		$this->list = 0;
		$this->listedit = 0;
		$this->rows = 10;
	}
}

Class DateField extends TextField
{
	var $daytime=0;
	var $mindate = null;
	var $maxdate = null;
	var $format = null;

	function set_filter(&$errors, &$data)
	{
		if($this->daytime>0 && preg_match("#^[12][0129]\d\d-[01]\d-[0-3]\d\s[012]\d:[0-5]\d:[0-5]\d$#", $data[$this->name])) $data[$this->name]=date('Y-m-d H:i:s', strtotime($data[$this->name])+$this->daytime);
		parent::set_filter($errors, $data);
	}

	function validate (&$errors, &$data, $config, $enums, $ignore_uploads = false)
	{
		if ($this->required)
			$result = validate_required($errors, $data, $this->name);
		else
			$result = validate_optional($errors, $data, $this->name);
			
		if ($result)
			validate_datetime($errors, $data, $this->name);
	}
}

Class DateTimeField extends DateField
{
}

Class DatePeriodField extends TextField
{
	/*
	function form_posted(&$result, $action=null, $arrays = null)
	{
	        $fields = array($this->name.'_from', $this->name.'_to');
		fields_fill($result, $fields); 
		fields_find($result, $fields, $arrays);
	}

	function validate (&$errors, &$data, $config, $enums, $ignore_uploads = false)
	{
	        $fields = array($this->name.'_from', $this->name.'_to');
	        if ($this->required)
	        {
			$result = validate_required($errors, $data, $this->name.'_from');
			$result2 = validate_required($errors, $data, $this->name.'_to');
		}else
		{
			$result = validate_optional($errors, $data, $this->name.'_from');
			$result2 = validate_optional($errors, $data, $this->name.'_to');
		}
		if ($result)
			validate_datetime($errors, $data, $this->name.'_from');
		if ($result2)
			validate_datetime($errors, $data, $this->name.'_to');
	}
	*/

	function prepare_filter(&$filters)
	{
		$filters[$this->name.'_from'] = $this->value;
		$filters[$this->name.'_to'] = $this->value;
	}

	function field2dom(&$data)
	{
$this->value = array('from'=>$data[$this->name.'_from'], 'to'=>$data[$this->name.'_to']);
		return $this;
	}
}

Class SqlSelected extends TextField
{
	var $sql_list_str;

	function form_posted(&$result, $action=null, $arrays = null)
	{
	}

	function validate (&$errors, &$data, $config, $enums, $ignore_uploads = false)
	{
	}

	function sql_list($table = '')
	{
		if ($table) $table .= '.';
		if ($this->sql_list_str)
			return " {$this->sql_list_str} as `{$this->name}`";
		else
			return "";
			#throw new exception("sql_list_str no set for '".get_class($m)."' ({$this->name}).");
	}

	function sql_set(&$data)
	{
		return "";
	}
}

Class PriceField extends TextField
{
}

Class Radio extends TextField
{
}

Class TextFieldPassword extends TextField
{
}

// Выбор из заданого списка, в БД схораняется id (ключ) значенияю.
Class Select extends TextField
{
	var $values_list;
	var $empty;
	var $text;

	function field2dom(&$data)
	{
	    $val = $this->values_list;
	    $this->values_list = array();
	    $i = 0;
		foreach($val as $f=>$v) { $i++; $this->values_list['value:'.$i] = array('id' => $f, 'value' =>$v); }
		$this->value = @$data[$this->name];
		return $this;
	}
}

// Выбор из заданого списка, в БД схораняется само значение.
Class SelectText extends Select
{
	function field2dom(&$data)
	{
	        $val = $this->values_list;
	        $this->values_list = array();
		foreach($val as $f=>$v) $this->values_list['value:'.($f+1)] = $v;
		$this->value = $data[$this->name];
		return $this;
	}
}

// Выбор из справочника в БД
Class SelectList extends TextField
{
        var $enums;
        var $linked_module;
        var $select_function;
        var $empty;

	function __construct($name, $value=null, $required=false)
	{
		parent::__construct($name, $value, $required);
		$this->select_function = 'select_for_select';
		$this->list = 1;
		$this->listedit = 1;
	}

	function fetch_enums (&$enums, &$data = [])
	{
		$m = _main_::fetchModule($this->linked_module);
		if (method_exists($m, $this->select_function))
		{
			$m->{$this->select_function}($this->enums);
		}
		else
			throw new exception("Method '{$this->select_function}' no found in class '".get_class($m)."'.");
	}
}

Class AutocompleteField extends TextField
{
        var $value_txt;
        var $linked_module;
        var $select_function;

	function __construct($name, $value=null, $required=false)
	{
		parent::__construct($name, $value, $required);
		$this->select_function = 'select_for_select';
	}

	function fetch_enums (&$enums, &$data = [])
	{
		if (isset($data[$this->name]) && $data[$this->name])
		{
			$m = _main_::fetchModule($this->linked_module);
			if (method_exists($m, $this->select_function))
			{
				$this->value_txt = $m->{$this->select_function}($data[$this->name]);
			}
			else
				throw new exception("Method '{$this->select_function}' no found in class '".get_class($m)."'.");
		}
	}
}

Class AutocompleteFieldWthChBox extends AutocompleteField {}


Class DadataField extends AutocompleteField
{
	function prepare (&$errors, &$data, $config, $enums)
	{
		if ($data[$this->name])
		{
			$db = new Base();
			$term = mysqli_real_escape_string($db->conn, $data[$this->name]);
			$tmp = $db->GetData("select `aoid` from `m12Dsaiwodx_custom_addrob` where `aoguid` = '{$term}' and `actstatus` = 1", 0);
			
			if ($tmp)
			{
				$data[$this->name] = $tmp['aoid'];
				$this->value = $tmp['aoid'];
			}
			
		}
	}

}

Class Email extends TextField
{
	function validate (&$errors, &$data, $config, $enums, $ignore_uploads = false)
	{
	        if ($this->required)
			$result=validate_required($errors, $data, $this->name);
		else
			$result=validate_optional($errors, $data, $this->name);
		if ($result)
		{
			validate_email($errors, $data, $this->name);
		}
	}
}


Class CheckBox extends BaseType
{
	var $is_int=false;

	function __construct($name,$value=null,$required=false)
	{
        parent::__construct($name, $value, $required);
		$this->list = 1;
		$this->listedit = 1;
	}

	function form_posted(&$result, $action=null, $arrays = null)
	{
		fields_fill($result, $this->name, $action !== null ? 0 : null); 
		fields_find($result, $this->name, $arrays);
	}

	function validate (&$errors, &$data, $config, $enums, $ignore_uploads = false)
	{
	    if ($this->required)
			validate_required($errors, $data, $this->name)&&validate_enum($errors, $data, $this->name, array(1, 0));
		else
			validate_optional($errors, $data, $this->name);
	}

	function sql_set(&$data)
	{
		if($this->is_int)
		{
			if ($this->nodb)
				return "";
			else
				return " `{$this->name}` = "._main_::sql_quote($data[$this->name])."\n";
		}
		else
		{
			if ($data[$this->name])
				return " `{$this->name}` = true\n";
			else
				return " `{$this->name}` = false\n";
		}

	}
}

Class CheckBoxSelector extends CheckBox {}

Class CheckBoxList extends BaseType
{
	var $values_list;

	function sql_set(&$data)
	{
	        $str = serialize($data[$this->name]);
		return " `{$this->name}` = "._main_::sql_quote($str)."\n";
	}

	function form_posted(&$result, $action=null, $arrays = null)
	{
		fields_fill($result, $this->name, $action !== null ? array() : null); 
		fields_find($result, $this->name, $arrays);
	}

	function validate (&$errors, &$data, $config, $enums, $ignore_uploads = false)
	{
	}

	function post_select(&$data)
	{
	        if ($data[$this->name]) $data[$this->name] = unserialize($data[$this->name]);
	}
}

Class Password extends BaseType
{
        var $activator_field;

	function form_posted(&$result, $action=null, $arrays = null)
	{
        $fields = array('password1', 'password2');
		fields_fill($result, $fields); 
		#fields_find($result, $this->name, $arrays);
		fields_find($result, $fields, $arrays);
	}

	function validate (&$errors, &$data, $config, $enums, $ignore_uploads = false)
	{
		if ($this->module->isInsert)
		{
			validate_required($errors, $data, 'password1'	);
			validate_required($errors, $data, 'password2'	);
		}else
		{
			validate_optional($errors, $data, 'password1'	);
			validate_optional($errors, $data, 'password2'	);
		}
	
		if ($data['password1']&&($data['password1']!==$data['password2']))
		{
			validate_add_error($errors, 'password', 'not_equal');
		}
	}

	function sql_set(&$data)
	{
		if ($this->module->isInsert)
		{
			$activator = number_format(floor(rand() * 0x7FFFFF), 0, ',', '');
			return " `{$this->name}` = "._main_::sql_quote(md5($data['password1'])).", `{$this->activator_field}` = '{$activator}'\n";
		}
		else
			return $data['password1']
				? " `{$this->name}` = "._main_::sql_quote(md5($data['password1']))."\n"
				: "";
	}

	function sql_list($table = '')
	{
		return "";
	}

	function field2dom(&$data)
	{
		return $this;
	}
}

Class PasswordToEmail extends BaseType
{
        var $activator_field;
        var $new_pass;

	function form_posted(&$result, $action=null, $arrays = null)
	{
		fields_fill($result, $this->name, $action !== null ? 0 : null); 
		fields_find($result, $this->name, $arrays);
	}

	function sql_set(&$data)
	{
		if ($data[$this->name] == 1)
		{
			_main_::depend('generators');
			$this->new_pass = generate_alphabet(7, 7);

			if ($this->module->isInsert)
			{
				$data['activator'] = number_format(floor(rand() * 0x7FFFFF), 0, ',', '');
				return " `{$this->name}` = "._main_::sql_quote(md5($this->new_pass)).", `{$this->activator_field}` = '{$data['activator']}'\n";
			}else
				return " `{$this->name}` = "._main_::sql_quote(md5($this->new_pass))."\n";
		}
		else
			return "";
	}

	function post_update($id, &$data)
	{
	        if (!$data['email']) return;
	        if ($data[$this->name] != 1) return;

		// Потому как /*/done добавляется уже ПОСЛЕ операции, мы пихаем туда своё, а потом удалим.
//		$data['gen_pass']
		$node = _main_::put2dom('mail', $data);
		$node1 = _main_::put2dom('module', $this->module->fields2dom($data));

		_main_::depend('mail');
		if ($this->module->isInsert)
			$txt = _main_::transform_by_file(_main_::$document, _config_::$messages_dir . 'user_confirm_pass' . _config_::$messages_ext);
		else
			$txt = _main_::transform_by_file(_main_::$document, _config_::$messages_dir . 'user_new_pass' . _config_::$messages_ext);

		send_multipart_mail(_config_::$mail_from, $data['email'], null, $txt, $files);
		if ($send_copy)
		send_multipart_mail(_config_::$mail_from, _config_::$mail_copy, null, $txt, $files);

		// Удаляем временный элемент, созданный для шаблона сообщения.
		$node->parentNode->removeChild($node);
		$node1->parentNode->removeChild($node1);
	}

	function sql_list($table = '')
	{
		return "";
	}

	function field2dom(&$data)
	{
		return $this;
	}
}

Class Gp extends BaseType
{
	var $gp_id;
	var $gp_w;
	var $gp_h;

	function __construct($name,$value=null,$required=false)
	{
		parent::__construct($name,$value,$required);
		list($this->gp_id, $this->gp_w, $this->gp_h) = gp_new_question();
	}

	function form_posted(&$result, $action = null, $arrays = null)
	{
		$fields=array($this->name.'_id',$this->name.'_answer');
		fields_fill($result, $fields); 
		fields_find($result, $this->name, $arrays);
	}

	function validate (&$errors, &$data, $config, $enums, $ignore_uploads = false)
	{
	        if ($this->required)
			$result=validate_required($errors, $data, $this->name.'_id');
		else
			$result=validate_optional($errors, $data, $this->name.'_id');
		if ($result)
			validate_gp($errors, $data, $this->name);
	}
}

Class UploadFile extends BaseType
{
	function form_posted(&$result, $action = null, $arrays = null)
	{
		// Fields with uploaded files.
		fields_file($result, $this->name, _config_::$tmp_for_linked, true, false);
//		debug($result); die;
	}

	function validate (&$errors, &$data, $config, $enums, $ignore_uploads = false)
	{
	        if ($this->required)
	        {
			if (validate_required_upload($errors, $data, $this->name) && validate_upload($errors, $data, $this->name, _config_::$ext_for_files, _config_::$dir_for_linked . "forms/{$this->name}/" , _config_::$tmp_for_linked))
			{
				validate_required($errors, $data, $this->name . '_size'); // && validate_number($errors, $data, $this->name . '_size', 0, $config['attach_limit_size']);
				validate_optional($errors, $data, $this->name . '_type');
			}
		}else
		{
			validate_array_optional($errors, $data, $this->name);
		}
	}

	function remember (&$data)
	{
		_main_::depend('uploads');
		handle_upload_temporarily($data, $this->name , _config_::$dir_for_linked . "forms/{$this->name}/", _config_::$tmp_for_linked);
	}

	function field2dom(&$data)
	{
	        $this->value = $data[$this->name];
	        $this->delete = $data[$this->name.'_delete'];
	        $this->temp = $data[$this->name.'_temp'];
	        $this->file_name = $data[$this->name.'_name'];
	        $this->path = $data[$this->name.'_path'];
	        $this->type = $data[$this->name.'_type'];
	        $this->size = $data[$this->name.'_size'];
	        $this->file = $data[$this->name.'_file'];
		return $this;
	}
}

Class TextArray extends BaseType
{
	var $typograph = false;

	function form_posted(&$result, $action=null, $arrays = null)
	{
		fields_fill($result, $this->name); 
		fields_find($result, $this->name, $arrays);

#		if ($this->typograph) fields_typograph($result, $this->name);

		if (is_array($result[$this->name]))
		{
			$tmp = array();
			foreach ($result[$this->name] as $f=>$val)
			{
				$item = array();
				$item['id'    ] = $f;
				$item['value'  ] = $val;
				if ((strlen($item['id'])) && $item['value'])
					$tmp[$this->name.':'.count($tmp)] = $item;
			}
			$result[$this->name] = $tmp;
		}
	}

	function validate (&$errors, &$data, $config, $enums, $ignore_uploads = false)
	{
        if ($this->required)
			validate_array_required($errors, $data, $this->name);
		else
			validate_array_optional($errors, $data, $this->name);
	}

	function sql_set(&$data)
	{
		return " `{$this->name}` = "._main_::sql_quote($data[$this->name])."\n";
	}
}

Class TimeField extends BaseType
{
	function validate (&$errors, &$data, $config, $enums, $ignore_uploads = false)
	{
	}

	function sql_set(&$data)
	{
		return " `{$this->name}` = "._main_::sql_quote($data[$this->name])."\n";
	}
}

Class PositionField extends BaseType
{
	function __construct($name,$value=null,$required=false)
	{
        parent::__construct($name, $value, $required);
		$this->list = 1;
		$this->listedit = 1;
	}

	function fetch_enums (&$enums, &$data = [])
	{
		$enums['siblings'] = _main_::query($this->module->outfield, "
			select	`id`, `{$this->module->name_field}`, `{$this->name}`
			from	`{$this->module->table}`
			order	by `position` asc, `id` asc
		");

		fill_texts($enums['siblings'], $this->module->multilang_fields);
	}

	function sql_set(&$data)
	{
		return " "._main_::sql_field($this->name)." = " . _main_::sql_quote($this->module->parse_position($data[$this->name])) . "\n";
	}
}

Class ItemsList extends BaseType
{
        var $outfield;
        var $table;
        var $id_field;
        var $link_field;

	function __construct($name, $value=null, $required=false)
	{
        parent::__construct($name, $value, $required);
		$this->select_function = 'select_for_select';
		$this->list = 0;
		$this->listedit = 0;
	}

	function fetch_enums (&$enums, &$data)
	{
		/* Устарело?
		$m = _main_::fetchModule($this->linked_module);
		if (method_exists($m, $this->select_function))
			$m->{$this->select_function}($enums[$this->linked_module]);
		else
			throw new exception("Method '{$this->select_function}' no found in class '".get_class($m)."'.");

		if ($data[$this->name])
			$m->select_by_ids($enums['names-for-'.$this->linked_module], get_fields($data[$this->name], 'id'));
		*/
		$m = _main_::fetchModule($this->linked_module);
		if (method_exists($m, $this->select_function))
			$m->{$this->select_function}($this->enums['list']);
		else
			throw new exception("Method '{$this->select_function}' no found in class '".get_class($m)."'.");

		if ($data[$this->name])
			$m->select_by_ids($this->enums['names_for'], get_fields($data[$this->name], 'id'));
	}

	function form_posted(&$result, $action=null, $arrays = null)
	{
		fields_fill($result, $this->name); 
		fields_find($result, $this->name, $arrays);

		//dom-fixes
		if (is_array($result[$this->name]))
		{
			$tmp = array();
			foreach ($result[$this->name] as $val)
			{
				$item = array();
				$item['id'    ] = isset($val['id'    ]) && strlen($val['id'    ]) ? $val['id'    ] : null;
				$item['remove'] = isset($val['remove']) && strlen($val['remove']) ? $val['remove'] : null; if ($item['remove']) { $action = 'remove_service'; }
				$item['append'] = isset($val['append']) && strlen($val['append']) ? $val['append'] : null; if ($item['append']) { $action = 'append_service'; }
				if ((strlen($item['id'])) && !$item['remove'])
					$tmp[$this->outfield.':'.count($tmp)] = $item;
			}
			$result[$this->name] = $tmp;
		}
	}

	function validate (&$errors, &$data, $config, $enums, $ignore_uploads = false)
	{
	}

	function sql_set(&$data)
	{
		return "";
	}

	function sql_list($table = '')
	{
		return "";
	}

	function post_update($id, &$data)
	{
	        if (!$this->table) throw new exception($this->name . ': link table not set for '.__FUNCTION__.'().');
	        if (!$this->id_field) throw new exception($this->name . ': id_field not set for '.__FUNCTION__.'().');
	        if (!$this->link_field) throw new exception($this->name . ': link_field not set for '.__FUNCTION__.'().');

		$parts_ids = get_fields($data[$this->name], 'id');

		// Удаляем ссылки, которые отсутствуют в нашем целевом списке (либо чистим все связи, если целевой список пуст).
		// Закомментил т.к. проблема с 2-мя одинаковыми part_id. ToDo:
		/*
		if (count($parts_ids))
		_main_::query(null, "
			delete	from `{$this->table}`
			where	`{$this->id_field}` = {1} and `{$this->link_field}` not in {2}
			", $id, $parts_ids);
		else
		*/
		_main_::query(null, "
			delete	from `{$this->table}`
			where	`{$this->id_field}` = {1}
			", $id);
			
		// Добавляем (с игнорированием уже существующих связей) связи на автомодели из целевого списка.
		// Для работы replace важно чтоб связка двух этих id была primary key!
		$list = array(); foreach ($parts_ids as $parts_id) $list[] = _main_::sql_quote($parts_id);
		$list = count($list) ? "({1}," . implode("),({1},", $list) . ")" : null;
		if (strlen($list)) _main_::query(null, "
			insert ignore into `{$this->table}`
				(`{$this->id_field}`, `{$this->link_field}`)
			values	{$list}
			", $id);
	}

	function delete($ids)
	{
		_main_::query(null, "delete from `{$this->table}` where `{$this->id_field}` in {1}", $ids);
	}
}

Class TableField extends BaseType
{
        var $fields;
        var $outfield;
        var $table;
        var $id_field;
        var $link_field;

	function __construct($name, $value=null, $required=false)
	{
        parent::__construct($name, $value, $required);
		$this->list = 0;
		$this->listedit = 0;
	}

	function prepare (&$errors, &$data, $config, $enums)
	{
		foreach ($data[$this->name] as &$val)
		{
			foreach($this->fields as $f=>$v) $v->prepare($errors, $val, $config, $enums);
		}
	}

	function predelete (&$errors, &$data, $config, $enums)
	{
		foreach ($data[$this->name] as &$val)
		{
			foreach($this->fields as $f=>$v) $v->predelete($errors, $val, $config, $enums);
		}
	}

	function fetch_enums (&$enums, &$data)
	{
		foreach($this->fields as $f=>$v) $v->fetch_enums($enums, $null);
	}

	function form_posted(&$result, $action=null, $arrays = null)
	{
	        $res = array();
		fields_fill($result, $this->name, $action !== null ? array() : null); 
		fields_find($result, $this->name, $arrays);

		if (is_array($result[$this->name]))
		{
			$tmp = array();
			foreach ($result[$this->name] as $val)
			{
				$item = array();
				foreach($this->fields as $f=>$v) $v->form_posted($item, $action, array($val));
				if (strlen($item[$this->link_field]))
					$tmp[$this->outfield.':'.count($tmp)] = $item;
			}
			$result[$this->name] = $tmp;
		}
	}

	function validate (&$errors, &$data, $config, $enums, $ignore_uploads = false)
	{
	        if ($data[$this->name])
		foreach ($data[$this->name] as &$val)
		{
			foreach($this->fields as $f=>$v) $v->validate($errors, $val, $config, $enums, $ignore_uploads);
		}
	}

	function sql_set(&$data)
	{
		return "";
	}

	function sql_list($table = '')
	{
		return "";
	}

	function post_update($id, &$data)
	{
	        if (!$this->table) throw new exception($this->name . ': link table not set for '.__FUNCTION__.'().');
	        if (!$this->id_field) throw new exception($this->name . ': id_field not set for '.__FUNCTION__.'().');
	        if (!$this->link_field) throw new exception($this->name . ': link_field not set for '.__FUNCTION__.'().');

		$parts_ids = get_fields($data[$this->name], 'id');

		// Удаляем ссылки, которые отсутствуют в нашем целевом списке (либо чистим все связи, если целевой список пуст).
		if (count($parts_list))
		_main_::query(null, "
			delete	from `{$this->table}`
			where	`{$this->id_field}` = {1} and `{$this->link_field}` not in {2}
			", $id, $parts_ids);
		else
		_main_::query(null, "
			delete	from `{$this->table}`
			where	`{$this->id_field}` = {1}
			", $id);

		// Добавляем (с игнорированием уже существующих связей) связи на автомодели из целевого списка.
		// Для работы replace важно чтоб связка двух этих id была primary key!
		$list = array();
		$pos = 0;
		if($data[$this->name])
		foreach($data[$this->name] as $row)
		{
		        $pos++;
			$sql = '';
			foreach($this->fields as $f=>$v) if($field = $v->sql_set($row)) $sql .= ','.$field;
			$sql = substr($sql, 1);

			_main_::query(null, "
				replace into `{$this->table}`
				set	{$sql}
				,	`position` = {2}
				,	`{$this->id_field}` = {1}
			", $id, $pos);
		}
	}

	function delete($ids)
	{
		foreach($this->fields as $f=>$v) $v->delete($ids);
		_main_::query(null, "delete from `{$this->table}` where `{$this->id_field}` in {1}", $ids);
	}

	function field2dom(&$data)
	{
	        $fields = array();

		foreach($this->fields as $f=>$v)
		{
			$key = get_class($v).":$f";
			$fields[$key] = clone $v->field2dom($data);
			unset($fields[$key]->module); // удаляем рекурсивную ссылку на родительский модуль
		}

		$this->fields = ($fields) ? $fields : null;
	        $this->value = $data[$this->name];

		return $this;
	}
}

Class PriceComputed extends BaseType
{
	var $calc_method;

	function __construct($name,$value=null,$required=false)
	{
        parent::__construct($name, $value, $required);
		$this->list = 0;
		$this->listedit = 0;
		$this->edit = 0;
	}

	function fetch_enums (&$enums, &$data)
	{
		if ($data && $this->calc_method)
		{
		        $data[$this->name] = $this->module->{$this->calc_method}($data, $this->name);
		}
	}

	function form_posted(&$result, $action=null, $arrays = null)
	{
	}
	function validate (&$errors, &$data, $config, $enums, $ignore_uploads = false)
	{
	}
	function sql_list($table = '')
	{
		return "";
	}
}

Class Computed extends BaseType
{
	var $calc_method;

	function __construct($name,$value=null,$required=false)
	{
        parent::__construct($name, $value, $required);
		$this->list = 0;
		$this->listedit = 0;
		$this->edit = 0;
	}

	function fetch_enums (&$enums, &$data)
	{
		if ($data && $this->calc_method)
		{
		        $data[$this->name] = $this->module->{$this->calc_method}($data, $this->name);
		}
	}

	function form_posted(&$result, $action=null, $arrays = null)
	{
	}
	function validate (&$errors, &$data, $config, $enums, $ignore_uploads = false)
	{
	}
	function sql_list($table = '')
	{
		return "";
	}
}

Class Hidden extends BaseType
{
	function sql_set(&$data)
	{
		return " `{$this->name}` = "._main_::sql_quote($data[$this->name])."\n";
	}
	/*
	function field2dom(&$data)
	{
		return $this;
	}
	*/
}

Class HiddenNoDB extends BaseType
{
	/*
	function field2dom(&$data)
	{
		return $this;
	}
	*/
	function sql_list($table = '')
	{
		return "";
	}
}

Class HeaderText extends BaseType
{
	/*
	function field2dom(&$data)
	{
		return $this;
	}
	*/
	function sql_list($table = '')
	{
		return "";
	}
}

Class DBFunction extends BaseType
{
	function sql_set(&$data)
	{
		return " `{$this->name}` = ".$this->function."\n";
	}
	/*
	function field2dom(&$data)
	{
		return $this;
	}
	*/
}


?>