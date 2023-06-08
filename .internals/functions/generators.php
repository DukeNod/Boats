<?php

function generate_alphabet ($min_length, $max_length = null, $alphabet = '0123456789abcdefhijklmnopqrstuvwxyzABCDEFHIJKLMNOPQRSTUVWXYZ')
{
	if ($max_length < $min_length) $max_length = $min_length;
	$length = rand($min_length, $max_length);
	$result = '';
	for ($position = 1; $position <= $length; $position++)
	{
		$result .= substr($alphabet, rand(0, strlen($alphabet) - 1), 1);
	}
	return $result;
}

function guid() {
    $a = sprintf( '%04x%04x-%04x-%04x-%04x-%04x%04x%04x',
        mt_rand( 0, 0xffff ), mt_rand( 0, 0xffff ),
        mt_rand( 0, 0xffff ),
        mt_rand( 0, 0x0fff ) | 0x4000,
        mt_rand( 0, 0x3fff ) | 0x8000,
        mt_rand( 0, 0xffff ), mt_rand( 0, 0xffff ), mt_rand( 0, 0xffff )
    );
    return mb_strtoupper($a);
}

?>