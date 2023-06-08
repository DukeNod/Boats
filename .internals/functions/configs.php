<?php
//
// (c) 2007 http://www.howard-studio.ru/
// Sergei Vasilyev, nolar@howard-studio.ru
//
// Функция для добычи конфигов модуля (задаётся ключами $keys), с возможностью перекрытия определённых
// значений в конфиге от корня массива до нужного модуля. Используется наиболее глубоко вложенное значение.
// Если значения в конфиге вообще нет, то будет поставлено null. Так или иначе, все запрошенные поля ($fields)
// будут присутствовать в результирующем массиве; других полей не будет ни в коем случае.
//
// Ключи представляют собой "путь" к нужному значению от корня массива _config_::$modules.
// Например, если $keys = array('abc', 'def', 'hij'), то функция попробует найти и вернуть (в порядке убывания приоритетности):
// * _config_::$modules['abc']['def']['hij']
// * _config_::$modules['def']['hij']
// * _config_::$modules['hij']
//
// Составление такой структуры в конфиге гораздо удобнее, чем прописывание каждого отдельного значения, потому что:
// * имя модуля и иной селектор (ключ) может меняться динамически без привлечения сверх-языковых конструкций (типа $$varname);
// * большинство значений можно пропускать лио задавать в единичном экземпляре на уровни ключей выше, чем ему должно быть.
//
// Отличать в общем массиве ключи от полей нужно только по здравому смыслу и корректности кода;
// никаких специальных пометок, критериев или методик для такого отличия нет.
//

function config_for_module ($keys, $fields)
{
	// Подгоняем всё в нужные структуры данных, как они будут использоваться ниже.
	if (!is_array($keys  )) $keys   = ($keys   === null) ? array() : array($keys  );
	if (!is_array($fields)) $fields = ($fields === null) ? array() : array($fields);
	$result = array();

	// Гарантируем что хотя бы значения null будут заданы. Кроме того, фиксируем порядок полей как запрошено.
	foreach ($fields as $field) $result[$field] = null;

	// В цикле выдёргиваем поля от корневого до самого последнего уровня, пока оно выдёргивается.
	// Условия остановки: либо кончились ключи для углубления, либо очередного ключа в конфиге нет.
	// Специальный ключ "" (пустая строка или null) в конфиге срабатывает на все значения ключей.
	$config = isset(_config_::$modules) ? _config_::$modules : null;
	for ($key = reset($keys); is_array($config); $key = next($keys))
	{
		// Выдёргиваем те поля, которые присутствуют на текущем обрабатываемом уровне конфига.
		foreach ($fields as $field)
			if (array_key_exists($field, $config))
				$result[$field] = $config[$field];

		// Переходим далее вглудь конфига. Причём только если ключ есть.
		// Если нужного ключа нет, либо если список ключей кончился, то за'null'яем, и выходим из цикла.
		$config = 
			(($key !== false) && array_key_exists($key, $config) ? $config[$key] :
			(($key !== false) && array_key_exists(null, $config) ? $config[null] : 
			(null)));
	}
	// Возвращаем что насобирали.
	return $result;
}

// Извлечение диапазонов размеров прилинкованных картинок из конфига.

function extract_limits(&$config)
{

	$sizes = array('small');

	if ($config['count'] > 1)
	{
		$sizes[] = 'large';
		if ($config['count'] == 3)
			$sizes[] = 'middle';
	}

	$result = array();

	foreach($sizes as $size)
	{	
		if (strpos($config[$size.'_limit_w'], '-')!==false)
		{
			list($result[$size]['w_min'], $result[$size]['w_max']) = explode('-', $config[$size.'_limit_w']);
		}else
		{
			$result[$size]['w_min'] = 1;
			$result[$size]['w_max'] = $config[$size.'_limit_w'];
		}

		if (strpos($config[$size.'_limit_h'], '-')!==false)
		{
			list($result[$size]['h_min'], $result[$size]['h_max']) = explode('-', $config[$size.'_limit_h']);		
		}else
		{
			$result[$size]['h_min'] = 1;
			$result[$size]['h_max'] = $config[$size.'_limit_h'];
		}
	}
	return ($result) ? $result : null;
}

?>