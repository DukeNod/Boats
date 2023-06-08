<?php
//
// (c) 2007 http://www.howard-studio.ru/
// Sergei Vasilyev, nolar@howard-studio.ru
//
// Функции для обработки загруженных файлов. Обработка заключается в сохранении файлов либо в постоянное хранилище,
// либо во временное для следующих шагов/повторов операции (например, если в форме ошибки), либо полное удаление
// всех следов файлов. Поскольку файловые поля задаются определённым набором обычных скалярных полей
// (суффиксы path/temp/file/name), то и обработка здесь ведётся "умная", то есть с учётом какие поля какие значения имеют.
//
// Необходимость временного хранение файлов между шагами/повторами операции обуславливается тем, что, в отличие
// от скалярных полей, их нельзя выводить в форму в качестве значения по умолчанию и потом заново передавать при submit'е;
// и кроме того, загруженный файл удаляется после окончания скрипта самим PHP. Поэтому мы сохраняем этот файл
// во временное хранилище с уникальным сгенерированным идентификатором, и уже этот идентификатор таскаем с собой
// между submit'ами для ссылки на загруженный файл. Если однажды форма остаётся незавершённой до конца (то есть файл
// загружен во временное хранилище, но дальнейшие шаги/повторы операции не выполнялись и файл не был перемещён
// в постоянное хранилище), то этот файл так и останется во временном хранилище, практически вечно. Поэтому
// временное хранилище нужно ругулярно чистить от старых файлов.
//
// Идентификатора временного файла состоит из случайно сгенерированного кода и имени файла в конце (чтоб можно было
// автоматически восстановить исходное имя файла, если оно не таскается между submit'ами, а также чтобы у ссылки
// было исходное расширение и браузеры адекватно выводили такой файл -- он ведь выводится в формах даже когда временный).
//



// Копирует исходный файл (srcfield) на место целевого файла (dstfield), если целевой файл не был загружен.
// Применимо, например, к полноразмерной и уменьшенной картинкам, когда нужно уменьшенную взять из полноразмерной.
function put_uploaded_image_if_needed (&$data, $dstfield, $srcfield)
{
	// Если нет ни свежезалитого, ни старого, ни временного файла на замещаемом поле, но есть свежезалитый на исходном,
	// то замещаем всё так, как будто на замещаемое поле был залит точно тот же файл, что и на исходное.
	if (!(isset($data[$dstfield . '_path']) && strlen($data[$dstfield . '_path']))
	&&  !(isset($data[$dstfield . '_temp']) && strlen($data[$dstfield . '_temp']))
	&&  !(isset($data[$dstfield . '_name']) && strlen($data[$dstfield . '_name']))
	&&   (isset($data[$srcfield . '_path']) && strlen($data[$srcfield . '_path'])))
	{
		$data[$dstfield . '_path'] = $data[$srcfield . '_path'] . '.' . md5(rand());
		$data[$dstfield . '_name'] = isset($data[$srcfield . '_name']) ? $data[$srcfield . '_name'] : null;
		$data[$dstfield . '_type'] = isset($data[$srcfield . '_type']) ? $data[$srcfield . '_type'] : null;
		$data[$dstfield . '_size'] = isset($data[$srcfield . '_size']) ? $data[$srcfield . '_size'] : null;
		$data[$dstfield . '_w'   ] = isset($data[$srcfield . '_w'   ]) ? $data[$srcfield . '_w'   ] : null;
		$data[$dstfield . '_h'   ] = isset($data[$srcfield . '_h'   ]) ? $data[$srcfield . '_h'   ] : null;
		copy($data[$srcfield . '_path'], $data[$dstfield . '_path']);
	}
}

//
function put_uploaded_image_as_preview (&$data, $dstfield, $srcfield)
{
	// Если нет ни свежезалитого, ни старого, ни временного файла на замещаемом поле, но есть свежезалитый на исходном,
	// то замещаем всё так, как будто на замещаемое поле был залит точно тот же файл, что и на исходное.
	if (!(isset($data[$dstfield . '_path']) && strlen($data[$dstfield . '_path']))
	&&  !(isset($data[$dstfield . '_temp']) && strlen($data[$dstfield . '_temp']))
	&&   (isset($data[$srcfield . '_path']) && strlen($data[$srcfield . '_path'])))
	// ... и если у нас и так картинка, то испоьлзуем её саму в качестве превью.
	if ( (isset($data[$srcfield . '_type']) && strncasecmp($data[$srcfield . '_type'], 'image/', 6) == 0)
	||   (isset($data[$srcfield . '_name']) && preg_match('/\\.(gif|png|jpg|jpeg)\$/six', $data[$srcfield . '_name'])) )
	{
		put_uploaded_image_if_needed($data, $dstfield, $srcfield);
	}
	//??? pdf? via ghostscript+imagemagick
}

