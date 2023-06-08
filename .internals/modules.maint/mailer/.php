<?php
//
// Рассылка очередной порции сообщений из очереди почтовика.
//
// Рекомендуется выполнять каждые 1-5-15 минут, не реже.
// Но фактически частота вызовов зависит от размера одной порции,
// а также от желаемой стабильности рассылки. В любом случае,
// две копии рассыльщика не запустится никогда (механизм lock'ов).
//

$silent = in_array('silent', $pathargs);

_main_::depend('locks');
_main_::depend('mail');
_main_::depend('mailer//queue');
_main_::depend('mailer_tasks//reads');
_main_::depend('mailer_tasks//opers');
_main_::depend('mailer_files//reads');
_main_::depend('mailer_files//opers');

_main_::depend('_specific_/fetches');
fetch_inlines(array('mailer:mail', 'mailer:sign'));

// С помощью lock'ов обеспечиваем чтоб не запустился другой экземпляр мейлера пока работаем мы сами.
#if (make_lock_nb(_config_::$mailer_lock_file, _config_::$mailer_lock_age))
#{

$fp = fopen(_config_::$mailer_lock_file, "a");
if (!$fp || !flock($fp, LOCK_EX | LOCK_NB))
{
	_main_::put2dom('locked');
}else
{
	// Читаем из очереди очередную пачку сообщений для отправки (комбинация заданий и подписчика) вместе с детальными данными.
	select_mailer_queue($dat, _config_::$mailer_bulk_size);

	// Выполняем отправку всех сообщений из очередной прочитанной пачки.
	$previous_mailer_task = null;
	foreach ($dat as $idx => $row)
	{
	        if (($emails = mailer_check_email($row['email'])) === false)
	        {
	        	del_mailer_queue($row['mailer_task'], $row['subscriber']);
	        	mailer_delete_subscriber($row['subscriber']);
	        	continue;
	        }

		// Обеспечиваем чтоб наш lock не убили раньше времени, и чтоб скрипт не убился по timeout'у.
		prolong_lock(_config_::$mailer_lock_file);
		set_time_limit(0);// В расчёте на чтение файлов, кодирование и отправку всего по почте.

		// Формируем список файлов, которые рассылать с сообщением.
		// Список файлов читаем только в том случае, если изменился идентификатор рассылки в цикле
		// (чтобы не читать кучу раз одни и те же файлы). Помним что в select'е идёт order by в первую очередь по id задания.
		if ($previous_mailer_task !== $row['mailer_task'])
		{
			$previous_mailer_task = $row['mailer_task'];
			$files = array();
			foreach ($row['mailer_files'] as $file_row)
				$files[strlen($file_row['name']) ? $file_row['name'] : $file_row['attach_file']] =
					file_get_contents(_config_::$dir_for_linked . 'mailer/' . $file_row['attach_file']);
		}

		// Формируем текст письма на основе основного DOM, но не оставляем за собой вспомогательного элемента.
		// Тут нельзя запоминать предыдущее сообщение, так как в шаблоне могут быть изменения на основе данных адресата.
		$node = _main_::put2dom('current_mailer', $row);
		$message = _main_::transform_by_file($doc, _config_::$messages_dir . 'mailer_mail' . _config_::$messages_ext);
		$node->parentNode->removeChild($node);

		// Отправляем сообщение, и в случае успеха после каждого очередного сообщения помечаем его в базе как выполненное.
		$ok = send_multipart_mail(_config_::$mail_for_mailer, $emails, null, $message, $files);
		if ($ok)
		{
			done_mailer_queue($row['mailer_task'], $row['subscriber']);
			_main_::commit();
			sleep(_config_::$mailer_bulk_delay);
		}else
		{
	        	del_mailer_queue($row['mailer_task'], $row['subscriber']);
			mailer_subscriber_set_inactive($row['subscriber']);
			_main_::commit();
		}
	}

	// Закидываем в DOM выполненную пачку отправок. Может пригодиться для формирования отчёта.
	if (!$silent) _main_::put2dom('queue', $dat);



	// После отправки очередной пачки сообщений, проверяем какие рассылки достигли 100%-ого исполнения и их надо завершить.
	// Не забываем оповестить админа о завершении рассылки, а также стереть почтовые файлы с диска, соответственно пометив их в БД.
	select_mailer_tasks_where_complete($dat);
	foreach ($dat as $idx => $row)
	{
		// Формируем административное сообщение о завершении конкретной рассылки.
		$node = _main_::put2dom('current_mailer', $row);
		$message = _main_::transform_by_file($doc, _config_::$messages_dir . 'mailer_done' . _config_::$messages_ext);
		$node->parentNode->removeChild($node);

		// И отсылаем сформированное сообщение администратору.
		// После отсылки отчёта помечаем задание как выполненное, и физически стираем все его файлы (особо помечая это в базе).
		$ok = send_multipart_mail(_config_::$mail_for_mailer, _config_::$mail_for_mailer_report, null, $message, null);
		if ($ok)
		{
			stop_mailer_task($errors, $row, $row['id']);
			_main_::commit();
		}
	}

	// Закидываем в DOM список полностью законченных рассылок. Может пригодиться для формирования отчёта.
	if (!$silent) _main_::put2dom('complete', $dat);



	// Освобождаем lock.
	free_lock(_config_::$mailer_lock_file);
}

// В случае "тихого" режима не генериуем отчёт.
if ($silent) throw new exception_exit();

?>