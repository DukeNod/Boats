<?php

$mode = isset($pathargs[0]) ? $pathargs[0] : null;
$time = 10*365*24*60*60;
$root = isset(_config_::$dom_info['adm_root']) ? _config_::$dom_info['adm_root'] : '/';
switch ($mode)
{
	case 'on':
	case '1':
		setcookie("DEBUG", "1", time()+$time, $root, "");
		$doc->documentElement->appendChild(_main_::dom_node_tree($doc, "on", null));
		break;
	case 'off':
	case '0':
		setcookie("DEBUG", null, time()+$time, $root, "");
		$doc->documentElement->appendChild(_main_::dom_node_tree($doc, "off", null));
		break;
}

?>