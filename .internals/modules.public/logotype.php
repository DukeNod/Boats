<?php
// скрипт для нанесения логотипа на linked-штучки (обычно картинки).
// сделан, кончно, тяп-ляп, в порядке очередной мегазатычки; но работает как задумано и без уязвимостей (as i see: realpath).
// если наложиьт логотип не может - отдаёт файл как есть. ибо лучше уж что-то отдать.
// плохо только с оформлением 404 (сейчас пустая страница, но лучше уж так, чем рисовать полный шаблон с сообщением).
// применяется в основном только для дисков и шин:
// RewriteRule ^linked/(picts/large/tyre_model/.*)$		.redirects/public/index.php/logotype/$1		[L,NC,NS]
// RewriteRule ^linked/(picts/large/disk_model/.*)$		.redirects/public/index.php/logotype/$1		[L,NC,NS]
// причём эти вещи должны идти ДО того, как картинки иными правилами отметаются от rewrite'а.
// само лого должно лежать в корне (на том же уровне что и каталог linked); обычно это PNG-24 с прозрачностями.
// если лого не влазит в картинку - то считаем ошибкой и выдаём картинку как есть без изменений.

$rdir = realpath(_config_::$dir_for_linked);
$path = realpath(_config_::$dir_for_linked . implode('/', $pathargs));

// just doesnt exist
if ($path === false)
{
	header("HTTP/1.0 404 Not found");
	_main_::put2dom('unknown');
//	return;
	throw new exception_exit();
}

// exists, but is something from outside of allowed dir
if (strncmp($path, $rdir, strlen($rdir)) !== 0)
{
	throw new exception('Bad path. Probably hack.');
}

// Assert: NOW file exists, and file is "safe" (in safe dir, not system one).



if (logotypize($path, null, '../../.internals/files/logotype.png'))//???!!!: вынести в config?
{
	ob_flush();
	throw new exception_exit();
} else
{
	header("Content-type: application/octet-stream");
	readfile($path);
	ob_flush();
}



// А далее выдернуто из generate_image_*() функций, просто чтоб не пложить лишнюю там.
// К тому же мы в конце не сохраняем результат в файл, а выводим в вывод; так что оно ещё и разное.
function logotypize ($source_path, $target_path, $logo_path)
{
	// Определяем формат изображения и открываем его.
	$source_handle = false;
	if ($source_handle === false) { $source_handle = @imagecreatefromjpeg($source_path); $format = 'jpeg'; } 
	if ($source_handle === false) { $source_handle = @imagecreatefrompng ($source_path); $format = 'png' ; } 
	if ($source_handle === false) { $source_handle = @imagecreatefromgif ($source_path); $format = 'gif' ; } 
	if ($source_handle === false) { return false; }
	$sx = imagesx($source_handle); $sy = imagesy($source_handle);

	// Читаем накладываемое лого.
	$logo_handle = false;
	if ($logo_handle === false) { $logo_handle = @imagecreatefromjpeg($logo_path); } 
	if ($logo_handle === false) { $logo_handle = @imagecreatefrompng ($logo_path); } 
	if ($logo_handle === false) { $logo_handle = @imagecreatefromgif ($logo_path); } 
	if ($logo_handle === false) { return false; }
	$lx = imagesx($logo_handle); $ly = imagesy($logo_handle);

	// Создаём копию исходного изображения, но гарантируем ему truecolor и изначальный transparent.
	// Оно нам нужно чтоб использовать alpha=on(blending=off), а это нужно чтоб накладывать
	// полупрозрачный логотип на исходную картинку.
	$target_handle = imagecreatetruecolor($sx, $sy);
	imagealphablending($target_handle, true);
	imagesavealpha($target_handle, true);
	imagefill($target_handle, 0, 0, imagecolorallocatealpha($target_handle, 0, 0, 0, 0x7F));
	imagecopy($target_handle, $source_handle, 0, 0, 0, 0, $sx, $sy);

	// Накладываем логотип. Позиционируем так, чтоб центр логотипа лёг на центр картинки.
	// Если логотип вылазит за рамки картинки, ты мы его обрезаем и накладываем только то,
	// что влазит.
	//sx/sy - размер исходной картинки
	//lx/ly - размер накладываемой картинки
	//БЫЛО: if ($lx <= $sx && $ly <= $sy) -- чтоб логотип не наносился, если картинка
	//БЫЛО: меньше логтипа. но увы, НННАДА (с) масяня
	imagecopy($target_handle, $logo_handle,
		$sx - min($sx, $lx+10), $sy - min($sy, $ly+10), // координаты цели
		0, 0, // координаты исходной области
		min($sx, $lx),	//x-размер области
		min($sy, $ly));	//y-размер области

	// Вариант с логотипом в центре картинки.
	// (сохраняем код на всякий случай):
//	imagecopy($target_handle, $logo_handle,
//		$sx/2 - min($sx, $lx)/2, $sy/2 - min($sy, $ly)/2, // координаты цели
//		$lx/2 - min($sx, $lx)/2, $ly/2 - min($sy, $ly)/2, // координаты исходной области
//		min($sx, $lx),	//x-размер области
//		min($sy, $ly));	//y-размер области

//	// А это вариант с втискиванием логотипа с масштабированием, чтоб влез целиком
//	// (сохраняем код на всякий случай):
//	imagecopyresampled($target_handle, $logo_handle,
//		$sx/2 - min($sx, $lx)/2, $sy/2 - min($sy, $ly)/2,// координаты цели
//		0, 0, //координаты исходной области
//		min($sx, $lx),	//x-размер области
//		min($sy, $ly),	//y-размер области
//		$lx, $ly);

	// Сохраняем уменьшенное изображение в том же формате, что и исходное.
	switch ($format)
	{
		case 'jpeg': header("Content-type: image/jpeg");$ok = imagejpeg($target_handle, null, _config_::$generated_jpeg_quality); break;
		case 'png' : header("Content-type: image/png" );$ok = imagepng ($target_handle, null); break;
		case 'gif' : header("Content-type: image/gif" );$ok = imagegif ($target_handle      ); break;
		default: $ok = false;
	}

	// Освобождаем ресурсы и выходим.
	imagedestroy($source_handle);
	imagedestroy($target_handle);
	return (bool) $ok;
}

?>