<?php
//
// (c) 2007 http://www.howard-studio.ru/
// Sergei Vasilyev, nolar@howard-studio.ru
//
// Функции для быстрого оперирования массивами данных, причём не всякими, а приспособленными для наших задач
// (чтение данных или _main_::query() и запихивание в DOM через _main_::dom()).
//
// В функциях array_merge() значение null считается как отсутствующее.
//
// В функциях get_fields/merge_subtable() поле задаётся или непосредственно именем (это поле и будет создано),
// либо массивом, в котором последний элемент - это само имя создаваемого поля, а другие поля до него задают
// путь для углубления в целевой таблице (если нужно внедрять не просто по плоской таблице, а по большой иерархии).
//

// Формирует конечный массив накладыванием not-null значений из массивов-аргументов (справа налево).
//lor = left over(overrides?) right (i.e. left arrays have priority over right arrays)
function array_merge_lor (/* var arg list*/)
{
	$result = array();
	$arrays = func_get_args();
	foreach ($arrays as $array)
		if (is_array($array))
			foreach ($array as $key => $val)
				if (!array_key_exists($key, $result) || ($result[$key] === null))
					$result[$key] = $val;
	return $result;
}

// Формирует конечный массив накладыванием not-null значений из массивов-аргументов (слева направо).
//rol = right over(overrides?) left (i.e. right arrays have priority over left arrays)
function array_merge_rol (/* var arg list*/)
{
	$result = array();
	$arrays = func_get_args();
	foreach ($arrays as $array)
		if (is_array($array))
			foreach ($array as $key => $val)
				if (!array_key_exists($key, $result) || ($val !== null))
					$result[$key] = $val;
	return $result;
}

// Возвращает список значений опредлённого поля в исходной таблице.
// Уникальность не обеспечивается (мало ли для чего всё это выдёргивается, она может быть и нужна)!
function get_fields ($array, $fields)
{
	if (is_scalar($fields)) $fields = ($fields === null) ? array() : array($fields);
	$field = array_shift($fields);

	if (is_array($array))
	{
	$result = array();
		if (count($fields))// если ещё остались поля после забора оттуда первого
		{
			foreach ($array as $row)
				$result = array_merge($result, get_fields($row[$field], $fields));
		} else
		if ($field !== null)// если хотя бы одно поле было указано, но больше уже не осталось
		{
			foreach ($array as $row)
				$result[] = isset($row[$field]) ? $row[$field] : null;
		}
		return $result;
	}else
		return null;
}

// Внедряет поле подтаблицы ($subtable) как скалярное поле в целевую таблицу ($table),
// но только из тех записей подтаблицы, у которых поле $field_uplink совпадает с целевым $field_id.
function merge_subtable_as_scalar (&$table, $subtable, $fields, $field_uplink, $field_id)
{
	if (is_scalar($fields)) $fields = ($fields === null) ? array() : array($fields);
	$field = array_shift($fields);

	if (count($fields))
	{
		foreach ($table as $idx => $row)
			merge_subtable_as_scalar($table[$idx][$field], $subtable, $fields, $field_uplink, $field_id);
	} else
	if ($field !== null)
	{
		foreach ($table as $idx1 => $row1)
		{
			$table[$idx1][$field] = null;
			foreach ($subtable as $idx2 => $row2)
				if ($row2[$field_uplink] == $row1[$field_id])
					$table[$idx1][$field] = $row2[$field];
		}
	}
}

// Внедряет поле подтаблицы ($subtable) как табличное поле в целевую таблицу ($table),
// но только из тех записей подтаблицы, у которых поле $field_uplink совпадает с целевым $field_id.
function merge_subtable_as_array (&$table, $subtable, $fields, $field_uplink, $field_id)
{
	if (is_scalar($fields)) $fields = ($fields === null) ? array() : array($fields);
	$field = array_shift($fields);

	if (count($fields))
	{
		foreach ($table as $idx => $row)
			merge_subtable_as_array($table[$idx][$field], $subtable, $fields, $field_uplink, $field_id);
	} else
	if ($field !== null)
	{
		foreach ($table as $idx1 => $row1)
		{
			if (!isset($table[$idx1][$field])) $table[$idx1][$field] = array();
			foreach ($subtable as $idx2 => $row2)
				if ($row2[$field_uplink] == $row1[$field_id])
				{
					if (isset($GLOBALS['api']) && $GLOBALS['api'] == 1)
						$table[$idx1][$field][] = $row2;
					else
						$table[$idx1][$field][$idx2] = $row2;
				}
		}
	}
}

// Внедряет одну запись подтаблицы ($subtable) как табличное поле в целевую таблицу ($table),
// но только из тех записей подтаблицы, у которых поле $field_uplink совпадает с целевым $field_id.
function merge_subtable_row (&$table, $subtable, $fields, $field_uplink, $field_id)
{
	if (is_scalar($fields)) $fields = ($fields === null) ? array() : array($fields);
	$field = array_shift($fields);

	if (count($fields))
	{
		foreach ($table as $idx => $row)
			merge_subtable_as_array($table[$idx][$field], $subtable, $fields, $field_uplink, $field_id);
	} else
	if ($field !== null)
	{
		foreach ($table as $idx1 => $row1)
		{
			if (!isset($table[$idx1][$field])) $table[$idx1][$field] = array();
			foreach ($subtable as $idx2 => $row2)
				if ($row2[$field_uplink] == $row1[$field_id])
					$table[$idx1][$field] = $row2;
		}
	}
}

?>