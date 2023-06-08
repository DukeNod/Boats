<?php

// Функции проверки текста на спам.

// spam_check_masks() принимает аргументом список масок, которые пытается найти. Они должны быть написаны
// как регулярные выражения perl (preg_match и т.п.). Для лучшего понимания русского языка в этих выражениях
// принудительно переопределено значение \\b (граница слова), и учитывает латинские, русские буквы и все цифры.

// На выходе функция возвращает массив попаданий спам-масок в текст. Для каждой маски в массиве создаётся элемент
// с тем же ключом, с которым маска находится в своём списке, и в качестве значения этого элемента (в результате)
// хранится список совпадений с маской (только по первой скобке регулярного выражения, если она есть, null иначе).
// Можно, например, проверить факт совпадения по тексту просто как if(count($result)>0).

// Если параметр $dom задан как true, то результат возвращается не просто ввиде массива, а массива,
// пригодного для передачи функции _main_::dom(). То есть ключи первого уровня заменяются на mask:key
// (где key -- значение ключа маски в исходном массиве), а ключи второго уровня на word:N (где N - последовательное число).

// В общем случае, использование функции может выглядет примерно так:
//	if (count($temp = spam_check_masks($text, _config_::$somepurpose_spam_masks, true)))
//		{ сообщить об ошибке }
//	else	{ считать что всё ок }
// Пример $somepurpose_spam_masks можно взять в _config_.php (forum_spam_masks).


function spam_check_masks ($text, $masks, $dom = false)
{
	$letter = iconv('cp1251', 'utf-8', '[a-zA-Zа-яА-ЯёЁ0-9]');
	$b = "(?:(?:(?<!$letter)(?=$letter))|(?:(?<=$letter)(?!$letter)))";

	$domL1 = $dom ? 'mask:' : '';
	$domL2 = $dom ? 'word:' : '';

	$result = array();
	foreach ($masks as $key => $val)
	{
		$val = iconv('cp1251', 'utf-8', $val);//fix: потому что в конфиге всё записано в 1251.
		$re = $val; $re = str_replace(array("\\b"), array($b), $re);
		if (preg_match_all("/{$re}/siuU", $text, $matches, PREG_SET_ORDER))
		{
			$result[$domL1 . $key] = array();
			if ($dom) { $result[$domL1 . $key]['@mask'] = $val; $result[$domL1 . $key]['@regex'] = $re; }
			foreach ($matches as $match)
				$result[$domL1 . $key][$domL2 . count($result[$domL1 . $key])] = isset($match[1]) ? $match[1] : null;
		}
	}
	return $result;
}



// spam_check_links() возвращает количество гиперссылок в тексте (или то, что похоже на гиперссылки).
// Рекомендуется просто проверять что количество, например, >=10.

function spam_check_links ($text, $dom = false)
{
	$result = 0;
	if (preg_match_all("/http:\\/\\//", $text, $matches, PREG_SET_ORDER))
	{
		$result = count($matches);
	}
	return $result;
}

?>