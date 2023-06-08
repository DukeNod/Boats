<?php
#_main_::depend('db_class');

Class Dictionaries {

	function __construct()
	{
		
	}
	
	public function branches (&$dat, $all = true)
	{
		$dat = _main_::query('branch', 'SELECT `id`, `name` FROM branches where active = 1');
	}
	
	public function managers (&$dat)
	{
		$u = _main_::fetchModule('users');

		$where = ($u->is('rop')) ? '`branch` = '._identify_::$info['branch'].' and roles not like '."'%admin%'" : '1';

		$dat = _main_::query('manager', "SELECT `id`, `name` FROM users where $where order by name");
	}
	
	public function models (&$dat)
	{
		$dat = _main_::query('model', 'SELECT `id`, `name` FROM models where active = 1');
	}
	
	public function paytypes (&$dat)
	{
		$dat = _main_::query('paytype', 'SELECT `id`, `name` FROM paytype where active = 1');
	}
	
	public function organizations (&$dat)
	{
		$dat = _main_::query('organization', 'SELECT `id`, `name` FROM organization where active = 1');
	}
	
	public function regions (&$dat)
	{
		$dat = _main_::query('region', 'SELECT `id`, `name` FROM regions where active = 1');
	}
	
	public function get_id ($name, $table)
	{
		if (!$name) return null;
		
		$dat = _main_::query('row', 'SELECT `id` FROM '.$table.' WHERE `name` = {1}', $name);
		if (!isset($dat['row:0']))
		{
			return null;
		}
		return $dat['row:0']['id'];
	}
//-----------------------------------------------------------------------------
	public function get_country_name ($code)
	{
		return $this->db->GetData("SELECT `name` FROM `m12Dsaiwodx_custom_countries` WHERE `code`='".$code."'", 0)['name'];
	}
//-----------------------------------------------------------------------------
	public function get_country_short_name ($code)
	{
		return $this->db->GetData("SELECT `short_name` FROM `m12Dsaiwodx_custom_countries` WHERE `code`='".$code."'", 0)['short_name'];
	}
//-----------------------------------------------------------------------------
	function document_type (&$dat)
	{
		$dat_tmp = $this->db->GetData("SELECT `value` as id, `name` FROM `m12Dsaiwodx_custom_passportall`");
		
		foreach($dat_tmp as $f => $v)
		{
			$dat['passport:'.$f] = $v;
		}
	}
//-----------------------------------------------------------------------------
	public function get_passport_type ($code)
	{
		return $this->db->GetData("SELECT `name` FROM `m12Dsaiwodx_custom_passportall` WHERE `value`='".$code."'", 0)['name'];
	}
//-----------------------------------------------------------------------------
	function document_rus_type (&$dat)
	{
		$dat_tmp = $this->db->GetData("SELECT `value` as id, `name` FROM `m12Dsaiwodx_custom_ruspassport`");
		
		foreach($dat_tmp as $f => $v)
		{
			$dat['passport:'.$f] = $v;
		}
	}
//-----------------------------------------------------------------------------
	function purpose_type (&$dat)
	{
		$dat_tmp = $this->db->GetData("SELECT `value` as id, `name` FROM `m12Dsaiwodx_custom_aims`");
		
		foreach($dat_tmp as $f => $v)
		{
			$dat['aims:'.$f] = $v;
		}
	}
//-----------------------------------------------------------------------------
	public function get_entrancePurpose ($code)
	{
		return $this->db->GetData("SELECT `name` FROM `m12Dsaiwodx_custom_aims` WHERE `value`='".$code."'", 0)['name'];
	}
//-----------------------------------------------------------------------------
	function visa_type (&$dat)
	{
		$dat_tmp = $this->db->GetData("SELECT `value` as id, `name` FROM `m12Dsaiwodx_custom_visatype`");
		
		foreach($dat_tmp as $f => $v)
		{
			$dat['type:'.$f] = $v;
		}
	}
//-----------------------------------------------------------------------------
	public function get_visa_type ($code)
	{
		return $this->db->GetData("SELECT `name` FROM `m12Dsaiwodx_custom_visatype` WHERE `value`='".$code."'", 0)['name'];
	}
//-----------------------------------------------------------------------------
	function visa_category (&$dat)
	{
		$dat_tmp = $this->db->GetData("SELECT `value` as id, `name` FROM `m12Dsaiwodx_custom_visacategory`");
		
		foreach($dat_tmp as $f => $v)
		{
			$dat['category:'.$f] = $v;
		}
	}
//-----------------------------------------------------------------------------
	public function get_visa_category ($code)
	{
		return $this->db->GetData("SELECT `name` FROM `m12Dsaiwodx_custom_visacategory` WHERE `value`='".$code."'", 0)['name'];
	}
//-----------------------------------------------------------------------------
	function visa_multiplicity (&$dat)
	{
		$dat_tmp = $this->db->GetData("SELECT `value` as id, `name` FROM `m12Dsaiwodx_custom_kratnost`");
		
		foreach($dat_tmp as $f => $v)
		{
			$dat['category:'.$f] = $v;
		}
	}
//-----------------------------------------------------------------------------
	public function get_visa_multiplicity ($code)
	{
		return $this->db->GetData("SELECT `name` FROM `m12Dsaiwodx_custom_kratnost` WHERE `value`='".$code."'", 0)['name'];
	}
//-----------------------------------------------------------------------------
	function visa_visitPurpose (&$dat)
	{
		$dat_tmp = $this->db->GetData("SELECT `value` as id, `name` FROM `m12Dsaiwodx_custom_visafields`");
		
		foreach($dat_tmp as $f => $v)
		{
			$dat['category:'.$f] = $v;
		}
	}
//-----------------------------------------------------------------------------
	public function get_visa_visitPurpose ($code)
	{
		return $this->db->GetData("SELECT `name` FROM `m12Dsaiwodx_custom_visafields` WHERE `value`='".$code."'", 0)['name'];
	}
//-----------------------------------------------------------------------------
	function prolongation_reason (&$dat)
	{
		$dat_tmp = $this->db->GetData("SELECT `value` as id, `name` FROM `m12Dsaiwodx_custom_prolongation`");
		
		foreach($dat_tmp as $f => $v)
		{
			$dat['reason:'.$f] = $v;
		}
	}
//-----------------------------------------------------------------------------
	public function get_prolongationReason ($code)
	{
		return $this->db->GetData("SELECT `name` FROM `m12Dsaiwodx_custom_prolongation` WHERE `value`='".$code."'", 0)['name'];
	}
//-----------------------------------------------------------------------------
	function state_program_member (&$dat)
	{
		$dat_tmp = $this->db->GetData("SELECT `value` as id, `name` FROM `m12Dsaiwodx_custom_zaiavitel`");
		
		foreach($dat_tmp as $f => $v)
		{
			$dat['member:'.$f] = $v;
		}
	}
//-----------------------------------------------------------------------------
	public function get_stateProgramMember ($code)
	{
		return $this->db->GetData("SELECT `name` FROM `m12Dsaiwodx_custom_zaiavitel` WHERE `value`='".$code."'", 0)['name'];
	}
//-----------------------------------------------------------------------------
	public function get_authorityOrgan ($code)
	{
		if(!$code) return NULL;
		return $this->db->GetData("SELECT `name` FROM `m12Dsaiwodx_custom_organs` WHERE `ext_id`='".$code."'", 0)['name'];
	}
//-----------------------------------------------------------------------------
	public function get_omvd ($code)
	{
		if(!$code) return NULL;
		return $this->db->GetData("SELECT `name` FROM `m12Dsaiwodx_custom_omvd` WHERE `ext_id`='".$code."'", 0)['name'];
	}
//-----------------------------------------------------------------------------
	public function get_district ($code)
	{
		if(!$code) return NULL;
		return $this->db->GetData("SELECT `name` FROM `m12Dsaiwodx_custom_district` WHERE `ext_id`='".$code."'", 0)['name'];
	}
//-----------------------------------------------------------------------------
	public function get_area ($code)
	{
		if(!$code) return NULL;
		return $this->db->GetData("SELECT `name` FROM `m12Dsaiwodx_custom_area` WHERE `ext_id`='".$code."'", 0)['name'];
	}
//-----------------------------------------------------------------------------
	public function get_area_district_ext_id ($code)
	{
		if(!$code) return NULL;
		return $this->db->GetData("SELECT `district_ext_id` FROM `m12Dsaiwodx_custom_area` WHERE `ext_id`='".$code."'", 0)['district_ext_id'];
	}
//-----------------------------------------------------------------------------
	public function areas_by_district_ext_id ($district_ext_id)
	{
		if (!$district_ext_id)
		{
			return null;
		}

		$dat_tmp = $this->db->GetData("SELECT `ext_id` FROM `m12Dsaiwodx_custom_area` WHERE `district_ext_id`='".$district_ext_id."'");

		foreach($dat_tmp as $tmp)
		{
			$dat[] = $tmp['ext_id'];
		}

		return $dat;
	}

//-----------------------------------------------------------------------------
	function district (&$dat)
	{
		$dat_tmp = $this->db->GetData("SELECT `ext_id` as id, `name` FROM `m12Dsaiwodx_custom_district`");
		
		foreach($dat_tmp as $f => $v)
		{
			$dat['district:'.$f] = $v;
		}
	}
//-----------------------------------------------------------------------------
	function area (&$dat)
	{
		$dat_tmp = $this->db->GetData("SELECT `ext_id` as id, `name` FROM `m12Dsaiwodx_custom_area`");
		
		foreach($dat_tmp as $f => $v)
		{
			$dat['area:'.$f] = $v;
		}
	}
//-----------------------------------------------------------------------------
	public function get_kpp_id_by_code ($code)
	{
		if(!$code) return NULL;
		return $this->db->GetData("SELECT `id` FROM `m12Dsaiwodx_custom_kpp` WHERE `code`='".$code."'", 0)['id'];
	}
//-----------------------------------------------------------------------------
	public function get_housing_by_type ($code)
	{
		return $this->addressObjectType[$code];
	}
//-----------------------------------------------------------------------------
	public function get_address_by_fias ($code)
	{
		if(trim($code)=="") return NULL;
		$street = $this->db->GetData("SELECT `shortname`, `formalname`, `parentguid` FROM `m12Dsaiwodx_custom_addrob` WHERE `aoid`='".$code."' and `actstatus` = 1", 0);
		$parent = $street['parentguid'];

		$address = [];
				
		do
		{
			$row = $this->db->GetData("SELECT `shortname`, `formalname`, `parentguid` FROM `m12Dsaiwodx_custom_addrob` WHERE `aoguid`='".$parent."' and `actstatus` = 1", 0);
			$address[] = ($row['shortname'] ? $row['shortname'].'. ' : '') . $row['formalname'];
			$parent = $row['parentguid'];
		}
		while ($parent);
		
		$address = array_reverse($address, true);
		$address = join(', ', $address);
		
		$st = trim(($street['shortname'] ? $street['shortname'].'. ' : '') . $street['formalname']);
		$address .= $st=="" ? "" : ', ' . $st;
		
		return $address;
	}
//-----------------------------------------------------------------------------
	public function get_aoid_from_guid_fias ($guid)
	{
		if(!$guid) return NULL;
		$term = mysqli_real_escape_string($this->db->conn, $guid);
		return $this->db->GetData("select `aoid` from `m12Dsaiwodx_custom_addrob` where `aoguid` = '{$term}' and `actstatus` = 1", 0)['aoid'];
	}
//-----------------------------------------------------------------------------	
	public function get_address_by_fias_array ($code)
	{
		$street = $this->db->GetData("SELECT `shortname`, `formalname`, `parentguid` FROM `m12Dsaiwodx_custom_addrob` WHERE `aoid`='".$code."' and `actstatus` = 1", 0);
		$parent = $street['parentguid'];
		
		$address = [];
				
		do
		{
			$row = $this->db->GetData("SELECT `aolevel`, `shortname`, `formalname`, `parentguid` FROM `m12Dsaiwodx_custom_addrob` WHERE `aoguid`='".$parent."' and `actstatus` = 1", 0);
			$address[$row['aolevel']] = ($row['shortname'] ? $row['shortname'].'. ' : '') . $row['formalname'];
			$parent = $row['parentguid'];
		}
		while ($parent);
		
		$address = array_reverse($address, true);
		
		$address[7] = ($street['shortname'] ? $street['shortname'].'. ' : '') . $street['formalname'];
		
		return $address;
	}
//-----------------------------------------------------------------------------	
	public function find_fias_address_by_array ($array)
	{
		$aolevels = [
				'region' =>	1
			,	'area' =>	3
			,	'city' =>	'4,5,6'
			,	'np' =>		'5,6'
			,	'mkr' =>	'5,6'
			,	'street' =>	7
		];
		
		$left= 0; $right = 0;
		
		if ($array['region'] && $array['region'] == $array['city']) $array['city'] = ''; // Город-регион. (Москва, Питер)
		
		if (!$array['np'] && !$array['mkr'] && !$array['street']) return false;
		
		foreach($array as $level=>$value)
		{
			if (!$value) continue;
			
			$aolevel = $aolevels[$level];
			
			$where = ($left) ? "and `left` > $left and `right` < $right" : "";
			
			$obj = $this->db->GetData("
				SELECT `aoid`, `left`, `right`
				FROM `m12Dsaiwodx_custom_addrob`
				WHERE `aolevel` in (".$aolevel.")
				$where 
				and MATCH(`formalname`) AGAINST ('".mysqli_escape_string($this->db->conn, $value)."')
				and `actstatus` = 1
				order by `aolevel`
			", 0);
				//and `formalname` like '".mysqli_escape_string($this->db->conn, $value)."%' 
			
			if (!$obj) return false;
			
			$left = $obj['left']; $right = $obj['right'];
			$aoid = $obj['aoid'];
		}
		
		return $aoid;
	}
//-----------------------------------------------------------------------------	
	public function get_kpp_by_id ($id)
	{
		return $this->db->GetData("SELECT `name` FROM `m12Dsaiwodx_custom_kpp` WHERE `id`='".$id."'", 0)['name'];
	}
//-----------------------------------------------------------------------------	
	public function get_organ ($ext_id)
	{
		return $this->db->GetData("SELECT `name_clean` FROM `m12Dsaiwodx_custom_organs` WHERE `ext_id`='".$ext_id."'", 0)['name_clean'];
	}
//-----------------------------------------------------------------------------
	public function get_organ_code ($ext_id)
	{
		return $this->db->GetData("SELECT `code` FROM `m12Dsaiwodx_custom_organs` WHERE `ext_id`='".$ext_id."'", 0)['code'];
	}
}
?>