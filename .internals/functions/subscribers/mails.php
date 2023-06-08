<?php

function mail_subscribe_request ($doc, $data)
{
	_main_::depend('mail');

	// Потому как /*/done добавляется уже ПОСЛЕ операции, мы пихаем в DOM свой узел, который потом удалим.
	$node = _main_::put2dom('mail', $data);

	//
	$txt = _main_::transform_by_file($doc, _config_::$messages_dir . "subscribe_request" . _config_::$messages_ext);
	send_multipart_mail(_config_::$mail_for_subscriptions, $data['email'], null, $txt, null);

	// Удаляем временный элемент, созданный для шаблона сообщения.
	$node->parentNode->removeChild($node);
}

function mail_subscribe_confirm ($doc, $data)
{
	_main_::depend('mail');

	// Потому как /*/done добавляется уже ПОСЛЕ операции, мы пихаем в DOM свой узел, который потом удалим.
	$node = _main_::put2dom('mail', $data);

	//
	$txt = _main_::transform_by_file($doc, _config_::$messages_dir . "subscribe_confirm" . _config_::$messages_ext);
	send_multipart_mail(_config_::$mail_for_subscriptions, $data['email'], null, $txt, null);

	// Удаляем временный элемент, созданный для шаблона сообщения.
	$node->parentNode->removeChild($node);
}

function mail_unsubscribe_request ($doc, $data)
{
	_main_::depend('mail');

	// Потому как /*/done добавляется уже ПОСЛЕ операции, мы пихаем в DOM свой узел, который потом удалим.
	$node = _main_::put2dom('mail', $data);

	//
	$txt = _main_::transform_by_file($doc, _config_::$messages_dir . "unsubscribe_request" . _config_::$messages_ext);
	send_multipart_mail(_config_::$mail_for_subscriptions, $data['email'], null, $txt, null);

	// Удаляем временный элемент, созданный для шаблона сообщения.
	$node->parentNode->removeChild($node);
}

function mail_unsubscribe_confirm ($doc, $data)
{
	_main_::depend('mail');

	// Потому как /*/done добавляется уже ПОСЛЕ операции, мы пихаем в DOM свой узел, который потом удалим.
	$node = _main_::put2dom('mail', $data);

	//
	$txt = _main_::transform_by_file($doc, _config_::$messages_dir . "unsubscribe_confirm" . _config_::$messages_ext);
	send_multipart_mail(_config_::$mail_for_subscriptions, $data['email'], null, $txt, null);

	// Удаляем временный элемент, созданный для шаблона сообщения.
	$node->parentNode->removeChild($node);
}

?>