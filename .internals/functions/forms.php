<?php

//
function determine_action ($actions, $default_action = null, $submitted = null)
{
	$result = null;

	// Превращаем список действий в массив, потому что дальше расчитываем что это массив.
	if (!is_array($actions)) $actions = ($actions == '') ? array() : array($actions);

	// Перебираем указанные действия, проверяя какое из них запрошено.
	foreach ($actions as $action)
	{
		if (array_key_exists($action, $_POST) || array_key_exists($action, $_GET))
		{
			$result = $action;
			break;
		}
	}

	// Если ни одно из действий не было запрошено, 
	if ($result === null)
	{
		// Если явно не указан режим подписи формы, то определяем его сами.
		if ($submitted === null) $submitted = ($_SERVER['REQUEST_METHOD'] == 'POST' && !isset($_POST['login_submit']));

		// Если форма подписана, то возвращаем дефолтное действие, иначе null.
		if ($submitted) $result = $default_action;
	}

	// Возвращаем что наопределяли.
	return $result;
}

//
function fields_fill (&$data, $fields, $value = null)
{
	if (!is_array($fields)) $fields = $fields == '' ? array() : array($fields);

	foreach ($fields as $field)
		$data[$field] = $value;
}

//
function fields_fill_array ($fields, $values = array())
{        
        $data = array();

	if (!is_array($fields)) $fields = $fields == '' ? array() : array($fields);

	foreach ($fields as $field)
		$data[$field] = isset($values[$field]) && strlen($values[$field]) ? $values[$field] : null;

	return $data;
}

//
function fields_find (&$data, $fields, $arrays = null)
{
	if ($arrays === null) $arrays = array($_POST, $_GET);
	if (!is_array($fields)) $fields = $fields == '' ? array() : array($fields);

	foreach ($fields as $field)
		foreach ($arrays as $array)
		{
			if (array_key_exists($field, $array))
			{
				$data[$field] = trim_recursively($array[$field]);
				if (!isset($GLOBALS['adminka']) || $GLOBALS['adminka'] != 1) $data[$field] = escape_recursively($array[$field]);
				break;
			}
		}
}

