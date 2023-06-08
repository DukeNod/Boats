<?php
_main_::depend('forms');
_main_::depend('forms_class');
_main_::depend('types_class');

$m = _main_::fetchModule("questions");

$data = $m->get_data();

$data = array_merge($data, [ 'token' => session_id() ]);

_main_::returnJSON($data);

?>