<?php
//
// Чистка временных папок от старых файлов, которые остаются когда формы не завершаются успехом
// (обычно когда их забрасывают без завершения, предварительно загрузив файлы).
//
// Рекомендуется выполнять раз в день-неделю.
//

//
clean_oldies_from_temporary_folder(_config_::$tmp_for_linked, 3*24*60*60);
//???clean_oldies_from_temporary_folder(_config_::$tmp_for_attachments, 3*24*60*60);

// В случае "тихого" режима не генериуем отчёт.
if (in_array('silent', $pathargs)) throw new exception_exit();

////////////////////////////////////////////////////////////////////////////////////////////////////

// Объявление функции чистики одного указанного каталога.
// Выносить в depend() нет смысла, так как она актуальна ТОЛЬКО на этой странице.
function clean_oldies_from_temporary_folder ($directory, $age)
{
	$stamp_limit = time() - $age;
	if (($d = opendir($directory)) !== false)
	{
		while (($filename = readdir($d)) !== false)
		{
			if (($filename == '.') || ($filename == '..')) continue;
			$filepath = $directory . $filename;
			if (is_dir($filepath))
			if (($file_stamp = filemtime($filepath)) !== false)
			if ($file_stamp <= $stamp_limit)
			{
				if (($d2 = opendir($filepath)) !== false)
				{
					while (($filename2 = readdir($d2)) !== false)
					{
						if (($filename2 == '.') || ($filename2 == '..')) continue;
						$filepath2 = $filepath . '/' . $filename2;
						if (is_file($filepath2)) unlink($filepath2);
					}
					closedir($d2);
					rmdir($filepath);
				}
			}
		}
		closedir($d);
	}
}

?>