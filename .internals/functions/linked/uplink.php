<?php
//
// (c) 2007 http://www.howard-studio.ru/
// Sergei Vasilyev, nolar@howard-studio.ru
//
// ЭТОТ ФАЙЛ МЕНЯЕТСЯ ОТ ПРОЕКТА К ПРОЕКТУ!
//
// Функция для "умного" определения и чтения аплинка по его типу и идентификатору. Используется в linked-модулях
// (linked_paras, linked_files, linked_picts и т.п.), где аплинк задаётся таким образом (uplink_type & uplink_id).
//

function select_uplink_by_type_and_id (&$dat, $uplink_type, $uplink_id, $required = null)
{			
	switch ($uplink_type)
	{
		case 'response'     : _main_::depend('responses//reads'    ); select_responses_by_ids     ($dat, $uplink_id, $required, sprintf($exception_id, $uplink_type)); break;
			default:
			_main_::depend('linked//conf');
			_main_::depend('merges');
			$uc=uplinks_config();
			
			if (!$uc[$uplink_type]['@sname'])
				throw new exception_bl("Uplink type unknown ('{$uplink_type}').", $exception_id);

//			$time = 10*365*24*60*60;
//			$root = isset(_config_::$dom_info['adm_root']) ? _config_::$dom_info['adm_root'] : '/';
//			setcookie("bookmark", $uplink_type, time()+$time, $root, "");

			$m=_main_::fetchModule($uc[$uplink_type]['@sname']);
			if (method_exists($m,"select_for_linked")) $m->select_for_linked ($dat, $uplink_id, $required, null);
			if (!empty($dat)){
				$dat=array_merge_lor($dat,$uc[$uplink_type]);
			}else{
				$dat = array(); 
				if ($required) throw new exception_bl("Uplink type unknown ('{$uplink_type}').", $exception_id);
			}
	
	}
}

?>