//
function fields_file (&$data, $fields, $tmp, $as_file = false, $as_image = false)
{
	if (!is_array($fields)) $fields = $fields == '' ? array() : array($fields);

	_main_::depend('texts', 'mime');
	if ($as_image) _main_::depend('images');

	// В обязательном порядке вытаскиваем из POST только реально необходимые поля. Остальные - по нужде.
	$subfields = array('delete', 'temp', 'path', 'name');
	if ($as_file ) array_push($subfields, 'type', 'size');
	if ($as_image) array_push($subfields, 'w', 'h');
	
	foreach ($fields as $field)
	{
//		debug($data); die;
		$tmpfields = array(); foreach ($subfields as $subfield) $tmpfields[] = $field . '_' . $subfield;
		fields_fill($data, $tmpfields);
		fields_find($data, $tmpfields);// И ничего что сюда и path попал, мы его всё равно ниже перекрываем везде.
		fields_fill($data, $field . '_file');

		// Если залит новый файл, то восстанавливаем недостающие значения из этой заливки.
		if (array_key_exists($field, $_FILES) && is_uploaded_file($_FILES[$field]['tmp_name']))
		{
			$path = $_FILES[$field]['tmp_name'];
			$data[$field . '_path'] = $path;
			if ($_FILES[$field]['error']) $data[$field . '_error'] = $_FILES[$field]['error'];
			if (             !strlen($data[$field . '_temp'])) $data[$field . '_temp'] = null;//NB: have to keep value if it was posted.
			if (             !strlen($data[$field . '_name'])) $data[$field . '_name'] = transliterate($_FILES[$field]['name']);
			if ($as_file  && !strlen($data[$field . '_type'])) $data[$field . '_type'] = is_file($path) ? get_mime($path) : null;
			if ($as_file  && !strlen($data[$field . '_size'])) $data[$field . '_size'] = is_file($path) ? filesize($path) : null;
			if ($as_image && !strlen($data[$field . '_w'   ])) $data[$field . '_w'   ] = is_file($path) ? measure_image_w($path) : null;
			if ($as_image && !strlen($data[$field . '_h'   ])) $data[$field . '_h'   ] = is_file($path) ? measure_image_h($path) : null;
		} else
		
		// В случае если свежезалитого файла нет, но есть временный файл, то пытаемся восстановить значения из него.
		// И при этом защищаемся от inject'а некорректного поля temp, которое на деле учавствует в формировании пути к файлу.
		if (strlen($data[$field . '_temp']) && preg_match('@^ ([a-zA-Z0-9]+) / (?!\\.\\.$|\\.$|$) ([^/\\\\]+) $@sx', $data[$field . '_temp']))
		{
			$path = $tmp . (substr($tmp, -1) !== '/' ? '/' : '') . $data[$field . '_temp'];
			$data[$field . '_path'] = null;
			if (             !strlen($data[$field . '_temp'])) {} // NEVER HAPPEN (see "if" above)!
			if (             !strlen($data[$field . '_name'])) $data[$field . '_name'] = transliterate(basename($data[$field . '_temp']));
			if ($as_file  && !strlen($data[$field . '_type'])) $data[$field . '_type'] = is_file($path) ? get_mime($path) : null;
			if ($as_file  && !strlen($data[$field . '_size'])) $data[$field . '_size'] = is_file($path) ? filesize($path) : null;
			if ($as_image && !strlen($data[$field . '_w'   ])) $data[$field . '_w'   ] = is_file($path) ? measure_image_w($path) : null;
			if ($as_image && !strlen($data[$field . '_h'   ])) $data[$field . '_h'   ] = is_file($path) ? measure_image_h($path) : null;
		} else

//???		// ПОД ВОПРОСОМ (непонятно что это даст, но что-то в этой идее есть):
//???		// Если никаких новых или временных файлов, но есть старый исходный файл, то дозаполняем поля по нему.
//???		// Возможно это на случай когда временные файлы были, но потом потерялись или ещё чего, вот чтбы не искарёжить name/type/size/w/h...
//???		if (strlen($data[$field . '_file']))
//???		{
//???		} else

		// Принудительно сбрасываем все поля, даже если они заданы, когда нет ни залитого, ни старого файла. Ибо нефиг.
		{
			$data[$field . '_path'] = null;
			$data[$field . '_temp'] = null;
			$data[$field . '_name'] = null;
			$data[$field . '_type'] = null;
			$data[$field . '_size'] = null;
			if ($as_image)
			{
			$data[$field . '_w'   ] = null;
			$data[$field . '_h'   ] = null;
			}
		}
	}
}

//??? сделать по-другому, и, скорее всего, в другом месте должен быть такой автдетект.
//??? может проверку делать непосредственно в retrieve_...()?
function fields_typograph (&$data, $fields, $force = false)
{
	if (!is_array($fields)) $fields = $fields == '' ? array() : array($fields);

	if (isset($_COOKIE['auto_typograph']) && $_COOKIE['auto_typograph'])
	{
		_main_::depend('typograph-unicode');
		foreach ($fields as $field)
			if (array_key_exists($field, $data) && ($data[$field] !== null))
				$data[$field] = typograph($data[$field]);
	}
}

// Вспомогательная функция. Используется выше для trim'а присланных значений любого типа.
function trim_recursively ($value)
{
	if (is_array ($value)) return array_map(__FUNCTION__, $value); else
	if (is_string($value)) return trim($value); else
	return $value;
}

function fetch_bookmark()
{
	if (isset($_COOKIE['bookmark']) && $_COOKIE['bookmark'])
	{
		_main_::put2dom('bookmark', $_COOKIE['bookmark']);
	}
}

function escape_recursively ($value)
{
	if (is_array ($value)) return array_map(__FUNCTION__, $value); else
	if (is_string($value)) return str_replace(array('>', '<'), array('&gt;', '&lt;'), $value); else
	return $value;
}

?>