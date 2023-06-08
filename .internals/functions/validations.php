<?php
//
// (c) 2007 http://www.howard-studio.ru/
// Sergei Vasilyev, nolar@howard-studio.ru
//
// Функции для проверки корректности значений в массиве данных. Предполагается что этот массив ($data)
// содержит ассоциативный массив тех полей/данных, которые нужно проверить. Для проверки по всех функциях
// задаётся как минимум пополняемый массив ошибок, иногда изменяемый массив данных, и имя поля.
//
// Ошибки должны представлять собой массив. При несоблюдении условия в него помещается ключ, состоящий
// из имени поля и кодового обозначения ошибки (через подчёркивание). Иногда в этот узел помещается какое-то значение.
// Так или иначе, этот массив всегда пригоден для закидывания в DOM через класс _main_.
//
// Некоторые функции чуть-чуть корректируют значения данных (приводят к правильному формату как у validate_date(),
// или к null как у validate_optional()).
//
// validate_add_error()	- принудительное добавление ошибки (формирует имя ключа и т.п.)
//
// validate_optional()	- проверяет что значение пустое (после trim), и превращает его у null если это так.
// validate_required()	- проверяет что значение не пустое; если пустое - то добавляет ошибку {$field}_required.
// validate_prohibit()	- проверяет что значение пустое; если не пустое - то добавляет ошибку {$field}_prohibit.
// Аналогичные задачи выполняют validate_*_upload(), но только проверяют по набору полей, свойственных для файлов.
//
// validate_length	- что длина значения находится в интервале "от" и "до".
// validate_position	- что значение пригодно для позиционирования ("до" или "после" чего-то, либо "на место номер")
// validate_mr		- что значение пригодно для mod_rewrite
// validate_enum	- что значение находится в списке допустимых
// validate_number	- что значение есть число в интервале "от" и "до"
// validate_boolean	- что значение является логическим
// validate_pair	- что парные значение совпадают (для конфирмации, например, паролей)
// validate_email	- что значение является корректным e-mail адресом
// validate_upload	- что загружаемый файл и все его поля корректны и пригодны для операций
// validate_gp		- что значение graph-protector'а корректны и подтверждены (обращается к бибилиотеке gp)
// validate_spam	- что значение не содержит запрещённых слов и выражений (по regex-маске)
// validate_dateonly	- что значение является датой, в нужном формате (dd.mm.yyyy или yyyy-mm-dd) и само по себе корректно
// validate_datetime	- аналогично, но позволяет вводить дату и время (dd.mm.yyyy hh:mm:ss или yyyy-mm-dd hh:mm:ss)
//			  причём при проверке даты все понимаемые форматы приводятся в mysql-формат (yyyy-mm-dd hh:mm:ss)
//

// Функция принудительного добавления ошибки в список.
//todo: расписать комментарий по аргументам, что на входе и что на выходе.
function validate_add_error (&$errors, $format, $error = null, $text = null)
{
	$parts = explode(':', $format);
	$field = array_shift($parts);
	$set   = array_shift($parts);
	$key   = array_shift($parts);
	if (isset($GLOBALS['api']) && $GLOBALS['api'] == 1)
	{
		$struct = array();
		if ($field != '') $struct['field'] = $field;
		if ($error !== null) $struct['type'] = $error;
		if ($set   != '') $struct['set'  ] = $set  ;
		if ($key   != '') $struct['key'  ] = $key  ;
		if ($text  != '') $struct['text' ] = $text ;
		
		if (_DEBUG_)
		{
			$ar=debug_backtrace();
			$struct['line']="in ".$ar[0]['file']." at line ".$ar[0]['line'];
		}
		
		if (!count($struct)) $struct = $text;
		
		if (_DEBUG_)
		{
			$ar=debug_backtrace();
			$struct['line']="in ".$ar[0]['file']." at line ".$ar[0]['line'];
		}

		$errors[] = $struct;
	}
	else
	{
		$index = implode(':', array($field . ($error != '' ? '_' : '') . $error, $set, $key));

		$struct = array();
		if ($field != '') $struct['@field'] = $field;
		if ($error !== null) $struct['@type'] = $error;
		if ($set   != '') $struct['@set'  ] = $set  ;
		if ($key   != '') $struct['@key'  ] = $key  ;
		if ($text  != '') $struct[''      ] = $text ;
		if (!count($struct)) $struct = $text;

		$errors[$index] = $struct;
	}
}



