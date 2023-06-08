<?php

function enumerate_linked_para_siblings (&$dat, $uplink_type, $uplink_id)
{
	$dat = _main_::query("linked_para", "
		select	`id`, `name`, `position`
		from	`linked_paras`
		where	`uplink_type` = {1} and `uplink_id` = {2} and `lang_id` = {3}
		order	by `position` asc, `id` asc
		", $uplink_type, $uplink_id, LANG_ID);
}

?>