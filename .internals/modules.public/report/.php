<?php

$u = _main_::fetchModule('users');
$u->check('admin');

function money($sum, $cur)
{
	if (!$sum) return '';
	
	$ret = number_format($sum, 0, ',', ' ');
	
	switch($cur)
	{
		case 'usd': $ret = '$'.$ret; break;
		case 'euro': $ret .= '€'.$ret; break;
		default: $ret .= ' р.';
	}
	
	return $ret;
}

// Читаем и выводим всестраничные данные до начала всех работ.
_main_::depend('configs');
_main_::depend('sql');
_main_::depend('types_class');
_main_::depend('filters_class');
_main_::depend('_specific_/fetches');
fetch_every_page_content();

$filters_fields["client"] = new TextField("client", '');

$filters_fields["time_from"]=new DateField("time_from", '');
$filters_fields["time_from"]->title="с";
$filters_fields["time_from"]->value = date("d.m.Y", mktime(0, 0, 0, date("m")+1, 1, date("Y")));

$filters_fields["time_to"]=new DateField("time_to", '');
$filters_fields["time_to"]->title="по";
$filters_fields["time_to"]->value = date("d.m.Y", mktime(0, 0, 0, date("m")+2, 0, date("Y")));

$filters = new Filters($filters_fields);

$filters_data = $filters->get_filters();

/*
if(!@$filters_data["time_to"])
{
	$filters->filters_data["time_to"]=date("d.m.Y", mktime(0, 0, 0, date("m")+2, 0, date("Y")));
}
else $time_to=strtotime($filters_data["time_to"]); // конечное время из фильтра

if(!@$filters_data["time_from"])// начальное время
{
	$filters->filters_data["time_from"]=date("d.m.Y", mktime(0, 0, 0, date("m")+1, 1, date("Y")));
}
else $time_from=strtotime($filters_data["time_from"]); // начальное время из фильтра
*/

$m = _main_::fetchModule('payment');

$report = $m->report($filters_data);

if ($_GET['export'] == 1)
{
	require_once '../../.internals/functions/_external_/excel/vendor/autoload.php';
	$locale = 'ru';
	$validLocale = \PhpOffice\PhpSpreadsheet\Settings::setLocale($locale);
	
	$spreadsheet = new \PhpOffice\PhpSpreadsheet\Spreadsheet();

	$sheet = $spreadsheet->getActiveSheet();
	$sheet->setTitle($filters_data['client'] == 'all' ? 'Все договоровы' : 'Активные договоровы');
	
	$sheet->setCellValue('A1', 'Клиент');
	$sheet->setCellValue('B1', 'Сумма запланированных неоплаченных');
	$sheet->setCellValue('C1', 'Сумма поступивших');
	
	$sheet->getColumnDimension('A')->setAutoSize(true);
	$sheet->getColumnDimension('B')->setAutoSize(true);
	$sheet->getColumnDimension('C')->setAutoSize(true);
	
	$sheet->getStyle('A1:C1')->getFont()->setBold(true);

	
	$sheet->setCellValue('A2', 'Всего за период');
	$sheet->getStyle('A2')->getFont()->setBold(true);
	
	$wait_pays = '';
	foreach($report['wait_pays'] as $f => $v) $wait_pays .= money($v, $f).' ';
	$sheet->setCellValue('B2', trim($wait_pays));
	
	$have_pays = '';
	foreach($report['have_pays'] as $f => $v) $have_pays .= money($v, $f).' ';
	$sheet->setCellValue('C2', trim($have_pays));
	
	$i = 3;
	foreach($report['data'] as $f => $v)
	{
		$sheet->setCellValue('A'.$i, $v['client']);
		$sheet->getCell('A'.$i)->getHyperlink()->setUrl(_config_::$dom_info['pub_site']."payment/{$v['id']}/");
		$sheet->getStyle('A'.$i)->getFont()->getColor()->setARGB('FF1976D2');
		
		$sheet->setCellValue('B'.$i, money($v['wait_pays'], $v['currency']));
		$sheet->setCellValue('C'.$i, money($v['have_pays'], $v['currency']));
		$i++;
	}
	
	$writer = new \PhpOffice\PhpSpreadsheet\Writer\Xlsx($spreadsheet);
	
	$filename = 'report-'.($filters_data['client'] == 'all' ? '-all-' : '').date('d.m.Y', strtotime($filters_data['time_from'])).'-'.date('d.m.Y', strtotime($filters_data['time_to'])).'.xlsx';
	
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
?>