// Две функции для проверки наличия значения, и, если необходимо, нормализации и стандартизации значения (строк).
function validate_required (&$errors, &$data, $field)
{
	$ok = true;
	$data[$field] = trim($data[$field]);
	if (!strlen($data[$field]))
	{
		validate_add_error($errors, $field, 'required');
		$ok = false;
	}
	return $ok;
}

function validate_optional (&$errors, &$data, $field)
{
	$ok = true;
	$data[$field] = trim($data[$field]);
	if (!strlen($data[$field]))
	{
		$data[$field] = null;
		$ok = false;
	}
	return $ok;
}

function validate_prohibit (&$errors, &$data, $field)
{
	$ok = true;
	if (is_array($data[$field]) && count($data[$field]))
	{
		validate_add_error($errors, $field, 'prohibit', count($data[$field]));
		$ok = false;
	} else
	if (!is_array($data[$field]) && strlen($data[$field]))
	{
		validate_add_error($errors, $field, 'prohibit', strlen($data[$field]));
		$ok = false;
	}
	return $ok;
}

function validate_required_upload (&$errors, &$data, $field)
{
	$ok = true;
	if (!strlen($data[$field . '_file']) && !strlen($data[$field . '_path']) && !strlen($data[$field . '_temp']))
	{
		validate_add_error($errors, $field, 'required');
		$ok = false;
	}
	return $ok;
}

function validate_optional_upload (&$errors, &$data, $field)
{
	$ok = true;
	if (!strlen($data[$field . '_file']) && !strlen($data[$field . '_path']) && !strlen($data[$field . '_temp']))
	{
		$data[$field . '_file'] = null;
		$data[$field . '_path'] = null;
		$data[$field . '_temp'] = null;
		$ok = false;
	}
	return $ok;
}




//
function validate_length (&$errors, &$data, $field, $min, $max)
{
	$ok = true;
	$length = strlen($data[$field]);
	if ($length < $min)
	{
		validate_add_error($errors, $field, 'too_short', $min);
		$ok = false;
	}
	if ($length > $max)
	{
		validate_add_error($errors, $field, 'too_long', $max);
		$ok = false;
	}
	return $ok;
}

function validate_array_required (&$errors, &$data, $field)
{
	$ok = true;
	if (!count($data[$field]))
	{
		validate_add_error($errors, $field, 'required');
		$ok = false;
	}
	return $ok;
}

function validate_array_optional (&$errors, &$data, $field)
{
	$ok = true;
	if (!count($data[$field]))
	{
		$data[$field] = null;
		$ok = false;
	}
	return $ok;
}

function validate_position (&$errors, &$data, $field, $enum, $moved)
{
	$ok = true;
	if ((strcasecmp ($data[$field], '<'   ) === 0)) {} else
	if ((strcasecmp ($data[$field], '>'   ) === 0)) {} else
	if ((strncasecmp($data[$field], '<', 1) === 0) && in_array(substr($data[$field], 1), $enum)) {} else
	if ((strncasecmp($data[$field], '>', 1) === 0) && in_array(substr($data[$field], 1), $enum)) {} else
	if (!is_numeric($data[$field]))
	{
		validate_add_error($errors, $field, 'bad');
		$ok = false;
	} else
	if ($moved)
	{
		validate_add_error($errors, $field, 'moved');
		$ok = false;
	}
	return $ok;
}

