<?php

function rtf_convert ($r_word)
{
	$cnv_array = array("c0","c1","c2","c3","c4","c5","c6","c7","c8","c9","ca","cb","cc","cd","ce","cf","d0","d1","d2","d3","d4","d5","d6","d7","d8","d9","da","db","dc","dd","de","df","e0","e1","e2","e3","e4","e5","e6","e7","e8","e9","ea","eb","ec","ed","ee","ef","f0","f1","f2","f3","f4","f5","f6","f7","f8","f9","fa","fb","fc","fd","fe","ff",);
	$r_word = str_replace("\\\\", "##_slash_##", $r_word);
	$r_word = str_replace("\\", "\\\\", $r_word);
	$r_word_length = strlen($r_word);
	$r_word_out = "";
	for ($i=0;$i<$r_word_length;$i++) {
		if ($r_word[$i]=='¨') {
			$r_word_out = $r_word_out."\\a8'";
			} else {
			if ($r_word[$i]=='¸') {
				$r_word_out = $r_word_out."\\'b8";
				} else {
				if ((ord($r_word[$i])>=192)&&(ord($r_word[$i])<=255)) {
					$array_pos = ord($r_word[$i])-192;
					$r_word_out = $r_word_out."\\'".$cnv_array[$array_pos];
					} else {
					$r_word_out = $r_word_out.$r_word[$i];
					}
				}
			}
		}
	$r_word_out = str_replace("{", "\\{", $r_word_out);
	$r_word_out = str_replace("}", "\\}", $r_word_out);
	$r_word_out = str_replace("\\\\\\{", "{", $r_word_out);
	$r_word_out = str_replace("\\\\\\}", "}", $r_word_out);
	$r_word_out = str_replace("##_slash_##", "\\", $r_word_out);
	$r_word_out = str_replace("\n", "\\line", $r_word_out);
	return $r_word_out;
}

?>