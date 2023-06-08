<?php
//define('_DEBUG_', true);//если не определена, то отладку можно включить в запросе; явно задавать false в релизах!
//define('_TIMER_', true);//если не определена, то замер   можно включить в запросе; явно задавать false в релизах!
session_start();
$GLOBALS['adminka'] = $_SESSION['admin'] = 1;

require_once("../../.internals/config.php");
require_once("../../.internals/main.php");
	PutTimer();
_config_::$modules_dir = sprintf(_config_::$modules_dir, 'admin');
_main_::cache_mode('nostore');// Делаем страницы некешируемым и вообще нехранимыми (при возможности).
_main_::cache_time(0);// Со сроком устаревания immediately.
_main_::_work_();
?>