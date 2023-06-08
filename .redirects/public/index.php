<?php
if (!(@$_COOKIE['PHPSESSID']||@$_GET['PHPSESSID']))
	session_cache_limiter('public');

//define('_DEBUG_', false);//если не определена, то отладку можно включить в запросе; явно задавать false в релизах!
//define('_TIMER_', false);//если не определена, то замер   можно включить в запросе; явно задавать false в релизах!
require_once("../../.internals/config.php");
require_once("../../.internals/main.php");
require_once("../../.internals/identify_consumer.php");
require_once("../../.internals/session.php");

session_start();

_config_::$modules_dir = sprintf(_config_::$modules_dir, 'public');

if (!(@$_COOKIE['PHPSESSID']||@$_GET['PHPSESSID']))
{
//	_main_::cache_mode('public');// Делаем по умолчанию кешируемым.
//	_main_::cache_time(24*60*60);// Со сроком устаревания 1d.
}
_main_::_work_();
?>