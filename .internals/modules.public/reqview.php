<?php

$u = _main_::fetchModule('users');
$u->check();


if (isset($pathargs[0]))
{
	$val = $pathargs[0];
	$param = 'requestsStyle';
}

$dat = array($param => $val);

$u->setParam($dat, _identify_::$info['id']);

_main_::Redirect(_config_::$dom_info['pub_site']);