<?php

// Version: 1.0

Class Pager
{
	var $page_count;
	var $page;
	var $onpage;
	var $total;

	function __construct($onpage){
		$this->onpage=($onpage)? (integer) $onpage:0;
	}

	function setPage($page=1)
	{
	        if ($page == 'all')
	        {
	        	$this->page = 1;
	        	$this->onpage = 0;
	        	return;
	        }

		$page = (integer) $page;
		if ($page < 1     ) $page = 1;
		#if ($page > $this->onpage) $page = $this->onpage;
		$this->page = $page;
	}

	function limit($if_empty=null)
	{
		if ($this->onpage <= 0)
		{
			$result = $if_empty;
		} else
		{
			$offset = (max(1, $this->page) - 1) * max(1, $this->onpage);
			$result = sprintf("limit %s offset %s", $this->onpage, $offset);
		}
		return $result;		
	}

	function setTotal($count)
	{
		$this->total = $count;

		$this->page_count = $count ? floor($count / $this->onpage) + ($count % $this->onpage ? 1 : 0) : 1;
		if ($this->page > $this->page_count) throw new exception_bl('Page out of range.', 'page_absent', 'absent');


	}

	function getTotal()
	{
        if ($this->onpage > 0)
        {
			$total=_main_::query(null, "SELECT FOUND_ROWS() as total");
			$t=array_shift($total);
			$t=array_shift($t);
		} else
			$t = 0;
			
		$this->setTotal($t);
		return $t;
	}

	function toDOM()
	{
		$ret=array('page'=>$this->page,'cycle'=>array(),'total'=>$this->total);
		for ($i=0;$i<$this->page_count;$i++){
			$ret['cycle']['page:'.$i]=$i+1;
		}
		return $ret;
	}
}

function fetch_page_from_path(&$pathargs)
{
	$page=1;
	for ($ind=0; $ind<count($pathargs);$ind++)
	{
		if (($pathargs[$ind]=='page')&&isset($pathargs[$ind+1]))
		{
			$page=$pathargs[$ind+1];
			unset($pathargs[$ind]);
			unset($pathargs[$ind+1]);
			break;
		}
	}
	return $page;
}
?>