<?php

Class Filters
{

	var $fields = array();

	function __construct($fields)
	{
		if (is_array($fields))
		foreach($fields as &$v)
		{
			$this->fields[$v->name]=$v;
		}
	}

	function get_filters()
	{
		$fields = [];
		$errors = array();
		foreach($this->fields as $f=>$fl) $fl->prepare_filter($fields);
//		foreach($this->fields as $v) $fields[$v->name] = $v->value;
		
		_main_::depend('sql');
		
		$this->filters_data = get_requested_filters($fields); // ассоциативный массив полей с их значениями
		
		foreach($this->fields as $f=>$fl) $fl->set_filter($errors, $this->filters_data);
		
		return $this->filters_data;
	}

	function sql_where ($table = null, $mapping = null, $if_empty = 'true')
	{
		$result = array();
		foreach ($this->fields as $filter)
		{
			$field = $filter->name;
			$value = $filter->value;
			
			if ($this->filters_data[$field] === null) continue;
			
			$field =
				(is_array($mapping) && array_key_exists($field, $mapping)) ? $mapping[$field] :
				(isset($filter->mapping) && $filter->mapping) ? $filter->mapping :
				(($table !== null ? $table . '.' : '') . '`' . (isset($filter->sql_field) ? $filter->sql_field : $filter->name) . '`');
			if ($value !== null)
				$result[] =
					(isset($filter->sql_where) ? $filter->sql_where() :
					(isset($filter->cond) && $filter->cond ? $field . ' ' . $filter->cond . ' ' . _main_::sql_quote($value) :
					(strpos($field, '{#}') !== false ? str_replace('{#}', _main_::sql_quote($value), $field) :
					(strpos($field, '{%#%}') !== false ? str_replace('{%#%}', _main_::sql_quote('%'.$value.'%'), $field) :
					($value === 'null' ? $field . ' is null '                                   :
					($value === 'not null' ? $field . ' is not null '                           :
					(is_array ($value) ? $field . ' in '   . _main_::sql_quote(      $value      ):
					(gettype($value) == 'integer' ? $field . ' = '    . _main_::sql_quote(      $value      ):
					(preg_match('/^\d{4}\-\d{2}\-\d{2}/', $value) ? $field . ' = '    . _main_::sql_quote(      $value      ):
					(is_string($value) ? $field . ' like ' . _main_::sql_quote('%' . $value . '%'):
					(                    $field . ' = '    . _main_::sql_quote(      $value      ))))))))))));
		}
		$result = implode(' and ', $result);
		if ($result == '') $result = $if_empty;

		return $result;
	}

	// Нужны для списков из БД
	function fetch_enums (&$data = [])
	{
		$enums = array('@for' => 'filters');

		foreach($this->fields as $f=>$v) $v->fetch_enums($enums, $data);

		_main_::put2dom('enums', $enums);
	}
	
	function fields2dom()
	{
		$this->fetch_enums($this->filters_data);
		
		$res = array();

		$i = 0;
		foreach($this->fields as $f=>&$v) { $i++; $res[get_class($v).":$i"] = clone $v->field2dom($this->filters_data); }

		return ($res) ? $res : null;
	}

}
?>