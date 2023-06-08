<?php

_main_::depend('configs');
_main_::depend('merges');
_main_::depend('forms');
_main_::depend('sql');

$module_name = array_shift($pathargs);
$m = _main_::fetchModule($module_name);

// Чтение исходных данных записи и всех её дочерних элементов при необходимости.
$id = array_shift($pathargs);
$m->select_by_ids($dat, $id, true, $m->update_details);

$info = array_shift($dat);// не бывает null, потому что required при select'е!

// Определение имени и нового значения поля, проверка их допустимости.
$fields = array();
if ($_POST)
{
        foreach($_POST as $f=>$v)
        {
        	if (isset($m->fields[$f]))
        	{
			$field = $f;
			$value = $v;
			break;
        	}
        }
}else
{
$field = array_shift($pathargs);
$value = array_shift($pathargs);
}
if (!isset($m->fields[$field])) throw new exception_bl("Unsupported field for turning ({$field}).", "unsupported_field");

// Определение запрошенных действий и получение присланных данных.
$errors = array();
$action = determine_action(null, 'do', true);
$defs   = array();
$data   = array_merge_rol($m->defs(), $info, array($field => $value));

// Чтение конфига модуля, списков для полей выбора (для валидации и элементов формы) и других данных.
$config = $m->fetch_config();
#$m->fetch_enums($enums);

// Типичный сценарий операции: подгонка файлов, проверка значений, и либо обращение к базе, либо временное запоминание.
if (($action === 'do') && !count($errors)) $m->validate($errors, $data, $config, $enums, true);
if (($action === 'do') && !count($errors))   $m->toggle($errors, $data, $id, $field, $value);

// В DOM!
$dom = compact('id', 'action', 'info', 'data', 'errors', 'field', 'value');
$dom['@for'] = $m->essence;

_main_::put2dom(($action === 'do') && !count($errors) ? 'done' : 'form', $dom);
_main_::put2dom('module', $m->fields2dom($data));

if ($_GET['ajax'] == 1)
	_main_::set_module_xslt("/common/ajax/toggle");
else
	_main_::set_module_xslt("/common/toggle");

?>