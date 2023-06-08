<?php
//
// (c) 2007 http://www.howard-studio.ru/
// Sergei Vasilyev, nolar@howard-studio.ru
//
// Система графической защиты от автоматов (скриптов, роботов и т.п.).
// Подразумевает что для выполнения операции модуль требует генерации и дальнейшей проверки
// пары вопроса и ответа, но которые выводятся в нетипичном виде, непонятном для автоматов
// (например, в виде картинки с текстом, либо в общем потоке текста формы ввода). В таком
// случае увидеть, распознать и ответить может только человек (либо иное "умное устройство").
//
// WARNING:
// Возможный обход состоит в том, чтобы, получив id картинки, запрашивать её изображение
// несколько раз, и выявить общие графические элементы, имеющиеся на всех полученных
// изображениях (графический анализ). И таким образом избавиться от любого мусора и вариаций.
// SOLUTION:
// Генерировать все до единого случайные параметры там же, где генерируется и сам вопрос,
// а в функции вывода картинок лишь использовать их. Тогда повторные запросы будут возвращать
// в точности одну и ту же картинку.
//



// Функция генерирует уникальный идентификатор, вопрос и правильный ответ
// для системы графической защиты и сохраняет их в рамках сессии для дальнейшей проверки.
// Возможно сохранение в сессии нескольких вопросов с разными идентификаторами,
// чтобы система могла работать в нескольких окнах одновременно.
function gp_new_question ()
{
	// Генерируем уникальный идентификатор опроса, который к тому же актуален только в рамках сессии.
	$gp_id = md5(uniqid(rand()));

	// Случайно выбираем длины чисел (какое какой длины).
//	switch (rand(0,2))
//	{
//		case 0:/* первое число 1 символ, второе - тоже 1 */
//			$gp_number1 = rand(0,9);
//			$gp_number2 = rand(0,9);
//			break;
//		case 1:/* первое число 1 символ, второе - 2 */
//			$gp_number1 = rand(0,9);
//			$gp_number2 = rand(10,99);
//			break;
//		case 2:/* первое число 2 символа, второе - 1 */
			$gp_number1 = rand(10,99);
			$gp_number2 = rand(1,9);
//			break;
//	}

	// Случайно выбираем арифметическую операцию из тех, что можно выполнить в уме и получить целый результат.
	switch (rand(0,1))
	{
		case 0: /* сложение */
			$gp_op = '+';
			$gp_result = $gp_number1 + $gp_number2;
			break;
//		case 1: /* умножение */
//			$gp_op = "\xD7";
//			$gp_result = $gp_number1 * $gp_number2;
//			break;
		case 1: /* вычитание */
			$gp_op = '-';
			// Делаем первое число всегда больше второго чтобы не было отрицательного результата.
			if ($gp_number1 < $gp_number2)
			{
				$tmp = $gp_number1;
				$gp_number1 = $gp_number2;
				$gp_number2 = $tmp;
			}
			$gp_result = $gp_number1 - $gp_number2;
			break;
	}

	// Формируем текст вопроса.
	$gp_question = "{$gp_number1}{$gp_op}{$gp_number2}=";

	// Проверяем попытку переполнения сессионных данных и очищаем "свои" сессионные переменные, если это так.
	// Причём делаем это не всегда, а время от времени (в рамках заданной вероятности).
	if (1.0*rand(0, 1000)/1000 <= _config_::$gp_trash_probabilty) gp_flush_trash();

	// Запоминаем в сессии вопрос (чтобы вывести его в картинке) и ответ (чтобы сравнить с введённым).
	$_SESSION['gp_' . $gp_id] = array(
		'question'	=> (string) $gp_question,
		'answer'	=> (string) $gp_result);

	// Возвращаем всё что насобирали и нагенерировали.
	return array($gp_id, _config_::$gp_w, _config_::$gp_h);
}

