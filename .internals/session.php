<?php

class MySQLSession implements SessionHandlerInterface
{
    private $link;
    
    public function open($savePath, $sessionName)
    {
		return true;
    }
    public function close()
    {
//        mysqli_close($this->link);
        return true;
    }
    
    public function read($id)
    {
		$result = _main_::query(null,"SELECT data FROM php_session WHERE id = {1} AND (expires > now())", $id); // `user_id` is not null or
		
        if($result)
        {
            return array_shift($result)['data'];
        }
        else
        {
            return "";
        }
    }
    
    public function write($id, $data)
    {
		$user = unserialize($data);
		
        $result = _main_::query(null,"
        	REPLACE INTO `php_session`
        	SET	`id`		= {1}
        	,	`expires`	= NOW() + INTERVAL 1 DAY
        	,	`data`		= {2}
        	,	`user_id`	= {3}
        	"
        	,	$id
        	,	$data
        	,	isset($user['@id']) ? $user['@id'] : null
        	);

        // Обернуть и вернуть false в случае эксепшона       	
		return true;
    }
    
    public static function write_now()
    {
        $result = _main_::query(null,"
        	REPLACE INTO `php_session`
        	SET	`id`		= {1}
        	,	`expires`	= NOW() + INTERVAL 1 DAY
        	,	`data`		= {2}
        	,	`user_id`	= {3}
        	"
        	,	session_id()
        	,	serialize($_SESSION)
        	,	isset($_SESSION['@id']) ? $_SESSION['@id'] : null
        	);
    }
    
    public function destroy($id)
    {
        $result = _main_::query(null,"DELETE FROM php_session WHERE id = {1}", $id);
        
		return true;
		/*
        if($result){
            return true;
        }else{
            return false;
        }
        */
    }
    
    public function gc($maxlifetime)
    {
        $result = _main_::query(null,"DELETE FROM php_session WHERE `expires` < NOW()"); // `user_id` is null and
        
		return true;
		/*
        if($result){
            return true;
        }else{
            return false;
        }
        */
    }
}
ini_set('session.serialize_handler', 'php_serialize');

$session_handler = new MySQLSession();
session_set_save_handler($session_handler, true);

?>