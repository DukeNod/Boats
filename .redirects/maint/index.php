<?php
//define('_DEBUG_', true);//если не определена, то отладку можно включить в запросе; явно задавать false в релизах!
//define('_TIMER_', true);//если не определена, то замер   можно включить в запросе; явно задавать false в релизах!
require_once("../../.internals/config.php");
require_once("../../.internals/main.php");
_config_::$modules_dir = sprintf(_config_::$modules_dir, 'maint');
_main_::cache_mode('nostore');// Делаем страницы некешируемым и вообще нехранимыми (при возможности).
_main_::cache_time(0);// Со сроком устаревания immediately.
_main_::_work_();
?>