<?php
//
// (c) 2007 http://www.howard-studio.ru/
// Sergei Vasilyev, nolar@howard-studio.ru
//
// Функция для определения MIME-типа файла по его содержимому (т.н. magic mime).
//
// WARNING:
// Fileinfo() настолько глючное, что жуть:
// 1. Путь к файлу mime-базы надо указывать БЕЗ расширения .mime, иначе оно его не найдёт.
// 2. Под виндой надо в magic.mime заменить все "!" на "\!", иначе будет всегда возвращать "application/x-dpkg".
// 3. Путь к проверяемому файлу надо подавать всегда в абсолютном виде (для этого тут realpath()).
// 4. Иногда оно возвращает mime-тип с кодировкой (например, "text/plain; charset=us-ascii" для файлов "*.txt").
// И эта багнутая вещь считается лучше чем mime_content_type(), которая стала deprecated. :-(
// К тому же mime_content_type() ругается что база не инициализирована (не знаю как сделать что не ругалось).
//

function get_mime ($path, $default = '')
{
	if (function_exists('mime_content_type'))
	{
		$result = mime_content_type($path);
		if ($result === false) $result = null;
	}
	elseif (function_exists('finfo_open') && function_exists('finfo_file'))
	{
		$fpath = isset(_config_::$magic_mime_file) ? _config_::$magic_mime_file : null;
		if (strcasecmp(substr($fpath, -5), ".mime") == 0) $fpath = substr($fpath, 0, -5);
		$finfo = finfo_open(FILEINFO_MIME, $fpath);
		if ($finfo === false) $result = null; else
		{
			$path = realpath($path);
			$result = finfo_file($finfo, $path);

			// Избавляемся от кодировки в ответах типа "text/plain; charset=ascii"
			$tmp = explode(';', $result, 2); $result = trim(array_shift($tmp));

			finfo_close($finfo);
		}
	}
	else
	{
		$result = $default;
	}
	return $result;
}

?>