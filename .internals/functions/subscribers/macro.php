<?php

function subscribe_request_macro ($doc, $email)
{
	_main_::depend('validations');

	// Инициализируем начальные структуры, которые потом закинутся в DOM или повляют на имя элемента.
	$code = generate_subscriber_code();
	$info = null;// Просто начальное значение. Потом наверняка перекроется при чтении.
	$data = compact('email', 'code');
	$done = false;
	$errors = array();

	// Проверяем валидность переданных нам полей. Потому что они сами могут быть невалидны, и тогда не нужно напрягать базу.
	validate_required($errors, $data, 'email') && validate_email($errors, $data, 'email');

	// Внаглую пробуем добавить подписчика. Если там такой уже есть, то вылетит exception_db_unique.
	// Есть разница в том, чтоб сначала селектнуть и потом вставить по необходимости, и тем чтоб
	// вставлять и ловить нарушение уникального ключа: потому что select читает по консистенции
	// на момент начала транзакции, а после начала другой скрипт мог уже вставить такой email,
	// и тогда повторная попытка вставки провалится; поэтому сразу и переходим к попытке вставки.
	//todo: replace to insert_subscriber() with its $data emulated here. gives us less routines.
	if (!count($errors))
		try { request_subscriber($data, $id); }
		catch (exception_db_unique $exception) {} // do nothing to keep $done == false, and $errors untouched (empty).

	// Перечитываем данные только что добавленного подписчика, либо того, на которого мы наткнулись по unique violation.
	// Мы ведь не можем угадать все поля при вставке, ни даже их набор. Поэтому проще всё перечитать селектом; особенно даты.
	// Но только если нет ошибок операции, то есть если мы воообще пытались его вставить, а не прошли мимо из-за ошибок.
	if (!count($errors))
	{
		select_subscriber_by_email($dat, $email, true);// silent assertion: он есть, мы ведь только что наткнулись на email unique violation, либо вставили.
		$info = array_shift($dat);
	}

	// Проверяем достаточно ли у нас данных для операции, и корректны ли эти данные, и выполняем саму операцию.
	// А поскольку попытка добавления вынесена в самое начало (до чтения), то выполнение операции заключается лишь в отправке почты.
	if (!count($errors) && ($info['is_active'])) validate_add_error($errors, 'is_active', 'already');
	if (!count($errors))
	{
		mail_subscribe_request($doc, $info);
		$done = true;
	}

	// В DOM!
	$dom = compact('data', 'info', 'errors');
	$dom['@for'] = 'subscribe-request';
	_main_::put2dom($done ? 'done' : 'form', $dom);

}

function subscribe_request_macro_from_request ($doc, $email)
{
	_main_::depend('validations');

	// Инициализируем начальные структуры, которые потом закинутся в DOM или повляют на имя элемента.
	$code = generate_subscriber_code();
	$info = null;// Просто начальное значение. Потом наверняка перекроется при чтении.
	$data = compact('email', 'code');
	$done = false;
	$errors = array();

	// Проверяем валидность переданных нам полей. Потому что они сами могут быть невалидны, и тогда не нужно напрягать базу.
	validate_required($errors, $data, 'email') && validate_email($errors, $data, 'email');

	// Внаглую пробуем добавить подписчика. Если там такой уже есть, то вылетит exception_db_unique.
	// Есть разница в том, чтоб сначала селектнуть и потом вставить по необходимости, и тем чтоб
	// вставлять и ловить нарушение уникального ключа: потому что select читает по консистенции
	// на момент начала транзакции, а после начала другой скрипт мог уже вставить такой email,
	// и тогда повторная попытка вставки провалится; поэтому сразу и переходим к попытке вставки.
	//todo: replace to insert_subscriber() with its $data emulated here. gives us less routines.
	if (!count($errors))
		try { request_subscriber($data, $id); }
		catch (exception_db_unique $exception) {} // do nothing to keep $done == false, and $errors untouched (empty).

	// Перечитываем данные только что добавленного подписчика, либо того, на которого мы наткнулись по unique violation.
	// Мы ведь не можем угадать все поля при вставке, ни даже их набор. Поэтому проще всё перечитать селектом; особенно даты.
	// Но только если нет ошибок операции, то есть если мы воообще пытались его вставить, а не прошли мимо из-за ошибок.
	if (!count($errors))
	{
		select_subscriber_by_email($dat, $email, true);// silent assertion: он есть, мы ведь только что наткнулись на email unique violation, либо вставили.
		$info = array_shift($dat);
	}

	// Проверяем достаточно ли у нас данных для операции, и корректны ли эти данные, и выполняем саму операцию.
	// А поскольку попытка добавления вынесена в самое начало (до чтения), то выполнение операции заключается лишь в отправке почты.
	if (!count($errors) && ($info['is_active'])) validate_add_error($errors, 'is_active', 'already');
	if (!count($errors))
	{
		mail_subscribe_request($doc, $info);
		$done = true;
	}

	// В DOM!
	$dom = compact('data', 'info', 'errors');
	$dom['@for'] = 'subscribe-request';
	if (count($errors))
	_main_::put2dom('form', $dom);

}

