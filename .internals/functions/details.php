<?php

function select_details (&$struct, $details, $fields)
{
	// Не работаем там, где нет данных для детализации.
	if (!count($struct)) return;

	// Отсеиваем случаи когда список собственных полей просто не задан. Это косяк, без списка фича не работает.
	if (!is_array($fields )) throw new exception_bl('Self-descriptive fields must be an array in '.__FUNCTION__.'().');

	// Придаём минимально ожидаемую структуру параметрам детализации, если они ещё этой структурой не обладают.
	if (!is_array($details)) $details = array('*' => $details);
	if (!array_key_exists('*', $details)) $details['*'] = null;

	// Проходимся по всем собственным полям в том порядке, в котором сущность описала себя.
	foreach ($fields as $field => $function)
	{
		// Проверяем нужно ли включать это поле в результат (зависит от дефолтного режима и указания для поля).
		$subdetails = array_key_exists($field, $details) ? $details[$field] : $details['*'];

		// Проверяем, нужно ли читать детализацию для этого поля. И читаем, если нужно.
		if (is_array($subdetails) || (bool) $subdetails)
		{
			// Вызываем указанную функцию чтения. Набор и порядок аргументов всегда строго предопределён,
			// но ради передачи by-reference мы используем call_user_func_array() вместо call_user_func().
			if ($function === null) {} else
			if (!is_callable($function)) throw new exception("Function is not callable."); else
			call_user_func_array($function, array(&$struct, $subdetails));
		}
	}
}

function select_details_oop ($module, &$struct, $details, $fields, $params = [])
{
	// Не работаем там, где нет данных для детализации.
	if (!count($struct)) return;

	// Отсеиваем случаи когда список собственных полей просто не задан. Это косяк, без списка фича не работает.
	if (!is_array($fields )) throw new exception_bl('Self-descriptive fields must be an array in '.__FUNCTION__.'().');

	// Придаём минимально ожидаемую структуру параметрам детализации, если они ещё этой структурой не обладают.
	if (!is_array($details)) $details = array('*' => $details);
	if (!array_key_exists('*', $details)) $details['*'] = null;

	// Проходимся по всем собственным полям в том порядке, в котором сущность описала себя.
	foreach ($fields as $field => $function)
	{
		// Проверяем нужно ли включать это поле в результат (зависит от дефолтного режима и указания для поля).
		$subdetails = array_key_exists($field, $details) ? $details[$field] : $details['*'];

		// Проверяем, нужно ли читать детализацию для этого поля. И читаем, если нужно.
		if (is_array($subdetails) || (bool) $subdetails)
		{
			// Вызываем указанную функцию чтения. Набор и порядок аргументов всегда строго предопределён,
			// но ради передачи by-reference мы используем call_user_func_array() вместо call_user_func().
			$m=_main_::fetchModule($module);
			if ($function === null) {} else
			if (!is_callable(array($m,$function))) throw new exception("Function is not callable."); else
			call_user_func_array(array($m,$function), array(&$struct, $subdetails, $params));
		}
	}
}

?>