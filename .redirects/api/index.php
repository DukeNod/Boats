<?php
//define('_DEBUG_', false);//если не определена, то отладку можно включить в запросе; явно задавать false в релизах!
//define('_TIMER_', false);//если не определена, то замер   можно включить в запросе; явно задавать false в релизах!
#xdebug_disable();
ini_set('html_errors', 0);

$GLOBALS['api'] = 1;

require_once("../../.internals/config.php");
require_once("../../.internals/main.php");
require_once("../../.internals/identify_consumer.php");
require_once("../../.internals/session.php");

/*
session_name('token');

if (isset($_POST['token']) && $_POST['token'])
	session_id($_POST['token']);
elseif (isset($_GET['token']) && $_GET['token'])
	session_id($_GET['token']);
*/

session_start();

_config_::$modules_dir = sprintf(_config_::$modules_dir, 'api');
_main_::cache_mode('nostore');// Делаем страницы некешируемым и вообще нехранимыми (при возможности).
_main_::cache_time(0);// Со сроком устаревания immediately.
_main_::_work_();
?>