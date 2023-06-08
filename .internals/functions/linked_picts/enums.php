<?php

function enumerate_linked_pict_siblings (&$dat, $uplink_type, $uplink_id)
{
	$dat = _main_::query("linked_pict", "
		select	`id`, `alt`, `position`
		from	`linked_picts`
		where	`uplink_type` = {1} and `uplink_id` = {2}
		order	by `position` asc, `id` asc
		", $uplink_type, $uplink_id);
}

function enumerate_linked_pict_uploads_list(&$dat)
{
        $directory = '../../uploads';
        $dat = array();

	if (($d = opendir($directory)) !== false)
	{
		while (($filename = readdir($d)) !== false)
		{
			$filepath = $directory . '/' . $filename;

			if (($filename == '.') || ($filename == '..')) continue;

			if (is_dir($filepath))
				$dat['path:'.count($dat)] = $filename;
		}
		closedir($d);
	}
}

?>