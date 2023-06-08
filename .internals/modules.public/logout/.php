<?php
$u = _main_::fetchModule('users');
$u->check();

_main_::depend('forms');
_main_::depend('mail');
_main_::depend('gp');
_main_::depend('forms_class');
_main_::depend('types_class');

_main_::depend('_specific_/fetches');
fetch_every_page_content();

if ($pathargs)
print_check($pathargs);

#fetch_inlines ("register:sent");

$u = _main_::fetchModule("users");

$u->logout();

_main_::Redirect(_config_::$dom_info['pub_site']);

?>