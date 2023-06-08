<?php

#_main_::depend('configs');
#_main_::depend('merges');
_main_::depend('uploads');

	$dat = _main_::query('linked_pict', "
		select	L.*
		,	L.`small_file`  as `small_name`
		,	L.`middle_file` as `middle_name`
		,	L.`large_file`  as `large_name`
		from	`linked_picts`  as L
		where	L.`uplink_type` = {1}
		", 'article');

while($data=array_shift($dat)){
	
	put_uploaded_image_if_needed($data, 'small', 'large');
	
	_main_::query(null, "
		update  `linked_picts`
		set	small_w	= {1}
		,	small_h	= {2}
		where	`id` = {3}
		", $data['small_w']
		, $data['small_h']
		, $data['id']
		);
#	print_r($data);
}
_main_::commit();
die("OK");

?>