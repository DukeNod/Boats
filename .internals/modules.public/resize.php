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

_main_::depend("images");

$rdir = realpath(_config_::$dir_for_linked);
$width = $pathargs[1];
$height = $pathargs[2];
unset($pathargs[1]);
unset($pathargs[2]);
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



if (img_resize($path, $width, $height))//???!!!: вынести в config?
{
	ob_flush();
	throw new exception_exit();
} else
{
	header("Content-type: application/octet-stream");
	readfile($path);
	ob_flush();
}



function img_resize ($source_path, $limit_w, $limit_h)
{
        $cut = true;

	// Определяем формат изображения и открываем его.
	$source_handle = false;
	if ($source_handle === false) { $source_handle = imagecreatefromjpeg($source_path); $format = 'jpeg'; } 
	if ($source_handle === false) { $source_handle = imagecreatefrompng ($source_path); $format = 'png' ; } 
	if ($source_handle === false) { $source_handle = imagecreatefromgif ($source_path); $format = 'gif' ; } 
	if ($source_handle === false) { return false; }

	// Определяем размеры исходного изображения.
	$source_sx = imagesx($source_handle);
	$source_sy = imagesy($source_handle);
	if (($source_sx == 0) || ($source_sy == 0)) { imagedestroy($source_handle); return false; }

	$src_x = $src_y = 0;

	// Вычисляем размеры избражения после умещения в рамку.
	if ($cut)
	{
		list($source_sx, $source_sy, $src_x, $src_y) = calculate_image_cuted($source_sx, $source_sy, $limit_w, $limit_h);
		$target_sx = min($source_sx, $limit_w);
		$target_sy = min($source_sy, $limit_h);
        }else
        {
		list($target_sx, $target_sy) = calculate_image_limited($source_sx, $source_sy, $limit_w, $limit_h);
        }
	// Создаём умещённое в рамку изображение.
	$target_handle = imagecreatetruecolor($target_sx, $target_sy);
	if ($target_handle === false) { imagedestroy($source_handle); return false; }
	imagealphablending($target_handle, false);
	imagesavealpha($target_handle, true); 

	// Заполняем белым, так как белый - фон сайта, и уж лучше прозрачность исходного изображения ляжет на белый фон,
	// чем на системно-дефолтный чёрный. В идеале либо вынести цвет в конфиг, либо сохранять прозрачность от исходного изображения.
	$color = imagecolorallocate($target_handle, 255, 255, 255);//white
	imagefill($target_handle, 0, 0, $color);

	// Копируем изображение из исходного в целевое, с уменьшением и усреднением.
	imagecopyresampled($target_handle, $source_handle, 0, 0, $src_x, $src_y, $target_sx, $target_sy, $source_sx, $source_sy);

	
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