//
function fit_uploaded_image_to_grayscale (&$data, $field)
{
	if ((isset($data[$field . '_path']) && strlen($data[$field . '_path'])))
	{
		_main_::depend("images");
		// Emulate as if it was just uploaded.
		if (generate_image_grayscaled($data[$field . "_path"], $data[$field . "_path"]))
		{
			// nothing to do here
		}
	}
}

// Умещает свежезагруженную картинку в рамку по размерам. 
function fit_uploaded_image_to_limits (&$data, $field, $limit_w, $limit_h, $cut = false)
{
	if (($limit_w || $limit_h)
	&& ((isset($data[$field . '_path']) && strlen($data[$field . '_path'])))
	&& (($data[$field . '_w'] > $limit_w) || ($data[$field . '_h'] > $limit_h)))
	{
		_main_::depend("images");
		// Emulate as if it was just uploaded.
		if (generate_image_limited($data[$field . "_path"], $data[$field . "_path"], $limit_w, $limit_h, $new_w, $new_h, $cut))
		{
			$data[$field . '_w'] = $new_w;
			$data[$field . '_h'] = $new_h;
		}
	}
}



//todo: в будущем эта фукнция может дозаполнять $errors своими ошибками о сбоях в файловых операциях.
//todo: проблема может быть только в том, что обрабатывать ошибки может быть уже поздно, потому что операция в БД уже выполнена.
//todo: (разве что сделать rollback транзакции?)
//todo: но пока что $errors используется тоьлко для проверки что есть ошибки в валидации/операции.

// Удаление всех файлов указанного поля.
function handle_upload_cleanly (&$data, $field, $dir, $tmp)
{
	// Удаляем вообще всё что удаляемо касательно этого файл-поля.
	if (isset($data[$field . '_file'])) remove_file_from_dir($data[$field . '_file'], $dir);
	if (isset($data[$field . '_temp'])) remove_file_from_tmp($data[$field . '_temp'], $tmp);
	if (isset($data[$field . '_path'])) remove_file_from_php($data[$field . '_path']);
}

// Перемещение свежезагруженного файла во временное хранилище.
function handle_upload_temporarily (&$data, $field, $dir, $tmp)
{
	// Случай, когда в форме ошибки и будет перезапрос формы, но файл нужно сохранить временно.

		// Если у нас уже есть какой-то временный файл, и мы загрузили новый,
		// то старый временный стираем, потому как новый ляжет вместо него (хотя и с новым temp-id).
		if ((isset($data[$field . '_path']) && strlen($data[$field . '_path']))
		&&  (isset($data[$field . '_temp']) && strlen($data[$field . '_temp'])))
			remove_file_from_tmp($data[$field . '_temp'], $tmp);

		// Перемещаем файл из php-upload'а в наш tmp-folder, и запоминаем его идентификатор в данных.
		// Но только если он был залит. Иначе оставляем tmp нетронутым.
		if (isset($data[$field . '_path']) && strlen($data[$field . '_path']))//??? && strlen($data[$field . '_name'])
		{
			$data[$field . '_temp'] = md5(uniqid(rand(), true)) . '/' . $data[$field . '_name'];
			move_file_from_php_to_tmp($data[$field . '_path'], $data[$field . '_temp'], $tmp);
			$data[$field . '_path'] = null;
		}
}

