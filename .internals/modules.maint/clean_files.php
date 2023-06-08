<?php
//
// Чистка папок с постоянно сохраняемыми файлами от файлов, на которые не ссылается ни одна запись
// (обычно когда их забрасывают без завершения, предварительно загрузив файлы).
//
// Рекомендуется выполнять разово после импортов-реимпортов базы данных.
//

_main_::depend('uploads');

//NB: Со слешами на конце. Автоправки не делаем. Это quick-script, в конце концов.
clean_unlinked_from_presistent_folder(_config_::$dir_for_linked . 'picts/small/'  , 2, convert_dat_to_hash(_main_::query(null, "select distinctrow `uplink_type`, `uplink_id`, `small_file`   as `filename` from `linked_picts` where `small_file`   is not null")));
clean_unlinked_from_presistent_folder(_config_::$dir_for_linked . 'picts/large/'  , 2, convert_dat_to_hash(_main_::query(null, "select distinctrow `uplink_type`, `uplink_id`, `large_file`   as `filename` from `linked_picts` where `large_file`   is not null")));
clean_unlinked_from_presistent_folder(_config_::$dir_for_linked . 'paras/small/'  , 2, convert_dat_to_hash(_main_::query(null, "select distinctrow `uplink_type`, `uplink_id`, `small_file`   as `filename` from `linked_paras` where `small_file`   is not null")));
clean_unlinked_from_presistent_folder(_config_::$dir_for_linked . 'paras/large/'  , 2, convert_dat_to_hash(_main_::query(null, "select distinctrow `uplink_type`, `uplink_id`, `large_file`   as `filename` from `linked_paras` where `large_file`   is not null")));
clean_unlinked_from_presistent_folder(_config_::$dir_for_linked . 'files/attach/' , 2, convert_dat_to_hash(_main_::query(null, "select distinctrow `uplink_type`, `uplink_id`, `attach_file`  as `filename` from `linked_files` where `attach_file`  is not null")));
clean_unlinked_from_presistent_folder(_config_::$dir_for_linked . 'files/preview/', 2, convert_dat_to_hash(_main_::query(null, "select distinctrow `uplink_type`, `uplink_id`, `preview_file` as `filename` from `linked_files` where `preview_file` is not null")));

// В случае "тихого" режима не генериуем отчёт.
if (in_array('silent', $pathargs)) throw new exception_exit();

////////////////////////////////////////////////////////////////////////////////////////////////////

// Функция для генерации хеша файловых имён, как она используется в рекурсивном обходе,
// чтоб не генерировать на каждом уровне, а сгенерироваьт разово.
function convert_dat_to_hash ($dat)
{
	// Составляем список имён файлов. Нам важнее чтоб оно было в ключе (быстрее поиск и проверки будут),
	// а что в значении - маловажно (поэтому пишем true).
	$filenames = array();
	foreach ($dat as $row)
		$filenames[
			(isset($row['uplink_type']) ? $row['uplink_type'] . '/' : '') .
			(isset($row['uplink_id'  ]) ? $row['uplink_id'  ] . '/' : '') .
			$row['filename']] = true;
	return $filenames;
}

// Объявление функции чистики одного указанного каталога.
// Выносить в depend() нет смысла, так как она актуальна ТОЛЬКО на этой странице.
function clean_unlinked_from_presistent_folder ($directory, $deepness, $filenames, $prefix = null)
{
	// Проходимся по указанному каталогу.
	if (($d = opendir($directory)) !== false)
	{
		while (($filename = readdir($d)) !== false)
		{
			// Чтоб не вываливаться.
			set_time_limit(30);

			// Отсеиваем системные имена файлов. Отсеиваем наши спец-имена.
			if (($filename == '.') || ($filename == '..')) continue;
			if (($filename == '.dummy')) continue;

			// Нас интересуют только файлы, без каталогов и прочей ереси (пайпов, и тп)
			// Причём нас интересуют те из файлов, которые отсутствуют в списке файлов, полученном из базы.
			$filepath = $directory . $filename;
			if (is_file($filepath))
			if (!array_key_exists($prefix . $filename, $filenames))
			{
				// И если файл подходит под критерии "мусора", мы его стираем.
				unlink($filepath);
				var_dump("UNLINK: " . $filepath);
			} else
			{
				// А если попали сюда, то значит файл нужный, его не трогаем.
				var_dump("KEEP: " . $filepath);
			} else
			if (is_dir($filepath))
			if ($deepness > 0)
			{
				// Чистим каталог внутри (обычный рекурсивный обход). И только если не достигли предельного уровня.
				var_dump("DEEP IN : " . $filepath);
				clean_unlinked_from_presistent_folder($filepath . '/', $deepness - 1, $filenames, $prefix . $filename . '/');
				var_dump("DEEP OUT: " . $filepath);

				// А после чистки пытаемся стереть сам каталог, если он оказался пуст (ибо тоже мусор).
				// NB: сам каталог подтираем только если мы в него заходили, а сами себя (когда мы
				// NB: и есть top-level каталог) не трём (иначе переместить rmdirr($directory) после closedir()).
				rmdirr($filepath);
				var_dump("RMDIRR: " . $filepath);

			}
		}
		closedir($d);
	}
}

?>