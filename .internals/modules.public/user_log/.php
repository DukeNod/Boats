<?php

$u = _main_::fetchModule('users');
$u->check(['admin']);

$m = _main_::fetchModule('users/log');

$dict = _main_::fetchModule('dictionaries');

// Читаем и выводим всестраничные данные до начала всех работ.
_main_::depend('_specific_/fetches');
_main_::depend('embed_files');
_main_::depend('sql');
_main_::depend('pager');
_main_::depend('filters_class');

fetch_every_page_content();

$page = null;
$page =  isset($pathargs[0]) && (strtolower($pathargs[0]) == 'page') && isset($pathargs[1]) ? $pathargs[1] : null;

	$filters_fields["user"] = new TextField("user", null);
	$filters_fields["user"]->title = 'Пользователь';

	$filters_fields["id"] = new TextField("id", null);
	$filters_fields["id"]->title = 'ID';
	
	$filters_fields["type"] = new Select("type", '');
	$filters_fields["type"]->title = 'Тип запроса';
	$filters_fields["type"]->empty = 'Не учитывать';
	$filters_fields["type"]->values_list = [
		'request' => 'Дело'
	,	'hotels' => 'Гостиница'
	,	'dsig' => 'Подпись'
	];

	/* Отдельные фильтры по названию и юр.адресу слиты в один фильтр both_names

	$filters_fields["name_full"] = new AutocompleteField("name_full", '');
	$filters_fields["name_full"]->title = "Название";
	$filters_fields["name_full"]->placeholder = "не учитывать";
	$filters_fields["name_full"]->autocomplete = [ 'url' => 'search/hotels.php' ];
	$filters_fields["name_full"]->mapping = "H.id";
	$filters_fields["name_full"]->cond = "=";
	$filters_fields["name_full"]->linked_module = "hotels";
	$filters_fields["name_full"]->select_function = "select_for_filters";
	*/

	$filters_fields["from"] = new DateTimeField("from", '');
	$filters_fields["from"]->title = "с";
	$filters_fields["from"]->cond = ">=";
	$filters_fields["from"]->sql_field = "date";

	$filters_fields["to"] = new DateTimeField("to", '');
	$filters_fields["to"]->title = "по";
	$filters_fields["to"]->cond = "<=";
	$filters_fields["to"]->sql_field = "date";

	$filters = new Filters($filters_fields);

	$filters_data = $filters->get_filters();

	$sorters = array(
		'date' => true
	);
	_main_::put2dom('sorters', $sorters = get_requested_sorters($sorters));

	$pager = new Pager(200);
	
	if (@$_GET['export'])
		$pager->setPage('all');
	else
		$pager->setPage($page);

	$m->select_for_list($dat, $filters, $sorters, $pager);
	
	if (@$_GET['export'])
	{
		$es = _main_::fetchModule('excelspreadsheet');
		
		$styleArray = [
			'borders' => [
				'allBorders' => [
					'borderStyle' => \PhpOffice\PhpSpreadsheet\Style\Border::BORDER_THIN
				]
			]
    	];
    	
		// Формируем заголовки
		$exp_fields = array(
			"npp" => "№",
			"hotel" => "Гостиница",
			"last_case" => "Последнее созданое дело",
			"name" => "Юр. лицо",
			"fms_code" => "Идентификатор гостиницы",
			"inn" => "ИНН гостиницы",
			"address" => "Фактический адрес гостиницы",
			"contract" => "Номер соглашения",
			"new"  => "признак"
		);
		//	"rdate" => "Дата",
		
		$es->esopen('300_hotels_new', null, true); // false

		$sheet = $es->spreadsheet->getActiveSheet();
		$sheet->setTitle('Гостиницы');

		// Текущая строка
		$r = 1;

		// Текущая колонка
		$c = 0;

		// Заголовки
		$cname_last = null;
		foreach ($exp_fields as $field_name => $field_header)
		{
			$cname = $es->column_from_index($c);
			$cname_last = $cname;
			$sheet->getColumnDimension($cname)->setAutoSize(true);
			$sheet->setCellValue($cname.$r, $field_header);
			$c++;
		}
		$sheet->getStyle('B'.$r.':'.$cname_last.$r)->getFont()->setBold(true);
		$r++;

		$rn = 0; $in = $out = $all = 0;
		foreach($dat as $row)
		{
			#$sheet->setCellValue('A'.$r, date('d.m.Y',strtotime($row['rdate'])));
			
			$sheet->setCellValue('A'.$r, $r-1);
			$sheet->setCellValue('B'.$r, $row['name_full']);
			$sheet->getCell('B'.$r)->getHyperlink()->setUrl("http://gkumosbez.mos.ru/hotels/{$row['id']}/");

			/*			
			$last_case = _main_::query(null, "
				select r.created_at
				from requests r
				inner join profiles p on (r.hotelier_profile_id = p.id)
				where  p.hotel_id = {1} and r.sig = 1
				order by r.created_at
				limit 1
			", $row['id']);
			*/
			$last_case = _main_::query(null, "
				select max(r.created_at) as created_at
				from requests r
				inner join profiles p on (r.hotelier_profile_id = p.id)
				where  p.hotel_id = {1} and r.sig = 1
			", $row['id']);

			$sheet->setCellValue('C'.$r, $last_case ? date('d.m.Y', Strtotime($last_case[0]['created_at'])) : '');
			$sheet->setCellValue('D'.$r, $row['name']);
			$sheet->getCell('E'.$r)->setValueExplicit($row['fms_code'], \PhpOffice\PhpSpreadsheet\Cell\DataType::TYPE_STRING);
			
			#$sheet->setCellValue('D'.$r, $hotels['hotel:'.$row['hid']]['hotel_code']);
			
			$sheet->getCell('F'.$r)->setValueExplicit($row['inn'], \PhpOffice\PhpSpreadsheet\Cell\DataType::TYPE_STRING);
			
			$sheet->setCellValue('G'.$r, $row['address_real']);
			$sheet->setCellValue('H'.$r, $row['contract']);
			$sheet->setCellValue('I'.$r, $row['is_blocked'] == 1 ? 'заблокирована' : ($row['new'] == 1 ? 'новая' : ''));
			
			$r++;
		} // row

		$sheet->setCellValue('G'.$r, 'Итог');
		$sheet->getStyle('G'.$r)->getFont()->setBold(true);
		$sheet->getStyle('G'.$r)->getAlignment()->setHorizontal(\PhpOffice\PhpSpreadsheet\Style\Alignment::HORIZONTAL_RIGHT);
		$sheet->setCellValue('H'.$r, $in);
		$sheet->setCellValue('I'.$r, $out);
		$sheet->setCellValue('J'.$r, $all);
			
		$sheet->getStyle('F1:F'.$r)
			->getNumberFormat()
			->setFormatCode( \PhpOffice\PhpSpreadsheet\Style\NumberFormat::FORMAT_TEXT );
				
		$sheet->getStyle('B2:B'.$r)->getFont()->getColor()->setARGB('FF1976D2');
		
		$sheet ->getStyle('A1:L'.($r-1))->applyFromArray($styleArray);
		$sheet ->getStyle('H'.$r.':J'.$r)->applyFromArray($styleArray);
		
		$sheet->getStyle('B1');

		$es->eswrite();
		$es->esclose();
		throw new exception_exit();
	}

	_main_::put2dom('list', $dat);
	_main_::put2dom('pager', $pager->toDOM());
	_main_::put2dom('filters', $filters->fields2dom());

	_main_::put2dom('main');
?>
