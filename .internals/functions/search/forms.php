<?php

function form_posted_search ($action = null, $text = null)
{
	$result = array();
	_main_::depend('forms');

	// Always posted fields (text/password/textarea/select/radio/...)
	$fields = array('text', 'price_from', 'price_to', 'brand');
	fields_fill($result, $fields); 
	fields_find($result, $fields);

	// Conditionally posted fields (checkbox)
	$fields = array();
	fields_fill($result, $fields, $action !== null ? 0 : null); 
	fields_find($result, $fields);

	// это для поиска через pathargs.
	if (!strlen($result['text']) && strlen($text)) $result['text'] = $text;

	return $result;
}

function prepare_search (&$errors, &$data, $config, $enum)
{
	// Из поисковых слов исключаем все пробельные (они у нас разделители на поисковом мини-языке),
	// а также спец-символы SQL, используещиеся в where like (процент и подчёркивание), ибо они не escape'ятся.
	$data['words'] = array();
	if (preg_match_all("/[^\\s]+/siu", $data['text'], $matches, PREG_PATTERN_ORDER))
	{
		foreach ($matches[0] as $match)
			$data['words']['word:'.count($data['words'])] = $match;
	}

	$trash_length = $config['trash_length'];
	$trash_words  = $config['trash_words' ];
	_main_::depend('texts'); $trash_words = toUTF8($trash_words, 'windows-1251');
	if (!is_array($trash_words)) $trash_words = preg_match_all("/ ([^\\s]+) /sux", $trash_words, $matches, PREG_PATTERN_ORDER) ? $matches[1] : array();
//	$data['text'] = iconv('UTF-8', 'UTF-8', $data['text']);
	//$data['text'] = unicode_encode($data['text'],'UTF-8');
	$data['text'] = mb_convert_encoding($data['text'],'UTF-8', 'UTF-8');

	foreach ($data['words'] as $idx => $word)
		if ((mb_strlen($word, 'utf-8') <= $trash_length) || (in_array($word, $trash_words)))
			unset($data['words'][$idx]);
	$data['words'] = array_unique($data['words']);
}

function validate_search (&$errors, &$data, $config, $enum, $ignore_uploads = false)
{
}

function remember_search (&$data)
{
}

?>