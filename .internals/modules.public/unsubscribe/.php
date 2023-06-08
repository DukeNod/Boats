<?php
$u = _main_::fetchModule('users');
$u->check([ 'admin' ]);

// „итаем и выводим всестраничные данные до начала всех работ.
_main_::depend('_specific_/fetches');
#fetch_every_page_content();

// ѕодключаем нужные функции.
_main_::depend('subscribers//opers');
_main_::depend('subscribers//reads');
_main_::depend('subscribers//mails');
_main_::depend('subscribers//macro');

// ѕолучаем данные дл€ выполнени€ операции (и дл€ определени€ что за операци€ запрошена).
$email = isset($_GET['email']) && strlen($_GET['email']) ? $_GET['email'] : null;
$code  = isset($_GET['code' ]) && strlen($_GET['code' ]) ? $_GET['code' ] : null;

// —лучай, когда указаны и адрес, и код, считаем самим фактом подтверждени€ (или попыткой подтверждени€).
if (($email !== null) && ($code !== null))
	unsubscribe_confirm_macro($doc, $email, $code);
else	unsubscribe_request_macro($doc, $email);

?>