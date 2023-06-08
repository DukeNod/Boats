<?php
//
// (c) 2007 http://www.howard-studio.ru/
// Sergei Vasilyev, nolar@howard-studio.ru
//
// Функции для обработки (анализа и генерации) изображений.
// Не путать с функциями для обработки файлов, в т.ч. содержащими изображения, -- это всё в uploads!
//



// Определяет размеры изображения или его размер толко по одной оси. Значения кешириуются чтобы не проверять одини
// и тот же файл повторно (когда, например, запрашивается сначала одна координата, а потом другая).
// Определение размера по одной оси может быть полезно, например, при вызове из xslt-процессора.

global $measure_image_cache;// Мы в контексте метода _main_::depend(), поэтому нужно чёткое указание что переменная глобальна.
$measure_image_cache = array();

function measure_image ($path)
{
	global $measure_image_cache;

	$realpath = realpath($path);
	if ($realpath !== false)
	{
		// Return cached.
		if (array_key_exists($realpath, $measure_image_cache)) return $measure_image_cache[$realpath];

		// Have to ignore absence of a file! Throw no errors or exceptions!
		$info = @getimagesize($path);// Using $path as it was passed, not $realpath (used only for cache keys).
		return $measure_image_cache[$realpath] = ($info === false) ? array(null, null) : array($info[0], $info[1]);
	}
}

function measure_image_w ($path) { $tmp = measure_image($path); return $tmp[0]; }
function measure_image_h ($path) { $tmp = measure_image($path); return $tmp[1]; }



// Вычисляет размер изображения (calculate) если его уместить в рамку указанных размеров.
// Либо генерирует само умещённое в рамку изображение (generate).
// Причём генерация позволяет записывать файл поверх исходного.

function calculate_image_limited ($original_w, $original_h, $limit_w, $limit_h)
{
	// Если какой-то из исходных размеров не указан, то ничего не масштабируем и возвращаем как есть.
	if (empty($original_w) || empty($original_h)) return array($original_w, $original_h);

	// Собственно, вычисляем новые размеры.
	$ratio_w = ($limit_w > 0) ? 1.0 * $original_w / $limit_w : 0.0;
	$ratio_h = ($limit_h > 0) ? 1.0 * $original_h / $limit_h : 0.0;
	$ratio   = max($ratio_w, $ratio_h, 1.0);// 1.0 здесь чтобы картинка не растягивалась, когда она меньше лимита по обеим координатам.
	$result_w = $ratio ? $original_w / $ratio : $original_w;
	$result_h = $ratio ? $original_h / $ratio : $original_h;

	// Возвращаем как пару целочисленных значений (чтоб не было дробей и null'ов).
	return array((integer) round($result_w), (integer) round($result_h));
}

function calculate_image_cuted ($original_w, $original_h, $limit_w, $limit_h)
{
	// Если какой-то из исходных размеров не указан, то ничего не масштабируем и возвращаем как есть.
	if (empty($original_w) || empty($original_h)) return array($original_w, $original_h);

	// Собственно, вычисляем новые размеры.
		$prop = $limit_w / $limit_h;

		if (($original_w / $original_h) > $prop)
		{
			$result_h = $original_h; $result_w = round($original_h * $prop);
			$im_y = 0; $im_x = round(($original_w - $result_w) / 2);
		}else{
			$result_w = $original_w; $result_h = round($original_w / $prop);
			$im_x = 0; $im_y = round(($original_h - $result_h) / 2);
		}

	// Возвращаем как пару целочисленных значений (чтоб не было дробей и null'ов).
	return array((integer) round($result_w), (integer) round($result_h), (integer) round($im_x), (integer) round($im_y));
}

function generate_image_limited ($source_path, $target_path, $limit_w, $limit_h, &$target_sx, &$target_sy, $cut = false)
{
	// Определяем формат изображения и открываем его.
	$source_handle = false;
	if ($source_handle === false) { $source_handle = @imagecreatefromjpeg($source_path); $format = 'jpeg'; } 
	if ($source_handle === false) { $source_handle = @imagecreatefrompng ($source_path); $format = 'png' ; } 
	if ($source_handle === false) { $source_handle = @imagecreatefromgif ($source_path); $format = 'gif' ; } 
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
		case 'jpeg': $ok = imagejpeg($target_handle, $target_path, _config_::$generated_jpeg_quality); break;
		case 'png' : $ok = imagepng ($target_handle, $target_path); break;
		case 'gif' : $ok = imagegif ($target_handle, $target_path); break;
		default: $ok = false;
	}

	// Освобождаем ресурсы и выходим.
	imagedestroy($source_handle);
	imagedestroy($target_handle);
	return (bool) $ok;
}