function validate_mr (&$errors, &$data, $field, $strict = true)
{
	$ok = true;
	if ($strict)
	{
		if (preg_match("/[^a-zA-Z0-9_\\.,-]/sixu", $data[$field]))
		{
			validate_add_error($errors, $field, 'char');
			$ok = false;
		}
	} else
	{
		//???todo:fix: какие символы считать недопустимыми в режиме "расслабленного" mr? пока что разрешаем вообще всё.
//		if (preg_match("/[^a-zA-Z0-9_\\.,-]/iu", $data[$field]))
//		{
//			validate_add_error($errors, $field, 'char');
//			$ok = false;
//		}
	}
	return $ok;
}

function validate_enum (&$errors, &$data, $field, $enum)
{
	$ok = true;
	if (!in_array($data[$field], $enum))
	{
		validate_add_error($errors, $field, 'bad');
		$ok = false;
	}
	return $ok;
}

function validate_number (&$errors, &$data, $field, $min = null, $max = null)
{
	$ok = true;
	if (is_string($data[$field])) $data[$field] = str_replace(',', '.', $data[$field]);
	if (!is_numeric($data[$field]))
	{
		validate_add_error($errors, $field, 'bad');
		$ok = false;
	} else
	{
		if (($min !== null) && ($data[$field] < $min))
		{
			validate_add_error($errors, $field, 'too_low');
			$ok = false;
		}
		if (($max !== null) && ($data[$field] > $max))
		{
			validate_add_error($errors, $field, 'too_high');
			$ok = false;
		}
	}
	return $ok;
}

function validate_boolean (&$errors, &$data, $field)
{
	$ok = true;
	if (!is_numeric($data[$field]))
	{
		validate_add_error($errors, $field, 'bad');
		$ok = false;
	}
	return $ok;
}

function validate_pair (&$errors, &$data, $field, $suffixes = array('1', '2'))
{
	$ok = true;
	$suffix_last = null;
	foreach ($suffixes as $suffix)
		if ($suffix_last === null)
		{
			$suffix_last = $suffix;
		} else
		if ($data[$field . $suffix_last] != $data[$field . $suffix])
		{
			validate_add_error($errors, $field, 'different');
			$ok = false;
			break;
		}
	return $ok;
}

function validate_email (&$errors, &$data, $field)
{
	$ok = true;
	if (!preg_match("/^[\\w\\d_\\.+-]+@[\\w\\d_\\.-]+\$/sixu", $data[$field]))
	{
		validate_add_error($errors, $field, 'bad');
		$ok = false;
	}
	return $ok;
}

