<?php
set_time_limit(0);
_main_::depend('multilang');
_main_::depend('merges');

	$dat = unserialize(file_get_contents('inlines.ser'));

	foreach($dat as &$v)
	{	
	        $v['content'] = null;

	        preg_replace('/text\:/','/:html\:/',$v['label']);

	        $id = 0;

	        if ($v['texts']) foreach($v['texts'] as $vv)
	        {		
		        if ($id == 0)
		        {
				_main_::query(null,"
					INSERT INTO `texts`
					set	`lang_id`	= {2}
					,	`text`		= {3}
				"
				,null
				,$vv['lang_id']
				,$vv['text']
				);

				$id=mysql_insert_id();
			        $v['content'] = $id;
			}else
			{
				_main_::query(null,"
					INSERT INTO `texts`
					set	`lang_id`	= {2}
					,	`text`		= {3}
					,	`text_id`	= {4}
				"
				,null
				,$vv['lang_id']
				,$vv['text']
				,$id
				);
			}
	        }

		_main_::query(null, "insert 
			into	`inlines`
			set	`group`		= {1}
			,	`mode`		= {2}
			,	`content`	= {3}
			,	`label`		= {4}
			,	`comment`	= {5}
			,	`search_url`	= {6}
			,	`search_title`	= {7}
		"
		,	$v['group']
		,	$v['mode']
		,	$v['content']
		,	$v['label']
		,	$v['comment']
		,	$v['search_url']
		,	$v['search_title']
		);
	}

	
_main_::put2dom("done");
?>