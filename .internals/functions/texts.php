<?php
//
// (c) 2007 http://www.howard-studio.ru/
// Sergei Vasilyev, nolar@howard-studio.ru
//
// Функции для обработки текстов (в основном в кодировке UTF-8, но и в других тоже).
// Описание к каждой группе функций отдельно.
//



// Проверяет что текст является корректным UTF-8 текстом.
// Взято с php.net
function isUTF8 ($str)
{
	return function_exists('mb_convert_encoding') && ($str === mb_convert_encoding(mb_convert_encoding($str, "UTF-32", "UTF-8"), "UTF-8", "UTF-32"));
}

function toUTF8 ($val, $suggested_encoding = null)
{
	if (is_array($val))
	{
		$result = array(); foreach ($val as $k => $v) $result[toUTF8($k, $suggested_encoding)] = toUTF8($v, $suggested_encoding);
	} else
	if (is_string($val))
	{
		$result = isUTF8($val) ? $val : mb_convert_encoding($val, 'UTF-8', $suggested_encoding);
	} else
	{
		$result = $val;
	}
	return $result;
}



// Транслитерация (преобразование русских букв в латинские эквиваленты) используется, например, для преобразования имён файлов.
// В данный момент этот скрипт написан в кодировке cp1251, и чтобы было реальное преобразование, таблица преобразований
// с помощью iconv() перегоняется в UTF-8. В будущем имеет смысл переписать целиком файл в UTF-8, либо русские буквы
// в slash-notation (\x01\x02 и т.п.) -- только не путать UTF-8 с UCS-2/UTF-16!

global $transliterate_replaces_encoding, $transliterate_replaces_table, $transliterate_replaces_table_url;
$transliterate_replaces_encoding = 'cp1251';// потому что php-файл написан в ней, и таблица замен написана в ней
$transliterate_replaces_table    = array(
	' ' => '_'  ,
	'а' => 'a'  , 'А' => 'A'   ,
	'б' => 'b'  , 'Б' => 'B'   ,
	'в' => 'v'  , 'В' => 'V'   ,
	'г' => 'g'  , 'Г' => 'G'   ,
	'д' => 'd'  , 'Д' => 'D'   ,
	'е' => 'e'  , 'Е' => 'E'   ,
	'ё' => 'yo' , 'Ё' => 'YO'  ,
	'ж' => 'zh' , 'Ж' => 'ZH'  ,
	'з' => 'z'  , 'З' => 'Z'   ,
	'и' => 'i'  , 'И' => 'I'   ,
	'й' => 'i'  , 'Й' => 'I'   ,
	'к' => 'k'  , 'К' => 'K'   ,
	'л' => 'l'  , 'Л' => 'L'   ,
	'м' => 'm'  , 'М' => 'M'   ,
	'н' => 'n'  , 'Н' => 'N'   ,
	'о' => 'o'  , 'О' => 'O'   ,
	'п' => 'p'  , 'П' => 'P'   ,
	'р' => 'r'  , 'Р' => 'R'   ,
	'с' => 's'  , 'С' => 'S'   ,
	'т' => 't'  , 'Т' => 'T'   ,
	'у' => 'u'  , 'У' => 'U'   ,
	'ф' => 'f'  , 'Ф' => 'F'   ,
	'х' => 'h'  , 'Х' => 'H'   ,
	'ч' => 'ch' , 'Ч' => 'CH'  ,
	'ц' => 'ts' , 'Ц' => 'TS'  ,
	'ш' => 'sh' , 'Ш' => 'SH'  ,
	'щ' => 'sch', 'Щ' => 'SCH' ,
	'ъ' => '`'  , 'Ъ' => '`'   ,
	'ы' => 'y'  , 'Ы' => 'Y'   ,
	'ь' => '\'' , 'Ь' => '\''  ,
	'э' => 'e'  , 'Э' => 'E'   ,
	'ю' => 'yu' , 'Ю' => 'YU'  ,
	'я' => 'ya' , 'Я' => 'YA'  ,
);

$transliterate_replaces_table_url    = array(
	'.' => ''   ,
	',' => ''   , ';' => ''    ,
	'(' => ''   , ')' => ''    ,
	'*' => ''   , '#' => ''    ,
	'@' => ''   , '~' => ''    ,
);

function transliterate_callback ($matches)
{
	return sprintf("%02X", ord($matches[0]));
}

function transliterate ($string, $encoding = 'utf-8')
{
	global $transliterate_replaces_encoding, $transliterate_replaces_table;
	$replaces = array();
	foreach ($transliterate_replaces_table as $src => $dst)
		$replaces[iconv($transliterate_replaces_encoding, $encoding, $src)] = iconv($transliterate_replaces_encoding, $encoding, $dst);
	$string = str_replace(array_keys($replaces), array_values($replaces), $string);
	// Здесь не используется флаг "u" (utf-8), потому что нам нужна побайтовая обработка!
	$string = preg_replace_callback('/[^a-zA-Z0-9\\(\\)\\[\\]\\{\\}\\.,!_+-]/six', 'transliterate_callback', $string);
	return $string;
}


function transliterate_url ($string, $encoding = 'utf-8')
{
	global $transliterate_replaces_encoding, $transliterate_replaces_table, $transliterate_replaces_table_url;
	$replaces = array();
	foreach ($transliterate_replaces_table as $src => $dst)
		$replaces[iconv($transliterate_replaces_encoding, $encoding, $src)] = iconv($transliterate_replaces_encoding, $encoding, $dst);
	foreach ($transliterate_replaces_table_url as $src => $dst)
		$replaces[iconv($transliterate_replaces_encoding, $encoding, $src)] = iconv($transliterate_replaces_encoding, $encoding, $dst);
	$string = str_replace(array_keys($replaces), array_values($replaces), $string);
	// Здесь не используется флаг "u" (utf-8), потому что нам нужна побайтовая обработка!
	$string = preg_replace_callback('/[^a-zA-Z0-9\\(\\)\\[\\]\\{\\}\\.,!_+-]/six', 'transliterate_callback', $string);
	return $string;
}

// Преобразование UBB-кодов в HTML.
// WARNING:
// В данный момент практически не написано, кроме пары базовых замен.
// И пока нигде не используется.

function ubb2html ($string)
{
	$string = preg_replace('/\\[i\\] (.*?) \\[\\/i\\]/six', '<i>$1</i>', $string);
	$string = preg_replace('/\\[b\\] (.*?) \\[\\/b\\]/six', '<b>$1</b>', $string);
	$string = preg_replace('/\\[u\\] (.*?) \\[\\/u\\]/six', '<u>$1</u>', $string);
	$string = preg_replace('/\\[s\\] (.*?) \\[\\/s\\]/six', '<strike>$1</strike>', $string);
	$string = preg_replace('/\\[url\\] (.*?) \\[\\/url\\]/six', '<a href="$1">$1</a>', $string);
	//todo: автоматически поиск и превращение в a_href ссылок с http:// ftp://
	//todo: НО которые не находятся внутри url/a_href уже в сей момент (это важно!).
	return $string;
}

function money($sum, $cur)
{
	if (!$sum) return '0';
	
	$ret = number_format($sum, 0, ',', ' ');
	
	switch($cur)
	{
		case 'usd': $ret = '$'.$ret; break;
		case 'euro': $ret = '€'.$ret; break;
		default: $ret .= ' р.';
	}
	
	return iconv('cp1251', 'utf8', $ret);
}

function prices_format($ar)
{
	$ret = [];
	foreach($ar as $cur => $v)
	{
		if ($v)
		$ret[] = money($v, $cur);
	}
	
	return join(', ', $ret);
}

?>