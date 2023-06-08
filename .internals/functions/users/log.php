<?php
class UsersLog extends Base_Module
{
	var $time = null;
	
	function __construct()
	{
		parent::__construct('user_log', 'user_log', 'Логи');
	}
	
	function log_request()
	{
		$method = $_SERVER['REQUEST_METHOD'];
		
		if (preg_match('|^/([^/]+)/|', $_SERVER['REQUEST_URI'], $match))
		{
			$type = $match[1];
		}
		else $type = null;
		
		if (preg_match('|(?<!page)/(\d+)/|u', $_SERVER['REQUEST_URI'], $match))
		{
			$id = $match[1];
		}
		else $id = null;

		$this->time = DateTime::createFromFormat('U.u', sprintf('%.4f', microtime(TRUE)))->format('Y-m-d H:i:s.v');
		
		$id = _main_::query(null, "
			insert into user_log (`date`, method, type, url, id, `user`)
			values (now(3), {02}, {03}, {04}, {05}, {06})
		"
		, $this->time
		, $method
		, $type
		, $_SERVER['REQUEST_URI']
		, $id
		, _identify_::id()
		);
	}

	function select_for_list (&$dat, $filters, $sorters, $pager, $details = null)
	{
		$limit = $pager->limit();

		$order_clause = convert_sorters_to_sql_order_clause($sorters, 'A');
		
		$where = $filters->sql_where("A");

		$dat = _main_::query($this->outfield, "
			select	A.*
			from	{$this->table} as A
			where	{$where}
			order	by {$order_clause}
			{$limit}
		");

		if (!($where === 'true' && $pager->page == 1 && !isset($_GET['sorter'])))
		{
			$where_op = $where;
			$total = _main_::query(null, "
				select	count(*) as total
				from	{$this->table} as A
				where	{$where}
				");

			$pager->setTotal($total[0]['total']);
			$this->select_details($dat, $details);
		}
	}

	function update_id($id = null)
	{
		if ($id)
		{
			_main_::query(null, "
				update	user_log
				set		id = {1}
				where	date = {2} and `user` = {3}
			"
			, $id
			, $this->time
			, _identify_::id()
		);
		}
	}

	function select_details (&$struct, $details = null)
	{
		_main_::depend('details');
		select_details_oop($this->essence,$struct, $details, array(
	//		'xml'	=> 'select_xml'
		));
	}
}
?>