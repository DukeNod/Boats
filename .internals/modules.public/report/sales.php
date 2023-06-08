<?php

function export_month($report, &$sheet, &$spreadsheet, &$i)
{
	foreach($report as $f => $branch)
	{
		if ($f == 'total') continue;
		
		$name = (isset($branch['name'])) ? $branch['name'] : 'Филиал не указан';

		if (isset($branch['counts']))		
		foreach($branch['counts'] as $cnt)
		{
			$name .= ', '.$cnt['name'].' '.$cnt['count'];
		}
		
		$sheet->setCellValue('A'.$i, $name);
		$sheet->getStyle('A'.$i)->getFont()->setBold(true);
		
		$i++;

		if (isset($branch['payments']))	
		foreach($branch['payments'] as $f => $payment)
		{
			if ($payment['plan'] == 1)
			{
				$spreadsheet->getActiveSheet()->getStyle('A'.$i.':L'.$i)->getFill()
					->setFillType(\PhpOffice\PhpSpreadsheet\Style\Fill::FILL_SOLID)
					->getStartColor()->setARGB('FFDDDDDD');
			}
			
			$sheet->setCellValue('A'.$i, date('d.m.Y', strtotime($payment['date'])));

			$models = ''; $types = ''; $j = 0; $max = count($payment['models']);
			foreach($payment['models'] as $model)
			{
				$models .= $model['name'];
				$types .= $model['model_type'];
				$j++;
				if ($j != $max) { $models .= ', '; $types .= ', '; }
			}
			
			$sheet->setCellValue('B'.$i, $models);
			$sheet->setCellValue('C'.$i, $types);

			$sheet->setCellValue('D'.$i, $payment['client']);
			#$sheet->getCell('D'.$i)->getHyperlink()->setUrl(_config_::$dom_info['pub_site']."payment/{$payment['id']}/");
			#$sheet->getStyle('D'.$i)->getFont()->getColor()->setARGB('FF1976D2');
			$sheet->setCellValue('E'.$i, $payment['manager']);
			$sheet->setCellValue('F'.$i, $payment['region']);
			$sheet->setCellValue('G'.$i, money($payment['summ'], $payment['currency']));
			$sheet->setCellValue('H'.$i, money($payment['have_pays'], $payment['currency']));
			$sheet->setCellValue('I'.$i, money($payment['ost'], $payment['currency']));
			$sheet->setCellValue('J'.$i, money($payment['discount'], $payment['currency']));
			$sheet->setCellValue('K'.$i, $payment['paytype']);
			$sheet->setCellValue('L'.$i, $payment['status']);
			$sheet->setCellValue('M'.$i, $payment['phone']);
			
			$i++;
		}
	}
	
	$groups = [ 'boat', 'track' ];
	
	foreach($groups as $group)
	{
		$total1 = 'Всего: ';

		$j = 0; $max = count($report['total']['counts'][$group]);
		foreach($report['total']['counts'][$group] as $t1)
		{
			$total1 .= $t1['name'].' '.$t1['count'];
			$j++;
			
			if ($j != $max) $total1 .= ', ';
		}
		$sheet->setCellValue('A'.$i, $total1);
		$sheet->getStyle('A'.$i)->getFont()->setBold(true);
		
		$sheet->setCellValue('G'.$i, prices_format($report['total']['contract'][$group]));
		$sheet->getStyle('G'.$i)->getFont()->setBold(true);
		
		$sheet->setCellValue('H'.$i, prices_format($report['total']['summ'][$group]));
		$sheet->getStyle('H'.$i)->getFont()->setBold(true);
		
		$sheet->setCellValue('J'.$i, prices_format($report['total']['discount'][$group]));
		$sheet->getStyle('J'.$i)->getFont()->setBold(true);
		
		$i++;
		
		foreach($report['total']['paytypes'][$group] as $p1)
		{
			$sheet->setCellValue('A'.$i, $p1['name'] == '' ? 'Не указано:' : $p1['name'].':');
			$sheet->setCellValue('H'.$i, prices_format($p1['summ']));
			$i++;
		}
		
	}	
}

$u = _main_::fetchModule('users');
$u->check(['admin', 'rop']);

// Читаем и выводим всестраничные данные до начала всех работ.
_main_::depend('configs');
_main_::depend('sql');
_main_::depend('texts');
_main_::depend('merges');
_main_::depend('types_class');
_main_::depend('filters_class');
_main_::depend('_specific_/fetches');
fetch_every_page_content();

$filters_fields["client"] = new TextField("client", '');