function validate_upload (&$errors, &$data, $field, $extensions, $dir, $tmp)
{
	$ok = true;

	// Проверяем на допустимость расширения, и выполняем его замену, либо полностью игнорируем залитый файл.
	// Проверка актуальна как для свежезалитых файлов, так и для перекрытия поля *_name у ранее принятого temp-файла.
	if (is_array($extensions) && strlen($data[$field . '_name']))
	{
		$allow = true;
		foreach ($extensions as $ext => $action)
			if (($ext == '.*') || ($ext == '*') || ($ext === '') || ($ext === null)
			|| (strcasecmp(substr($data[$field . '_name'], -strlen($ext)), $ext) == 0))
			{
				if (is_string($action) && strlen($action))
				{
					$data[$field . '_name'] = substr($data[$field . '_name'], 0, -strlen($ext)) . $action;
					$allow = true;
				} else
				{
					$allow = (bool) $action;
				}
				break;
			}
		if (!$allow)
		{
			validate_add_error($errors, $field, 'extension', $data[$field . '_name']);
			$ok = false;
			// А это мы в случае признания файла "вредным" делаем вид, что как будто бы ничего и не было залито.
			//fix: Одно "но": поля type, size, w, h в случае загрузки определены из этого файла. Так что нам надо бы
			//fix: и их перекрывать. Или хотя бы игнорировать. Или как-то по-другому поступать с "вредными" файлами.
			//fix: Но даже выкидывая ошибку, нельзя такой файл помещать в tmp-folder, потому что там он УЖЕ опасен.
			$data[$field . '_path'] = null;
		}
	}

	$tmp_path = $tmp . (substr($tmp, -1) !== '/' ? '/' : '') . $data[$field . '_temp'];
	$dir_path = $dir . (substr($dir, -1) !== '/' ? '/' : '') . $data[$field . '_name'];
	// Если есть ссылка на временный файл, но самого файла на диске нет...
	if (strlen($data[$field . '_temp']) && (!$data[$field . '_delete']) && !is_file($tmp_path))
	{
		validate_add_error($errors, $field, 'lost');
		$ok = false;
	}
	// Если файл есть, но юзер пытается его в пустое имя переименовать...
	if (!strlen($data[$field . '_name']) && (!$data[$field . '_delete']) && (strlen($data[$field . '_file']) || strlen($data[$field . '_temp']) || strlen($data[$field . '_path'])))
	{
		validate_add_error($errors, $field, 'nameless');
		$ok = false;
	}
	// Если мы указали новое имя файла (или залили новый файл), но файл с таким именем уже есть...
	if (strlen($data[$field . '_name']) && ($data[$field . '_file'] != $data[$field . '_name']) && is_file($dir_path))
	{
		validate_add_error($errors, $field, 'exists', $data[$field . '_name']);
		$ok = false;
	}
	// Если была ошибка загрузки (аплоада) файла...
	if (isset($data[$field . '_error']) && $data[$field . '_error'])
	{
		validate_add_error($errors, $field, 'error', $data[$field . '_error']);
		$ok = false;
	}
	return $ok;
}

function validate_dateonly (&$errors, &$data, $field)
{
	if (!strlen($data[$field])) return;
	if ($ok = preg_match('/^(\\d+)\\.(\\d+)\\.(\\d+) (?: \+*(\\d+) (?: \\:(\\d+) (?: \\:(\\d+) )? )? )$/six', $data[$field], $matches))
	{
		$day   = $matches[1];//отрицательные значения невоможны из-за regex-маски, которая не допускает минуса
		$month = $matches[2];//отрицательные значения невоможны из-за regex-маски, которая не допускает минуса
		$year  = $matches[3];//отрицательные значения невоможны из-за regex-маски, которая не допускает минуса
	} else
	if ($ok = preg_match('/^(\\d+)-(\\d+)-(\\d+) (?: \+*(\\d+) (?: \\:(\\d+) (?: \\:(\\d+) )? )? )$/six', $data[$field], $matches))
	{
		$day   = $matches[3];//отрицательные значения невоможны из-за regex-маски, которая не допускает минуса
		$month = $matches[2];//отрицательные значения невоможны из-за regex-маски, которая не допускает минуса
		$year  = $matches[1];//отрицательные значения невоможны из-за regex-маски, которая не допускает минуса
	} else
	{
		$errors[$field . '_format'] = null;
		return false;
	}

	// Выправляем одно- и двухциферный год в нужный век (ориентируясь по текущему году).
	$current_year2digit = date('y');// 2-digit
	$current_year4digit = date('Y');// 4-digit
	$current_millenium  = $current_year4digit - $current_year2digit;
	if (($year >  $current_year2digit) && ($year <= 99)) $year += $current_millenium - 100;
	if (($year <= $current_year2digit) && ($year >= 00)) $year += $current_millenium;

	// Проверяем что такая дата существует в природе.
	if (!checkdate($month, $day, $year))
	{
		$errors[$field . '_invalid'] = null;
		return false;
	}

	// Записываем дату в MySQL-формат.
	$data[$field] = sprintf('%04d-%02d-%02d', $year, $month, $day);
	return true;
}

