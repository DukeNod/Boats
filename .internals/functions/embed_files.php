<?php

/*
Класс для хранения файлов в БД в таблице embed_files

id			- Primary Key
src_id		- ID объекта, к которому относится файл, например request.ID
src_type	- Тип объекта, к которому прикреплен файл, название сущности, например 'request'
doc_num		- Номер документа (т.е. прикрепленного файла), для данного ID объекта и данного типа
doc_mime	- MIME type объекта
doc_content	- Содержимое файла, типа TEXT
created_at	- дата/время создания
updated_at	- дата/время изменения

Подключение:
_main_::depend('embed_files');

Примеры использования:
== Загрузить сканы для формы, пример из modules.public/request/fields_ino.php

// Загрузить из БД сканы для APEC Business Travel Card
EmbedFiles::get_scans($scans['apecgroup'],$request['id'],'request','apec');

	,	'photo' => MakeField([
			'type' => 'MultiImgUpload'
		,	'name' => 'photo'
		,	'title' => 'Скан документа'
		//,	'required' => true
		,	'value' => @$scans['apecgroup']
		])

== Сохранить сканы из формы

	// Сохранить в БД сканы для APEC Business Travel Card
	if ($data['apecgroup']['active'])
	{
		EmbedFiles::save_scans($data['apecgroup']['photo'], $request['id'], 'request', 'apec');
	}


*/

class EmbedFiles
{

	// Добавление файла
    private static function insert_file_int($src_id, $src_type, $doc_type, $doc_num, $doc_mime, $doc_content)
	{
		$embed_file_id = _main_::query(null,"
			INSERT INTO `embed_files` (
				 `src_id`
				,`src_type`
				,`doc_type`
				,`doc_num`
				,`doc_mime`
				,`doc_content`
				,`created_at`
				,`updated_at`
			)
			VALUES ({02},{03},{04},{05},{06},{07},{08},{09})
		"
		,null
		,$src_id
		,$src_type
		,$doc_type
		,$doc_num
		,$doc_mime
		,$doc_content
		,date('Y-m-d H:i:s')
		,date('Y-m-d H:i:s')
		);

		return $embed_file_id;
	}

	// Удалить для заданного объекта все прикрепленные файлы определенного типа
	private static function delete_file_by_src_and_type($src_id, $src_type, $doc_type)
	{
		_main_::query(null,"
			DELETE FROM `embed_files` WHERE src_id = {01} AND src_type = {02} AND doc_type = {03}
		"
		,$src_id
		,$src_type
		,$doc_type
		);
	}

	// Удалить для заданных объектов все прикрепленные файлы - в связи с полным удалением объектов
	// Для использования в метод
	public static function delete_file_by_src($ids, $src_type)
	{
		_main_::query(null,"
			DELETE FROM `embed_files` WHERE src_id in {01} AND src_type = {02}
		"
		,$ids
		,$src_type
		);
	}

	// Взять из базы все файлы определенного типа для данного объекта 
	private static function select_file_by_src_and_type(&$dat, $src_id, $src_type, $doc_type)
	{
		$dat = _main_::query(null,"
			SELECT ef.*
			FROM `embed_files` AS ef
			WHERE ef.`src_id` = {01} AND ef.`src_type` = {02} AND ef.`doc_type` = {03}
			ORDER BY ef.`doc_num`
		"
		,$src_id
		,$src_type
		,$doc_type
		);
	}

	// Загрузить сканы для формы
	// 'photo' и 'value' - ключевые слова для контрола MultiImgUpload
	public static function get_scans(&$scans, $src_id, $src_type, $doc_type)
	{
		self::select_file_by_src_and_type($dat, $src_id, $src_type, $doc_type);

		$scans = [];
		$pic_count = 1;

		foreach($dat as &$v)
		{
			$scans['photo:'.$pic_count] = [ 'value' => $v['doc_content'] ]; 
			$pic_count = $pic_count + 1;
		}
	}

	// Загрузить сканы для карточки дела и для печати
	// 'photo' и 'img' - ключевые поля для XSLT - .xslt и print.xslt
	public static function get_scans_print(&$scans, $src_id, $src_type, $doc_type)
	{
		self::select_file_by_src_and_type($dat, $src_id, $src_type, $doc_type);

		$scans = [];
		$pic_count = 1;

		foreach($dat as &$v)
		{
			$scans['photo:'.$pic_count] = [ 'img' => $v['doc_content'] ]; 
			$pic_count = $pic_count + 1;
		}
	}

	// Сохранить сканы из формы
	// 'photo' и 'value' - ключевые слова для контрола MultiImgUpload
	public static function save_scans(&$scans, $src_id, $src_type, $doc_type)
	{
		self::delete_file_by_src_and_type($src_id, $src_type, $doc_type);
		
		$doc_num = 1;
		$doc_mime = 'image/jpeg';
		foreach($scans as $ff => $vv)
		{
			self::insert_file_int(
				$src_id, 
				$src_type, 
				$doc_type, 
				$doc_num, 
				$doc_mime, 
				$vv['value']
			);
			$doc_num = $doc_num + 1;
		}
	}

} // class EmbedFiles

?>