$filters_fields["time_from"]=new DateField("time_from", '');
$filters_fields["time_from"]->title="Месяц с";
$filters_fields["time_from"]->value = date("m.Y", mktime(0, 0, 0, date("m")-1, 1, date("Y")));
$filters_fields["time_from"]->format = 'MM.YYYY';
//$filters_fields["time"]->submit = 1;

$filters_fields["time_to"]=new DateField("time_to", '');
$filters_fields["time_to"]->title="Месяц по";
$filters_fields["time_to"]->value = date("m.Y", mktime(0, 0, 0, date("m")-1, 1, date("Y")));
$filters_fields["time_to"]->format = 'MM.YYYY';
//$filters_fields["time"]->submit = 1;

/*
$filters_fields["from"] = new DateField("from", date('Y-m-d', mktime(0, 0, 0, date("m")-1, 1, date("Y"))));
$filters_fields["from"]->title = "с";

$filters_fields["to"] = new DateField("to", date('Y-m-d', mktime(0, 0, 0, date("m"), 0, date("Y"))));
$filters_fields["to"]->title = "по";
*/

$filters = new Filters($filters_fields);

$filters_data = $filters->get_filters();

$m = _main_::fetchModule('payment');

if ($filters_data["time_from"] == $filters_data["time_to"])
{
	$many_months = false;
	list($month, $year) = explode('.', $filters_data['time_from']);
	
	$from	= date('Y-m-d', mktime(0, 0, 0, $month, 1, $year));
	$to		= date('Y-m-d', mktime(0, 0, 0, $month+1, 1, $year));
	
	$report['m-'.$month.'-'.$year] = $m->sales_report($from, $to);
}
else
{
	$many_months = true;
	list($month_from, $year_from) = explode('.', $filters_data['time_from']);
	list($month_to, $year_to) = explode('.', $filters_data['time_to']);
	
	if ($year_from.$month_from > $year_to.$month_to)
	{
		$report = [];
	}
	else
	{
		$i = 0;
		
		do
		{
			$from	= mktime(0, 0, 0, $month_from+$i, 1, $year_from);
			$to	= mktime(0, 0, 0, $month_from+$i+1, 1, $year_from);
			
			$month	= date('m', $from);
			$year	= date('Y', $to);
			
			$from	= date('Y-m-d', $from);
			$to		= date('Y-m-d', $to);
			
			$report['m-'.$month.'-'.$year] = $m->sales_report($from, $to);
			
			$i++;
		}
		while($year.$month < $year_to.$month_to);
		
		$from	= date('Y-m-d', mktime(0, 0, 0, $month_from, 1, $year_from));
		$to		= date('Y-m-d', mktime(0, 0, 0, $month_to+1, 1, $year_to));
		$total_report = $m->sales_report($from, $to);
		$total_models = $m->sales_models($from, $to);
	}
}

