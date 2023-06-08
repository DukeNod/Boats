<?php

_main_::depend('typograph-unicode');

try
{
	// Берём текст в предположении что он в UTF-8 (как и весь сайт), и обрабатываем его.
	$text = file_get_contents('php://input');// http raw post data
	$text = function_exists('typograph_throwable') ? typograph_throwable($text) : typograph($text);
}
catch (service_exception $e)
{
	header("HTTP/1.0 503");
}

// Пишем вывод (включая тип и кодировку контента).
header("Content-type: text/plain; charset=utf-8");
print($text);

// Тихо выходим из ядра, не применяя xslt, потому как у нас простой текстовый вывод.
throw new exception_exit();

?>