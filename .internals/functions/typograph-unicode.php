<?php
//
// (a) 2008 nolar@howard-studio.ru, nolar@numeri.net
// (c) 2008 http://www.howard-studio.ru/
//
// Wrapper'ы для вызова типографа через сервисы.
//
// Сами классы сервисов должны подгружаться динамически и автоматически (autoload).
// Поскольку в старых проектах ни классов, ни тем более автоподгрузок не было,
// то тут можно влёгкую определить функцию __autoload() для этих целей, и быть 
// уверенным, что она не пересечётся с другим автоподгрузчиком. В новых проектах
// надо будет обеспечить загрузку классов самостоятельно.
//
// А! Другой способ - слить все нужные файлы воедино и одной библиотекой подгружать.
// Никакой autoload вообще тогда не нужен.
//

function typograph_throwable ($text, $force_quotes = true, $language = null)
{
	//fix: затычка-защитница от визуальных заменителей невидимых символов (nbsp & shy).
	//fix: вообще-то должно вырезаться в js или там, откуда оно приходит.
	//fix: но для надёжности мы и тут заменим.
	//fix: но никак не в сервисе - ибо нефиг, оно (masculine ordinal indicator) вообще-то буква (latin letter lowercase).
	$text = str_replace(array("\xC2\xBA"), array("\xC2\xA0"), $text);

	$url  = isset(_config_::$remote_services_url ) ? _config_::$remote_services_url  : (defined('REMOTE_SERVICES_URL' ) ? REMOTE_SERVICES_URL  : 'http://www.howard-studio.ru/remote_services/typograph/%s/');
	$user = isset(_config_::$remote_services_user) ? _config_::$remote_services_user : (defined('REMOTE_SERVICES_USER') ? REMOTE_SERVICES_USER : null);
	$pass = isset(_config_::$remote_services_pass) ? _config_::$remote_services_pass : (defined('REMOTE_SERVICES_PASS') ? REMOTE_SERVICES_PASS : null);

	_main_::depend('services.remotes');
	$s = new remote_service_invoker(
		$url,
		new remote_service_enveloper_serialized,
		new remote_service_connector_file_get_contents(10, $user, $pass));
	return $s->format($text, $force_quotes, $language);
}

function typograph ($text, $force_quotes = true, $language = null)
{
	try
	{
		return typograph_throwable($text, $force_quotes, $language);
	}
	catch (service_exception $e)
	{
		return $text;
	}
}

?>