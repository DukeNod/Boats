<?php

function enumerate_mailer_file_siblings (&$dat, $mailer_task)
{
	$dat = _main_::query("mailer_file", "
		select	`id`, `name`, `attach_file`, `position`
		from	`mailer_files`
		where	`mailer_task` = {1}
		order	by `position` asc, `id` asc
		", $mailer_task);
}

?>