function subscribe_confirm_macro ($doc, $email, $code)
{
	_main_::depend('validations');

	// Инициализируем начальные структуры, которые потом закинутся в DOM или повляют на имя элемента.
	$info = null;// Просто начальное значение. Потом наверняка перекроется при чтении.
	$data = compact('email', 'code');
	$done = false;
	$errors = array();

	// Проверяем валидность переданных нам полей. Потому что они сами могут быть невалидны, и тогда не нужно напрягать базу.
	validate_required($errors, $data, 'email') && validate_email($errors, $data, 'email');
	validate_required($errors, $data, 'code' );

	// Пытаемся читать данные подписчика, неявно проверяя его существование в базе. Если, конечно, email валиден.
	if (!count($errors))
	{
		select_subscriber_by_email($dat, $email);
		$info = array_shift($dat);
	}

	// Проверяем достаточно ли у нас данных для операции, и корректны ли эти данные, и выполняем саму операцию.
	// Код проверяем функцией сравнения строк (а не оператором ==) чтоб не было неявных преобразований в числа, не дай бог.
	if (!count($errors) && ($info === null)) validate_add_error($errors, 'email', 'wrong');
	if (!count($errors) && ($info['is_active'])) validate_add_error($errors, 'is_active', 'already');
	if (!count($errors) && (strcmp($info['code'], $data['code']) !== 0)) validate_add_error($errors, 'code', 'wrong');
	if (!count($errors))
	{
		activate_subscriber($info['id']);
		mail_subscribe_confirm($doc, $info);
		$done = true;
	}

	// В DOM!
	$dom = compact('data', 'info', 'errors');
	$dom['@for'] = 'subscribe-confirm';
	_main_::put2dom($done ? 'done' : 'form', $dom);
}

function unsubscribe_request_macro ($doc, $email)
{
	_main_::depend('validations');

	// Инициализируем начальные структуры, которые потом закинутся в DOM или повляют на имя элемента.
	$code = null;
	$info = null;// Просто начальное значение. Потом наверняка перекроется при чтении.
	$data = compact('email', 'code');
	$done = false;
	$errors = array();

	// Проверяем валидность переданных нам полей. Потому что они сами могут быть невалидны, и тогда не нужно напрягать базу.
	validate_required($errors, $data, 'email') && validate_email($errors, $data, 'email');

	// Пытаемся читать данные подписчика, неявно проверяя его существование в базе. Если, конечно, email валиден.
	if (!count($errors))
	{
		select_subscriber_by_email($dat, $email);
		$info = array_shift($dat);
	}

	// Проверяем достаточно ли у нас данных для операции, и корректны ли эти данные, и выполняем саму операцию.
	// Когда запись найдена, но неактивирована, мы ведём себя так, будто её вообще нет (полезно для режима "неполной отписки").
	if (!count($errors) && ($info === null)) validate_add_error($errors, 'email', 'wrong');
	if (!count($errors) && (!$info['is_active'])) validate_add_error($errors, 'email', 'wrong');//NB: same if we just didn't find it
	if (!count($errors))
	{
		mail_unsubscribe_request($doc, $info);
		$done = true;
	}

	// В DOM!
	$dom = compact('data', 'info', 'errors');
	$dom['@for'] = 'unsubscribe-request';
	_main_::put2dom($done ? 'done' : 'form', $dom);
}

function unsubscribe_confirm_macro ($doc, $email, $code)
{
	_main_::depend('validations');

	// Инициализируем начальные структуры, которые потом закинутся в DOM или повляют на имя элемента.
	$info = null;// Просто начальное значение. Потом наверняка перекроется при чтении.
	$data = compact('email', 'code');
	$done = false;
	$errors = array();

	// Проверяем валидность переданных нам полей. Потому что они сами могут быть невалидны, и тогда не нужно напрягать базу.
	validate_required($errors, $data, 'email') && validate_email($errors, $data, 'email');
	validate_required($errors, $data, 'code' );

	// Пытаемся читать данные подписчика, неявно проверяя его существование в базе. Если, конечно, email валиден.
	if (!count($errors))
	{
		select_subscriber_by_email($dat, $email);
		$info = array_shift($dat);
	}

	// Проверяем достаточно ли у нас данных для операции, и корректны ли эти данные, и выполняем саму операцию.
	// Код проверяем функцией сравнения строк (а не оператором ==) чтоб не было неявных преобразований в числа, не дай бог.
	if (!count($errors) && ($info === null)) validate_add_error($errors, 'email', 'wrong');
	if (!count($errors) && (!$info['is_active'])) validate_add_error($errors, 'email', 'wrong');
	if (!count($errors) && (strcmp($info['code'], $data['code']) !== 0)) validate_add_error($errors, 'code', 'wrong');
	if (!count($errors))
	{
		disactivate_subscriber($info['id'], isset(_config_::$clean_subscriptions) ? _config_::$clean_subscriptions : null);
		mail_unsubscribe_confirm($doc, $info);
		$done = true;
	}

	// В DOM!
	$dom = compact('data', 'info', 'errors');
	$dom['@for'] = 'unsubscribe-confirm';
	_main_::put2dom($done ? 'done' : 'form', $dom);
}

function macro_subscribe_add ($doc, $email)
{
        $data = array(
        	'email'		=> $email,
        	'is_active'	=> 1,
        	'code'		=> generate_subscriber_code(),
        	'is_tester'	=> 0
        );
	insert_subscriber ($errors, $data, $id);
}
?>