function validate_datetime (&$errors, &$data, $field)
{
	if (!strlen($data[$field])) return;
	if ($ok = preg_match('/^(\\d+)\\.(\\d+)\\.(\\d+) (?: \\s* \+*(\\d+) (?: \\:(\\d+) (?: \\:(\\d+) )? )? )? $/x', $data[$field], $matches))
	{
		$year   = isset($matches[3]) ? $matches[3] : null;//отрицательные значения невоможны из-за regex-маски, которая не допускает минуса
		$month  = isset($matches[2]) ? $matches[2] : null;//отрицательные значения невоможны из-за regex-маски, которая не допускает минуса
		$day    = isset($matches[1]) ? $matches[1] : null;//отрицательные значения невоможны из-за regex-маски, которая не допускает минуса
		$hour   = isset($matches[4]) ? $matches[4] : null;//отрицательные значения невоможны из-за regex-маски, которая не допускает минуса
		$minute = isset($matches[5]) ? $matches[5] : null;//отрицательные значения невоможны из-за regex-маски, которая не допускает минуса
		$second = isset($matches[6]) ? $matches[6] : null;//отрицательные значения невоможны из-за regex-маски, которая не допускает минуса
	} else
	if ($ok = preg_match('/^(\\d+) - (\\d+) - (\\d+) (?: \\s* \+*(\\d+) (?: \\:(\\d+) (?: \\:(\\d+) )? )? )? $/x', $data[$field], $matches))
	{
		$year   = isset($matches[1]) ? $matches[1] : null;//отрицательные значения невоможны из-за regex-маски, которая не допускает минуса
		$month  = isset($matches[2]) ? $matches[2] : null;//отрицательные значения невоможны из-за regex-маски, которая не допускает минуса
		$day    = isset($matches[3]) ? $matches[3] : null;//отрицательные значения невоможны из-за regex-маски, которая не допускает минуса
		$hour   = isset($matches[4]) ? $matches[4] : null;//отрицательные значения невоможны из-за regex-маски, которая не допускает минуса
		$minute = isset($matches[5]) ? $matches[5] : null;//отрицательные значения невоможны из-за regex-маски, которая не допускает минуса
		$second = isset($matches[6]) ? $matches[6] : null;//отрицательные значения невоможны из-за regex-маски, которая не допускает минуса
	} else
	{
		$errors[$field . '_format'] = null;
		return false;
	}

	// Выправляем одно- и двухциферный год в нужный век (ориентируясь по текущему году).
	$current_year2digit = date('y');// 2-digit
	$current_year4digit = date('Y');// 4-digit
	$current_millenium  = $current_year4digit - $current_year2digit;
	if (($year >  $current_year2digit) && ($year <= 99)) $year += $current_millenium - 100;
	if (($year <= $current_year2digit) && ($year >= 00)) $year += $current_millenium;

	// Проверяем что такая дата существует в природе.
	if (!checkdate($month, $day, $year) || ($hour < 0) || ($hour > 23) || ($minute < 0) || ($minute > 59) || ($second < 0) || ($second > 59))
	{
		$errors[$field . '_invalid'] = null;
		return false;
	}

	// Записываем дату в MySQL-формат.
	$data[$field] = sprintf('%04d-%02d-%02d %02d:%02d:%02d', $year, $month, $day, $hour, $minute, $second);
	return true;
}

function validate_gp (&$errors, $data, $field)
{
	_main_::depend('gp');
	$ok = true;
	if (!gp_check_answer($data[$field . '_id'], $data[$field . '_answer'], (bool) (!count($errors))))
	{
		$errors[$field . '_wrong'] = null;
		$ok = false;
	}
	return $ok;
}

function validate_spam (&$errors, $data, $field)
{
	$ok = true;

	_main_::depend('spam');
	$t = spam_check_masks($data[$field], _config_::$spam_masks, true);
	$l = spam_check_links($data[$field]);

	if (count($t) || ($l >= 10))
	{
		$errors[$field . '_filtered'] = $t;
		$errors[$field . '_filtered']['links'] = $l;
		$ok = false;
	}

	return $ok;
}

?>