<?php
_main_::depend('multilang');
_main_::depend('base_module');

require_once __DIR__.'/../_external_/vendor/autoload.php';
use \Firebase\JWT\JWT;

class MakeAuth extends Computed {}
class AutocompleteFieldMvd extends AutocompleteField
{
	function fetch_enums (&$enums, &$data = [])
	{
		if (isset($data[$this->name]) && $data[$this->name])
		{
			$m = _main_::fetchModule($this->linked_module);
			if ($data['roles'] == 'officer,uvm')
			{
				$this->value_txt = $m->get_authorityOrgan($data[$this->name]);
			}
			else
			{
				$this->value_txt = $m->get_omvd($data[$this->name]);
			}
		}
	}
}

class Users extends Base_Module
{
	var $admin;
	private $roles;
	private $officer_roles;
	private $officer_where;

	function __construct()
	{
		parent::__construct('users', 'user', 'Пользователи');
		
		$this->roles = [
				 'admin'		=> 'Администратор'
				,'rop'			=> 'РОП'
				,'rop,track'	=> 'РОП Траки'
				,'manager'		=> 'Менеджер'
		];

		#$this->order_field = 'last_name'; // Специальное поле position позволяет управлять сортировкой (стрелочки)
		$this->name_field = 'name'; // Какое поле представляет название записи. default 'name'
		#$this->update_details = array(); // Список линков для страницы редактирования записи. default true (все линки)
		$this->on_page = 100;
		$this->return_to_list = true; // Возвтрат к списку после добавления/радктирования. default: false (возврат к редактированию)

		$this->additional_js = 'user.js';
		// make_filter(filter_type, filter_name, filter_title, defauilt value, [fields = array()])
		/*
		$this->make_filter('Select', 'with_card', 'Наличие карты', '', array(
			'values_list'	=> array('not null'=>'имеют карту', 'null'=>'не имеют карту')
		,	'empty'		=> 'не учитывать'
		,	'mapping'	=> array('with_card'=>'A.`card`')
		));
		$this->make_filter('TextField', 'card', 'Номер карты', array());
		$this->make_filter('TextField', 'last_name', 'Фамилия', '');
		$this->make_filter('TextField', 'email', 'E-mail', '');
		*/

		/*
				
		$this->make_filter('TextField', 'role', 'Роль', '');
		$this->make_filter('TextField', 'resident_name', 'ФИО', '');
		$this->make_filter('TextField', 'hotel', 'Отель', '');
		$this->make_filter('Select', 'state', 'Статус', '', array(
			'values_list'	=> [
				'created' => 'создано'
			,	'sent' => 'отправлено'
			,	'processed' => 'обработано'
			,	'closed' => 'закрыто'
			]
		,	'empty'		=> 'не учитывать'
		));
		*/
		$this->make_filter('Select', 'roles', 'Роль', '', array(
			'values_list'	=>  $this->roles
		,	'empty'		=> 'не учитывать'
		,	'mapping' => [ 'roles' => 'P.roles' ]
		));
		
//		$this->admin_filters = array('last_name'=>''); // , 'mr'=>'', 'short'=>''
		$this->admin_sorters = array('name'=>false); // 'position'=>false, 'mr'=>false, 
		//$this->unique_keys = array(2=>'email', 4=>'card'); // ???

		// Добавление полей модуля
		// make_field('field_type', 'field_name', [required], [defauilt value], [parameters = array()])

		$this->make_field('Email', 'email', true, null, array(
			'title'		=> 'Email'
		));

		$this->make_field('Password', 'password', true, null, array(
			'title'		=> 'Пароль'
		));
		
		$this->make_field('TextField', 'name', true, null, array(
			'title'		=> 'ФИО'
		));

		$this->make_field('Select', 'roles', true, null, array(
			'title'		=> 'Роль'
		,	'values_list' => $this->roles
		));
		
		$this->make_field('SelectList', 'branch', null, null, array(
			'title'		=> 'Филиал'
		,	'linked_module'	=> 'branches'
		,	'empty'		=> 'Выбрать'
		,	'list'		=> 1
		));
        $this->make_field('MakeAuth', 'auth', false, null, array(
			'title' => ''
		,	'list'		=> 1
		));

		//$this->make_field('CheckBox', 'extended_policy', false, null, array(
		//	'title'		=> 'Расширенная политика безопасности'
		//,	'list'		=> 0
		//));

		/*
		$this->make_field('CheckBox', 'must_change_password', false, null, array(
			'title'		=> 'Требуется сменить пароль'
		));

		$this->make_field('TextField', 'wrong_password_attempts', false, null, array(
			'title'		=> 'Попыток ввода неправильного пароля'
		,	'list'		=> 0
		,	'disabled'	=> true
		));

		$this->make_field('TextField', 'last_wrong_password_attempt', false, null, array(
			'title'		=> 'Последняя попытка ввода неправильного пароля'
		,	'list'		=> 0
		,	'disabled'	=> true
		));

		$this->make_field('TextField', 'password_expiration_date', false, null, array(
			'title'		=> 'Время окончания действия пароля'
		,	'list'		=> 0
		,	'disabled'	=> true
		));

		$this->make_field('CheckBox', 'user_is_locked', false, null, array(
			'title'		=> 'Заблокирован'
		));

		$this->make_field('TextField', 'user_lock_time', false, null, array(
			'title'		=> 'Время блокировки пользователя'
		,	'list'		=> 0
		,	'disabled'	=> true
		));

		$this->make_field('TextField', 'user_lock_mode', false, null, array(
			'title'		=> 'Режим блокировки пользователя'
		,	'list'		=> 0
		,	'disabled'	=> true
		));

		$this->make_field('TextField', 'user_lock_comment', false, null, array(
			'title'		=> 'Комментарий к блокировке пользователя'
		,	'list'		=> 0
		));
		*/
	}

################## COMMON ####################################

################## ENUMS ####################################

################## FORMS ####################################

################## OPERS ####################################
function make_auth_link ($data, $field_name)
{
	return "<a href='"._config_::$dom_info['pub_root']."?auth={$data['id']}|{$data['encrypted_password']}'>Авторизоваться</a>";
}

function pwd_hash ($pwd)
{
//	$salt = strtr(base64_encode(mcrypt_create_iv(16, MCRYPT_DEV_URANDOM)), '+', '.');
//	return crypt($pwd, '$2a$11$'.$salt);
	return sha1($pwd);
}

function validate (&$errors, &$data, $config, $enums, $ignore_uploads = false)
{
	_main_::depend('validations', 'merges');

	parent::validate($errors, $data, $config, $enums, $ignore_uploads);

	if (strpos($data['roles'], 'hotelier') !== false)
	{
		//debug($data['roles']);die;
		validate_required($errors, $data, 'umms_id');
		validate_required($errors, $data, 'hotel_id');
	}
}

function insert (&$errors, &$data, &$id)
{
	try 
	{
		$id = _main_::query(null, "
			insert 	into 
				`users` 
				(
				`encrypted_password`, 
				`email`, 
				`name`,
				`roles`,
				`branch`
				)
			values 
				(
				{02}, 
				{03}, 
				{04}, 
				{05},
				{06}
				)
		", null
		,$this->pwd_hash($data['password1'])
		,$data['email']
		,$data['name']
		,$data['roles']
		,$data['branch']
		);

		if (isset($data['password1']) && $data['password1'])
		{
			// Если поменяли пароль через админку - сбрасываем поля, касающиеся неправильного ввода пароля
			$this->extended_policy_set_password($id, $data['password1'], 'admin');
		}

		// Блокируем / разблокируем пользователя
		// Из админки блокировка перманентная, разблокировка без дополнительных условий
		#$this->extended_policy_set_user_lock($id, $data['user_is_locked'], 'admin', $data['user_lock_comment']);

		// Вычисляем и проставляем дату/время, когда истечет срок действия пароля, если это не было сделано ранее
		#$this->extended_policy_set_password_expiration($id, $data['must_change_password']);

		//print_r($data['password1']);
		//print_r($this->pwd_hash($data['password1']));
		//die();
		
		$this->handle_uploads_persistently($data);

		#foreach($this->fields as $f=>$v) $v->post_update($id, $data);
		$this->post_update($id, $data);
	}
	catch (exception_db_unique $exception) { $this->handle_uploads_temporarily($data); _main_::depend('validations'); validate_add_error($errors, $this->parce_unique_exception($exception->getMessage()), 'duplicate'); }
	catch (exception           $exception) { $this->handle_uploads_temporarily($data); throw $exception; }
}

function update (&$errors, &$data, &$id, $orig = null)
{	
//	update_texts($data, $this->table, $this->multilang_fields);

//	$sql = '';
//	foreach($this->fields as $f=>$v) if($field = $v->sql_set($data)) $sql .= ','.$field;
//	$sql = substr($sql, 1);

	$type = explode(',', $data['roles'])[0];
	
	try
	{
		_main_::query(null, "
			update	`users`
			set		`email`					= {02}
			,		`name`					= {03}
			,		`roles`					= {04}
			,		`branch`				= {05}
			where	`id` 	= {01}
		", $id
		,$data['email']
		,$data['name']
		,$data['roles']
		,$data['branch']
		);

		if (isset($data['password1']) && $data['password1'])
		{
			// Если поменяли пароль через админку - сбрасываем поля, касающиеся неправильного ввода пароля
			$this->extended_policy_set_password($id, $data['password1'], 'admin');
		}

		// Блокируем / разблокируем пользователя
		// Из админки блокировка перманентная, разблокировка без дополнительных условий
		#$this->extended_policy_set_user_lock($id, $data['user_is_locked'], 'admin', $data['user_lock_comment']);

		// Вычисляем и проставляем дату/время, когда истечет срок действия пароля, если это не было сделано ранее
		#$this->extended_policy_set_password_expiration($id, $data['must_change_password']);

		//print_r($data['password1']);
		//print_r($this->pwd_hash($data['password1']));
		//die();	
		
		#foreach($this->fields as $f=>$v) $v->post_update($id, $data, $orig);
		$this->post_update($id, $data, $orig);

	}
	catch (exception_db_unique $exception) { $this->handle_uploads_temporarily($data); _main_::depend('validations'); validate_add_error($errors, $this->parce_unique_exception($exception->getMessage()), 'duplicate'); }
	catch (exception           $exception) { $this->handle_uploads_temporarily($data); throw $exception; }
}

function post_update($id, &$data, &$orig = null)
{
	/*
	foreach($this->fields as $f=>$v) $v->post_update($id, $data, $orig);

	if (!$this->admin)
	if ((!$orig['card']) && ($data['card']))
	{
		$dat = _main_::query('row', "select `points` from `fishconf`");
		$start_points = array_shift(array_shift($dat));

		_main_::query(null, "
			update `users`
			set	`points` = {2}
			where	`id` = {1}",
		$id, $start_points);
	}
	*/
}

function delete_in_table ($table)
{
	_main_::depend('merges');
	$ids = get_fields($table, 'id');

	// Удаляем сами записи и чистим файлы от файловых полей.
	_main_::query(null, "delete from `{$this->table}` where `id` in {1}", $ids);
	foreach ($table as $row) $this->handle_uploads_cleanly($row);
}

function register (&$errors, &$data, &$id)
{
	$data['activator'] = rand(1001, 9999);

	try { 
		/*
		$id = _main_::query(null, "
		insert 	into `{$this->table}`
		set	`pwd_md5`		= {02}
		,	`email`			= {03}
		,	`confirm`		= {04}
		,	`name`			= {05}
		,	`activator`		= {06}
		,	`deviceid`		= {07}
		", null,
		md5($data['password']),
		$data['email'],
		$data['confirm'],
		$data['name'],
		$data['activator'],
		$data['deviceid'],
		null);
		*/
		
		$id = _identify_::id();

		_main_::query(null, "
			update `{$this->table}`
			set	`pwd_md5`		= {02}
			,	`email`			= {03}
			,	`confirm`		= {04}
			,	`name`			= {05}
			,	`activator`		= {06}
			,	`deviceid`		= {07}
			where	`id`		= {01}
			", $id,
			md5($data['password']),
			$data['email'],
			$data['confirm'],
			$data['name'],
			$data['activator'],
			$data['deviceid'],
		null);
		$this->handle_uploads_persistently($data);
#		$this->reorder();
	}
	catch (exception_db_unique $exception)
	{
		$this->handle_uploads_temporarily($data);
		_main_::depend('validations');
		
		$dat = _main_::query('row', "select `id`, `confirm`, `activator` from `{$this->table}` where `email` = {1}", $data['email']);
		
		$user_data = array_shift($dat);
		$confirm = $user_data["confirm"];
		
		if ($confirm == 1)
		{
			validate_add_error($errors, 'email', 'duplicate', 'Электронный адрес уже зарегистрирован.');
		}
		else
		{
			$id = $user_data['id'];
			$data['activator'] = $user_data['activator'];
			//validate_add_error($errors, 'confirm', 'no', 'Электронный адрес уже зарегистрирован, но не подтверждён.');
		}
	}
	catch (exception           $exception) { $this->handle_uploads_temporarily($data); throw $exception; }
}

// Убиваем сессию пользователя по users.id, путем удаления записи из таблицы php_session
function extended_policy_kill_session($user_id)
{
	if (!$user_id)
	{
		return false;
	}

	#$db->query("DELETE FROM php_session WHERE user_id = ".$user_id);
	session_destroy();

	return true;	
}

// Ставим / снимаем блокировку пользователя
function extended_policy_set_user_lock($id, $user_is_locked, $user_lock_mode, $user_lock_comment)
{
	$dat = _main_::query(null, "select * from users where id = {01}", $id);
	if ($dat)
	{
		// полные данные юзера
		$userdata = array_shift($dat);
	}
	else
	{
		// нет такого пользователя
		return false;
	}

	// Блокируем
	if ($user_is_locked == 1)
	{
		if (($userdata['user_is_locked'] == 1) && ($userdata['user_lock_mode'] == $user_lock_mode) && ($userdata['user_lock_comment'] == $user_lock_comment))
		{
			// Блокировка уже стоит, режим блокировки совпадает, комментарий тоже, ничего делать не нужно
			return true;
		}

		if ($userdata['user_lock_time'])
		{
			// сохраняем старое значение
			$user_lock_time = $userdata['user_lock_time'];
		}
		else
		{
			// Иначе проставляем текущие дату/время
			$user_lock_time = date('c');
		}

		if ($userdata['user_lock_mode'] == 'admin')
		{
			// Режим блокировки admin (пермабан) может быть сброшен только из админки
			// Поэтому игнорируем режим блокировки, переданный в аргументе
			$user_lock_mode = 'admin';
		}

		// В бан!
		_main_::query(null, "
			update
				users
			set
				user_is_locked = 1,
				user_lock_time = {02},
				user_lock_mode = {03},
				user_lock_comment = {04}
			where
				id = {01}
		",
		$id,
		$user_lock_time,
		$user_lock_mode,
		$user_lock_comment
		);

		// Сразу рвем пользователю сессию
		$this->extended_policy_kill_session($id);

		return true;
	} // user_is_locked == 1

	// Разблокируем
	if ($user_is_locked == 0)
	{
		if (($userdata['user_lock_mode'] == 'admin') && ($user_lock_mode != 'admin'))
		{
			// Блокировку, поставленную администратором, может снять только администратор
			return false;
		}

		// Разбан
		_main_::query(null, "
			update
				users
			set
				user_is_locked = 0,
				user_lock_time = null,
				user_lock_mode = null,
				user_lock_comment = null
			where
				id = {01}
		",
		$id
		);

		return true;
	} // user_is_locked == 0

	// Неправильные параметры
	return false;
}

// Выставляем или стираем флаг "Требуется сменить пароль" и срок окончания действия временного пароля
function extended_policy_set_password_expiration($id, $must_change_password)
{
	$dat = _main_::query(null, "select * from users where id = {01}", $id);
	if ($dat)
	{
		// полные данные юзера
		$userdata = array_shift($dat);
	}
	else
	{
		// нет такого пользователя
		return false;
	}

	if ($must_change_password == 1)
	{
		// если выставлена галка "Требуется сменить пароль" - проставляем время жизни временного пароля
		if ($userdata['password_expiration_date'])
		{
			// не перетираем старое время
			return false;
		}

		$dt_password_expiration_date = date_add(new DateTime(), date_interval_create_from_date_string(_config_::$auth_extended_policy['temp_password_lifetime_days'].' days'));
		$password_expiration_date = $dt_password_expiration_date->format('Y-m-d H:i:s');

		_main_::query(null, "
			update
				users
			set
				must_change_password = 1,
				password_expiration_date = {02}
			where
				id = {01}
		",
		$id,
		$password_expiration_date
		);

		// Сразу рвем пользователю сессию
		$this->extended_policy_kill_session($id);

		return true;
	}

	if ($must_change_password == 0)
	{
		if (!$userdata['password_expiration_date'])
		{
			// дата и так пустая
			return false;
		}

		_main_::query(null, "
			update
				users
			set
				must_change_password = 0,
				password_expiration_date = null
			where
				id = {01}
		",
		$id
		);

		return true;
	}

	return false;
}

// Меняем пароль и заодно проставляем поля расширенной политики безопасности
// Режимы работы ($mode) отличаются для смены пароля через админку и смены пароля самим пользователем
function extended_policy_set_password($id, $newpassword, $mode)
{
	if (!in_array($mode, array('admin','user')))
	{
		return false;
	}

	// Считываем полные данные пользователя, это можно делать, так как функция вызывается после insert/update в users из админки
	// и после update таблицы users в extended_policy_login()
	$dat = _main_::query(null, "select * from users where id = {01}", $id);
	if ($dat)
	{
		// полные данные юзера
		$userdata = array_shift($dat);
	}
	else
	{
		// нет такого пользователя
		return false;
	}

	// Это смена пароля через админку
	if ($mode == 'admin')
	{
		// если выставлена галка "Требуется сменить пароль" - проставляем время жизни временного пароля
		$password_expiration_date = null;
		if ($userdata['must_change_password'] == 1)
		{
			$dt_password_expiration_date = date_add(new DateTime(), date_interval_create_from_date_string(_config_::$auth_extended_policy['temp_password_lifetime_days'].' days'));
			$password_expiration_date = $dt_password_expiration_date->format('Y-m-d H:i:s');
		}

		// Меняем пароль и проставляем поля расширенной политики
		_main_::query(null, "
			update 
				users
			set	
				encrypted_password = {02}
			where
				id = {01}
		", 
		$id,
		$this->pwd_hash($newpassword),
		$password_expiration_date
		);

		// Сразу рвем пользователю сессию
		$this->extended_policy_kill_session($id);
	} // mode = admin

	// Это смена пароля самим пользователем, она сбрасывает требование смены пароля и дату/время протухания пароля
	if ($mode == 'user')
	{
		// Меняем пароль и проставляем поля расширенной политики
		_main_::query(null, "
			update 
				users
			set	
				encrypted_password = {02},
				must_change_password = 0,
				wrong_password_attempts = 0,
				last_wrong_password_attempt = null,
				password_expiration_date = null
			where
				id = {01}
		", 
		$id,
		$this->pwd_hash($newpassword)
		);
	} // mode = user
}


// Выставляем всем полям расширенной политики значения "всё нормально"
// Эта функция вызывается после каждого успешного логина, поэтому не делаем лишних update, чтобы не забивать логи
function extended_policy_set_valid($user_id)
{
	$dat = _main_::query(null, "
		select 
			count(*) as cnt
		from 
			users 
		where 
			id = {01}
			and not (
				(must_change_password = 0)
				and (wrong_password_attempts = 0)
				and (last_wrong_password_attempt is null)
				and (password_expiration_date is null)
				and (user_is_locked = 0)
				and (user_lock_time is null)
				and (user_lock_mode is null)
				and (user_lock_comment is null)
			)
		", 
		$user_id);

	$user_to_clean = array_shift($dat);

	if ($user_to_clean['cnt'] == 1)
	{
		_main_::query(null, "
			update 
				users
			set	
				must_change_password = 0,
				wrong_password_attempts = 0,
				last_wrong_password_attempt = null,
				password_expiration_date = null,
				user_is_locked = 0,
				user_lock_time = null,
				user_lock_mode = null,
				user_lock_comment = null
			where	
				id = {01}
			", 
			$user_id
			);
	}

	return true;
}


// Проверить расширенные условия политики безопасности для пользователя
function extended_policy_login(&$errors, $formdata, $userdata, $password_was_correct)
{
	// Передача дополнительных данных в сообщение об ошибке - обычно email (он же логин)
	$errdata = $userdata['email'];

	// Регулярка для проверки на латинские буквы в верхнем и нижнем регистре и цифры
	$min_password_length = _config_::$auth_extended_policy['min_password_length'];
	$passwd_regex_allowed_chars = "/[a-zA-Z0-9]{".$min_password_length.",}/";

	// Проверки, чтобы обязательно была маленькая латинская буква, большая латинская буква и цифра
	// Могут включаться и выключаться настройками политики
	$passwd_regex_lower_latin = "/[a-z]{1,}/";
	$passwd_regex_upper_latin = "/[A-Z]{1,}/";
	$passwd_regex_digit = "/[0-9]{1,}/";

	// Текущие дата и время
	$dt_now = new DateTime();

	// Дата/время последней попытки ввода неправильного пароля
	$dt_last_wrong_password_attempt = null;
	if ($userdata['last_wrong_password_attempt'])
	{
		$dt_last_wrong_password_attempt = new DateTime($userdata['last_wrong_password_attempt']);

		// Тут же, до всех остальных проверок, не даем слишком часто вводить пароли, если было сделано уже несколько попыток
		if ($userdata['wrong_password_attempts'] >= _config_::$auth_extended_policy['password_attempts_before_delay'])
		{
			// Варьируем время задержки перед повторной попыткой ввода пароля на +-50% от значения конфига
			$config_delay_minutes = _config_::$auth_extended_policy['password_attempts_delay_minutes'];
			$delay_shift = floor(_config_::$auth_extended_policy['password_attempts_delay_minutes'] / 2);
			$password_attempts_delay_minutes = rand($config_delay_minutes - $delay_shift, $config_delay_minutes + $delay_shift);

			$dt_next_allowed_attempt = date_add($dt_last_wrong_password_attempt, date_interval_create_from_date_string($password_attempts_delay_minutes.' minutes'));
			if ($dt_next_allowed_attempt > $dt_now)
			{
				// Для следующей попытки надо подождать несколько минут, но мы не скажем пользователю, сколько именно
				// И даже не скажем, правильный ли введен пароль
				validate_add_error($errors, 'auth', 'attempt_delay', $errdata);
				return false;
			}
		}
	}

	// Проверки в ситуации, если пароль введен верно
	if ($password_was_correct)
	{
		// Пользователь заблокирован
		if ($userdata['user_is_locked'] == 1)
		{
			// Заблокирован админом
			if ($userdata['user_lock_mode'] == 'admin')
			{
				validate_add_error($errors, 'auth', 'user_locked_permanent', $errdata);
				return false;
			}

			if ($userdata['user_lock_mode'] == 'user')
			{
				// Заблокирован за ввод неправильныз паролей
				// Смотрим - можно ли автоматически разблокировать
				if ($dt_last_wrong_password_attempt)
				{
					$dt_allow_logins = date_add($dt_last_wrong_password_attempt, date_interval_create_from_date_string(_config_::$auth_extended_policy['user_auto_unlock_minutes'].' minutes'));

					if ($dt_allow_logins < $dt_now)
					{
						// Времени прошло достаточно, можно разблокировать
						$this->extended_policy_set_user_lock($userdata['id'], 0, 'user', null);
					}
					else
					{
						// Заблокирован за попытки ввода неправильного пароля
						validate_add_error($errors, 'auth', 'user_locked_temporary', $errdata);
						return false;
					}
				}
				else
				{
					// Ненормальная ситуация, когда пользовательская блокировка установлена, но время последней попытки ввода неправильного пароля не записана
					// Некорректные данные, возможно, из-за сбоя в работе, сбрасываем блокировку
					$this->extended_policy_set_user_lock($userdata['id'], 0, 'user', null);
				}
			}
			else
			{
				// Заблокирован по другой причине, закладка на другие режимы блокировки, кроме user и admin
				validate_add_error($errors, 'auth', 'user_locked', $errdata);
				return false;
			}
		} // locked

		// У пользователя истек срок действия пароля
		if ($userdata['password_expiration_date'])
		{
			$dt_password_expiration_date = new DateTime($userdata['password_expiration_date']);

			if ($dt_password_expiration_date < $dt_now)
			{
				validate_add_error($errors, 'auth', 'password_expired', $errdata);
				return false;
			}
		}

		// Пользователь ввел правильный пароль, не заблокирован, проверки сделаны выше, поэтому сбрасываем ему счетчик неправильных паролей
		if ($userdata['last_wrong_password_attempt'])
		{
			_main_::query(null, "
				update 
					users
				set	
					wrong_password_attempts = 0,
					last_wrong_password_attempt = null
				where
					id = {01}
			", 
			$userdata['id']
			);
		}

		// Пользователь должен сменить пароль
		if ($userdata['must_change_password'] == 1)
		{
			$newpassword1 = trim($formdata['newpassword1'].'');
			$newpassword2 = trim($formdata['newpassword2'].'');

			if ((strlen($newpassword1) == 0) && (strlen($newpassword2) == 0))
			{
				// Новый пароль и подтверждение пароля не введены - требуем ввести
				validate_add_error($errors, 'auth', 'expired', $errdata);
				return false;
			}

			if ($newpassword1 != $newpassword2)
			{
				// Новый пароль и подтверждение пароля не совпадают
				validate_add_error($errors, 'auth', 'expired', $errdata);
				validate_add_error($errors, 'auth', 'newpassword_mismatch', $errdata);
				return false;
			}

			if ($newpassword1 == $formdata['password'])
			{
				// Новый пароль не должен повторять старый
				validate_add_error($errors, 'auth', 'expired', $errdata);
				validate_add_error($errors, 'auth', 'newpassword_duplicate_old', $errdata);
				return false;
			}

			if (strlen($newpassword1) < $min_password_length)
			{
				// Проверяем на минимальную длину пароля
				validate_add_error($errors, 'auth', 'expired', $errdata);
				validate_add_error($errors, 'auth', 'newpassword_tooshort', $min_password_length);
				return false;
			}

			if (!preg_match($passwd_regex_allowed_chars, $newpassword1))
			{
				// Проверяем на допустимые символы в пароле
				validate_add_error($errors, 'auth', 'expired', $errdata);
				validate_add_error($errors, 'auth', 'newpassword_badchars', $errdata);
				return false;
			}

			if (_config_::$auth_extended_policy['want_lower_latin'])
			{
				if (!preg_match($passwd_regex_lower_latin, $newpassword1))
				{
					// Проверяем, чтобы была маленькая латинская буква
					validate_add_error($errors, 'auth', 'expired', $errdata);
					validate_add_error($errors, 'auth', 'newpassword_want_lower_latin', $errdata);
					return false;
				}
			}

			if (_config_::$auth_extended_policy['want_upper_latin'])
			{
				if (!preg_match($passwd_regex_upper_latin, $newpassword1))
				{
					// Проверяем, чтобы была большая латинская буква
					validate_add_error($errors, 'auth', 'expired', $errdata);
					validate_add_error($errors, 'auth', 'newpassword_want_upper_latin', $errdata);
					return false;
				}
			}

			if (_config_::$auth_extended_policy['want_digit'])
			{
				if (!preg_match($passwd_regex_digit, $newpassword1))
				{
					// Проверяем, чтобы была цифра
					validate_add_error($errors, 'auth', 'expired', $errdata);
					validate_add_error($errors, 'auth', 'newpassword_want_digit', $errdata);
					return false;
				}
			}

			$this->extended_policy_set_password($userdata['id'], $newpassword1, 'user');
			return true;

		} // must_change_password
	} // password_was_correct
	else
	{
		// Первым делом указываем ошибку
		validate_add_error($errors, 'auth', 'wrong', $errdata);

		// Неверно введен пароль - увеличиваем счетчик попыток, прописываем время последней попытки
		if ($userdata['wrong_password_attempts'] >= 0)
		{
			++$userdata['wrong_password_attempts'];
		}
		else
		{
			$userdata['wrong_password_attempts'] = 1;
		}
		$userdata['last_wrong_password_attempt'] = date('c');

		_main_::query(null, "
			update
				users
			set
				wrong_password_attempts = {02},
				last_wrong_password_attempt = {03}
			where
				id = {01}
		",
		$userdata['id'],
		$userdata['wrong_password_attempts'],
		$userdata['last_wrong_password_attempt']
		);

		// Если число неправильных попыток ввода пароля превысило лимит - выписываем временный бан
		// на какое время - указывается в конфиге в $auth_extended_policy['user_auto_unlock_minutes']
		if ($userdata['wrong_password_attempts'] >= _config_::$auth_extended_policy['max_wrong_password_attempts'])
		{
			$this->extended_policy_set_user_lock($userdata['id'], 1, 'user', 'попыток ввода неверного пароля: '.$userdata['wrong_password_attempts']);
		}

		// Тут всегда false, потому что ввели неверный пароль
		return false;
	}

	// Расширенная проверка пройдена
	return true;
}

function login(&$errors, &$data)
{
	_main_::depend('validations');

	$dat = _main_::query('row', "
		select	*
		from	`users`
		where	`email` = {1}", // and `pwd_md5` = {2}  and `confirm` = 1
		$data['email']); // sha1($data['password'])

	$login = false;
			
	if ($dat)
	{
		$userdata = array_shift($dat);
		$login = ($userdata['encrypted_password'] == $this->pwd_hash($data['password'])); //password_verify($data['password'], $userdata['encrypted_password']);	// bool
	}

	if (_config_::$auth_extended_policy['force_extended_policy'])
	{
		if (!($userdata['extended_policy'] == 1))
		{
			$userdata['extended_policy'] = 1;
			_main_::query(null, "
				update 
					users 
				set
					extended_policy = 1
				where 
					id = {01}
			",
			$userdata['id']
			);
		}
	}

	if (_config_::$auth_extended_policy['force_extended_policy'] && $userdata['extended_policy'] == 1)
	{
		if (!self::extended_policy_login($errors, $data, $userdata, $login))
		{
			session_destroy();
			return;
		}
	}
	
	if ($login)
	{
		$_SESSION['@id'] = $userdata['id'];

			/*
		$tmp = array_shift($dat);

		if ($tmp['confirm'] == 1)
		{
			$_SESSION['@id'] = $tmp['id'];

			$data = array_merge_rol($tmp, $data);

		}
		else
		{
			validate_add_error($errors, 'confirm', 'no', 'Электронный адрес не подтверждён.');
		}
			*/

	}
	else
	{
		validate_add_error($errors, 'auth', 'wrong', @$userdata['email']);
		session_destroy();
	}

}

function merge_users($old_id, $id)
{
	_main_::query(null, "
		update `locations`
		set		`user`	= {02}
		where	`user`	= {01}
		"
		,$old_id
		,$id
	);
	_main_::query(null, "
		update `log`
		set		`user`	= {02}
		where	`user`	= {01}
		"
		,$old_id
		,$id
	);
	_main_::query(null, "delete from `users` where `id` = {1}", $old_id);
}

function change_password(&$errors, &$data)
{
	_main_::depend('validations');

	$dat = _main_::query('row', "
		select	`id`
		from	`users`
		where	`id` = {1} and `pwd_md5` = {2}",
		_identify_::id(), md5($data['old_password']));
		
	if ($dat)
	{
		_main_::query(null, "
			update	`users`
			set		`pwd_md5`	= {2}
			where	`id`		= {1}
			"
			,_identify_::id(), md5($data['new_password']));
	}
	else
	{
		validate_add_error($errors, 'wrong password', 'wrong');
	}

}

function logout()
{
	$_SESSION['@id'];
	session_destroy();
	//session_name('token');
	session_start();
	setcookie('token', "", time() - 3600, _config_::$dom_info['pub_root']); // , _config_::$cookie_domain
}

function activate(&$errors, $activator, $id)
{
	_main_::depend('validations');

	$dat = _main_::query('row', "
		select	*
		from	`users`
		where	activator = {1}
		and		id = {2}
		",
		$activator, $id);

	if ($dat)
	{
        $data = array_shift($dat);
        
        if ($data['confirm'] == 1)
        {       	
			validate_add_error($errors, 'user', 'exists');
        }
        else
        {       	
			_main_::query(null, "
				update `users`
				set	`confirm` = 1
				where	`id` = {1}",
			$data['id']);

			$_SESSION['@id'] = $data['id'];
			
			return $data;
        }
	}else
	{
		validate_add_error($errors, 'user', 'not_found');
	}

	return false;
}

function gen_passwd()
{
	$chars = "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ1234567890";
	$passwd = "";
	for ($i=0;$i<5;$i++) $passwd .= $chars[rand(0,61)];
	return $passwd;
}

/*
function recovery_password(&$errors, &$data)
{
	// $passwd = $this->gen_passwd();

	$dat = _main_::query(null, "
		update	`users`
		set	`pwd_md5` = {2}
		where	`email`	  = {1}
		and	`confirm` = 1",
	$data['email'], md5($passwd));

	if (mysql_affected_rows() > 0)
	{
		$data['password'] = $passwd;
	}else
	{
		validate_add_error($errors, 'user', 'not_found');
	}

}
*/

function recovery_password(&$errors, $data)
{
	_main_::depend('validations');

	$dat = _main_::query('row', "
		select	*
		from	`users`
		where	activator = {1}
		and		id = {2}
		",
		$data['code'], $data['user_id']);

	if ($dat)
	{
//        $data = array_shift($dat);
        
			_main_::query(null, "
				update `users`
				set	`pwd_md5` = {2}
				,	`confirm` = 1
				where	`id` = {1}",
			$data['user_id'], md5($data['password']));

			$_SESSION['@id'] = $data['user_id'];
			
			return $data;
	}
	else
	{
		validate_add_error($errors, 'user', 'not_found');
	}

//	return false;
}

function forget_password(&$errors, &$data, &$id)
{
	$dat = _main_::query('row', "
		select	`id`
		from	`users`
		where	`email`	= {1}
		",
		$data['email']
	);

	if ($dat)
	{
		$id = array_shift($dat)['id'];

		$activator = rand(1001, 9999);

		_main_::query(null, "
			update 	`{$this->table}`
			set		`activator`	= {01}
			where	`id`		= {02}
		"
		,$activator
		,$id
		);
	}
	else
	{
		validate_add_error($errors, 'user', 'not_found');
	}
}

function prepare_public (&$errors, &$data, $config, $enums)
{
	$data['confirm'] = 0;
}

function update_public (&$errors, &$data, &$id, $orig = null)
{
	update_texts($data, $this->table, $this->multilang_fields);

	try { 
		if ($data['password1'])
		{

		_main_::query(null, "
		update 	`{$this->table}`
		set	`phone`		= {02}
		,	`email`		= {03}
		,	`last_name`	= {04}
		,	`comments`	= {05}
		,	`first_name`	= {06}
		,	`pwd_md5`	= {07}
		where	`id` = {1}
		", $id
		, $data['phone']
		, $data['email']
		, $data['last_name']
		, $data['comments']
		, $data['first_name']
		, md5($data['password1'])
		);
		
		}else
		{

		_main_::query(null, "
		update 	`{$this->table}`
		set	`phone`		= {02}
		,	`email`		= {03}
		,	`last_name`	= {04}
		,	`comments`	= {05}
		,	`first_name`	= {06}
		where	`id` = {1}
		", $id
		, $data['phone']
		, $data['email']
		, $data['last_name']
		, $data['comments']
		, $data['first_name']
		);

		}
		
		$this->handle_uploads_persistently($data);
	}
	catch (exception_db_unique $exception) { $this->handle_uploads_temporarily($data); _main_::depend('validations'); validate_add_error($errors, '', 'duplicate'); }
	catch (exception           $exception) { $this->handle_uploads_temporarily($data); throw $exception; }
}

function redirect(&$errors, &$data)
{
        if ($data['back'][0]!=='/') $data['back']='';
        else $data['back'] = substr($data['back'],1);

	if (strpos($data['back'], 'registration/confirm') === 0)
		_main_::Redirect(_config_::$dom_info['pub_site']);
	else
		_main_::Redirect(_config_::$dom_info['pub_site'].$data['back']);
}

// Выбока дополнительных данных юзера при каждом заходе
function data_parce (&$dat)
{
	_main_::depend('merges');
	
	foreach($dat as &$v)
	{
		$roles = explode(',', $v['roles']);
		$v['roles'] = [];
		if ($roles)
		foreach($roles as $i => $r)
		{
			$v['roles']['role:'.$i] = $r;
		}
		
		if (in_array('rop', $v['roles']))
		{
			$managers = _main_::query('employee', "
				select	`id`
				from	`{$this->table}`
				where	`branch` = {1}
				and		`roles` like '%manager%'
			"
			, $v['branch']
			);
			
			$v['employees'] = $managers;
		}
	}
}

function inline_login()
{
	_main_::depend('forms');
	_main_::depend('gp');
	_main_::depend('forms_class');
	_main_::depend('types_class');

	// Чтение конфига модуля, списков для полей выбора (для валидации и элементов формы) и других данных.
	$config=array();
	$enums=array();

	$fields = array(
		new TextField('email',null,true), 
		new TextField('password',null,true),
		new TextField('newpassword1'),
		new TextField('newpassword2'),
		new TextField('back'),
		new CheckBox('remember_pass')
	);

	$form = new Forms($fields);

	// Определение запрошенных действий и получение присланных данных.
	$errors = array();
	$action = determine_action("login_submit");
	if ($action === 'login_submit') $action = 'do'; // Просто костыль
	$data   = $form->form_posted($action);

	// Типичный сценарий операции: подгонка файлов, проверка значений, и либо обращение к базе, либо временное запоминание.
	if (($action !== null)                   )  $form->prepare  ($errors, $data, $config, $enums);
	if (($action === 'do') && !count($errors))  $form->validate ($errors, $data, $config, $enums);
	if (($action === 'do') && !count($errors))  $this->login ($errors, $data);
	if (($action === 'do') && !count($errors))
	{
		_main_::Redirect($_SERVER['REQUEST_URI']);
		die;
		#_main_::identify_visitor();
		#return true;
	}
	elseif (($action !== null)               )  $form->remember ($data);

	session_destroy(); // Защита от DDoS
	
	// В DOM!
	#list($gp_id, $gp_w, $gp_h) = gp_new_question();

	$dom = compact('action', 'data', 'errors', 'gp_id', 'gp_w', 'gp_h');
	_main_::put2dom(($action === 'do') && !count($errors) ? 'done' : 'form', $dom);
	_main_::put2dom('fields', $form->fields2dom($data));
	_main_::put2dom('auth_extended_policy', _config_::$auth_extended_policy);

	//_main_::set_module_xslt("/login/");
	_main_::$module_xslt = '../../.internals/modules.public/login/.xslt';
	
	throw new exception_bl_finish(); // тупо ранний выход из функций бизнес-логики.
}

function check ($roles = [])
{
	if ($roles && !is_array($roles)) $roles = [ $roles ];
	
	if (isset(_config_::$block_access) && _config_::$block_access)
	{
		if (!@$this->access)
			throw new exception_bl('No such record (by id).', 'id_absent', 'absent'); // Пока кажем 404
	}
	
	if (!_identify_::check())
	{
		if (preg_match('/Chrome/', @$_SERVER['HTTP_USER_AGENT']))
		{
			#_main_::Redirect(_config_::$dom_info['pub_site'].'login/'); // Устарело
			$this->inline_login();
		}
		else
		{
			throw new exception_bl('No such record (by id).', 'id_absent', 'absent'); // Пока кажем 404
		}
	}
	
	if ($roles)
	{
		if (in_array('admin', _identify_::$info['roles'])) return true;
		
		$find = false;
		foreach($roles as $role)
		{
			if (in_array($role, _identify_::$info['roles']))
			{
				$find = true;
				break;
			}
		}
		
		if (!$find)
			throw new exception_bl('No such record (by id).', 'id_absent', 'absent'); // Пока кажем 404
			// throw new exception_bl('Permission denied', 'permission', 'denied'); // ToDo: Сверстать страницу 403 "Доступ запрещён"
	}
}

function access ()
{
	$this->access = true;
}

function is ($roles)
{
	$result = true;
	if (!is_array($roles)) $roles = (array) $roles;
	
	foreach($roles as $role)
		if (!in_array($role, _identify_::$info['roles']))
		{
			$result = false;
			break;
		}
	return $result;
}

function is_metro ()
{
	// Если есть ключ is_fake_production_host и он true - не делается проверок авторизации в 
	// AdFileLoaded.php, GetAdFile.php, GetPlaylist.php, PlaylistLoaded.php - опция включается в /dev
	// или в папке разработчика, чтобы нормально работал эмулятор
	if (array_key_exists('is_fake_production_host', _config_::$dom_info) && _config_::$dom_info['is_fake_production_host'])
	{
		return true;
	}

	// is_production_host = true стоит в метро на рабочем сервере
	if (!_config_::$dom_info['is_production_host'])
	{
		return false;
	}

	// Для продакшн сервера проверяется IP, с которого пришел запрос,
	// чтобы метро могло брать файлы без авторизации
	foreach(_config_::$platform_ips as $ip => $val)
	{
		if (strpos($ip, $_SERVER['HTTP_X_REAL_IP']) !== false) return true;
	}

	return false;
}

################## READS ####################################

function select_by_ids (&$dat, $ids, $required = null, $details = null)
{
	if (!is_array($ids)) $ids = (array) $ids;
	
	$dat = !count($ids) ? array() : _main_::query($this->outfield, "
		select	A.*
		from	`{$this->table}` as A
		where	A.`id` in {1}
		", $ids);

	if ($required && !count($dat))
		throw new exception_bl('No such record (by id).', $this->outfield.'_absent', 'absent');
	fill_texts($dat,$this->multilang_fields);

	$this->select_details($dat, $details);
}

function select_by_profile_ids (&$dat, $ids, $required = null, $details = null)
{
	if (!is_array($ids)) $ids = (array) $ids;
	
	$dat = !count($ids) ? array() : _main_::query($this->outfield, "
		select	P.*, A.id, A.email, A.confirmed_at, A.confirmation_sent_at, P.id as profile_id, A.`encrypted_password`
			,A.`extended_policy`
			,A.`must_change_password`
			,A.`wrong_password_attempts`
			,A.`last_wrong_password_attempt`
			,A.`password_expiration_date`
			,A.`user_is_locked`
			,A.`user_lock_time`
			,A.`user_lock_mode`
			,A.`user_lock_comment`
		from	`profiles` as P
		inner	join `{$this->table}` as A on (A.`id` = P.`user_id`)
		where	P.`id` in {1}
		", $ids);

	if ($required && !count($dat))
		throw new exception_bl('No such record (by id).', $this->outfield.'_absent', 'absent');
	fill_texts($dat,$this->multilang_fields);

	$this->select_details($dat, $details);
}

function select_by_emails (&$dat, $emails, $required = null, $details = null)
{
	if (!is_array($emails)) $emails = (array) $emails;
	$dat = !count($emails) ? array() : _main_::query($this->outfield, "
		select	C.*
		from	`{$this->table}` as C
		where	C.`email` in {1}
		", $emails);
	if ($required && !count($dat))
		throw new exception_bl('No such record (by mr).', 'record_absent', 'absent');

	fill_texts($dat,$this->multilang_fields);
	$this->data_parce($dat);
	$this->select_details($dat, $details);
}

function select_by_hotels (&$dat, $hotels, $required = null, $details = null)
{
	if (!is_array($hotels)) $hotels = (array) $hotels;
	$dat = !count($hotels) ? array() : _main_::query($this->outfield, "
		select	P.*, A.id, A.email, A.confirmed_at, A.confirmation_sent_at, P.id as profile_id, A.`encrypted_password`
			,A.`extended_policy`
			,A.`must_change_password`
			,A.`wrong_password_attempts`
			,A.`last_wrong_password_attempt`
			,A.`password_expiration_date`
			,A.`user_is_locked`
			,A.`user_lock_time`
			,A.`user_lock_mode`
			,A.`user_lock_comment`
		from	`{$this->table}` as A
		inner	join `profiles` as P on (A.`id` = P.`user_id`)
		where	P.`hotel_id` in {1}
		", $hotels);
	if ($required && !count($dat))
		throw new exception_bl('No such record (by mr).', 'record_absent', 'absent');

	$this->select_details($dat, $details);
}

	function mail (&$errors, &$data, $doc, $email, $template, $files=array(), $send_copy=true)
	{
		// Потому как /*/done добавляется уже ПОСЛЕ операции, мы пихаем туда своё, а потом удалим.
		$node = _main_::put2dom('mail', $data);

		_main_::depend('mail');
		$txt = _main_::transform_by_file($doc, _config_::$messages_dir . $template . _config_::$messages_ext);
		send_multipart_mail(_config_::$mail_from, $email, null, $txt, $files);
		if ($send_copy)
		send_multipart_mail(_config_::$mail_from, _config_::$mail_copy, null, $txt, $files);

		// Удаляем временный элемент, созданный для шаблона сообщения.
		$node->parentNode->removeChild($node);
	}


function select_for_push (&$dat, $details = null)
{
	reset($this->admin_sorters);
	$key = key($this->admin_sorters);
	
	$order_clause = convert_sorters_to_sql_order_clause(array($key => $this->admin_sorters[$key]), 'N');

	$dat = _main_::query($this->outfield, "
		select	N.*, concat(`name`, ' (', `email`, ')') as `name`
		from	`{$this->table}` as N
		order	by {$order_clause}
		");

	fill_texts($dat,$this->multilang_fields);
	$this->select_details($dat, $details);
}

function select_for_admin (&$dat, $filters, $sorters, $pager, $details = null)
{
	$mapping = array();

    if ($this->admin_filters)
	{
		foreach($this->admin_filters as $f=>$v)
		{
			if ($v->mapping)
				$mapping = array_merge($mapping, $v->mapping);
		}
	}

	$where_clause = convert_filters_to_sql_where_clause($filters, 'A', $mapping, 'true');
	$order_clause = convert_sorters_to_sql_order_clause($sorters, 'A');
	#$limit_clause = convert_pager_to_sql_limit_clause  ($pager);
	$limit=$pager->limit();
	list($select_clause, $join_clause) = join_texts($this->multilang_fields,'A');
	if ($select_clause) $select_clause = ',	'.$select_clause;

	$sql = '';
	foreach($this->fields as $f=>$v) if ($v->list && !in_array($v->name, $this->multilang_fields)) if ($field = $v->sql_list('A')) $sql .= ','.$field;
	$sql = substr($sql, 1);

	$dat = _main_::query($this->outfield, "
		select	SQL_CALC_FOUND_ROWS A.*
		from	{$this->table} as A
		where {$where_clause}
		order	by {$order_clause}
		{$limit}
		");
		
	$pager->getTotal();
	$this->select_details($dat, $details);

	_main_::put2dom('auth_extended_policy', _config_::$auth_extended_policy);
}

// Выборка пользователей для работы с ними в публичной части
// additional_where позволяет выбирать пользователей только определенного типа, например, офицеров
function select_for_public_admin (&$dat, $filters, $sorters, $pager, $additional_where = null)
{
	$limit = $pager->limit();

	$order_clause = convert_sorters_to_sql_order_clause($sorters, null);
	$where = $filters->sql_where(null);
	
	if ($additional_where)
	{
		$where .= ' and '.$additional_where;
	}

	$dat = _main_::query('users', "
		select	P.*, A.id, A.email, A.`encrypted_password` 
				,A.`extended_policy`
				,A.`must_change_password`
				,A.`wrong_password_attempts`
				,A.`last_wrong_password_attempt`
				,A.`password_expiration_date`
				,A.`user_is_locked`
				,A.`user_lock_time`
				,A.`user_lock_mode`
				,A.`user_lock_comment`
				,concat(P.firstname,' ',P.middlename,' ',P.lastname) as fio
				,'' as district
				,'' as area
		from	{$this->table} as A
		inner	join `profiles` as P on (A.`id` = P.`user_id`)
		where {$where}
		order	by {$order_clause}
		{$limit}
		");
		
	$total = _main_::query(null, "
		select	count(*) as total
		from	{$this->table} as A
		inner	join `profiles` as P on (A.`id` = P.`user_id`)
		where {$where}
		");

	$pager->setTotal($total[0]['total']);
	//$this->select_details($dat, $details);
}

// Прописать округ и район, справлчники которых находятся в другой БД и поэтому не выбираются SQL запросом
function translate_district_and_area(&$dat)
{
	$d = _main_::fetchModule('dictionaries');

	foreach ($dat as $key => &$line)
	{
		if ($line['omvd'])
		{
			$line['area'] = $d->get_area($line['omvd']);
			$district_ext_id = $d->get_area_district_ext_id($line['omvd']);

			if ($district_ext_id)
			{
				$line['district'] = $d->get_district($district_ext_id);
			}
		}
	}
}

function translate_omvd(&$dat)
{
	$d = _main_::fetchModule('dictionaries');

	foreach ($dat as $key => &$line)
	{
		if ($line['omvd'])
		{
			if ($line['roles'] == 'officer,uvm')
			{
				$line['omvd'] = $d->get_authorityOrgan($line['omvd']);
			}
			if ($line['roles'] == 'officer,omvd')
			{
				$line['omvd'] = $d->get_omvd($line['omvd']);
			}
		}
	}
}

function select_for_filters ($id)
{
	$dat = _main_::query($this->outfield, "
		select	U.`name`
		from	`{$this->table}` as U
		where	id = {1}
		", $id);
	if ($dat) return array_shift($dat)['name'];
	else return '';
}

function select_details (&$struct, $details = null)
{
	_main_::depend('details');
	select_details_oop($this->essence,$struct, $details, array(
//		'xml'	=> 'select_xml'
	));
}

function select_xml(&$struct, $details = null) { _main_::depend('merges'); $m=_main_::fetchModule('xml');$m->select_by_users($dat, get_fields($struct, 'id'), $details); merge_subtable_as_array($struct, $dat, 'xml'   , 'user_id'  , 'id'); }

function setParam (&$dat, $id){
	
	$tmp = _main_::query(null, "
			select	id, configuration
			from	`profiles`
			where	`user_id` = {1}
			", $id);
			
	$configuration = json_decode(array_shift($tmp)['configuration'], true);
	
	foreach ($dat as $key => $value){
		$configuration[$key] = $value;
	}
	
	$jsonString = json_encode($configuration);
	
	_main_::query(null, "
		update 	`profiles`
		set	`configuration`		= {02}
		where	`user_id` = {1}
		", $id
		, $jsonString
		);
}

}
?>