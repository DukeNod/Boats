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

$rdir = realpath('./uploads/');
$path = realpath($_GET['i']);

// just doesnt exist
if ($path === false)
{
	header("HTTP/1.0 404 Not found");
	_main_::put2dom('unknown');
//	return;
	die();
}

// exists, but is something from outside of allowed dir
if (strncmp($path, $rdir, strlen($rdir)) !== 0)
{
	throw new exception('Bad path. Probably hack.');
}

// Assert: NOW file exists, and file is "safe" (in safe dir, not system one).

if (img_resize($path, null))//???!!!: вынести в config?
{
	ob_flush();
	die();
} else
{
	header("Content-type: application/octet-stream");
	readfile($path);
	ob_flush();
}



// А далее выдернуто из generate_image_*() функций, просто чтоб не пложить лишнюю там.
// К тому же мы в конце не сохраняем результат в файл, а выводим в вывод; так что оно ещё и разное.
function img_resize ($source_path, $target_path)
{
	// Определяем формат изображения и открываем его.
	$source_handle = false;
	if ($source_handle === false) { $source_handle = @imagecreatefromjpeg($source_path); $format = 'jpeg'; } 
	if ($source_handle === false) { $source_handle = @imagecreatefrompng ($source_path); $format = 'png' ; } 
	if ($source_handle === false) { $source_handle = @imagecreatefromgif ($source_path); $format = 'gif' ; } 
	if ($source_handle === false) { return false; }
	$sx = imagesx($source_handle); $sy = imagesy($source_handle);

	// Создаём копию исходного изображения, но гарантируем ему truecolor и изначальный transparent.
	// Оно нам нужно чтоб использовать alpha=on(blending=off), а это нужно чтоб накладывать
	// полупрозрачный логотип на исходную картинку.

        $oldx = $sx;
        $oldy = $sy;
        list($im_x, $im_y, $sx, $sy) = count_new_sizes($sx, $sy, 150, 0);

	$target_handle = imagecreatetruecolor($sx, $sy);
	imagealphablending($target_handle, true);
	imagesavealpha($target_handle, true);
	imagefill($target_handle, 0, 0, imagecolorallocatealpha($target_handle, 0, 0, 0, 0x7F));

	imagecopyresampled($target_handle, $source_handle, 0, 0, 0, 0, $sx, $sy, $oldx, $oldy);


	// Сохраняем уменьшенное изображение в том же формате, что и исходное.

	switch ($format)
	{
		case 'jpeg': header("Content-type: image/jpeg"); ob_start(); $ok = imagejpeg($target_handle, null, 100); $buffers = ob_get_contents(); ob_clean(); header("Content-Length: ".strlen($buffers)); echo $buffers; break;
		case 'png' : header("Content-type: image/png" ); ob_start(); $ok = imagepng ($target_handle, null);      $buffers = ob_get_contents(); ob_clean(); header("Content-Length: ".strlen($buffers)); echo $buffers; break;
		case 'gif' : header("Content-type: image/gif" ); ob_start(); $ok = imagegif ($target_handle      );      $buffers = ob_get_contents(); ob_clean(); header("Content-Length: ".strlen($buffers)); echo $buffers; break;
		default: $ok = false;
	}


	// Освобождаем ресурсы и выходим.
	imagedestroy($source_handle);
	imagedestroy($target_handle);
	return (bool) $ok;
}

function count_new_sizes($sizeW, $sizeH, $newW, $newH, $cut=false)
{

$image = array($sizeW, $sizeH);

$im_x=0; $im_y=0;  

if (!$newW) $newW = $sizeW;
if (!$newH) $newH = $sizeH;

if (($sizeW>$newW) || ($sizeH>$newH)) {
	if ($cut){
		$prop=$newW/$newH;
		if (($image[0]/$image[1])>$prop){
			$sizeH=$image[1]; $sizeW=round($image[1]*$prop);
			$im_y=0; $im_x=round(($image[0]-$sizeW)/2);
		}else{
			$sizeW=$image[0]; $sizeH=round($image[0]/$prop);
			$im_x=0; $im_y=round(($image[1]-$sizeH)/2);
		}
	}else{
		if ($sizeW>$newW){
			$sizeH=round($sizeH*$newW/$sizeW);
			$sizeW=$newW;
		}
		if ($sizeH>$newH){
			$sizeW=round($sizeW*$newH/$sizeH);
			$sizeH=$newH;
		}
		$newW=$sizeW;
		$newH=$sizeH;
		$sizeW=$image[0]; $sizeH=$image[1];
	}
}

if ($sizeW<$newW) $newW=$sizeW;
if ($sizeH<$newH) $newH=$sizeH;

return array($im_x, $im_y, $newW, $newH);

}
?>