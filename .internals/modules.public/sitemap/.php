<?php
$u = _main_::fetchModule('users');
$u->check([ 'admin' ]);

_main_::depend('_specific_/fetches');
	/*$c = _main_::fetchModule('categories');
	$tree =& $c->get_tree_public(1);
	$c->get_tree_details($tree, array('items_public' => array()));
	_main_::put2dom('categories', $tree);*/

	$p = _main_::fetchModule('pages');
	$m = _main_::fetchModule('gallery');
	$n=_main_::fetchModule('news');
	$a=_main_::fetchModule('actions');
	_main_::depend('pager');
	
	$p_tree =& $p->get_tree_public();
	$m->select_for_read($gdat);
	$pager = new Pager(1000);
	$pager->setPage($page);

	$n->select_news_by_page($ndat, $group, $pager, true);
	
	$apager = new Pager(1000);
	$apager->setPage($apage);

	$a->select_for_read($adat, $apager);

	_main_::put2dom('nlist', $ndat);
	_main_::put2dom('alist', $adat);
	_main_::put2dom('pages', $p_tree);
	_main_::put2dom('gpages', $gdat);
?>
