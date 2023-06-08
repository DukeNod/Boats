<?php

if (count($pathargs))
{
	try {
	        $module_name = array_shift($pathargs);
		$m = _main_::fetchModule($module_name);

		if (!isset($pathargs[0]))
		{
			_main_::set_module_file("/common/$module_name");
			_main_::execute_module();
		}else
		{
		        $action = array_shift($pathargs);
			
			_main_::set_module_file("/common/$action/$module_name", $pathargs);
			_main_::execute_module();
		}

	}catch (exception_depend $exception)
	{
		header("HTTP/1.0 404 Not Found");
		_main_::put2dom('unknown');
	}
} else
{
	_main_::put2dom('main');
}

?>