<?php
//
// (c) 2007 http://www.howard-studio.ru/
// Sergei Vasilyev, nolar@howard-studio.ru
//
// Функции для блокировки процесса/скрипта, чтоб он не запускался в несколько потоков одновременно.
// Полезно, например, для обслуживающих сервисных скриптов (мейлера, чистильщика и т.п.), которым
// весьма нежелательно чтобы, пока они работают длительное время, запустился бы другой процесс этого же скрипта
// (например, по cron'у или иному расписанию).
//
// Для lock'а используется файл с указанным путём. Т.к. ОС Windows не поддерживает non-blocking в flock(),
// то всю систему мы эмулируем вообще без flock(), с помощью создания и удаления файла-флага ($lock_file).
// Надеемся, что скорость вызова таких скриптов будет не настолько частой, чтоб вызвать конликт существования файла
// между проверкой (file_exists()) и созданием (touch()) lock-файла. Т.к. скрипт может и вылететь по ошибке,
// не освободив за собой lock (не удалив lock-файл), то мы считаем что если файлу более скольки-то секунд ($lock_age),
// то он является старым и ведём себя так, как будто его не существует вовсе. На очень длительных скриптах
// рекомендуется регулярно "обновлять" этот файл с помощью prolong_lock(), чтобы он не состарился раньше времени.
//
// Рекомендуемый способ использования:
//
//	if (make_lock_nb('/path/to/file', 1*60*60))
//	{
//		for (...) // for/foreach/while or another iterative operation
//		{
//			prolong_lock('/path/to/file');
//			set_time_limit(30);
//			... // do something useful here
//		}
//		free_lock('/path/to/file');
//	} else
//	{
//		print "Another process is running.";
//	}
//


function make_lock_nb ($lock_file, $lock_age = null)
{
	$locked    = false;
	$lock_time = file_exists($lock_file) ? filemtime($lock_file) : 0;
	if ((!$lock_time) || ($lock_time < time() - $lock_age))
	{
		touch($lock_file);
		$locked = true;
	}
	return $locked;
}

function prolong_lock ($lock_file)
{
	touch($lock_file);
}

function free_lock ($lock_file)
{
//	if (file_exists($lock_file)) unlink($lock_file);
}

?>