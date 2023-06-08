<?php
class _common_
{
	public static $brands = null;
}

function fetch_every_page_content ($no_head_imgs = false)
{
// xslts/public.xslt - шапка страницы
/*
	$check_date=date('Y-m-d H:i:s', time()-2*24*3600);
	$r = _main_::query(null, "
		SELECT count(*) AS `cnt`
		FROM `requests` as R
		left join `requests` as R1 on (R1.`removed` = R.id and R1.response_state = 0)
		WHERE R.`sig`=0 AND R.`hotelier_profile_id`={01} AND R.`created_at`>{02}
		and		R.response_state is null
		and		(R.`state`='created' OR R.`state`='corrected' OR R.`state`='updated')
		and		(R.operation = 0 or (R.operation = 1 and R1.state in ('processed', 'closed')))
		GROUP BY R.`sig`
	"
	,_identify_::$info['profile']['id']
	,$check_date
	);
	_main_::put2dom("alerts", $data);
*/	

        /*
	fetch_inlines(array(
		'main:logo',
		':html:contacts',
		':html:copyright',
		':html:counters',
		':html:phones',
		':html:howard',
		':html:banner',
		':html:regions',
		':html:informer',
		':meta:title:default',
		':meta:title:prolog',
		':meta:title:epilog',
		':meta:keywords:default',
		':meta:keywords:prolog',
		':meta:keywords:epilog',
		':meta:keywords:middle',
		':meta:description:default',
		':meta:description:prolog',
		':meta:description:epilog',
		));
		*/

//	fetch_words();
//	fetch_over_meta();

//	fetch_news(1);

	//if (!$basket) fetch_basket();

//	fetch_menu();

	_main_::depend('sql');
	
	$b = _main_::fetchModule('branches');
	$b->select_for_select($branches);
	_main_::put2dom('branches', $branches);
}

/*
function fetch_over_meta ()
{
        $url = _main_::dom_query('//system/curr_raw');
	$pub_root = _config_::$dom_info['pub_root'];
	if (substr($url,-1)!=='/') $url.='/';
	if ($pub_root!=='/'&&(strpos($url, $pub_root)===0))
		$url='/'.substr($url,strlen($pub_root));

	$dat = _main_::query('row','
		select * 
		from meta 
		where url = {1}
		', $url);

	if ($dat)
	_main_::put2dom('over_meta', array_shift($dat));
}
*/

function fetch_over_meta ()
{
        $url = _main_::dom_query('/*/system/curr_raw');
	$pub_root = _config_::$dom_info['pub_root'];
	if (substr($url,-1)!=='/') $url.='/';
	if ($pub_root!=='/'&&(strpos($url, $pub_root)===0))
		$url='/'.substr($url,strlen($pub_root));

	$m = _main_::fetchModule('meta');
	$m->select_by_url($dat, $url, array('linked_paras' => true));

	if ($dat)
	_main_::put2dom('over_meta', array_shift($dat));
}

function print_check (&$pathargs)
{
	$print=false;
	if (count($pathargs)&&$pathargs[count($pathargs)-1]=='print')
	{
		$print=true;
		unset($pathargs[count($pathargs)-1]);
	}

	if ($print||isset($_GET['print']))
	{
		_main_::put2dom('print');
	}
}

function fetch_domain_descr()
{
	$m=_main_::fetchModule('domains');
	$m->select_for_main($dat, null);
	_main_::put2dom('domains', $dat);
}

function fetch_domain()
{
	if ($_GET['main_page'] == 1)
		return null;
	else
		return LANG_ID;
        /*
	if (isset($_GET['domain'])&&($_GET['domain']!='www')){
		$m=_main_::fetchModule('domains');
		$m->select_by_mr($dat, $_GET['domain'], true);
		$dat=array_shift($dat);
		_main_::put2dom('domain', $dat);
		return $dat['id'];
        }else
		return null;
	*/
}

function fetch_articles ($limit)
{
	$m=_main_::fetchModule('articles');
	$m->select_where_latest($dat, $limit, null, false);
	_main_::put2dom('articles_latest', $dat);
}

function fetch_news ($limit)
{
	$m=_main_::fetchModule('news');
	$m->select_where_latest($dat, $limit, array('linked_picts'=>true));
	_main_::put2dom('news_latest', $dat);
}


function fetch_brands ()
{
	$m=_main_::fetchModule('brands');
	$m->select_for_read(_common_::$brands);	
	_main_::put2dom('main_brands', _common_::$brands);
}


function fetch_top_categories ()
{
	$m=&_main_::fetchModule('categories');
	$m->select_for_read($dat, 1, 0, array('linked_picts'=>true)); // 
	_main_::put2dom('top_categories', $dat);
}

function fetch_menu ()
{
	$m=_main_::fetchModule('pages');
	$m->select_by_mr($dat, 'services', false, array('subpages_public' => array()));
	if ($dat)
	_main_::put2dom('menu-services', array_shift($dat));
}

function fetch_main ()
{
        $main = array();
        $pages = array('about', 'fishing', 'gallery', 'services');

	$m=_main_::fetchModule('pages');

	foreach($pages as $page)
	{
		$m->select_by_mr($dat, $page, false, array('linked_picts' => true));
		if ($dat) $main[$page] = array_shift($dat);
	}

	if ($main)
	_main_::put2dom('main-menu', $main);
}

function fetch_inlines ($labels)
{
	$m=&_main_::fetchModule('inlines');
	$m->select_by_labels($dat, $labels, true);
	_main_::put2dom('inlines', $dat);
}

function fetch_words()
{
	$m = _main_::fetchModule('inlines');
	$m->select_all_words($dat);
	_main_::put2dom('inlines', $dat);
}


function fetch_banners()
{
	$m = _main_::fetchModule('banners');
	$m->select_for_read($dat, true);
	/*
	foreach ($dat as $i=>$banner){
		
		$ban_name=substr($banner['linked_files']['linked_file:0']['attach_name'],0,strpos($banner['linked_files']['linked_file:0']['attach_name'], ".swf"));
		if ($ban_name) $dat[$i]['linked_files']['linked_file:0']['attach_name']=$ban_name;
		}
	*/
	_main_::put2dom('banners', $dat);

}

function fetch_basket()
{
	$m =& _main_::fetchModule('orders');

	$cargo = $m->get_price_of_cargo();
	$cargo['order'] = $_SESSION['order'];
	_main_::put2dom('cargo', $cargo);
}

function fetch_offers($limit)
{
	$m = _main_::fetchModule('offers');
	$m->select_where_latest ($dat, $limit, array('linked_picts'=>true));
	_main_::put2dom('main-offers', $dat);
}

function fetch_questions($limit)
{
	$m = _main_::fetchModule('questions');
	$m->select_where_latest ($dat, $limit, array('linked_picts'=>true));
	_main_::put2dom('main-questions', $dat);
}

function fetch_spec($limit)
{
	$m = _main_::fetchModule('items');
	$m->select_spec ($dat, $limit, array('linked_picts'=>true));
	_main_::put2dom('main-spec', $dat);
}

function fetch_votes($limit)
{
	$m = _main_::fetchModule('votes');
	$m->select_latest($dat, $limit);
	if ($dat)
	_main_::put2dom('main-vote', array_shift($dat));
}

function fetch_head_images($limit)
{
	$i = _main_::fetchModule("items");
	$i->select_rand_images($dat, $limit);
	_main_::put2dom('head_linked_picts', $dat);
	
}
?>