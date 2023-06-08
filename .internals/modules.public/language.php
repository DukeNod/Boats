<?php
$u = _main_::fetchModule('users');
$u->check([ 'admin' ]);

function r ($url)
{
	_main_::put2dom('url', $url);
	header("HTTP/1.0 301 Moved Permanently");
	header("Location: ".$url);
}

function ex ($w)
{
	_main_::set_module_file($w);
	_main_::set_module_xslt($w);
	_main_::execute_module();
}

function go ($w, $qs = null)
{
	if (($pos = strpos($w, '?')) !== false) { $qs = substr($w, $pos+1); $w = substr($w, 0, $pos-1); }
	parse_str($qs, $qa);

	$_GET = $qa;
	$_SERVER['QUERY_STRING'] = $qs;

	_main_::set_module_file($w);
	_main_::set_module_xslt($w);
	_main_::execute_module();
}

// Вычленяем имя модуля (идёт через GET первым номером без значения).
// Sample: http://www.autobam.ru/language/?page&id=34
$file = (($fkey = reset(array_keys($_GET))) !== false) && !strlen($_GET[$fkey]) ? $fkey : null;
$q = isset($_SERVER['QUERY_STRING']) ? $_SERVER['QUERY_STRING'] : null;

// Карта редиректов.
if (preg_match("/^ wheels_search&size=195%2F65\\+R15&manufactor=&id=1 \$/six", $q, $m)) go('/tyres/by/size?snow=&w=195&p=65&r=15&producer='); else 
if (preg_match("/^ wheels_search&size=205%2F55\\+R16&manufactor=&id=1 \$/six", $q, $m)) go('/tyres/by/size?snow=&w=205&p=55&r=16&producer='); else 
if (preg_match("/^ wheels_search&size=255%2F55\\+R18&manufactor=&id=1 \$/six", $q, $m)) go('/tyres/by/size?snow=&w=255&p=55&r=18&producer='); else 
if (preg_match("/^ wheels_search&size=195\\/65\\+R15&manufactor=&id=1 \$/six", $q, $m)) go('/tyres/by/size?snow=&w=195&p=65&r=15&producer='); else 
if (preg_match("/^ wheels_search&size=205\\/55\\+R16&manufactor=&id=1 \$/six", $q, $m)) go('/tyres/by/size?snow=&w=205&p=55&r=16&producer='); else 
if (preg_match("/^ wheels_search&size=255\\/55\\+R18&manufactor=&id=1 \$/six", $q, $m)) go('/tyres/by/size?snow=&w=255&p=55&r=18&producer='); else 
if (preg_match("/^ page&id=5                                          \$/six", $q, $m)) go('/service-types/388'); else 
if (preg_match("/^ page&id=29                                         \$/six", $q, $m)) go('/montage'); else 
if (preg_match("/^ page&id=32                                         \$/six", $q, $m)) go('/repair'); else 
if (preg_match("/^ page&id=58                                         \$/six", $q, $m)) go('/service-types/385'); else 
if (preg_match("/^ page&id=61                                         \$/six", $q, $m)) go('/service-types/390'); else 
if (preg_match("/^ page&id=11                                         \$/six", $q, $m)) go('/articles/33'); else 
if (preg_match("/^ page&id=56                                         \$/six", $q, $m)) go('/service-types/385'); else 
if (preg_match("/^ page(&id=.*)?                                      \$/six", $q, $m)) go('/service-types'); else 
if (preg_match("/^ disks_model_search&model=27                        \$/six", $q, $m)) go('/disks/by/auto?automodel=34'); else 
if (preg_match("/^ disks_model_search(&.*)?                           \$/six", $q, $m)) go('/disks'); else 
if (preg_match("/^ special(s?)(&id=(.*))?                             \$/six", $q, $m)) go('/specials'); else 
if (preg_match("/^ toning                                             \$/six", $q, $m)) go('/service-types/386'); else 
if (preg_match("/^ tuning(&.*)?                                       \$/six", $q, $m)) go('/service-types/394'); else 
if (preg_match("/^ order(&.*)?                                        \$/six", $q, $m)) go('/order'); else 
if (preg_match("/^ subscribe                                          \$/six", $q, $m)) go('/news'); else 
if (preg_match("/^ (articles|allarticles)                             \$/six", $q, $m)) go('/articles'); else 
if (preg_match("/^ articles&id=(.*)                                   \$/six", $q, $m)) go('/articles'); else 
if (preg_match("/^ show_wheel_description(&.*)?                       \$/six", $q, $m)) go('/disks'); else 
if (preg_match("/^ gallery_show(&id=.*)?                              \$/six", $q, $m)) go('/works'); else 
if (preg_match("/^ cataloguetools                                     \$/six", $q, $m)) go('/service-types/389'); else 
if (preg_match("/^ catalogue&id=13                                    \$/six", $q, $m)) go('/service-types/393'); else 
if (preg_match("/^ catalogueDiscs&id=2                                \$/six", $q, $m)) go('/disks'); else 
if (preg_match("/^ catalogueFolder&id=630                             \$/six", $q, $m)) go('/service-types/387'); else 
if (preg_match("/^ catalogueFolder&id=667                             \$/six", $q, $m)) go('/service-types/394'); else 
if (preg_match("/^ catalogueWheels2&id=1                              \$/six", $q, $m)) go('/tyres'); else 
if (preg_match("/^ catalogue(?:Item)?&id=(\\d+)                       \$/six", $q, $m)) go('/service-types'); else 
if (preg_match("/^ catalogue(?:OpticModel)?&id=(\\d+)    	      \$/six", $q, $m)) go('/service-types/7'); else 
if (preg_match("/^ catalogue(?:Optic|Folder)?&id=(\\d+)               \$/six", $q, $m)) go('/service-types/'.$m[1]); else 
{
	header("HTTP/1.0 404 Not Found");
	_main_::put2dom('unknown');
	go(null);
}

?>