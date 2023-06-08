<?php

function enumerate_linked_file_siblings (&$dat, $uplink_type, $uplink_id)
{
	$dat = _main_::query("linked_video", "
		select	`id`, `name`, `position`
		from	`linked_video`
		where	`uplink_type` = {1} and `uplink_id` = {2}
		order	by `position` asc, `id` asc
		", $uplink_type, $uplink_id);
}

?>