if ($_GET['export'] == 1)
{
	require_once '../../.internals/functions/_external_/excel/vendor/autoload.php';
	$locale = 'ru';
	$validLocale = \PhpOffice\PhpSpreadsheet\Settings::setLocale($locale);
	
	$spreadsheet = new \PhpOffice\PhpSpreadsheet\Spreadsheet();

	setlocale( LC_TIME, 'ru_RU.UTF-8', 'russian' );
	
	$sheet = $spreadsheet->getActiveSheet();
	$sheet->setTitle('Отчет по продажам');
	
	$sheet->setCellValue('A1', 'Дата');
	$sheet->setCellValue('B1', 'Модель');
	$sheet->setCellValue('C1', 'Тип');
	$sheet->setCellValue('D1', 'Клиент');
	$sheet->setCellValue('E1', 'Менеджер');
	$sheet->setCellValue('F1', 'Регион');
	$sheet->setCellValue('G1', 'Сумма контракта');
	$sheet->setCellValue('H1', 'Сумма оплаченных');
	$sheet->setCellValue('I1', 'Остаток по контракту');
	$sheet->setCellValue('J1', 'Скидка');
	$sheet->setCellValue('K1', 'Способ оплаты');
	$sheet->setCellValue('L1', 'Закрытие оплаты');
	$sheet->setCellValue('M1', 'Телефон');
	
	$sheet->getColumnDimension('A')->setAutoSize(true);
	$sheet->getColumnDimension('B')->setAutoSize(true);
	$sheet->getColumnDimension('C')->setAutoSize(true);
	#$sheet->getColumnDimension('D')->setAutoSize(true);
	$sheet->getColumnDimension('E')->setAutoSize(true);
	$sheet->getColumnDimension('F')->setAutoSize(true);
	$sheet->getColumnDimension('G')->setAutoSize(true);
	$sheet->getColumnDimension('H')->setAutoSize(true);
	$sheet->getColumnDimension('I')->setAutoSize(true);
	$sheet->getColumnDimension('J')->setAutoSize(true);
	$sheet->getColumnDimension('K')->setAutoSize(true);
	$sheet->getColumnDimension('L')->setAutoSize(true);
	$sheet->getColumnDimension('M')->setAutoSize(true);
	
	$sheet->getStyle('A1:M1')->getFont()->setBold(true);

	$i = 2;
	
	foreach($report as $mn => $rep)
	{
		$i++;
		list($m, $month, $year) = explode('-', $mn);
		$sheet->setCellValue('A'.$i, strftime('%B', strtotime($year.'-'.$month.'-01')).' '.strftime('%Y', strtotime($year.'-'.$month.'-01')));
		$sheet->getStyle('A'.$i)->getFont()->setBold(true);
		$i++;
		export_month($rep, $sheet, $spreadsheet, $i);
	}
	
	if ($many_months)
	{
		$i+=2;
		
		$groups = [ 'boat', 'track' ];
		
		foreach($groups as $group)
		{
			$total1 = 'Всего: ';

			$j = 0; $max = count($total_report['total']['counts'][$group]);
			foreach($total_report['total']['counts'][$group] as $t1)
			{
				$total1 .= $t1['name'].' '.$t1['count'];
				$j++;
				
				if ($j != $max) $total1 .= ', ';
			}
			$sheet->setCellValue('A'.$i, $total1);
			$sheet->getStyle('A'.$i)->getFont()->setBold(true);
			
			$sheet->setCellValue('G'.$i, prices_format($total_report['total']['contract'][$group]));
			$sheet->getStyle('G'.$i)->getFont()->setBold(true);
			
			$sheet->setCellValue('H'.$i, prices_format($total_report['total']['summ'][$group]));
			$sheet->getStyle('H'.$i)->getFont()->setBold(true);
			
			$sheet->setCellValue('J'.$i, prices_format($total_report['total']['discount'][$group]));
			$sheet->getStyle('J'.$i)->getFont()->setBold(true);
			
			$i++;
			
			foreach($total_report['total']['paytypes'][$group] as $p1)
			{
				$sheet->setCellValue('A'.$i, $p1['name'] == '' ? 'Не указано:' : $p1['name'].':');
				$sheet->setCellValue('H'.$i, prices_format($p1['summ']));
				$i++;
			}
			
		}
		
		if (@$total_models['boat'])
		{
			foreach($groups as $group)
			{
				$i++;
				foreach($total_models[$group] as $model)
				{
					$sheet->setCellValue('A'.$i, $model['name']);
					$sheet->getStyle('A'.$i)->getFont()->setBold(true);
					
					$sheet->setCellValue('B'.$i, $model['count']);
					
					$i++;
				}
			}
		}
	}

	$styleArray = [
		'borders' => [
			'allBorders' => [
				'borderStyle' => \PhpOffice\PhpSpreadsheet\Style\Border::BORDER_THIN
			]
		]
	];
	
	$sheet ->getStyle('A1:M'.($i-1))->applyFromArray($styleArray);
	/*
	$sheet ->getStyle('A'.($i-2))->applyFromArray($styleArray);
	$sheet ->getStyle('G'.($i-2).':H'.($i-2))->applyFromArray($styleArray);
	$sheet ->getStyle('J'.($i-2))->applyFromArray($styleArray);
	$sheet ->getStyle('A'.($i-1))->applyFromArray($styleArray);
	$sheet ->getStyle('G'.($i-1).':H'.($i-1))->applyFromArray($styleArray);
	$sheet ->getStyle('J'.($i-1))->applyFromArray($styleArray);
	*/
	
	$sheet->getStyle('A1');
	
	$writer = new \PhpOffice\PhpSpreadsheet\Writer\Xlsx($spreadsheet);

	if ($many_months)
	{
		$filename = 'payments-'.$filters_data['time_from'].'-'.$filters_data['time_to'].'.xlsx';
	}
	else
	{
		$filename = 'payments-'.$filters_data['time_from'].'.xlsx';
	}

	// заставляем браузер показать окно сохранения файла
	header('Content-Description: File Transfer');
	header('Content-Type: application/vnd.ms-excel');
	header('Content-Disposition: attachment; filename='.$filename);
	header('Content-Transfer-Encoding: binary');
	header('Expires: 0');
	header('Cache-Control: must-revalidate');
	header('Pragma: public');

	$writer->save('php://output');
	die;
		#throw new exception_exit();
}

_main_::put2dom('filters', $filters->fields2dom());
_main_::put2dom('report', $report);
#debug($report);die;
?>
