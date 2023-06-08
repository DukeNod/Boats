<?php

function perform_search (&$errors, &$data, $doc, &$results, $spares_only = false)
{
	$results = array();

	$m=_main_::fetchModule('pages'); $m->select_by_words   ($dat, $data['words'], false); $results = array_merge($results, $dat);
	$m=_main_::fetchModule('news'); $m->select_by_words   ($dat, $data['words'], false); $results = array_merge($results, $dat);

	$m=_main_::fetchModule('questions'); $m->select_by_words   ($dat, $data['words'], false); $results = array_merge($results, $dat);
	$m=_main_::fetchModule('actions'); $m->select_by_words   ($dat, $data['words'], false); $results = array_merge($results, $dat);
	$m=_main_::fetchModule('responses'); $m->select_by_words   ($dat, $data['words'], false); $results = array_merge($results, $dat);

	$m=_main_::fetchModule('gallery'); $m->select_by_words   ($dat, $data['words'], false); $results = array_merge($results, $dat);

//	$m=_main_::fetchModule('articles'); $m->select_by_words   ($dat, $data['words'], false); $results = array_merge($results, $dat);
	//$m=_main_::fetchModule('inlines'); $m->select_by_words   ($dat, $data['words'], false); $results = array_merge($results, $dat);


	/*
	$m=_main_::fetchModule('production'); $m->select_by_words   ($dat, $data['words'], false); $results = array_merge($results, $dat);
	$m=_main_::fetchModule('services'); $m->select_by_words   ($dat, $data['words'], false); $results = array_merge($results, $dat);
	$m=_main_::fetchModule('equipments'); $m->select_by_words   ($dat, $data['words'], false); $results = array_merge($results, $dat);

	$m=_main_::fetchModule('items'); $m->select_by_words   ($dat, $data['words'], false); $results = array_merge($results, $dat);
	$m=_main_::fetchModule('categories'); $m->select_by_words   ($dat, $data['words'], false); $results = array_merge($results, $dat);
	$m=_main_::fetchModule('brands'); $m->select_by_words   ($dat, $data['words'], false); $results = array_merge($results, $dat);
	$m=_main_::fetchModule('offers'); $m->select_by_words   ($dat, $data['words'], false); $results = array_merge($results, $dat);

	_main_::depend('vacancies//reads'); select_vacancies_by_words($dat, $data['words'], false); $results = array_merge($results, $dat);


	_main_::depend('questions//reads'); select_questions_by_words($dat, $data['words'], false); $results = array_merge($results, $dat);
	*/


}

?>