<?php
set_time_limit(0);
_main_::depend('multilang');
_main_::depend('merges');

	$dat = _main_::query('inline', "
		select * from inlines
	");
	
	$ids = get_fields($dat, 'content');
	array_unique($ids);
	
	$dat2 = _main_::query('text', "select
		* 
		from texts
		where text_id in {1}
	", $ids);

	merge_subtable_as_array($dat, $dat2, 'texts', 'text_id'    , 'content');

	file_put_contents('inlines.ser', serialize($dat));

_main_::put2dom("done");
?>