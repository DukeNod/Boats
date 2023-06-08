<?php
function listDir($path) // получение содержимого каталога
{	// Вход: Путь к сканируемому каталогу
	// Выход: Ассоциативный массив:
	//				Элемент 'file' - список файлов
	//				Элемент 'dir' - список каталогов
	//				Элемент 'filelink'- список симв. ссылок на файлы
	//				Элемент 'dirlink' - список симв. ссылок на каталоги
	$list['file'] = array();
	$list['filelink'] = array();
	$list['dir'] = array();
	$list['dirlink'] = array();
	if(!($odir = @opendir($path))) die("неверный путь к каталогу или нет доступа");
	while(($file = readdir($odir))!== false)
	{
		if($file == "." || $file == "..") continue;
		if(is_file($path."/".$file)) // файл или символическая ссылка на файл
		{
			if(is_link($path."/".$file)) $list['filelink'][] = $file; // символическая ссылка на файл //=readlink($file);
			else $list['file'][] = $file; // простой файл
		}
		
		elseif(is_dir($path."/".$file)) // каталог или символическая ссылка на каталог
		{
			if(is_link($path."/".$file)) $list['dirlink'][] = $file; // символическая ссылка на каталог  //=readlink($file);
			else $list['dir'][] = $file; // простой каталог
		}
	}
	closedir($odir);
	return $list;
}
function makeDir($path) // создание нового каталога с рэндомным именем
{	// Вход: Путь для нового каталога
	// Выход: Имя созданного калалога, а в случае ошибки false
	do
	{
		$name = md5(microtime().rand(0, 9999));
	}
	while(file_exists($path.$name));
	if(mkdir($path.$name)) return $name;
	return false;
}
function clearDir($path) // рекурсивное удаление содержимого каталога
{	// Вход: Путь к очищаемому каталогу
	$list = listDir($path);
	if(isset($list['file'][0]))     foreach($list['file'] as $file) unlink($path."/".$file);
	if(isset($list['filelink'][0])) foreach($list['filelink'] as $file) unlink($path."/".$file);
	if(isset($list['dirlink'][0]))  foreach($list['dirlink'] as $file) unlink($path."/".$file);
	if(isset($list['dir'][0]))      foreach($list['dir'] as $file) { clearDir($path."/".$file); rmdir($path."/".$file); }
	return;
}
function removeDir($path) // рекурсивное удаление каталога
{	// Вход: Путь к удаляемому каталогу
	clearDir($path);
	rmdir($path);
	return;
}
function makeFileName($path, $pefix="", $suffix="", $ext="") // генерация рэндомного имени файла
{	// Вход: Путь для нового файла, Фиксированный префикс, Фиксированный суффикс, Тип
	// Выход: Имя для нового файла, а в случае ошибки false
	do
	{
		$name = $pefix.md5(microtime().rand(0, 9999)).$suffix.($ext==""?"":".").$ext;
	}
	while(file_exists($path.$name));
	return $name;
}
function download($file, $mimetype="application/octet-stream")
{
	#session_write_close();
	if(file_exists($file))
	{
		#set_time_limit(600);
		#ignore_user_abort(true);
		$filesize = filesize($file);
		header("Content-Description: File Transfer");
		header("Content-Type: ".$mimetype);
		header("Content-Disposition: attachment; filename=\"".basename($file)."\";");
		header("Last-Modified: ".gmdate("r", filemtime($file)));
		header("ETag: ".sprintf('%x-%x-%x', fileinode($file), $filesize, filemtime($file)));
		header("Content-Length: ".($filesize));
		header("Connection: close");
		ob_end_clean();
		$fp = fopen($file, "rb");
		while(!feof($fp))
		{
			echo fread($fp, 8*1024);
			flush(); ob_flush(); 
			if(connection_aborted()) return 1;
		}
		fclose($fp);
		return 0;
	}
	return 2;
}

function upload_file()
{
	$uploads_path = "../../uploads/";
	
	if (isset($_POST['cmd']) && $_POST['cmd'] == 'init_upload')
	{
		$res['session'] = makeDir($uploads_path);
		
		//_main_::returnJSON($res);
		echo json_encode($res);
		die;
	}

	if (isset($_GET['session']))
	{
		$session = $_GET['session'];
		$total = $_GET['total'];
		$filename = $_GET['filename'];
		$filesize = $_GET['filesize'];
		
		if ($session == '')
		{
			_main_::returnError('Wrong Session! 1');
		}

		if (strpos($session, '.') !== FALSE)
		{
			_main_::returnError('Wrong Session! 2');
		}

		if (strpos($filename, '/') !== FALSE)
		{
			_main_::returnError('Wrong Session! 3');
		}

		if (strpos($filename, '\\') !== FALSE)
		{
			_main_::returnError('Wrong Session! 4');
		}

		$dir = $uploads_path.$session.'/';

		if (!file_exists($dir))
		{
			_main_::returnError('Wrong Session! 2');
		}

		if ($total > 2*1024*1024*1024)
		{
			_main_::returnError('Wrong file size');
		}

	#	$file = $dir.$filename;
	#	$ext = pathinfo($filename, PATHINFO_EXTENSION);

		$allow = true;
		foreach (_config_::$ext_for_files as $ext => $action)
		{
			if (($ext == '.*') || ($ext == '*') || ($ext === '') || ($ext === null)
			|| (strcasecmp(substr($filename, -strlen($ext)), $ext) == 0))
			{              	
				if (is_string($action) && strlen($action))
				{
					$filename = substr($filename, 0, -strlen($ext)) . $action;
					$allow = true;
				} else
				{
					$allow = (bool) $action;
				}
				break;
			}
		}
		
		if (!$allow)
		{
			_main_::returnError('Wrong file extension.');
		}
		

		$file = $dir.$filename;
		
		$slice = file_get_contents('php://input', 'r');
		file_put_contents($file, $slice, FILE_APPEND);
		$res['written'] = strlen($slice);

		if (filesize($file) >= $total)
		{
			$res['result'] = 'ok';
			
			ob_end_clean();
			header("Connection: close\r\n");
			header("Content-Encoding: none\r\n");
			//session_write_close();
			ignore_user_abort(true);
			ob_start();

			echo json_encode($res);

			$size = ob_get_length();
			header("Content-Length: $size");

			ob_end_flush();
			ob_flush();
			flush();
			ob_end_clean();
			
			return [ $session, $filename ];
		}
		
		echo json_encode($res);
		die;
	}
	
	return false;
}
?>