function generate_image_grayscaled ($source_path, $target_path)
{
	// Определяем формат изображения и открываем его.
	$source_handle = false;
	if ($source_handle === false) { $source_handle = @imagecreatefromjpeg($source_path); $format = 'jpeg'; } 
	if ($source_handle === false) { $source_handle = @imagecreatefrompng ($source_path); $format = 'png' ; } 
	if ($source_handle === false) { $source_handle = @imagecreatefromgif ($source_path); $format = 'gif' ; } 
	if ($source_handle === false) { return false; }

	// Применяем фильтр. WARNING: imagefilter() недоступна на gd кроме как на bundled version.
//	$result = imagefilter($source_handle, IMG_FILTER_GRAYSCALE);
//	if ($result === false) { imagedestroy($source_handle); return false; }
//	$target_handle = $source_handle;
	// Накладываем с превращением в серый. WARNING: у хостера это падает в корку, и кешер выдаёт HTTP 502 Bad Gateway.
	// Ещё по теме: http://bugs.libgd.org/?do=details&task_id=19&histring=imagecopymergegray
//	$tmp = imagecreatetruecolor(imagesx($source_handle), imagesy($source_handle));
//	imagefill($tmp, 0, 0, imagecolorallocate($tmp, 255, 255, 255));
//	$result = imagecopymergegray($target_handle = $source_handle, $tmp, 0, 0, 0, 0, imagesx($source_handle), imagesy($source_handle), 40);
//	imagedestroy($tmp);
//	if ($result === false) { imagedestroy($source_handle); return false; }
	// Делаем greyscaled. Попытка №3. Мега-затычко.
	// Предварительно перегоняем исходную картинку в труколор, ибо иначе цвета возвращаются индексированными, а не RGB.
	$target_handle = imagecreatetruecolor($sx = imagesx($source_handle), $sy = imagesy($source_handle));
	imagealphablending($target_handle, false);
	imagesavealpha($target_handle, true); 

	imagecopy($target_handle, $source_handle, 0, 0, 0, 0, $sx, $sy);
	for($x = 0; $x < $sx; $x++)
	for($y = 0; $y < $sy; $y++)
	{
		$rgb = imagecolorat($target_handle, $x, $y);
		$r = ($rgb >> 16) & 0xFF;
		$g = ($rgb >>  8) & 0xFF;
		$b = ($rgb      ) & 0xFF;
		$s = ceil(1.0 * ($r + $g + $b) / 3);
		$s = imagecolorallocate($target_handle, $s, $s, $s);
		imagesetpixel($target_handle, $x, $y, $s);
	}
	$tmp = imagecreatetruecolor(imagesx($target_handle), imagesy($target_handle));
	imagefill($tmp, 0, 0, imagecolorallocate($tmp, 255, 255, 255));
	$result = imagecopymerge($target_handle, $tmp, 0, 0, 0, 0, $sx, $sy, 40);// чем больше (0..100), тем белесей
	imagedestroy($tmp);
	if ($result === false) { imagedestroy($source_handle); imagedestroy($target_handle); return false; }

	// Фиксим все пиксели с "почти белыми" цветами (FEFEFE) в строго белый (FFFFFF).
	// Потому что при наложении copy-merge с pct>0(1..100) оно гробит наш строго-белый цвет на "не совсем белый".
	$nc = imagecolorallocate($target_handle, 0xFF, 0xFF, 0xFF);
	$sx = imagesx($target_handle); $sy = imagesy($target_handle);
	for ($x = 0; $x < $sx; $x++) for ($y = 0; $y < $sy; $y++)
	{
		$oc = imagecolorat($target_handle, $x, $y);
		list($lim, $ocR, $ocG, $ocB) = array(0xFE, ($oc >> 16) & 0xFF, ($oc >> 8) & 0xFF, ($oc) & 0xFF);
		if ($ocR >= $lim && $ocG >= $lim && $ocB >= $lim)
			imagesetpixel($target_handle, $x, $y, $nc);
	}

	// Сохраняем уменьшенное изображение в том же формате, что и исходное.
	switch ($format)
	{
		case 'jpeg': $ok = imagejpeg($target_handle, $target_path, _config_::$generated_jpeg_quality); break;
		case 'png' : $ok = imagepng ($target_handle, $target_path); break;
		case 'gif' : $ok = imagegif ($target_handle, $target_path); break;
		default: $ok = false;
	}

	// Освобождаем ресурсы и выходим.
	imagedestroy($source_handle);
	imagedestroy($target_handle);
	return (bool) $ok;
}

function generate_image_rectangle ($source_path, $target_path, $target_sx, $target_sy, $offset_x = 0, $offset_y = 0)
{
	// Определяем формат изображения и открываем его.
	$source_handle = false;
	if ($source_handle === false) { $source_handle = @imagecreatefromjpeg($source_path); $format = 'jpeg'; } 
	if ($source_handle === false) { $source_handle = @imagecreatefrompng ($source_path); $format = 'png' ; } 
	if ($source_handle === false) { $source_handle = @imagecreatefromgif ($source_path); $format = 'gif' ; } 
	if ($source_handle === false) { return false; }

	// Определяем размеры исходного изображения.
	$source_sx = imagesx($source_handle);
	$source_sy = imagesy($source_handle);
	if (($source_sx == 0) || ($source_sy == 0)) { imagedestroy($source_handle); return false; }

	// Создаём умещённое в рамку изображение.
	$target_handle = imagecreatetruecolor(min($source_sx, $target_sx), min($source_sy, $target_sy));
	if ($target_handle === false) { imagedestroy($source_handle); return false; }
	imagealphablending($target_handle, false);
	imagesavealpha($target_handle, true); 

	// Копируем изображение из исходного в целевое, с уменьшением и усреднением.
	imagecopy($target_handle, $source_handle, 0, 0, $offset_x, $offset_y, $target_sx, $target_sy);

	// Сохраняем уменьшенное изображение в том же формате, что и исходное.
	switch ($format)
	{
		case 'jpeg': $ok = imagejpeg($target_handle, $target_path, _config_::$generated_jpeg_quality); break;
		case 'png' : $ok = imagepng ($target_handle, $target_path); break;
		case 'gif' : $ok = imagegif ($target_handle, $target_path); break;
		default: $ok = false;
	}

	// Освобождаем ресурсы и выходим.
	imagedestroy($source_handle);
	imagedestroy($target_handle);
	return (bool) $ok;
}

?>