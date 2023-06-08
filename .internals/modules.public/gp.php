<?php

// Подключаем нужные функции.
_main_::depend('gp');

// Получаем идентификатор вопроса из запроса.
$id = (isset($pathargs[0]) ? $pathargs[0] : (isset($_GET['id']) ? $_GET['id'] : null));

// Выводим изображение в основной поток вывода (stdout).
gp_print_image($id);

// Прерываем работу ядра (чтобы не срабатывал XSLT и не выводился XML и отладочный dump).
throw new exception_exit();

?>