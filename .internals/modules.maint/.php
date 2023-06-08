<?php


if (count($pathargs))
{
	header("HTTP/1.0 404 Not Found");
	_main_::put2dom('unknown');
} else
{
	_main_::put2dom('main');
}

?>