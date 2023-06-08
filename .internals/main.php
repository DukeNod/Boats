<?php
// Ядро системы main.php
// Версия 1.2.1 (починен If-Modified-Since)
ob_start();
####################################################################################################
####################################################################################################
####################################################################################################
#
class exception_depend		extends exception {}
class exception_xml		extends exception {}
class exception_db		extends exception {}
class exception_db_unique	extends exception_db {}
class exception_bl_finish	extends exception {}
#
class exception_bl		extends exception
{
	protected $id;
	protected $type;
	public function __construct ($message, $id = null, $type = null)
	{
		$encoding = mb_strtolower(mb_detect_encoding($message));
        if ($encoding !== 'utf-8')
        	$conv = iconv($encoding, 'utf-8', $message);
        else
        	$conv = $message;

		parent::__construct($conv);

		/*		
		$ret = '';
		$ar = debug_backtrace();
		for($i=count($ar)-1;$i>=1;$i--){
			$ret.="in <strong>".$ar[$i]['file']."</strong> at line <strong>".$ar[$i]['line']."</strong> ".(isset($ar[$i]['class'])?$ar[$i]['class']:"").(isset($ar[$i]['type'])?$ar[$i]['type']:"").$ar[$i]['function']."()<br>";
		}
		$conv .= "\n".$ret."\n\n";
		
		error_log($conv, 3, '../../debug.log');
		*/
		
		$this->id   = $id  ;
		$this->type = $type;
	}
	public function getId   () { return $this->id  ; }
	public function getType () { return $this->type; }
}
#
class exception_bl_privilege	extends exception_bl {}
class exception_bl_session	extends exception_bl {}
class exception_bl_system	extends exception_bl {}
class exception_bl_fatal	extends exception_bl {}
class exception_bl_data		extends exception_bl {}
class exception_bl_value	extends exception_bl_data {}
class exception_bl_field	extends exception_bl_data {}
class exception_bl_login	extends exception_bl_data {}
#
class exception_exit		extends exception {}
class exception_abort		extends exception {}
class exception_no_content	extends exception {}
#
####################################################################################################
####################################################################################################
####################################################################################################
#
class _main_
{
#
####################################################################################################
#
protected static $db = null;
protected static $db_add = null;
#
public static $document    = null;
public static $affected_rows = null;
#
protected static $module_file = null;
public static $module_xslt = null;
#
protected static $pathinfo    = null;
protected static $pathargs    = null;
protected static $xpath	      = null;
protected static $timer	      = null;
#
####################################################################################################
####################################################################################################
####################################################################################################
#
public static function identify_visitor ()
{
	// Задаём имя класса, который будем искать для идентификации.
	// Пока что один фиксированный. В теории потом может быть несколько.
	$classname = '_identify_';

	// Проверяем что такой класс есть. Если его нет, то даже и не выводим в DOM
	// никакую информацию об идентификации, ибо её и не предусмотрено.
	if (class_exists($classname))
	{
		// Вызываем основную функцию идентификации и получаем хеш полей или null.
		$info = call_user_func(array($classname, 'identify'));

		// Выводим полученную информацию в DOM в нужной структуре.
		$dom = array('@source'=>$classname);
		if (($info === null) || !count($info))
			$dom['anonymous'] = null ;
		else
		{
			$dom['consumer' ] = $info;
		}
		
		$old_identity = self::$xpath->evaluate('/*/identity');
		if ($old_identity->length > 0) self::$document->documentElement->removeChild($old_identity->item(0));
		self::$document->documentElement->appendChild(_main_::dom(self::$document, 'identity', $dom));
	}
}
#
####################################################################################################
#
protected static function identify_language (&$pathinfo)
{
	// Определяем язык работы с сайтом.
	// И убираем указание языка из $pathargs, если оно там есть

	$pathargs = explode('/',$pathinfo);
	if ($pathargs)
		foreach ($pathargs as $f=>&$v)
			if (!strlen(trim($v))) unset($pathargs[$f]);

        reset($pathargs);
	$from_patharg = false;

	define('LANG', 'ru');
	define('LANG_ID', 1);
			
	if (!defined('LANG'))
	{
		$l = null;

	        if(isset($_SESSION['admin']) && $_SESSION['admin'] == 1 && current($pathargs) == 'news')
	        {
	        	$l = 1;
	        }
	        elseif (isset($_GET['lang']))
	        {
	        	$l=$_GET['lang'];
	        }
	        elseif(isset($_SESSION['admin']) && $_SESSION['admin'] == 1 && isset($_COOKIE['LANG']) && $_COOKIE['LANG'])
	        {
	        	 $l = $_COOKIE['LANG'];
	        }else
	        {
                reset($pathargs);
			$l = $pathargs ? current($pathargs) : null;
			$from_patharg = true;
	        }

		if ($l!==null)
		{
			$dat=_main_::query('lang',"
				select *
				from langs
				where code = {1}
			",$l);

			if ($dat)
			{
				$dat=array_shift($dat);
				define('LANG', $dat['code']);
				define('LANG_ID', $dat['id']); //
				if ($from_patharg) array_shift($pathargs);
				if ($_SESSION['admin'] == 1)
					setcookie("LANG", $dat['code'], time()+10*365*24*60*60, _config_::$dom_info['adm_root'], "");
			}
		}

		if (!defined('LANG'))
		{
			define('LANG', 'ru');
			define('LANG_ID', 1);
		}

		_config_::$lang_id = LANG_ID;

		$dom = array();
		$dom[null] = LANG;

		$pathinfo = implode("/", $pathargs) . (count($pathargs) ? '/' : '');
		$dom['@pathinfo'] = $pathinfo;
		$dom['@query'] = isset($_SERVER['QUERY_STRING']) && strlen($_SERVER['QUERY_STRING']) ? '?' . $_SERVER['QUERY_STRING'] : null;
		self::$document->documentElement->appendChild(_main_::dom(self::$document, 'language', $dom));

		$dat=_main_::query('lang',"
			select *
			from langs
		");
		
		self::put2dom("languages",$dat);
	}
}
#
####################################################################################################
#
public static function execute_module ($doc = null, $pathinfo = null, $pathargs = null)
{
	if (self::$module_file !== null)
	{
		// Задаём контекст выполнения (определяем переменные в функции, потому как она и есть контекст).
		if ($doc      === null) $doc      = self::$document;
		if ($pathinfo === null) $pathinfo = self::$pathinfo;
		if ($pathargs === null) $pathargs = self::$pathargs;

		// Используем строго include без _once, так как допустимо повторное использование файла,
		// если, например, этот файл ещё как-то где-то используется в скрипте.
		// Причём модуль работает в изолированном контексте функции, и глобальные переменные
		// достпны только через global/$GLOBALS, и случайное их изменение исключено.
		// Не используем require потому что это убёт скрипт (просто include выдаст warning,
		// но недозаполнит DOM нужными данными, и страница всё равно отработает). Тем не менее,
		// это маловажно, так как существование файла проверяется в процедуре его поиска.
		include(self::$module_file);
	} else
	{
		// Даже если модуль "unknown" не найден - то тогда выкидываем исключение.
		throw new exception_no_content("Module's file was not found. Nothing to do.");
	}
}
#
####################################################################################################
#
public static function apply_stylesheet ($raw = false)
{
	if ($raw || (self::$module_xslt === null))
	{
		// При отсутствии файла трансформации или если специально попрошено выдаём "сырой" XML.
		$resp_text = self::$document->saveXML();
	} else
	{
		// При наличии файла трансформации преобразуем с его помощью.
		$resp_text = self::transform_by_file(self::$document, self::$module_xslt);
	}

	return $resp_text;
}
#
####################################################################################################
#
public static function fetch_last_modified ()
{
	$str='';
	$nodeList = self::$document->getElementsByTagName("last_modified");
	foreach ($nodeList as $v){
#		echo $v->nodeValue>$str;
		if ($v->nodeValue>$str) $str=$v->nodeValue;
	}
	if ((!$str)||($str=='0000-00-00 00:00:00')) {
		$time=time();
	}else{
		$time=strtotime($str);
	}
	header('Last-Modified: ' . gmdate('D, d M Y H:i:s', $time) . ' GMT');
	$headers = apache_request_headers();
	
	if (@$headers['If-Modified-Since'] && ($time < strtotime($headers['If-Modified-Since']))) {
    		header('HTTP/1.0 304 Not Modified');
		throw new exception_exit();
     }
}
#
####################################################################################################
####################################################################################################
#
private static         $depend_file = null;
private static function depend_load () { require_once(self::$depend_file); }
#
public static function depend ()
{
	static $files = array();

	$names = func_get_args();
	foreach ($names as $name)
	if (!isset($files[$name]))
	{
		if (preg_match("/^(.*)\/\/(.*)\$/", $name, $matches))
		{
			$pathinfo = $matches[1];
			$pathargs = null;
			$pathname = $matches[2];
		} else
		{
			$pathinfo = self::$pathinfo;
			$pathargs = self::$pathargs;
			$pathname = $name;
		}

		/*
		Полезно иметь в любой точке входа .function/. Но мы этим не пользуемся.

		$exts = array('/' . _config_::$depends_sub . '/' . $pathname . _config_::$depends_ext);
		self::$depend_file = self::set_module__find_file($pathinfo, $pathargs, _config_::$modules_dir, $exts, true);

		if (self::$depend_file === null)
		{
			self::$depend_file = _config_::$depends_dir . $name . _config_::$depends_ext;
			if (!file_exists(self::$depend_file)) self::$depend_file = null;
		}
		*/
		self::$depend_file = _config_::$depends_dir . $name . _config_::$depends_ext;
		if (!file_exists(self::$depend_file)) self::$depend_file = null;

		if (self::$depend_file === null) throw new exception_depend("Can not load file '{$name}'.");
		$files[$name] = self::$depend_file;
		self::depend_load();
	}
}
#
####################################################################################################
#
protected static function set_module__prepare_path (&$pathinfo, &$pathargs, $allow_dotted = false)
{
	// Склеиваем pathinfo & pathargs в единую строку, нормализуем её, и парсим снова,
	// всегда возвращая все элементы в pathinfo, и всегда пустой pathargs. Наполнение pathargs
	// элементами из pathinfo происходит чуть позже, при поиске файла. Здесь только парсинг.
	if (is_array($pathinfo)) $pathinfo = implode("/", $pathinfo);
	if (is_array($pathargs)) $pathargs = implode("/", $pathargs);
	$pathinfo = array_values(array_filter(
			explode('/', str_replace("\\", "/", $pathinfo . "/" . $pathargs)),
			create_function('$v', 'return ($v !== "")' .
				($allow_dotted ? '' : ' && ($v    !== "." )').
				($allow_dotted ? '' : ' && ($v    !== "..")').
				($allow_dotted ? '' : ' && ($v[0] !== "." )').
				';')));
	$pathargs = array();
}
#
####################################################################################################
#
protected static function set_module__find_file (&$pathinfo, &$pathargs, $dirs, $exts, $allow_dotted = false)
{
	// Если наборы каталогов и расширений ещё не заданы как массивы,
	// то мы делаем их массивами по нужной нам "методике" поиска.
	// "Нужная" методика заключается в том, что файл вида "/dir/module/.ext"
	// имеет приоритет над "/dir/module.ext", а сам каталог используется строго один.
	if (!is_array($dirs)) $dirs = array(             $dirs);
	if (!is_array($exts)) $exts = array('/' . $exts, $exts);

	// Пересобираем (склеиваем и парсерим) путь и аргументы к модулю заново.
	// Причём пересобранные значения возвращаются назад (потому как переданы by reference).
	self::set_module__prepare_path($pathinfo, $pathargs, $allow_dotted);

	// Ищем подходящий файл, наиболее глубоко вложенный в иерархию папок (начинаем с глубины и поднимаемся наверх).
	do
	{
		// Формируем имя модуля (без путей и расширений). Если что-то есть в pathinfo, то это
		// и будет именем модуля. А если там ничего нет, то ориентируемся на то, что мы ранее
		// что-то оттуда перенесли в аргументы; и если переносили, то считаем что запрошен
		// несуществующий модуль; а если и там и там изначально было пусто, то считаем что
		// запрошен модуль приветствия.
		$filename = count($pathinfo) ? implode("/", $pathinfo) : null;

		// В цикле перебираем комбинации пути и расширения, находя первый существующий файл для модуля.
		// Если так станется, что какой-то массив пуст (путей или расширений), то заранее задаём
		// дефолтные значения о ненайденном файле.
		$filepath = null;
		$exists = false;
		foreach ($dirs as $dir)
		foreach ($exts as $ext)
		if (!$exists)// После того, как файл был найден, уже не проверяем другие файлы. По-хорошему бы break на два уровня вверх, но нету такого в языке.
		{
			$filepath = $dir . $filename . $ext;
			$exists = is_file($filepath);
		}

		// Если файл был найден, либо если для дальнейшего поиска модуля нет больше составляющих имени,
		// то выходим из цикла. В противном случае перекидываем правую часть пути в аргументы, и ищем дальше.
		if ($exists || !count($pathinfo)) break;// Выход из цикла только тут!
		if (count($pathinfo)) array_unshift($pathargs, array_pop($pathinfo));
	}
	while (true);// Якобы вечный цикл. Выход только по break по условию (см. выше).

	// Возвращаем информацию о найденном имени файла (либо null, если он не был найден).
	return $exists ? $filepath : null;
}
#
####################################################################################################
#
public static function set_module_file ($pathinfo, $pathargs = null)
{
	self::$module_file = self::set_module__find_file($pathinfo, $pathargs, _config_::$modules_dir, _config_::$modules_file_ext);
	self::$pathinfo = $pathinfo;
	self::$pathargs = $pathargs;
}
#
####################################################################################################
#
public static function set_module_xslt ($pathinfo, $pathargs = null)
{
	self::$module_xslt = self::set_module__find_file($pathinfo, $pathargs, _config_::$modules_dir, _config_::$modules_xslt_ext);
}
#
####################################################################################################
#
public static function transform_by_file ($document, $xslt_file)
{
	// Создаём документ для таблицы преобразования и читаем его из файла.
	$xslt_document = new DOMDocument();
	$xslt_document->validateOnParse = false;
	$xslt_document->substituteEntities = true;

	//
	$xmlerrors = libxml_use_internal_errors(true);
	libxml_clear_errors();
	$loaded = $xslt_document->load($xslt_file, LIBXML_NOCDATA);
	$xmlerror = libxml_get_last_error();
	libxml_use_internal_errors($xmlerrors);
	if (!$loaded) throw new exception_xml($xmlerror->message);

	// Создаём XSLT-процессор и импортируем в него прочитанную таблицу преобразований.
	$xslt_processor = new XSLTProcessor();
	$xslt_processor->registerPHPFunctions();
	$xslt_processor->importStyleSheet($xslt_document);

	//
	$resp_text = $xslt_processor->transformToXML($document);
	return $resp_text;
}
#
####################################################################################################
#
public static $cache_mode = null;
public static $cache_time = null;
#
public static function cache_mode ($mode)
{
	if ($mode == 'nostore') { if (in_array(self::$cache_mode, array('', 'public', 'private', 'nocache'))) self::$cache_mode = $mode; } else
	if ($mode == 'nocache') { if (in_array(self::$cache_mode, array('', 'public', 'private'           ))) self::$cache_mode = $mode; } else
	if ($mode == 'private') { if (in_array(self::$cache_mode, array('', 'public'                      ))) self::$cache_mode = $mode; } else
	if ($mode == 'public' ) { if (in_array(self::$cache_mode, array('',                               ))) self::$cache_mode = $mode; } else
	if ($mode == ''       ) { self::$cache_mode= $mode; } else
	throw new exception("Unsupported value for cache mode ('{$mode}').");
}
#
public static function cache_time ($time)
{
	// "<=" чтобы можно было заменять null на 0, но ">" чтобы отличать что время устаревания задано.
	// Duke: Ваще не понял такое условие. Закоментил.
	#if ((self::$cache_time > 0) || ($time <= self::$cache_time))
	if ((!self::$cache_time) || (self::$cache_time > 0) && ($time <= self::$cache_time))
		self::$cache_time = $time;
}
#
####################################################################################################
####################################################################################################
####################################################################################################
#
public static function connection ($key = false, $force = false)
{
	if (!$key) $key = '_default_';
	
	if ($key == '_default_')
	{
		$server_port = _config_::$db_server . (_config_::$db_port == '' ? '' : ':' . _config_::$db_port);
		$username = _config_::$db_username;
		$password = _config_::$db_password;
		$database = _config_::$db_database;
		$type = 'mysql';
	}
	else
	{
		$server_port = _config_::$db_add[$key]['server'] . (_config_::$db_add[$key]['port'] == '' ? '' : ':' . _config_::$db_add[$key]['port']);
		$username = _config_::$db_add[$key]['username'];
		$password = _config_::$db_add[$key]['password'];
		$database = _config_::$db_add[$key]['database'];
		$type = _config_::$db_add[$key]['type'];
	}

	// Если подключение уже есть, то его и возвращаем.
	if ((!$force) && isset(self::$db_add[$key]) && (self::$db_add[$key] !== null))
	{
		if ($type == 'mysql')
		{
			// Если несколко БД на одном сервере, надо между ними каждый раз переключаться, т.к. соединение одно на всех.
			mysqli_select_db(self::$db_add[$key], $database);
			if (mysqli_errno(self::$db_add[$key])) throw new exception_db("Can not select database: " . mysqli_error(self::$db_add[$key]), mysqli_errno(self::$db_add[$key]));
		}
		return self::$db_add[$key];
	}
	
	switch($type)
	{
		case 'mysql':
			self::$db_add[$key] = self::connection_mysql($server_port, $username, $password, $database);
			break;
			
		case 'psql':
			self::$db_add[$key] = self::connection_psql($server_port, $username, $password, $database);
			break;
			
		default: throw new exception_db("Unknown DB type");
	}

    return self::$db_add[$key];
}
#
public static function connection_mysql ($server_port, $username, $password, $database)
{
	// А если подключения ещё нет, то соединяемся, настраиваем подключение,
	// запоминаем его для будущих вызовов, и возвращаем.
	// Запоминаем мы её именно здесь, чтобы в случае ошибки в командах настройки,
	// скрипту было что закрывать когда он выйдет после обработки ошибок.
	$db = mysqli_connect($server_port, $username, $password);
	if (mysqli_errno($db)) throw new exception_db("Can not connect to database: " . mysqli_error($db), mysqli_errno($db));

	/*	
	self::$db = $db = (isset(_config_::$db_persistent) && _config_::$db_persistent) ?
		mysqli_pconnect(_config_::$db_server . (_config_::$db_port == '' ? '' : ':' . _config_::$db_port), _config_::$db_username, _config_::$db_password):
		mysqli_connect (_config_::$db_server . (_config_::$db_port == '' ? '' : ':' . _config_::$db_port), _config_::$db_username, _config_::$db_password);
	if (mysqli_errno($db)) throw new exception_db("Can not connect to database: " . mysqli_error($db), mysqli_errno($db));
	*/

	// Выбор базы.
	mysqli_select_db($db, $database);
	if (mysqli_errno($db)) throw new exception_db("Can not select database: " . mysqli_error($db), mysqli_errno($db));

	// Кодировку используем уникодную, так как вся система DOM и так работает в ней.
	mysqli_query($db, "set names utf8");
	if (mysqli_errno($db)) throw new exception_db("Can not set connection charset: " . mysqli_error($db), mysqli_errno($db));

	// Начинаем транзакцию.
	//self::query_add(null, "start transaction /* automatically on query */");

	//
	return $db;
}

public static function connection_psql ($server_port, $username, $password, $database)
{
	return pg_connect('host='.$server_port.' dbname='.$database.' user='.$username.' password='.$password);
}
#
####################################################################################################
#
// ToDo: Допилить диссконнект, хотя он и не используется
public static function disconnect ()
{
	// Отключаемся, не выполняя никакие commit/rollback'и (отдаём на откуп php-extension'у).
	// А идентификатор соединения затираем, чтобы в других местах виделось что мы отключились.
	/*
	if (!is_null(self::$db))
		pg_close(self::$db);
	*/
	if (!is_null(self::$db))
		mysqli_close(self::$db);

	self::$db = null;
}

public static function disconnect_add ($key)
{
    // Отключаемся, не выполняя никакие commit/rollback'и (отдаём на откуп php-extension'у).
    // А идентификатор соединения затираем, чтобы в других местах виделось что мы отключились.
    if (!is_null(self::$db_add))
        pg_close(self::$db_add);
    self::$db_add = null;
}
#
####################################################################################################
#
public static function sql_quote ($value)
{
	if (is_null   ($value)) return 'null'; else
	if (is_bool   ($value)) return $value ? 'true' : 'false'; else
	if (is_integer($value)) return (integer) $value; else
	if (is_float  ($value)) return (float  ) $value; else
	//if (is_scalar ($value)) return "'" . pg_escape_string(self::connection(), $value) . "'"; else
	if (is_scalar ($value)) return "'" . mysqli_escape_string(self::connection(), $value) . "'"; else
	if (is_array  ($value)) return count($value) ? "(" . implode(",", array_map(array(__CLASS__, __METHOD__), $value)) . ")" : "(null)"; else
	throw new exception_db("Cannot SQL-quote value of unsupported type.");
}
#
####################################################################################################
#
public static function sql_field ($string)
{
	return "`" . str_replace("`", "``", $string) . "`";
}
#
####################################################################################################
#
public static $queries = array();
#
public static $query_quote_args = null;
#
public static function query_quote_callback ($matches)
{
	$index = $matches[1];
	$index = ((integer) $index) - 1;
	return array_key_exists($index, self::$query_quote_args) ? self::sql_quote(self::$query_quote_args[$index]) : null;
}
#
public static function query (/* nb: var arg list inside */)
{
	$args  = func_get_args();
	array_unshift($args, '_default_');
	return call_user_func_array(array(__CLASS__, 'query_add'), $args);
}
public static function query_add (/* nb: var arg list inside */)
{
	$args  = func_get_args();
	$key  = $args[0];
	
	
	if (!$key) $key = '_default_';
	
	if ($key == '_default_')
	{
		$type = 'mysql';
	}
	else
	{
		$type = _config_::$db_add[$key]['type'];
	}
	
	$db = self::connection($key);
	
	switch($type)
	{
		case 'mysql':
			return call_user_func_array(array(__CLASS__, 'query_mysql'), $args);
			break;
			
		case 'psql':
			return call_user_func_array(array(__CLASS__, 'query_psql'), $args);
			break;
			
		default: throw new exception_db("Unknown DB connection");
	}
}
#
public static function query_mysql (/* nb: var arg list inside */)
{
	// Берём аргументы и вычленяем оттуда два важных (режимы работы и сам запрос).
	$args  = func_get_args();
	$key  = array_shift($args);
	$mode  = array_shift($args);
	$query = array_shift($args);

	// Обязательно подключаемся перед выполнением. К тому же оно нужно для escape'инга значений.
	$db = self::connection($key);

	// Escape'им значения и подставляем их в запрос, запоминаем запрос для будущего дампа.
	self::$query_quote_args = $args;
	$query = preg_replace_callback("/\\{([0-9]+?)\\}/si", array('self', 'query_quote_callback'), $query);
	self::$query_quote_args = null;
	if (defined('_DEBUG_') && _DEBUG_) self::$queries[] = $query;

	// Выполняем запрос. Отлавливаем ошибки и при их появлении выкидываем exception.
	for($ind=0; $ind<2; $ind++)
	{
		$res = mysqli_query($db, $query);
		if ($res === false)
			if (mysqli_errno($db) == 1062)// Unique key violation
				throw new exception_db_unique("Error in query ({$query}): " . mysqli_error($db), mysqli_errno($db));
			elseif (mysqli_errno($db) == 2006) // Error lost connection
			{
				mysqli_close($db);
				$db = self::connection($key, true);
				continue;
			}
			else	throw new exception_db       ("Error in query ({$query}): " . mysqli_error($db) . " Code: " . mysqli_errno($db), mysqli_errno($db));
		break;
	}

	// Для успешно выполненных командных запросов (INSERT, UPDATE, etc) пытаемся вернуть last insert id.
	// Если last insert id не определён (если запрос не-INSERT), то просто возвращаем null.
    self::$affected_rows = mysqli_affected_rows($db);
	if ($res === true) return ($id = mysqli_insert_id($db)) ? $id : null;

	// Подготавливаем заготовки для формирования ключа строки в итоговом массиве.
	// Для этого парсерим режим (mode): составляющие через двоеточие; первая составляющая - вечно неизменная строка;
	// остальные составляющие - либо имя поля из данных, либо пустота для последовательной нумерации. Если задана
	// только одна составляющая (неизменная строка), то обязательно добавляем последовательную нумерацию.
	// Так или иначе, какой-то изменяемый суффикс после неизменной строки есть обязательно.
	// А вот неизменная строка может быть и пустой.
	$keyfields = explode(":", $mode);
	$keyprefix = array_shift($keyfields);
	if (empty($keyfields)) $keyfields[] = null;

	// Для успешно выполненных запросов с результирующими данными (SELECT, SHOW, etc),
	// добываем эти данные в таблицу и возвращаем. Следовательно, не использовать эту процедуру
	// для запросов, которые возвращают дофига данных, которые не влезут в память все сразу.
	// При этом ключ для строки таблицы в массиве формируем так, чтобы он был пригоден для
	// автоматической вставки в DOM-структуру (методом этого же класса) -- на основе режима работы (см. выше).
	$result = array();
	while (is_array($row = mysqli_fetch_array($res, MYSQLI_ASSOC)))
	{
		$key = ($keyprefix)?$keyprefix.":":"";
		foreach ($keyfields as $keyfield)
		$key = $key . ($keyfield != '' ? $row[$keyfield] : count($result));
		$result[$key] = $row;
	}

	// И после добычи всех данных освобождаем ресурс и возвращаем результат.
	mysqli_free_result($res);
	return $result;
}
//-----------------------------------------------------------------------------
public static function query_psql (/* nb: var arg list inside */)
{
    // Берём аргументы и вычленяем оттуда два важных (режимы работы и сам запрос).
    $args  = func_get_args();
	$key  = array_shift($args);
    $mode  = array_shift($args);
    $query = array_shift($args);

    // Обязательно подключаемся перед выполнением. К тому же оно нужно для escape'инга значений.
    $db = self::connection($key);

    // Escape'им значения и подставляем их в запрос, запоминаем запрос для будущего дампа.
    self::$query_quote_args = $args;
    $query = preg_replace_callback("/\\{([0-9]+?)\\}/si", array('self', 'query_quote_callback'), $query);
    self::$query_quote_args = null;
    if (_DEBUG_) self::$queries[] = $query;

    $query = str_replace('`', '', $query);

    $insert = stripos($query, 'insert') !== false ? true : false;

    // Выполняем запрос. Отлавливаем ошибки и при их появлении выкидываем exception.
    if ($insert)
        $res = pg_query($db, $query.' RETURNING id');
    else
        $res = pg_query($db, $query);

    if ($res === false)
    {
        $error = pg_last_error($db);

        if (strpos($error, 'duplicate key value') !== false)// Unique key violation
            throw new exception_db_unique("Error in query ({$query}): " . $error, 0);
        else
            throw new exception_db("Error in query ({$query}): " . $error, 0);
    }

    // Для успешно выполненных командных запросов (INSERT, UPDATE, etc) пытаемся вернуть last insert id.
    // Если last insert id не определён (если запрос не-INSERT), то просто возвращаем null.
    #if ($res === true) return null;
    self::$affected_rows = pg_affected_rows($res);

    // Подготавливаем заготовки для формирования ключа строки в итоговом массиве.
    // Для этого парсерим режим (mode): составляющие через двоеточие; первая составляющая - вечно неизменная строка;
    // остальные составляющие - либо имя поля из данных, либо пустота для последовательной нумерации. Если задана
    // только одна составляющая (неизменная строка), то обязательно добавляем последовательную нумерацию.
    // Так или иначе, какой-то изменяемый суффикс после неизменной строки есть обязательно.
    // А вот неизменная строка может быть и пустой.
    $keyfields = explode(":", $mode);
    $keyprefix = array_shift($keyfields);
    if (empty($keyfields)) $keyfields[] = null;

    // Для успешно выполненных запросов с результирующими данными (SELECT, SHOW, etc),
    // добываем эти данные в таблицу и возвращаем. Следовательно, не использовать эту процедуру
    // для запросов, которые возвращают дофига данных, которые не влезут в память все сразу.
    // При этом ключ для строки таблицы в массиве формируем так, чтобы он был пригоден для
    // автоматической вставки в DOM-структуру (методом этого же класса) -- на основе режима работы (см. выше).
    $result = array();
    while (is_array($row = pg_fetch_array($res, null, PGSQL_ASSOC)))
    {
        $key = ($keyprefix)?$keyprefix.":":"";
        foreach ($keyfields as $keyfield)
            $key = $key . ($keyfield != '' ? $row[$keyfield] : count($result));
        $result[$key] = $row;
    }

    // И после добычи всех данных освобождаем ресурс и возвращаем результат.
    pg_free_result($res);
	return $result;
}
#
####################################################################################################
#
public static function commit ($point = null)
{
	if (self::$db !== null)
		self::query(null, "commit"   . ($point === null ? "" : " /* {$point} */"));
}
#
####################################################################################################
#
public static function rollback ($point = null)
{
	if (self::$db !== null)
		self::query(null, "rollback" . ($point === null ? "" : " /* {$point} */"));
}
#
####################################################################################################
####################################################################################################
####################################################################################################
#
//???todo: старое имя для совместимости. со временем выжить его, и оставить только _main_::dom().
public static function dom_node_tree ($document, $element_name, $value)
{ return self::dom($document, $element_name, $value); }
#
public static function put2dom ($element_name, $value = null)
{
	return self::$document->documentElement->appendChild(self::dom(self::$document, $element_name, $value));
}
#
public static function dom ($document, $element_name, $value = null, $parse_date = true)
{
	if (is_array($value) || is_object($value))
	{
		if (($element_name === '') || ($element_name === null))
		{
			$element_name = 'data';
		}
		
		$result = $document->createElement($element_name);
		
		foreach ($value as $key => $val)
		if (($pos = strpos($key, ':')) === false)
		{
		try {
		    $result->appendChild(self::dom($document, $key, $val, $parse_date));
		  } catch (\Exception $e) {
		  }
		} else
		if ($pos > 0)
		{
			$key = substr($key, 0, $pos);
			$result->appendChild(self::dom($document, $key, $val, $parse_date));
		}
	} else
	if (is_scalar($value) || is_null($value))
	{
		if (($element_name === '') || ($element_name === null))
		{
			$result = $document->createTextNode($value);
		} else
		if ($element_name[0] === '@')
		{
			$result = $document->createAttribute(substr($element_name, 1));
			$result->appendChild($document->createTextNode($value));
		} else
		if ($parse_date && preg_match('/^(\\d{4})-(\\d{2})-(\\d{2}) \\s* (?: (?: \+|T)? (\\d{2}) (?: \\:(\\d{2}) (?: \\:(\\d{2}) (?: \\.(\\d+) )? )? )? )? (?: \+(\\d{2}) \:(\\d{2}) )? $/x', $value, $m2))
		{
			$result = $document->createDocumentFragment();

			$temp = $result->appendChild($document->createElement($element_name));
			$temp->appendChild($document->createTextNode($value));

			$temp = $result->appendChild($document->createElement($element_name . '_parsed'));
			if (isset($m2[1])) $temp->appendChild($document->createElement('year'    , $m2[1]));
			if (isset($m2[1])) $temp->appendChild($document->createElement('centyear', substr($m2[1], 2    )));
			if (isset($m2[1])) $temp->appendChild($document->createElement('century' , substr($m2[1], 0, -2)));
			if (isset($m2[2])) $temp->appendChild($document->createElement('month'   , $m2[2]));
			if (isset($m2[3])) $temp->appendChild($document->createElement('day'     , $m2[3]));
			if (isset($m2[4])) $temp->appendChild($document->createElement('hour'    , $m2[4]));
			if (isset($m2[5])) $temp->appendChild($document->createElement('minute'  , $m2[5]));
			if (isset($m2[6])) $temp->appendChild($document->createElement('second'  , $m2[6]));
		} else
		{
			$result = $document->createElement($element_name);
			if (is_bool($value))
			$result->appendChild($document->createTextNode($value ? '1' : '0'));
			else
			if (($value !== '') && ($value !== null))
			$result->appendChild($document->createTextNode($value));
		}
	} else
	{
		throw new exception("Unsupported type of value for DOM node.");
	}
	return $result;
}

public static function dom_query ($query)
{
	return self::$xpath->evaluate($query)->item(0)->nodeValue;
}
#
####################################################################################################
####################################################################################################
####################################################################################################
#
private static function _strip_magic_quotes_ ($value)
{
	$value = is_array($value) ? array_map(array('self', '_strip_magic_quotes_'), $value) : stripslashes($value);
	return $value;
}
private static function _normalize_back_urls_ ($url)
{
	// Эта функция решает такую задачу: надо убрать из URL'а вложенные urlencoded()-строки (типа %252F для слеша).
	// Причина в том, что на вложенном кодировании глючит ISA-server (его HTTP Filter), который выполняет роль прокси:
	// он параноидально deny'ит URL, поскольку видит что с одного прохода он его не декодировал полностью.

	// Вообще-то, двойное кодирование правильнее, конечно, а всё это -- баг ISA-прокси, но work-around, увы, делать нам.
	// Чтобы не лишаться функциональности по множественному возврату в исходные точки, мы сохраняем back'и,
	// разделяя из через double-colon (::). При этом из самих GET-параметров back'и как раз вырезаем (сама задача).
	// Чтобы всё это работало, только в admin.xslt мы изменить структуру redirect'а, чтоб он парсил эти double-colon'ы.

	// ВАЖНО, чтобы back_raw/curr_raw шли без этого кодирования, так как в "raw" мы помещаем ссылки для прямого
	// использования; а вот для передачи в GET-параметрах мы как раз и заводим "url" (back_url/curr_url).
	// Иными словами, не нужно навешивать эту функцию на "raw"; только на "url".

	$pos = strpos($url, '?');
	if ($pos === false) return $url;

	parse_str(substr($url, $pos + 1), $query);
	if (array_key_exists('back', $query))
	{
		$back = $query['back'];
		unset($query['back']);
	} else
	{
		$back = null;
	}
	
	return substr($url, 0, $pos) . (count($query) ? '?' . urldecode(http_build_query($query)) : '') . (strlen($back) ? '::' . $back : '');
}

private static function _normalize_back_urls_ajax_ ($url)
{
// Duke: удаляем ajax=1 из back_raw т.к. он ajax выдача бессымсленна при автоматическом возврате на предидущую страницу в admin.

	$pos = strpos($url, '?');
	if ($pos === false) return $url;

	parse_str(substr($url, $pos + 1), $query);
	unset($query['ajax']);

	return substr($url, 0, $pos) . (count($query) ? '?' . http_build_query($query) : '');
}

public static function _headers_()
{
		if (self::$cache_time)
		{
			self::fetch_last_modified ();
		}
		
		if (self::$cache_time !== null)
		{
			header(sprintf("Expires: %s", date(DATE_RFC1123, time() + self::$cache_time)));
			$maxage = sprintf("max-age=%d,", self::$cache_time);
		} else	$maxage = '';
		if (self::$cache_mode == 'nostore') { header("Cache-control: {$maxage}must-revalidate,no-store"); } else
		if (self::$cache_mode == 'nocache') { header("Cache-control: {$maxage}must-revalidate,no-cache"); } else
		if (self::$cache_mode == 'private') { header("Cache-control: {$maxage}must-revalidate,private" ); } else
		if (self::$cache_mode == 'public' ) { 
			header("Cache-control: {$maxage}must-revalidate,public"  ); 
			header('Pragma: public');

		} else
		if (self::$cache_time !== null    ) { header("Cache-control: {$maxage}must-revalidate"         ); }
}
#
public static function _work_ ()
{
	// Запоминаем время начала работы скрипта для последующего измерения времени работы.
	self::$timer = $ts_start = microtime(true);
	//PutTimer();

	// Основной функционал, общий для всех страниц и запросов.
	try
	{
		// Избавляемся от magic-quotes, если включены.
		if (get_magic_quotes_gpc())
		{
			$_GET    = self::_strip_magic_quotes_($_GET   );
			$_POST   = self::_strip_magic_quotes_($_POST  );
			$_COOKIE = self::_strip_magic_quotes_($_COOKIE);
		}

		// По спец-запросу включаем режимы отладки и замера времени, но только если они до сих пор
		// не включены/отключены принудительно. Для принудительного включения или отключения (запрета)
		// этих режимов, нужно определить соответствующие константы ещё до вызова ядра.
		if (!defined('_DEBUG_')) define('_DEBUG_', array_key_exists('DEBUG', $_COOKIE) || array_key_exists('DEBUG', $_POST) || array_key_exists('DEBUG', $_GET));
		if (!defined('_TIMER_')) define('_TIMER_', array_key_exists('TIMER', $_COOKIE) || array_key_exists('TIMER', $_POST) || array_key_exists('TIMER', $_GET));

		// Создаём документ для данных и записываем туда ключевые параметры запроса и среды выполнения,
		// но только те, которые нам актуальны для генерации страниц отлика.
		$system = array();
		$system['now'     ] = getdate(time()); $system['now']['epoch'] = $system['now'][0]; unset($system['now'][0], $system['now']['weekday'], $system['now']['month']);
		$system['info'    ] = isset(_config_::$dom_info) ? _config_::$dom_info : null;
		$system['curr_url'] = urlencode(self::_normalize_back_urls_(
		$system['curr_raw'] =
					(isset($_SERVER['REQUEST_URI' ]) ? $_SERVER['REQUEST_URI' ] :
					(null))));
		if ((strpos($system['curr_raw'],'?')===false)&&(substr($system['curr_raw'],-1,1)!=='/')) $system['curr_raw'].='/';

		$system['back_url'] = urlencode(self::_normalize_back_urls_(
		// Исправление неправильной переадресации здесь
		$system['back_raw'] = self::_normalize_back_urls_ajax_(
					preg_replace('/lang=\w{2}/sux', '', 
					((isset($_GET   ['back'        ])&&$_GET   ['back'        ]) ? $_GET   ['back'        ] :
					((isset($_POST  ['back'        ])&&$_POST  ['back'        ]) ? $_POST  ['back'        ] :
					(isset($_SERVER['HTTP_REFERER']) ? $_SERVER['HTTP_REFERER'] :
					(null))))))));

		$data_document = self::$document = new DOMDocument();
		$data_document->formatOutput = true;
		$data_document->encoding     = 'utf-8';
		$data_document->appendChild($data_document->createElement('response'));
		self::put2dom('system', $system);
		self::$xpath = new DOMXPath(self::$document);

		// Определяем что было запрошено и задаём это как модуль+преобразование по умолчанию.
		// Этот модуль в процессе выполнения может перенаправить выполнение на другой модуль
		// или переопределить используемую таблицу преобразований.
		$pathinfo = isset($_SERVER['PATH_INFO']) ? $_SERVER['PATH_INFO'] : null;

		// Убираем из пути указание языка
		self::identify_language($pathinfo);

		self::set_module_file($pathinfo);
		self::set_module_xslt($pathinfo);

		// Теперь мы подготовили среду выполнения, и можно выполнять основной код.
		// Для отлова ошибок идёт расчёт на исключения, причём очень желательно
		// чтобы эти исключения входили в список известных (или были унаследованы от них).
		try
		{
			// Коммиты стоят вокруг всех основных стадий кода на случай, когда
			// нужно сохранить изменения данных предыдущей стадии (опознание посетителя),
			// если произошла ошибка на следующей стадии (основной работы).
			// Актуально только если используются транзакционные таблицы (InnoDB);
			// в противном случае не имеет значение, и не влияют на производительность.
//???--			self::commit('A');//??? этот коммит бесполезен, так как до него ничего и не происходит
			self::identify_visitor();
//???--			self::commit('B');//??? этот коммит бесполезен, так как identify работает не всегда, а когда есть, то там в основном только select'ы.

			#$ts_end = microtime(true);printf("\ne: %.03fs", $ts_end - self::$timer);self::$timer = $ts_end;

			self::execute_module();
			self::commit('automatically after working');// Нужный и важный коммит, так как срабатывает после всех операций в случае их успеха.
		}
		// Бизнес-логика отработала правильна но нужен ранний выход из всех функций.
		catch (exception_bl_finish $exception)
		{
		}
		// Ошибка в бизнес-логике производит откат изменений той стадии,
		// в которой она возникла, и добавляет данные об ошибке в DOM.
		// При этом перевброса ошибки не производится, то есть считается
		// что ошибка в бизнес-логике -- часть корректного отклика.
		catch (exception_bl $exception)
		{
			if(isset($GLOBALS['api']) && $GLOBALS['api'] == 1)
			{
				header("HTTP/1.0 404 Not Found");
				self::returnError(array(
						'id'   => $exception->getId(),
						'type' => $exception->getType(),
						'text' => $exception->getMessage())
				);
			}
			else
			{
				self::rollback('on business-logic exception');
				$data_document->documentElement->appendChild(
					self::dom($data_document, 'exception', array(
						'id'   => $exception->getId(),
						'type' => $exception->getType(),
						'text' => $exception->getMessage())));
				if ($exception->getType()=='absent') {
					self::set_module_file("/404/");
					self::set_module_xslt("/404/");
					self::execute_module();
				}
			}
		}

		// Выводим нужные заголовки (которые определяются алгоритмами страницы),
		// и выводим текст отклика. При этом накопленный буфер вывода (ошибки, дампы)
		// запоминаем для вывода в отладочной секции, при этом не портя навешанные
		// обработчики буферов (gzip/deflate, session id injecter, и т.п.).
		// NOTA BENE:
		// Не использовать ob_get_clean() -- оно сбрасывает один уровень буфера.
		self::_headers_();
		#$ts_end = microtime(true);printf("\ne: %.03fs", $ts_end - self::$timer);self::$timer = $ts_end;
		$result = self::apply_stylesheet();
		$buffers = ob_get_contents(); ob_clean();
		print $result;

		// В отладочном режиме выводим дамп полученного документа в чистом виде (только добавив параметры среды
		// выполнения запроса), а также отладочные дампы и ошибки кода (тут главное чтобы после основного текста).
		if (_DEBUG_)
		{
			printf("<!--CONTENT-ENDS-HERE-->");
			$raw_xml = htmlspecialchars(self::apply_stylesheet(true));
			$queries = implode('', array_map(create_function('$v', 'return $v . ";\n";'), self::$queries));
		ob_start();

			printf("\n<hr/>BUFFERS:<br/>\n<pre>%s</pre>", ($buffers == '') ? '(empty)' : $buffers);
			printf("\n<hr/>QUERIES:<br/>\n<pre>%s</pre>", ($queries == '') ? '(empty)' : $queries);
			printf("\n<hr/>RAW XML:<br/>\n<pre>%s</pre>", ($raw_xml == '') ? '(empty)' : $raw_xml);
			$ss=ob_get_contents();
		ob_end_clean();
			$ss=str_replace(array('"',"\n","\r",'\\'),array('&quot;','','','\\\\'),nl2br($ss));
			echo "
<SCRIPT language=javascript>

//	if( self.name == '' ) {
//	   var title = 'Console';
//	}
//	else {
//	   var title = 'Console_' + self.name;
//	}

	var title = 'Console_' + window.location.hostname;
	
	_smarty_console = window.open(\"\",title,\"width=680,height=600,resizable,scrollbars=yes\");
	_smarty_console.document.write(\"<HTML><HEAD><TITLE>Debug Console_\"+window.location.hostname+\"</TITLE></HEAD><BODY bgcolor=#ffffff>\");
	_smarty_console.document.write(\"{$ss}\");
	_smarty_console.document.write(\"</BODY></HTML>\");
	_smarty_console.document.close();
</SCRIPT>				
	";			
		}
	}
	// В случае поимки спец-исключения производим подтверждение изменений,
	// но выполнение скрипта при этом прекращаем (вернее, молча, но корректно завершаем).
	catch (exception_exit $exception)
	{
		try { self::commit('on forced successful exit'); } catch (exception $exception_dummy) {}
		if (!_DEBUG_) self::clear_buffers();
	}
	// В случае поимки спец-исключения производим откат изменений в той стадии,
	// в которой оно возникло, и прекращаем работу без всяких сообщений.
	catch (exception_abort $exception)
	{
		try { self::rollback('on forced abortion/termination'); } catch (exception $exception_dummy) {}
		if (!_DEBUG_) self::clear_buffers();
	}
	// В случае поимки всех прочих исключений, делаем откат изменений (в рамках стадии,
	// на которой возникло исключение) и выводим сообщение о необработанной ошибке.
	// В отладочном режиме выводим сообщение с подробностями (для разработчика).
	// В релизе выводим просто сообщение что случилась ошибка (для посетителей).
	catch (exception $exception)
	{
		try { self::rollback('on unhandled exception'); } catch (exception $exception_dummy) {}

		if (_DEBUG_)
		{
			printf("<!--CONTENT-ENDS-HERE--><pre>");
			printf("Exception of class '%s' at %s:%s:\n%s\n%s\n</pre>",
				get_class($exception),
				$exception->getFile(),
				$exception->getLine(),
				$exception->getMessage(),
				$exception->getTraceAsString());
		} else
		{
			self::clear_buffers();
			printf("<!--CONTENT-ENDS-HERE-->");
			printf("Unhandled exception. Sorry.");
		}
	}

	// Независимо от успешности выполнения кода или возникновения исключений,
	// закрываем подключение к базе данных (если оно вообще было отрыто).
	self::disconnect();

	// Замеряем время выполнения скрипта, и выводим его если надо.
	$ts_end = microtime(true);
	#if (_DEBUG_ || _TIMER_)
	if (_TIMER_)
	{
		printf("<!--CONTENT-ENDS-HERE-->");
		printf("\n%.03fs", $ts_end - $ts_start);
	}
}
#
####################################################################################################
# Рабочая функция для запуска из командной строки (или cron).
# Без заголовков и отладки.
# По другому определяет pathinfo

public static function _work_maint ()
{
	// Запоминаем время начала работы скрипта для последующего измерения времени работы.
	$ts_start = microtime(true);

	// Основной функционал, общий для всех страниц и запросов.
	try
	{
		// Избавляемся от magic-quotes, если включены.
		if (get_magic_quotes_gpc())
		{
			$_GET    = self::_strip_magic_quotes_($_GET   );
			$_POST   = self::_strip_magic_quotes_($_POST  );
			$_COOKIE = self::_strip_magic_quotes_($_COOKIE);
		}

		// По спец-запросу включаем режимы отладки и замера времени, но только если они до сих пор
		// не включены/отключены принудительно. Для принудительного включения или отключения (запрета)
		// этих режимов, нужно определить соответствующие константы ещё до вызова ядра.
		if (!defined('_DEBUG_')) define('_DEBUG_', array_key_exists('DEBUG', $_COOKIE) || array_key_exists('DEBUG', $_POST) || array_key_exists('DEBUG', $_GET));
		if (!defined('_TIMER_')) define('_TIMER_', array_key_exists('TIMER', $_COOKIE) || array_key_exists('TIMER', $_POST) || array_key_exists('TIMER', $_GET));

		// Создаём документ для данных и записываем туда ключевые параметры запроса и среды выполнения,
		// но только те, которые нам актуальны для генерации страниц отлика.
		$system = array();
		$system['now'     ] = getdate(time()); $system['now']['epoch'] = $system['now'][0]; unset($system['now'][0], $system['now']['weekday'], $system['now']['month']);
		$system['info'    ] = isset(_config_::$dom_info) ? _config_::$dom_info : null;
		$system['curr_url'] = urlencode(self::_normalize_back_urls_(
		$system['curr_raw'] =
					(isset($_SERVER['REQUEST_URI' ]) ? $_SERVER['REQUEST_URI' ] :
					(null))));
		if ((strpos($system['curr_raw'],'?')===false)&&(substr($system['curr_raw'],-1,1)!=='/')) $system['curr_raw'].='/';
		$system['back_url'] = urlencode(self::_normalize_back_urls_(
		// Исправление неправильной переадресации здесь
		$system['back_raw'] =
					((isset($_GET   ['back'        ])&&$_GET   ['back'        ]) ? $_GET   ['back'        ] :
					((isset($_POST  ['back'        ])&&$_POST  ['back'        ]) ? $_POST  ['back'        ] :
					(isset($_SERVER['HTTP_REFERER']) ? $_SERVER['HTTP_REFERER'] :
					(null))))));

		$data_document = self::$document = new DOMDocument();
		$data_document->formatOutput = true;
		$data_document->encoding     = 'utf-8';
		$data_document->appendChild($data_document->createElement('response'));
		self::put2dom('system', $system);
		self::$xpath = new DOMXPath(self::$document);

		// Определяем что было запрошено и задаём это как модуль+преобразование по умолчанию.
		// Этот модуль в процессе выполнения может перенаправить выполнение на другой модуль
		// или переопределить используемую таблицу преобразований.
		$pathinfo = isset($_SERVER['argv'][1]) ? $_SERVER['argv'][1] : null;

		// Убираем из пути указание языка
		self::identify_language($pathinfo);

		self::set_module_file($pathinfo);
		self::set_module_xslt($pathinfo);

		// Теперь мы подготовили среду выполнения, и можно выполнять основной код.
		// Для отлова ошибок идёт расчёт на исключения, причём очень желательно
		// чтобы эти исключения входили в список известных (или были унаследованы от них).
		try
		{
			// Коммиты стоят вокруг всех основных стадий кода на случай, когда
			// нужно сохранить изменения данных предыдущей стадии (опознание посетителя),
			// если произошла ошибка на следующей стадии (основной работы).
			// Актуально только если используются транзакционные таблицы (InnoDB);
			// в противном случае не имеет значение, и не влияют на производительность.
//???--			self::commit('A');//??? этот коммит бесполезен, так как до него ничего и не происходит
			self::identify_visitor();
//???--			self::commit('B');//??? этот коммит бесполезен, так как identify работает не всегда, а когда есть, то там в основном только select'ы.
			self::execute_module();
			self::commit('automatically after working');// Нужный и важный коммит, так как срабатывает после всех операций в случае их успеха.
		}
		// Ошибка в бизнес-логике производит откат изменений той стадии,
		// в которой она возникла, и добавляет данные об ошибке в DOM.
		// При этом перевброса ошибки не производится, то есть считается
		// что ошибка в бизнес-логике -- часть корректного отклика.
		catch (exception_bl $exception)
		{
			if($GLOBALS['api'] == 1)
			{
				self::returnError(array(
						'id'   => $exception->getId(),
						'type' => $exception->getType(),
						'text' => $exception->getMessage())
				);
			}
			else
			{
				self::rollback('on business-logic exception');
				$data_document->documentElement->appendChild(
					self::dom($data_document, 'exception', array(
						'id'   => $exception->getId(),
						'type' => $exception->getType(),
						'text' => $exception->getMessage())));
				if ($exception->getType()=='absent') {
					self::set_module_file("/404/");
					self::set_module_xslt("/404/");
					self::execute_module();
				}
				if ($exception->getType()=='denied') {
					self::set_module_file("/403/");
					self::set_module_xslt("/403/");
					self::execute_module();
				}
			}
		}
		
		$result = self::apply_stylesheet();
		$buffers = ob_get_contents(); ob_clean();
		print $result;

		// В отладочном режиме выводим дамп полученного документа в чистом виде (только добавив параметры среды
		// выполнения запроса), а также отладочные дампы и ошибки кода (тут главное чтобы после основного текста).
		if (_DEBUG_)
		{
			printf("<!--CONTENT-ENDS-HERE-->");
			$raw_xml = htmlspecialchars(self::apply_stylesheet(true));
			$queries = implode('', array_map(create_function('$v', 'return $v . ";\n";'), self::$queries));

			printf("\n<hr/>BUFFERS:<br/>\n<pre>%s</pre>", ($buffers == '') ? '(empty)' : $buffers);
			printf("\n<hr/>QUERIES:<br/>\n<pre>%s</pre>", ($queries == '') ? '(empty)' : $queries);
			printf("\n<hr/>RAW XML:<br/>\n<pre>%s</pre>", ($raw_xml == '') ? '(empty)' : $raw_xml);
		}
	}
	// В случае поимки спец-исключения производим подтверждение изменений,
	// но выполнение скрипта при этом прекращаем (вернее, молча, но корректно завершаем).
	catch (exception_exit $exception)
	{
		try { self::commit('on forced successful exit'); } catch (exception $exception_dummy) {}
		if (!_DEBUG_) self::clear_buffers();
	}
	// В случае поимки спец-исключения производим откат изменений в той стадии,
	// в которой оно возникло, и прекращаем работу без всяких сообщений.
	catch (exception_abort $exception)
	{
		try { self::rollback('on forced abortion/termination'); } catch (exception $exception_dummy) {}
		if (!_DEBUG_) self::clear_buffers();
	}
	// В случае поимки всех прочих исключений, делаем откат изменений (в рамках стадии,
	// на которой возникло исключение) и выводим сообщение о необработанной ошибке.
	// В отладочном режиме выводим сообщение с подробностями (для разработчика).
	// В релизе выводим просто сообщение что случилась ошибка (для посетителей).
	catch (exception $exception)
	{
		try { self::rollback('on unhandled exception'); } catch (exception $exception_dummy) {}

		if (_DEBUG_)
		{
			printf("<!--CONTENT-ENDS-HERE--><pre>");
			printf("Exception of class '%s' at %s:%s:\n%s\n%s\n</pre>",
				get_class($exception),
				$exception->getFile(),
				$exception->getLine(),
				$exception->getMessage(),
				$exception->getTraceAsString());
		} else
		{
			self::clear_buffers();
			printf("<!--CONTENT-ENDS-HERE-->");
			printf("Unhandled exception. Sorry.");
		}
	}

	// Независимо от успешности выполнения кода или возникновения исключений,
	// закрываем подключение к базе данных (если оно вообще было отрыто).
	self::disconnect();

	// Замеряем время выполнения скрипта, и выводим его если надо.
	$ts_end = microtime(true);
	#if (_DEBUG_ || _TIMER_)
	if (_TIMER_)
	{
		printf("<!--CONTENT-ENDS-HERE-->");
		printf("\n%.03fs", $ts_end - $ts_start);
	}
}
#
####################################################################################################
#
public static function fetchModule($name)
{
	static $modules = array();

	$args = func_get_args();
	$name = array_shift($args);

	if (!isset($modules[$name]))
	{
		$names = explode('/', $name);

		if (file_exists(_config_::$depends_dir . $name . _config_::$depends_ext))
		{
			// если файл модуля лежит сразу в подкаталоге, то берем его
			// имя класса склеиваем из последних двух элементов
			$include_file = $name;
			$class_name = array_pop($names);
			$class_name = array_pop($names) . $class_name;
		}
		else
		{
			// иначе берем module.php из подкаталога (подкаталогов), 
			// а имя класса - последний элемент после '/' или совпадает с переданным аргументом, если '/' нет
			$include_file = $name.'/module';
			$class_name = array_pop($names);
		}
		self::depend($include_file);

 		if (!class_exists($class_name)) 
		{
			throw new exception("Could not load module $name with class $class_name from file $include_file.");
		}

		#$m=&call_user_func_array(array(new ReflectionClass($name), 'newInstance'), $args);
		$class = new ReflectionClass($class_name);
		$modules[$name] = $class->newInstance($args);
	}
	return $modules[$name];
}

public static function Redirect($url)
{
	try { self::commit('on forced successful exit'); } catch (exception $exception_dummy) {}
	header("Location: $url");
	die;
}

public static function is_json($value)
{
	if (!is_string($value)) return false;
	json_decode($value);
	return (json_last_error() == JSON_ERROR_NONE);
}

public static function returnJSON($result)
{
	try { self::commit('on forced successful exit'); } catch (exception $exception_dummy) {}
	
	//self::depend('json');
	//echo put_json([ "response" => $result ]);
	echo json_encode([ "response" => $result ]);
	
	die;
}

public static function returnJSONunesc($result)
{
	try 
	{ 
		self::commit('on forced successful exit'); 
	} 
	catch (exception $exception_dummy) 
	{
	}
	
	header('Content-Type: text/plain; charset=utf-8');
	echo json_encode([ 'response' => $result ], JSON_UNESCAPED_UNICODE + JSON_PRETTY_PRINT);
	
	die();
}

public static function returnTextPlane($result)
{
	try 
	{ 
		self::commit('on forced successful exit'); 
	} 
	catch (exception $exception_dummy) 
	{
	}
	
	header('Content-Type: text/plain; charset=utf-8');
	echo $result;
	
	die();
}

public static function returnError($message)
{
	try { self::commit('on forced successful exit'); } catch (exception $exception_dummy) {}
	
	//self::depend('json');
	//echo put_json([ 'error' => $message ]);
	//echo json_encode([ 'error' => $message ]);
	header('Content-Type: text/plain; charset=utf-8');
	echo json_encode([ 'error' => $message ], JSON_UNESCAPED_UNICODE + JSON_PRETTY_PRINT);
	
	die();
}

public static function clear_buffers()
{
	$handlers = ob_list_handlers();
	while (!empty($handlers))
	{
    	ob_end_clean();
	    $handlers = ob_list_handlers();
	}
}

#
####################################################################################################
#
}
#
####################################################################################################
####################################################################################################
####################################################################################################

function debug($var,$name="var"){
	$ar=debug_backtrace();
	$ret="in <strong>".$ar[0]['file']."</strong> at line <strong>".$ar[0]['line']."</strong><br>";
	echo "<table><td>$ret<pre>$name = "; print_r($var); echo "</pre></td></table>";
}

function print_backtrace()
{
	$ret = '';
	$ar = debug_backtrace();
	for($i=count($ar)-1;$i>=1;$i--){
		$ret.="in <strong>".$ar[$i]['file']."</strong> at line <strong>".$ar[$i]['line']."</strong> ".(isset($ar[$i]['class'])?$ar[$i]['class']:"").(isset($ar[$i]['type'])?$ar[$i]['type']:"").$ar[$i]['function']."()<br>";
	}
	echo $ret;
}

function debug_log($var, $debug_trace = false)
{
	$ar=debug_backtrace();
	$dbg = $ar[0];

//	date_default_timezone_set('UTC');
	$str = '[ '.date(DATE_RFC850).' ]'.'[ '.$dbg['file'].', '.$dbg['line'].' ]: '."<br/><pre>\n".print_r($var, true)."\n<pre><br>\n";

	$f = fopen("../../.internals/files/debug.log", "a");

	if ($f)
	{
		fputs($f, $str);
		if ($debug_trace)
		{
		    $ret = '';
        	for($i=count($ar)-1; $i>0; $i--)
        	{
        		@$ret.="in <strong>".$ar[$i]['file']."</strong> at line <strong>".$ar[$i]['line']."</strong> "
        		.(isset($ar[$i]['class']) ? $ar[$i]['class'] : "")
        		.(isset($ar[$i]['type']) ? $ar[$i]['type'] : "")
        		.$ar[$i]['function']."()<br>\n";
        	}

			fputs($f, $ret);
		}
		fclose($f);
	}
}

function PutTimer($name = 'start')
{
	static $timer;

	if (!$timer) $timer = microtime(true);
	else
	{
		$t = microtime(true);
		//printf("\n$name: %.03fs", $t - $timer);
		debug_log(sprintf("\n$name: %.03fs", $t - $timer));
		$timer = $t;
	}
}

//if(!("".(0+$v)=="".$v))
function is_empty_array($arr)
{
	if($arr)
	{
		foreach($arr as $v)
		{
			if(is_array($v)) { if(!is_empty_array($v)) return false; }
			else
			{
				if("".(0+$v)=="".$v) return false; // число (возможно строкой и возможно ноль)
				if(trim($v)) return false; // непустая строка
			}
		}
	}
	return true;
}

// Сохранение именованных таймкодов, чтобы отследить, какая часть скрипта сколько времени работает
class _debugtimer_
{
	public static $timers = [];

	public static function AddTimer($name, $add = null)
	{
		$timer = [];
		$timer['name'] = $name;
		$timer['ts'] = microtime(true);
		$timer['time'] = 0;
		$timer['add'] = $add;
		$timer['mem'] = memory_get_usage(false);

		$n = count(self::$timers);
		if ($n > 0)
		{
			$timer['time'] = $timer['ts'] - self::$timers[ $n-1 ]['ts'];
		}

		self::$timers[] = $timer;
	}

	public static function FormatTimers()
	{
		$result = [];

		$n = count(self::$timers);
		for ($i = 1; $i < $n; $i++)
		{
			$timer = self::$timers[$i];
			$result[$i] = $timer['name'].': '.sprintf('%f',$timer['time']);
			if ($timer['add'])
			{
				$add = $timer['add'];
				$result[$i] .= ', '.$add;
				if (is_numeric($add) && ($add > 0))
				{
					$result[$i] .= ', '.sprintf('%f',$timer['time'] / $add);
				}
			}
			$result[$i] .= ', '.sprintf('%.2fMb',$timer['mem'] / 1024.0 / 1024.0);
		}

		return $result;
	}

}

?>
