<?php
// скрипт дл€ нанесени€ логотипа на linked-штучки (обычно картинки).
// сделан, кончно, т€п-л€п, в пор€дке очередной мегазатычки; но работает как задумано и без у€звимостей (as i see: realpath).
// если наложиьт логотип не может - отдаЄт файл как есть. ибо лучше уж что-то отдать.
// плохо только с оформлением 404 (сейчас пуста€ страница, но лучше уж так, чем рисовать полный шаблон с сообщением).
// примен€етс€ в основном только дл€ дисков и шин:
// RewriteRule ^linked/(picts/large/tyre_model/.*)$		.redirects/public/index.php/logotype/$1		[L,NC,NS]
// RewriteRule ^linked/(picts/large/disk_model/.*)$		.redirects/public/index.php/logotype/$1		[L,NC,NS]
// причЄм эти вещи должны идти ƒќ того, как картинки иными правилами отметаютс€ от rewrite'а.
// само лого должно лежать в корне (на том же уровне что и каталог linked); обычно это PNG-24 с прозрачност€ми.
// если лого не влазит в картинку - то считаем ошибкой и выдаЄм картинку как есть без изменений.

$rdir = realpath(_config_::$dir_for_linked);
$path = realpath(_config_::$dir_for_linked . implode('/', $pathargs));

// just doesnt exist
if ($path === false)
{
	header("HTTP/1.0 404 Not found");
	_main_::put2dom('unknown');
//	return;
	throw new exception_exit();
}

// exists, but is something from outside of allowed dir
if (strncmp($path, $rdir, strlen($rdir)) !== 0)
{
	throw new exception('Bad path. Probably hack.');
}

// Assert: NOW file exists, and file is "safe" (in safe dir, not system one).


if (_identify_::field('id'))
{
	$rights = _identify_::field('rights');
	if ($rights['scheme'] == 1)
	{
		header("Content-type: application/pdf");
		readfile($path);
		ob_flush();
		die;
	}
}

_main_::Redirect(_config_::$dom_info['pub_site'].'403/');
?>