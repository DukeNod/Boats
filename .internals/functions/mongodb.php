<?php

class _mongo_
{
	public static $db = null;
	public static $conn = null;
	
	public static function connection ($force = false)
	{
		// Если подключение уже есть, то его и возвращаем.
		if ((!$force) && (self::$db !== null)) return self::$db;
		
		require_once __DIR__.'/_external_/vendor/autoload.php';
		
		self::$conn = new MongoDB\Client('mongodb://'._config_::$mongodb_username.':'._config_::$mongodb_password.'@'._config_::$mongodb_server.':'._config_::$mongodb_port.'/'._config_::$mongodb_database);

		self::$db = self::$conn->selectDatabase(_config_::$mongodb_database);

		return self::$db;
	}

	public static function collection ($collection)
	{
		$db = self::connection();
		return $db->selectCollection($collection);
	}
	
	public static function __callStatic($name, $arguments)
	{
		return self::collection($name);
	}

}

?>