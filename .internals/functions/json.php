<?php
//
// (c) 2007 http://www.howard-studio.ru/
// Sergei Vasilyev, nolar@howard-studio.ru
//
// Функции для обработки данных в формате JSON (для взаимодействия с AJAX).
//

// Получает "сырые" POST-данные запроса (именно так их шлёт AJAX).
function http_raw_post_data ()
{
	$input = file_get_contents('php://input');// http raw post data are in stdin
	return $input;
}

// Парсит JSON структуру и возвращает её в PHP-совместимой структуре.
// В случае если попрошено, то обрабатывает ошибки -- при их обнаружении генерирует exception.
function retrieve_json ($required = false)
{
	_main_::depend('_external_/Services_JSON/JSON');
	$json  = new Services_JSON(SERVICES_JSON_LOOSE_TYPE | SERVICES_JSON_SUPPRESS_ERRORS);
	$input = http_raw_post_data();
	$value = $json->decode($input);
	//todo: check for errors and throw (if $required) or SILENTLY ignore (if not required).
	return $value;
}

// Duke:
// Кодирует PHP в JSON структуру и возвращает её в виде строки
// Принимает только UTF-8
function put_json ($var)
{
	_main_::depend('_external_/Services_JSON/JSON');
	$json  = new Services_JSON(SERVICES_JSON_LOOSE_TYPE | SERVICES_JSON_SUPPRESS_ERRORS);
	$value = $json->encode($var);
	//todo: check for errors and throw (if $required) or SILENTLY ignore (if not required).
	return $value;
}

?>