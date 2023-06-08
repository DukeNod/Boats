<?php
$u = _main_::fetchModule('users');
#$u->access();
#$u->check([ 'admin' ]);
?>
<html>
<head>
<meta http-equiv="refresh" content="5">
</head>
<body>
<?php
	header("Content-Type: text/html; charset=utf-8"); 

	$log_file = "../../.internals/files/debug.log";
	if (isset($_POST['clear']))
	{
		file_put_contents($log_file, "");
		header("Location: "._config_::$dom_info['pub_root']."log/"); 
	}
?>

<form action="" method="post">
<input type="hidden" name="clear" value="1">
<input type="submit" value="Очистить">
</form>

<pre>
<?php
	readfile($log_file);
?>
</pre>
</body>
</html>
<?php
die;
?>