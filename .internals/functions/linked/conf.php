<?
function &uplinks_config(){
	$uplinks_conf['category']=array(
			'@sname'=>'categories',
			'@stitle'=>'Категории товаров',
			'@fieldname'=>'name'
		);
	$uplinks_conf['item']=array(
			'@sname'=>'items',
			'@stitle'=>'Товары',
			'@fieldname'=>'name'
		);
	$uplinks_conf['inline']=array(
			'@sname'=>'inlines',
			'@stitle'=>'Текстовые вставки',
			'@fieldname'=>'label'
		);

	$uplinks_conf['article']=array(
			'@sname'=>'articles',
			'@stitle'=>'Статьи',
			'@fieldname'=>'name'
		);
	$uplinks_conf['page']=$uplinks_conf['page_gallery']=array(
			'@sname'=>'pages',
			'@stitle'=>'Статические страницы',
			'@fieldname'=>'name'
		);
	$uplinks_conf['manager']=array(
			'@sname'=>'managers',
			'@stitle'=>'Менеджеры',
			'@fieldname'=>'name'
		);

	$uplinks_conf['news']=$uplinks_conf['news_gallery']=array(
			'@sname'=>'news',
			'@stitle'=>'Новости',
			'@fieldname'=>'title'
		);
	$uplinks_conf['contact']=array(
			'@sname'=>'contacts',
			'@stitle'=>'Контакты',
			'@fieldname'=>'name'
		);
	$uplinks_conf['brand']=array(
			'@sname'=>'brands',
			'@stitle'=>'Торговые марки',
			'@fieldname'=>'name'
		);
	$uplinks_conf['banner']=array(
			'@sname'=>'banners',
			'@stitle'=>'Банеры',
			'@fieldname'=>'name'
		);
	$uplinks_conf['group_article']=array(
			'@sname'=>'group_articles',
			'@stitle'=>'Группы статей',
			'@fieldname'=>'name'
		);
	$uplinks_conf['special']=array(
			'@sname'=>'specials',
			'@stitle'=>'Спецпредложения',
			'@fieldname'=>'name'
		);
	$uplinks_conf['gallery_list']=$uplinks_conf['gallery']=array(
			'@sname'=>'gallery',
			'@stitle'=>'Галерея',
			'@fieldname'=>'name'
		);
	$uplinks_conf['action_list']=$uplinks_conf['action']=array(
			'@sname'=>'actions',
			'@stitle'=>'Мероприятия клуба',
			'@fieldname'=>'name'
		);
	$uplinks_conf['items_gallery']=array(
			'@sname'=>'items',
			'@stitle'=>'Фотогалерея',
			'@fieldname'=>'name'
		);
	$uplinks_conf['production'] = $uplinks_conf['production_gallery'] = $uplinks_conf['production_down'] = array(
			'@sname'=>'production',
			'@stitle'=>'Продукция',
			'@fieldname'=>'name'
		);
	$uplinks_conf['service'] = $uplinks_conf['service_gallery'] = $uplinks_conf['service_down'] = array(
			'@sname'=>'services',
			'@stitle'=>'Услуги',
			'@fieldname'=>'name'
		);
	$uplinks_conf['video']=array(
			'@sname'=>'video',
			'@stitle'=>'Видео',
			'@fieldname'=>'name'
		);
	$uplinks_conf['meta']=array(
			'@sname'=>'meta',
			'@stitle'=>'Мета теги',
			'@fieldname'=>'url'
		);


	return $uplinks_conf;
}
?>
