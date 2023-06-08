<?php
_main_::depend('configs');
_main_::depend('sql');

	$dat = _main_::query(null, "
		select	content_body, content_file_name
		from	xml_files
		where	`id` = {1}
		", $pathargs[0]);

	$data = array_shift($dat);

header("Content-Disposition: attachment; filename={$data['content_file_name']}");
header("Content-type: application/xml");
echo $data['content_body'];

throw new exception_exit();
?>