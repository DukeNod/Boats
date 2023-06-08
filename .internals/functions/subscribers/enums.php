<?php

function enumerate_subscriber_groups (&$dat)
{
        $m = _main_::fetchModule('subscriber_groups');
        $m->select_for_read($dat);
}

?>