// Функция проверяет попытку переполнения сессионного файла данными (частым генерированием новых вопросов).
// Если обнаружено слишком много сгенерированных вопросов, то удаляет их все (удалять только старые нереально).
function gp_flush_trash ()
{
	$keys = array_filter(array_keys($_SESSION), create_function('$v', 'return strncmp($v, "gp_", 3) == 0;'));
	if (count($keys) > _config_::$gp_trash_limit)
		foreach ($keys as $key)
			unset($_SESSION[$key]);
}

// Функция возвращает текст вопроса для показа пользователю (на картинке).
// Возвращает всегда строку (даже если id неверен).
function gp_get_question ($gp_id)
{
	return isset($_SESSION['gp_'.$gp_id]['question']) ? $_SESSION['gp_'.$gp_id]['question'] : _config_::$gp_default_text;
}

// Функция проверяет что указанный ответ совпадает с правильным.
// Возвращает всегда true/false.
function gp_check_answer ($gp_id, $gp_answer, $clean = false)
{
	if (!isset($_SESSION['gp_'.$gp_id]['answer'])) return false;
	$correct_answer = $_SESSION['gp_'.$gp_id]['answer'];
	if ($clean && ($gp_answer == $correct_answer)) unset($_SESSION['gp_'.$gp_id]);
	return ($gp_answer == $correct_answer);
}

// Функция генерирует картинку и выводит её в стандартный вывод страницы.
function gp_print_image ($gp_id)
{
	// Получаем текст вопроса.
	$text = gp_get_question($gp_id);

	// Превращаем заданный цвет понимаемого формата в RGB-составляющие.
	gp_parse_color(_config_::$gp_back_color, $back_r, $back_g, $back_b);
	gp_parse_color(_config_::$gp_font_color, $font_r, $font_g, $font_b);

	// Создаём пустую картинку.
	$image = imagecreate(_config_::$gp_w, _config_::$gp_h);
	$back  = imagecolorallocate($image, $back_r, $back_g, $back_b);
	$font  = imagecolorallocate($image, $font_r, $font_g, $font_b);
	imagecolortransparent($image, $back);
	imagefill($image, 0, 0, $back);

	// Выводим символы со случайнымм смещениями.
	for($i = 0; $i < strlen($text); $i++)
	{
		imagettftext($image,
			_config_::$gp_font_size, 
			_config_::$gp_angle_base + rand(-_config_::$gp_angle_variation, +_config_::$gp_angle_variation),
			_config_::$gp_x_base     + rand(-_config_::$gp_x_variation    , +_config_::$gp_x_variation    ) + _config_::$gp_char_width * $i,
			_config_::$gp_y_base     + rand(-_config_::$gp_y_variation    , +_config_::$gp_y_variation    ) + _config_::$gp_h/2,
			$font, _config_::$gp_font_file, $text[$i]);
	}

	header("Content-type: image/gif");
	imagegif($image);

	imagedestroy($image);
}

function gp_parse_color ($color, &$r, &$g, &$b)
{
	if (is_array($color) && count($color) >= 3)
	{
		$r = array_shift($back);
		$g = array_shift($back);
		$b = array_shift($back);
	} else
	if (is_string($color) && preg_match("/^ \\#? ([0-9a-f]{2})([0-9a-f]{2})([0-9a-f]{2}) \$/six", $color, $matches))
	{
		$r = hexdec($matches[1]);
		$g = hexdec($matches[2]);
		$b = hexdec($matches[3]);
	} else
	if (is_string($color) && preg_match("/^ \\#? ([0-9a-f]{1})([0-9a-f]{1})([0-9a-f]{1}) \$/six", $color, $matches))
	{
		$r = hexdec($matches[1].$matches[1]);
		$g = hexdec($matches[2].$matches[2]);
		$b = hexdec($matches[3].$matches[3]);
	} else
	{
		$r = $g = $b = 0xff;
	}
}

?>