// Перемещение свежезагруженного лио временного файла в постоянное хранилище.
function handle_upload_persistently (&$data, $field, $dir, $tmp)
{
	// Случай, когда форма принята и обработана, но в ней попрошено "отцепить" файл (удалить).
	//???todo: вообще большой вопрос что делать, когда мы вклчили галочку delete, и при этом сразу залили новый файл.
	//???todo: сейчас удаляется и игнорирует свежий аплоад (точнее, его тоже удаляет).

	if ($data[$field . '_delete'])
		handle_upload_cleanly($data, $field, $dir, $tmp);
	else

	// Случай, когда форма принята и обработана, и надо поместить файл (при его наличии) в постоянное хранилище.
	{
		// Если есть что переносить в постоянное хранилище, и есть что-то уже в постоянном хранилище,
		// то удаляем оттуда что есть, перед тем, как заливать новое.
		// В том числе если одинаковые имена файлов (просто не проверяем это).
		if ((isset($data[$field . '_path']) && strlen($data[$field . '_path']))
		||  (isset($data[$field . '_temp']) && strlen($data[$field . '_temp'])))
			remove_file_from_dir($data[$field . '_file'], $dir);

		// Помещаем файл в постоянное хранилище (из временного или php-upload'а).
		// Причём свежазалитый файл (php upload dir) имеет приоритет над ранее залитым (tmp dir).
		(isset($data[$field . '_path']) && move_file_from_php_to_dir($data[$field . '_path'], $data[$field . '_name'], $dir))
		||
		(isset($data[$field . '_temp']) && move_file_from_tmp_to_dir($data[$field . '_temp'], $data[$field . '_name'], $dir, $tmp));

		// И на всякий случай подчищаем что после нас осталось (если вдруг останется, особенно в $tmp).
		if (isset($data[$field . '_temp'])) remove_file_from_tmp($data[$field . '_temp'], $tmp);
		if (isset($data[$field . '_path'])) remove_file_from_php($data[$field . '_path']);
	}
}



// Непосредственно функции для работы с файлами в файловой системе.
// Чуток "умные": если файла нет илине указано, то ничего не делать -- чтоб поменьше ошибок было.

function remove_file_from_dir ($filename, $dir)
{
	if (!strlen($filename)) return;
	$path = $dir . (substr($dir, -1) !== '/' ? '/' : '') . $filename;
	clearstatcache();
	if (is_file($path)) unlink($path);
	if (is_dir ($dir )) rmdirr($dir );
}

function remove_file_from_tmp ($filetemp, $tmp)
{
	if (!strlen($filetemp)) return;
	$path = $tmp . (substr($tmp, -1) !== '/' ? '/' : '') . $filetemp;
	$dir  = dirname($path);
	clearstatcache();
	if (is_file($path)) unlink($path);
	if (is_dir ($dir )) rmdirr($dir );
}

function remove_file_from_php ($filepath)
{
	if (!strlen($filepath)) return;
	$path = $filepath;
	clearstatcache();
	if (is_file($path)) unlink($path);
	//NB: don't use rmdir/rmdirr() -- it is php temp dir, not our own!
}

function move_file_from_php_to_tmp ($filepath, $filetemp, $tmp)
{
	if (!strlen($filepath)) return false;
	$source_path = $filepath;
	$target_path = $tmp . (substr($tmp, -1) !== '/' ? '/' : '') . $filetemp;
	$target_dir  = dirname($target_path);
	clearstatcache();
	if (!is_dir($target_dir )) mkdirr($target_dir);
	if (is_file($source_path)) copy($source_path, $target_path);
}

function move_file_from_php_to_dir ($filepath, $filename, $dir)
{
	if (!strlen($filepath)) return false;
	$source_path = $filepath;
	$target_path = $dir . (substr($dir, -1) !== '/' ? '/' : '') . $filename;
	clearstatcache();
	if (is_file($target_path)) unlink($target_path);
	if (!is_dir($dir        )) mkdirr($dir);
	if (is_file($source_path)) rename($source_path, $target_path);
	return true;
}

function move_file_from_tmp_to_dir ($filetemp, $filename, $dir, $tmp)
{
	if (!strlen($filetemp)) return false;
	$source_path = $tmp . (substr($tmp, -1) !== '/' ? '/' : '') . $filetemp;
	$target_path = $dir . (substr($dir, -1) !== '/' ? '/' : '') . $filename;
	$source_dir  = dirname($source_path);
	clearstatcache();
	if (is_file($target_path)) unlink($target_path);
	if (!is_dir($dir        )) mkdirr($dir);
	if (is_file($source_path)) rename($source_path, $target_path);
	if (is_dir ($source_dir )) rmdirr($source_dir );
	return true;
}

// Helper function to TRY to recursively remove directory tree until it is not empty, and then silently quit.
function rmdirr ($path)
{
	while (is_dir($path))
	{
		// Possible FS warning: dir can be non-empty, but we handle this normally (this is not an error for us).
		if (@rmdir($path) === false) return false;
		else $path = dirname($path);
	}
	return true;
}

// Helper function to make directory recursively. mkdir() is enough, actually; it's an alias.
function mkdirr ($path)
{
	return mkdir($path, 0777, true);
}

?>
