<?php

function get_requested_filters ($names)
{
	$result = array();
	foreach ($names as $name => $value)
	{
		if (array_key_exists('filter_'.$name, $_GET))
		{
        	$result[$name] = $_GET['filter_'.$name];
        	$type = gettype($value);
        	if ($type === 'NULL' && $result[$name] !== '') $type = 'integer';
        	settype($result[$name], $type);
		} else
		{
			$result[$name] = $value;
		}

		// ќчищаем массивы от пустых значений, и все скал€ры нормализуем (урезаем пробелы).
		if (is_array($result[$name]))
			$result[$name] = array_filter(array_map('trim', $result[$name]), 'strlen');
		else
		if (is_string($result[$name]))
			$result[$name] = trim($result[$name]);

		// ≈сли значение похоже на дату в национальном формате, то конвертируем в формат Ѕƒ.
               	if (is_string($result[$name]))//??? сделать дополнительное условие что это хот€ бы похоже на дату (pregex)? хот€ и сейчас отлваливает такое за счЄт validate().
               	{
               		$errors = array(); _main_::depend('validations');
                	validate_datetime($errors, $result, $name);
               	}

		if (is_array ($result[$name]) && !count($result[$name]) ) $result[$name] = null; else
		if (is_scalar($result[$name]) && ($result[$name] === '')) $result[$name] = null;

		// fixing array keys for dom:
		if (is_array($result[$name]))
		{
			$temp = array();
			foreach ($result[$name] as $key => $val)
				$temp['value:'.$key] = $val;
			$result[$name] = $temp;
		}
	}

	return $result;
}

function get_requested_sorters ($names)
{
	$result = array();
	if (array_key_exists('sorter', $_REQUEST))
		if (preg_match_all("/ ([\\+\\-]?) ([a-z0-9_]+) /suix", $_REQUEST['sorter'], $matches, PREG_SET_ORDER))
			foreach ($matches as $match)
			{
				$dir = $match[1]; if ($dir === '') $dir = '+';
				$fld = $match[2];
				if (array_key_exists($fld, $names))
					$result[$fld] = $dir;
			}
	foreach ($names as $name => $dir)
		if (!array_key_exists($name, $result))
			$result[$name] = ($dir === '-') || ($dir === true) ? '-' : '+';
	return $result;
}

function get_requested_pager ($hints)
{
	$page = $size = null;
	$size  = isset($hints['size' ]) ? (integer) $hints['size' ] : null;
	$count = isset($hints['count']) ? (integer) $hints['count'] : null;
	if ($page === null) $page = array_key_exists('page', $_GET ) ? (integer) $_GET ['page'] : null;
	if ($page === null) $page = array_key_exists('page', $hints) ? (integer) $hints['page'] : null;

	if (($size === null) || ($size <= 0))
	{
		$size  = 0;
		$pages = 1;
	} else
	{
		$pages = floor($count / $size) + ($count % $size ? 1 : 0);
	}
	if (($page === null) || ($page < 1     )) $page = 1     ;
	if (($page === null) || ($page > $pages)) $page = $pages;
	$offset = (max(1, $page) - 1) * max(1, $size);

	$iterator = array();
	for ($p = 1; $p <= $pages; $p++) $iterator['page:'.$p] = $p;

	$cycle = $iterator;

	$result = compact('page', 'size', 'count', 'offset', 'pages', 'iterator', 'cycle');
	return $result;
}

function make_pager ($size=0, $pagevar='page'){
	$page = array_key_exists($pagevar, $_GET ) ? (integer) $_GET [$pagevar] : null;
	$size = ($size==0) ? 10 : $size;
	return array('page'=>$page, 'size'=>$size);
}

function get_pager_struct ($hints)
{
	$size  = isset($hints['size' ]) ? (integer) $hints['size' ] : null;
	$count = isset($hints['count']) ? (integer) $hints['count'] : null;
	$page = array_key_exists('page', $hints) ? (integer) $hints['page'] : null;

	if (($size === null) || ($size <= 0))
	{
		$size  = 0;
		$pages = 1;
	} else
	{
		$pages = floor($count / $size) + ($count % $size ? 1 : 0);
	}
	if (($page === null) || ($page < 1     )) $page = 1     ;
	if (($page === null) || ($page > $pages)) $page = $pages;
	$offset = (max(1, $page) - 1) * max(1, $size);

	$iterator = array();
	for ($p = 1; $p <= $pages; $p++) $iterator['page:'.$p] = $p;

	$result = compact('page', 'size', 'count', 'offset', 'pages', 'iterator');
	return $result;
}

function convert_filters_to_sql_where_clause ($filters, $table = null, $mapping = null, $if_empty = null)
{
	$result = array();
	foreach ($filters as $field => $value)
	{
		$field =
			(is_array($mapping) && array_key_exists($field, $mapping)) ? $mapping[$field] :
			(($table !== null ? $table . '.' : '') . '`' . $field . '`');
		if ($value !== null)
			$result[] =
				(strpos($field, '{#}') !== false ? str_replace('{#}', _main_::sql_quote($value), $field) :
				($value == 'null' ? $field . ' is null '                                   :
				($value == 'not null' ? $field . ' is not null '                           :
				(is_array ($value) ? $field . ' in '   . _main_::sql_quote(      $value      ):
				(gettype($value) == 'integer' ? $field . ' = '    . _main_::sql_quote(      $value      ):
				(preg_match('/^\d{4}\-\d{2}\-\d{2}/', $value) ? $field . ' = '    . _main_::sql_quote(      $value      ):
				(is_string($value) ? $field . ' ilike ' . _main_::sql_quote('%' . $value . '%'):
				(                    $field . ' = '    . _main_::sql_quote(      $value      )))))))));
	}
	$result = implode(' and ', $result);
	if ($result == '') $result = $if_empty;
	return $result;
}

