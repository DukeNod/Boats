<?php
_main_::depend('multilang');
_main_::depend('base_module');

Class Models extends Base_Module
{
	function __construct()
	{
		parent::__construct('models', 'model', 'Модели');

		$this->order_field = 'name';	// Поле сортировки записей.
							// Может принимать специальное значение 'position', позволяющее управлять сортировкой (стрелочки)
		#$this->order_dest = 'asc'; // Направление сортировки
		#$this->name_field = 'name'; // Какое поле представляет название записи. default 'name'
		$this->update_details = true; // Список линков для страницы редактирования записи. default true (все линки)
		$this->on_page = 100;
		$this->return_to_list = true; // Возвтрат к списку после добавления/радктирования. default: false (возврат к редактированию)

		#$this->admin_list_where = 'and A.`parent` = 0';

		#$this->multilang_fields=array('name');
		#$this->multilang_fields_select = $this->multilang_fields;

		#$this->linked_subcat_name = 'subpages';

		$this->admin_sorters = array('name'=>false); // 'position'=>false, 'mr'=>false, 

		#make_filter(filter_type, filter_name, filter_title, defauilt value, [fields = array()])

		// Добавление полей модуля
		// make_field('field_type', 'field_name', [required], [defauilt value], [parameters = array()])

		$this->make_field('TextField', 'name', true, null, array(
			'title'		=> 'Название'
		));

		$this->make_field('CheckBox', 'active', false, '', array(
			'title'		=> 'Активность'
		));

		$this->make_field('SelectList', 'type', false, null, array(
			'title'		=> 'Тип'
		,	'linked_module'	=> 'model_types'
		,	'empty'		=> 'Выбрать тип'
		,	'list'		=> 1
		));
		

	
	// make_details('detail field name', 'linked module name, 'link name', 'link title', 'link function name', link fields list = array('field_uplink' => 'field_id', [...]), $show = true)

		// $detail_name      - Внутреннее имя для прилинкованных данных. Используется в переменной $details для указания, какие данные выбирать.
		//                     $detaila = array('linked_picts' => true);
		//                     Обычно, но не обязательно, совпадает с именем элемента массива, куда записывается подмассив.
		// $module           - Модуль прилинкованных данных. Используется для вызова функции select_for_linked, чтоб получить путь в шапке админки.
		// $link_name        - Для стандартных линков (linked_paras, linked_picts, linked_files, linked_video)
		//                     используется чтоб отличать в БД несколько разных групп прилинкованных данных (в поле uplink_type).
		//                     Например  для картинки товара в списке uplink_type = item, а для галлереи uplink_type = gallery.
		//                     Для самодельных линков не имеет значения.
		// $link_title       - Заголовок блока прилинкованных данных на странице редактирования текущего объекта.
		//                    
		// $link_function    - Функция (этого класса !) для выборки самих данных. Для стандартных линков эти функции уже есть в Base_Module.
		//                     Для самодельных линков джолжна быть объявлена в этом модуле.
		// $link_fields_list - Массив параметров которые передаются в ссылку 'Добавить' для этого типа прилинкованных данных.
		//                     Например: array('category'=>'id'), чтоб в форме нового товара уже стояла текущая категория.
		// $show             - Показывать этот блок прилинкованных данных на странице редактирования. По умолчанию: true
		//                     Например для прилинкованных parents должно быть false, т.к. блок родительской категории никак невыводится.

		#$this->make_details('linked_paras',   'linked_paras', $this->outfield, 'Параграфы',               'select_linked_paras');
	}

################## COMMON ####################################

################## ENUMS ####################################

################## FORMS ####################################

################## OPERS ####################################

################## READS ####################################
	function select_for_select (&$dat, $details = null)
	{
		$dat = _main_::query('model', 'SELECT `id`, `name` FROM models where active = 1');
	}
	
	function select_by_payments (&$dat, $payments, $details = null)
	{
		if (!is_array($payments)) $payments = array($payments);

		$dat = (!$payments) ? array() : _main_::query($this->outfield, "
			select	A.*
			,	m4p.`payment`
			,	mt.name as model_type
			from	`_models4payment_` as m4p
			left	join `{$this->table}` as A on (m4p.`model` = A.`id`)
			left  	join `model_types` as mt on (mt.id = A.type)
			where	m4p.`payment` in {1}  order by {$this->order_field}
			", $payments);

		fill_texts($dat,$this->multilang_fields);
		$this->select_details($dat, $details);
	}
	
}

?>