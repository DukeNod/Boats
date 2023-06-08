<?php
include_once('../../.internals/config.php');

global $db_host, $db_login, $db_password, $db_name;

$db_host = _config_::$db_server2;
$db_name = _config_::$db_database2;
$db_login = _config_::$db_username2;
$db_password = _config_::$db_password2;

Class Base {
	var $db_host;
	var $db_login;
	var $db_password;
	var $db_name;
	var $result;

function __construct()
{
	global $db_host, $db_login, $db_password, $db_name;
	$this->db_host = $db_host;
	$this->db_login = $db_login;
	$this->db_password = $db_password;
	$this->db_name = $db_name;
	$this->ConnectionOpen();
}

function ConnectionOpen() {
	$this->conn = mysqli_connect($this->db_host,$this->db_login,$this->db_password);
	mysqli_select_db($this->conn, $this->db_name);
	mysqli_query($this->conn, 'set charset utf8');
	#mysqli_query('set names cp1251');
}
function ConnectionClose() {
	mysqli_close();
}
function CheckError() {
	if (mysqli_errno()!=0) {
		echo "Error: ";
		mysqli_error();
		exit;
	}
}

	function query($query)
	{
		$this->result=mysqli_query($this->conn, $query);
		if (!$this->result) {$err=mysqli_error($this->conn)."<br>".$query; print_backtrace(); die("<br>".$err);}
		return $this->result;
	}

	function fetchRow($res)
	{
		$row=mysqli_fetch_array($res, MYSQLI_ASSOC);
		return $row;
	}

	function GetData($query, $many=1)
	{
		$mass = false;
		$this->result = $this->query($query);
		if ($many)
			while ($row = $this->fetchRow($this->result))	{$mass[]=$row;}
		else $mass=$this->fetchRow($this->result);
			return $mass;
	}

	function GetDataById($query)
	{
		$this->result = $this->query($query);
		while ($row = $this->fetchRow($this->result))	{$mass[$row['id']]=$row;}
			return $mass;
	}

	function GetPage($query, $page)
	{
		global $onpage;
		$start=($page)?($page-1)*$onpage:0;
		$query.=" limit $start,$onpage";
		$this->result = $this->query($query);
		while ($row = $this->fetchRow($this->result))	{$mass[]=$row;}
			return $mass;
	}

	function CountDB($type=0)
	{
		if ($type==1){
		$result=$this->query("SELECT FOUND_ROWS() as total");
		$row=$this->fetchRow($result);
		$total=$row['total'];
		}
		else
		$total=mysqli_num_rows($this->result);
		return $total;
	}

	function UpdateDB($values,$table,$id)
	{
		if (!empty($values)){
		$str="";
		foreach($values as $f=>$v) {$str .= ','.$f."='".$v."'";}
		
		$str=substr($str,1);
		$query="update $table set $str where id=$id";
		$this->result = $this->query($query);
		}
	}

	function InsertDB($values,$table)
	{
		if (!empty($values)){
		$fields=""; $vals="";
		foreach($values as $f=>$v) {$fields.="$f,"; $vals.="'$v',";}
		$fields=substr($fields,0,-1);
		$vals=substr($vals,0,-1);
		$query="insert into $table ($fields) values ($vals)";
		$this->result = $this->query($query);
		$ret=mysqli_insert_id();
		}
		return $ret;
	}

	function DeleteDB($ids,$table)
	{
		if (!empty($ids)){
			$query="delete from $table where id in ($ids)";
			$this->result = $this->query($query);
			$ret=mysqli_affected_rows();
		}
		return $ret;
	}

    function pagestr($total,$url,$page=1)
    {
    	global $onpage;
	if (empty($page)) $page=1;
	$pagestr="";
	if(strpos($url,'?')===false) $url.='?';
	else $url.='&';	
#	$onpage=ONPAGE;
	if (($total>$onpage)||($total==$onpage&&$page>1))
	{
		// Число страниц
		$tpages=($total-1)/$onpage+1; $tpages=(int)$tpages;
		// Текущий десяток
		$sgroup=($page-1)/10; $sgroup=(int)$sgroup;
		if ($sgroup>0)
		{
			$prev=($sgroup-1)*10+1;
			$prev2=$sgroup*10;
			$pagestr.=" <a class='pagestr' href='$url"."page=$prev'>$prev-$prev2</a> ";
		}
		$pstart=$sgroup*10+1;
		$pend=$sgroup*10+10;
		$pend=($tpages>$pend)?$pend:$tpages;
		for ($i=$pstart;$i<=$pend;$i++)
		{
			if ($i==$page){
				$pagestr.=" <a class='pagestr'><b>$i</b></a> |";
			}else{
				$pagestr.=" <a class='pagestr' href='$url"."page=$i'>$i</a> |";
			}
		}
		if ($tpages>$pend)
		{
			$next=($sgroup+1)*10+1;
			$next2=($sgroup+1)*10+10;
			$pagestr.=" <a class='pagestr' href='$url"."page=$next'>$next-$next2</a> |";
		}
		$pagestr=substr($pagestr,0,-2);
		$pagestr="Страницы: $pagestr";
	}
	return $pagestr;
    }

	function debug($var){
			echo "<pre>"; print_r($var); echo "</pre>";
	}
    
	function Recurse(&$values, $parent=0){
		if (is_array($values)){
		$j=0;
		$tmp=count($values);
		for($i=0;$i<$tmp;$i++){
			if ($values[$i]['parent']==$parent){
				$ret[$j]=$values[$i];
				$ret[$j]['childs']=$this->Recurse($values,$values[$i]['id']);
				$j++;
			}
		}
		}
		return $ret;
	}

	function RecurseGetIds(&$values, $parent=0){
		$ret=Array($parent);
		if (is_array($values)){
		#$j=0;
		for($i=0;$i<count($values);$i++){
			if ($values[$i]['parent']==$parent){
				#$ret[]=$values[$i]['id'];
				$tmp=$this->RecurseGetIds($values,$values[$i]['id']);
				$ret=array_merge($ret,$tmp);
				#$j++;
			}
		}
		}
		return $ret;
	}

	function GetRecursive($query){
		$values=$this->GetData($query);
		return $this->Recurse($values);
	}

	function &Recurse2(&$values, $parent=0){
		if (is_array($values))
		{
			$j=0;
			$tmp=count($values);

			$start = $t = $this->bin_search($values, 'parent', $parent);

			for($i=$t;$i>=0;$i--)
			{
				if ($values[$i]['parent']==$parent)
				{
					$start = $i;
				}
				else break;
			}
			
			for($i=$start;$i<$tmp;$i++)
			{
				if ($values[$i]['parent']==$parent)
				{
					//$start = true;
					$ret[$j]=$values[$i];
					$ret[$j]['childs'] =& $this->Recurse2($values,$values[$i]['id']);
					$j++;
				}
				else break;
			}
		}
		return $ret;
	}

	function bin_search(&$A, $key, $value)
	{
	        if (!count($A)) return false;

	        $l = 0; $u = count($A)-1;

		while(1)
		{
		    $m = round(($l + $u)/2);
		    if ($value < $A[$m][$key])
		    {
			$u = $m - 1;
		    }elseif ($value > $A[$m][$key])
		    {
			$l = $m + 1;
		    }else
			return $m;

		    if ($l > $u) return false;
    		}
	}

	function GetRecursive2($query){
		$values=$this->GetData($query);
                debug2("OK0.01");
		return $this->Recurse2($values);
	}
}
?>