function convert_sorters_to_sql_order_clause ($sorters, $table = null, $mapping = null, $multilang_fields = null)
{
	$result = array();

	if ($multilang_fields !== null)
	{
		if ($mapping === null) $mapping=array();
	
		foreach($multilang_fields as $f=>$field)
		{
			if (is_array($mapping) && array_key_exists($field, $mapping))
			{}
			else{
				$mapping[$field]="tx$f.`text`";
			}
		}		
	}

	foreach ($sorters as $field => $direction)
	{
		$field =
			(is_array($mapping) && array_key_exists($field, $mapping)) ? $mapping[$field] :
			(($table !== null ? $table . '.' : '') . '`' . $field . '`');
		if ($field !== null)// can be null because of mappings (like: ..., 'field' => null, ...).
		{
			$result[] = str_replace(
				array('>>>'                              , '<<<'                              ),
				array($direction === '-' ? 'desc' : 'asc', $direction === '-' ? 'asc' : 'desc'),
				$field . (strpos($field, '>>>') === false && strpos($field, '<<<') === false ? ' ' . '>>>' : ''));
		}
	}
	$result = implode(', ', $result);
	return $result;
}

function convert_pager_to_sql_limit_clause ($pager, $if_empty = null)
{
	$page = (integer) $pager['page'];
	$size = (integer) $pager['size'];
	if ($size <= 0)
	{
		$result = $if_empty;
	} else
	{
		$offset = (max(1, $page) - 1) * max(1, $size);
		$result = sprintf("limit %s offset %s", $size, $offset);
	}
	return $result;
}

function parse_position ($position, $table, $field, $where = 'true', $arg1 = null, $arg2 = null, $arg3 = null)
{
	// ≈сли попрошено поместить в начало списка, ставим позицию 1 и сдвигаем ¬—≈ записи.
	if (strcasecmp($position, '<') === 0)
	{
		$result = 1;
		_main_::query(null, "update {$table} set {$field} = {$field} + 1 where ({$where})", $arg1, $arg2, $arg3);
	} else

	// ≈сли попрошено поместить в конец списка, определ€ем максимальную позицию и ничего не сдвигаем.
	if (strcasecmp($position, '>') === 0)
	{
		$dat = _main_::query(null, "select max({$field}) from {$table} where ({$where})", $arg1, $arg2, $arg3);
		$result = count($dat) ? array_shift(array_shift($dat)) : null;
		$result++;
	} else

	// ≈сли попрошено поместить перед чем-то, определ€ем позицию (туда и ставим), и сдвигаем записи.
	if (strncasecmp($position, '<', 1) === 0)
	{
		$ref = substr($position, 1);
		$dat = _main_::query(null, "select {$field} from {$table} where `id` = {1}", $ref);
		$result = count($dat) ? array_shift(array_shift($dat)) : null;
		_main_::query(null, "update {$table} set {$field} = {$field} + 1 where ({$where}) and {$field} >= {4}", $arg1, $arg2, $arg3, $result);
	} else

	// ≈сли попрошено поместить после чего-то, определ€ем позицию (ставим на следующую позицию), и сдвигаем записи.
	if (strncasecmp($position, '>', 1) === 0)
	{
		$ref = substr($position, 1);
		$dat = _main_::query(null, "select {$field} from {$table} where `id` = {1}", $ref);
		$result = count($dat) ? array_shift(array_shift($dat)) : null;
		$result++;
		_main_::query(null, "update {$table} set {$field} = {$field} + 1 where ({$where}) and {$field} >= {4}", $arg1, $arg2, $arg3, $result);
	} else

	// ≈сли непон€тно чего попрошено, оставл€ем это "как есть", ничего никуда не двига€.
	{
		$result = $position;
	}

	return empty($result) ? 1 : $result;
}

function search_clauses (&$where, &$relat, $words, $fields)
{
	// —оставл€ем структуры дл€ запроса.
	// Relativity записи считаем как сумму максимальных совпадений по каждому полю (причЄм все
	// прицепленные сущности считаютс€ единым фронтом, хот€ их пол€ отличаютс€ по весу).
	// Relativity пол€ считаем как сумму совпадений каждого из слов. “аким образом, чем больше слов
	// совпало с полем, тем больше relativity. ќднако кол-во совпавших подсущностей не играет роли.
	$where = $relat = array(); foreach ($fields as $key => $info) $where[$key] = $relat[$key] = array();
	foreach ($words as $word)
	{
		$sql = "concat('%', " . str_replace('%', "\\%", _main_::sql_quote($word)) . ", '%')";
		foreach ($fields as $key => $info)
		{
			extract($info, EXTR_OVERWRITE | EXTR_PREFIX_ALL, 'info');
			$where[$key][] =   "({$info_field} like {$sql})";
			$relat[$key][] = "if({$info_field} like {$sql}, {$info_weight}, 0)";
		}
	}
	foreach ($fields as $key => $info)
	{ $where[$key] = '(' . implode('or', $where[$key]) . ')'; $relat[$key] = 'max(' . implode('+' , $relat[$key]) . ')'; }
	{ $where       = '(' . implode('or', $where      ) . ')'; $relat       =    '(' . implode('+' , $relat      ) . ')'; }
}

function get_selected_count(){
		$dat = _main_::query(null, "SELECT FOUND_ROWS() as total");
		$dat=array_shift($dat);
		return $dat['total'];
}

function make_filters($fields, $data)
{
	$filters = array();

	if ($fields)
	{
		foreach($fields as $f=>$v)
		{
			$key = get_class($v).":$f";
			$filters[$key] = clone $v->field2dom($data); //??? ѕочему clone (сам писал, сам забыл)
		}
	}

	return $filters;
}

?>