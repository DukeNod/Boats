<?xml version='1.0' encoding='cp1251' ?>
<!DOCTYPE xsl:stylesheet [
	<!ENTITY % HTMLlat1    PUBLIC "-//W3C//ENTITIES Latin 1 for XHTML//EN" "../dtds/xhtml-lat1.ent"   > %HTMLlat1;
	<!ENTITY % HTMLspecial PUBLIC "-//W3C//ENTITIES Special for XHTML//EN" "../dtds/xhtml-special.ent"> %HTMLspecial;
	<!ENTITY % HTMLsymbol  PUBLIC "-//W3C//ENTITIES Symbols for XHTML//EN" "../dtds/xhtml-symbol.ent" > %HTMLsymbol;
]>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:php="http://php.net/xsl">

<xsl:include href="_all_.xslt" />
<xsl:include href="./_common_/safes.xslt" />
<xsl:include href="./_common_/media.xslt" />
<xsl:include href="./_common_/meta.xslt" />
<xsl:include href="./_common_/picts.xslt" />
<xsl:include href="./_common_/paras.xslt" />
<xsl:include href="./_common_/dates.xslt" />
<xsl:include href="./_common_/pager.xslt" />
<xsl:include href="./_common_/files.xslt" />
<xsl:include href="left_menu.xslt" />

<!--
ВНИМАНИЕ:
Тег <meta content-type> (с mime-type и charset) перекрывается автоматически, хотя в документации это нигде явно не описано.
Indent принудительно отключен, потому что XSLT-процессор почему-то его включает (хотя default=no), и это портит вёрстку.
-->
<!--xsl:output
	method="xml" 
	indent="yes"
	encoding="UTF-8"
        doctype-public="-//W3C//DTD XHTML 1.0 Strict//EN" 
        doctype-system="http://www.w3.org/TR/xhtml1/DTD/xhtml1-strict.dtd"
/-->

<xsl:output
	method="html" 
	indent="yes"
	encoding="UTF-8"
/>


<!--
ПЕРЕОПРЕДЕЛЯЕМЫЕ ПУСТЫШКИ (OVERRIDEABLES).
Задаём секции и шаблоны, которые можно переопределять на страницах в зависимости от динамического контента
(это нужно чтобы они были хоть как-то определены, даже с низким приоритетом, на тот случай, если не будут переопределены вовсе;
 а если будут переопределены, как и должны, - то их бОльший приоритет, даже дефолтный, перекроет наши пустышки).
-->
<xsl:template priority="-99" match="/" mode="overrideable_title"       ></xsl:template>
<xsl:template priority="-99" match="/" mode="overrideable_keywords"    ></xsl:template>
<xsl:template priority="-99" match="/" mode="overrideable_description" ></xsl:template>

<xsl:template priority="-99" match="/" mode="overrideable_headers"     ></xsl:template>
<xsl:template priority="-99" match="/" mode="overrideable_content"     ></xsl:template>
<xsl:template priority="-99" match="/" mode="overrideable_prolog"      ></xsl:template>
<xsl:template priority="-99" match="/" mode="overrideable_measurer"    ></xsl:template>
<xsl:template priority="-99" match="/" mode="overrideable_left_menu"    ></xsl:template>
<xsl:template priority="-99" match="/" mode="overrideable_right_menu"    ></xsl:template>
<xsl:template priority="-99" match="/" mode="overrideable_top_menu"    ></xsl:template>
<xsl:template priority="-99" match="/" mode="overrideable_head"    ></xsl:template>
<xsl:template priority="-99" match="/" mode="overrideable_error_block_req"></xsl:template> 

<xsl:template priority="-99" match="/" mode="curr_category"    ></xsl:template>
<xsl:variable name="curr_category"><xsl:apply-templates select="/" mode="curr_category"/></xsl:variable>

<xsl:template priority="-99" match="/" mode="overrideable_body"        ><xsl:call-template name="default_body"/></xsl:template>

<xsl:template priority="-99" match="/" mode="global_top_menu"></xsl:template> 
<xsl:template priority="-99" match="/" mode="global_left_menu"></xsl:template> 
<xsl:template priority="-99" match="/" mode="select_item"></xsl:template> 
<xsl:template priority="-99" match="/" mode="disable-screen"></xsl:template> 
<xsl:template priority="-99" match="/" mode="print-link"></xsl:template> 


<xsl:attribute-set name="attributes_of_body">
	<xsl:attribute name="class">
	<xsl:choose>
		<xsl:when test="/*/main">start_page</xsl:when>
	</xsl:choose>
	</xsl:attribute>
</xsl:attribute-set>


<!--
ШАБЛОН ДЛЯ СИСТЕМНОЙ ОШИБКИ.
Определяем вёрстку по умолчанию для сообщений о системной ошибке программной части (исключения).
В рамках определённых модулей и ситуация, некоторые исключения могут быть отловлены по более
конкретизированным условиям (по id или type), и для них вёрстка определена иначе. Но в любом случае
необходим вот такой вот механизм "отката" на дефолтную обощённую вёрстку.
-->
<xsl:template priority="-99" match="/*/exception">
	<div class="layoutException">
		<xsl:if test="string(id  )!=''"><p class="layoutExceptionId"  >Код <xsl:value-of select="id  "/></p></xsl:if>
		<xsl:if test="string(type)!=''"><p class="layoutExceptionType">Тип <xsl:value-of select="type"/></p></xsl:if>
		<xsl:if test="string(text)!=''"><p class="layoutExceptionText"><xsl:value-of select="text"/></p></xsl:if>
	</div>
</xsl:template>



<!--
КОРНЕВОЙ УЗЕЛ.
Задаём оформление корневого узла (без режима), и на него навешиваем вывод оформления страницы.
В это оформление записываем только самый базовый HTML-код, определяющий технический формат результата (пролог и корневой тег).
Вещи, касающиеся контента или дизайна, помещаем в переопределяемых шаблонах для тегов head & body.
-->
<xsl:template match="/">
	<!-- Выводим DOCTYPE в самой первой строчке с переводом строки в конце (для пущей красоты результата). -->
	<!--xsl:text disable-output-escaping="yes"><![CDATA[<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Strict//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-strict.dtd">]]></xsl:text-->
	<xsl:text disable-output-escaping="yes"><![CDATA[<!DOCTYPE html>]]></xsl:text>
	<xsl:call-template name="_newline"/>
	
	

	<!-- Самая верхнеуровневая разметка, касающаяся технического представления страницы. -->
	<html>
	<head>
		<!-- Основные теги и конструкции страницы. -->
		<!-- Content-Type с правильной кодировкой подставится сам на основе xsl:output. -->
		<meta http-equiv="content-type" 	content="text/html charset=UTF-8"/><xsl:call-template name="_newline"/>
		<meta http-equiv="content-language" content="ru" /><xsl:call-template name="_newline"/>
		<meta http-equiv="X-UA-Compatible" content="IE=edge" /><xsl:call-template name="_newline"/>

		<!-- Поисково-оптимизационные параметры страницы. -->
		<!-- Для вывода используется CDATA чтобы избежать чрезмерно умного квотинга entities (lt+gt+amp) в атрибутах. -->
		<title>
		<xsl:choose>
			<xsl:when test="/*/over_meta/title!=''">
				<xsl:call-template name="safe_cut">
				<xsl:with-param name="in_string">
				<xsl:call-template name="meta_string">
					<xsl:with-param name="string"><xsl:value-of select="/*/over_meta/title"/></xsl:with-param>
					<xsl:with-param name="cut" select="'&#x0D;&#x0A;&#x26;&#x3C;&#x3E;'"/>
					<xsl:with-param name="put" select='"&#x20;&#x20;&#x20;&#x20;&#x20;"'/>
				</xsl:call-template>
				</xsl:with-param>
				</xsl:call-template>
			</xsl:when>
			<xsl:otherwise>
			<xsl:call-template name="safe_cut">
				<xsl:with-param name="in_string">
			<xsl:call-template name="safe_concat">
				<xsl:with-param name="content"><xsl:apply-templates select="/" mode="overrideable_title"/></xsl:with-param>
				<xsl:with-param name="default"><xsl:call-template name="meta_title_default"/></xsl:with-param>
				<xsl:with-param name="prolog" ><xsl:call-template name="meta_title_prolog" /></xsl:with-param>
				<xsl:with-param name="epilog" ><xsl:call-template name="meta_title_epilog" /></xsl:with-param>
				<xsl:with-param name="concat" select="' &mdash; '"/>
				<xsl:with-param name="cut" select="'&#x0D;&#x0A;&#x26;&#x3C;&#x3E;'"/>
				<xsl:with-param name="put" select='"&#x20;&#x20;&#x20;&#x20;&#x20;"'/>
			</xsl:call-template>
				</xsl:with-param>
			</xsl:call-template>
			</xsl:otherwise>
		</xsl:choose>	
		</title>
		<xsl:call-template name="_newline"/>
		<xsl:text disable-output-escaping="yes"><![CDATA[<meta name="keywords" content="]]></xsl:text>
		<xsl:choose>
			<xsl:when test="/*/over_meta/keywords!=''">
				<xsl:call-template name="meta_string">
					<xsl:with-param name="string"><xsl:value-of select="/*/over_meta/keywords"/></xsl:with-param>
					<xsl:with-param name="cut" select="'&#x0D;&#x0A;&#x26;&#x3C;&#x3E;&#x22;'"/>
					<xsl:with-param name="put" select='"&#x20;&#x20;&#x20;&#x20;&#x20;&#x27;"'/>
				</xsl:call-template>
			</xsl:when>
			<xsl:otherwise>
			<xsl:call-template name="safe_concat">
				<xsl:with-param name="content"><xsl:apply-templates select="/" mode="overrideable_keywords"/></xsl:with-param>
				<xsl:with-param name="default"><xsl:for-each select="/*/group_catalogues_actual/category"><xsl:value-of select="name"/><xsl:text> </xsl:text></xsl:for-each></xsl:with-param>
				<xsl:with-param name="prolog" ><xsl:call-template name="meta_keywords_prolog" /></xsl:with-param>
				<xsl:with-param name="epilog" ><xsl:call-template name="meta_keywords_epilog" /></xsl:with-param>
				<xsl:with-param name="concat" select="', '"/>
				<xsl:with-param name="cut" select="'&#x0D;&#x0A;&#x26;&#x3C;&#x3E;&#x22;'"/>
				<xsl:with-param name="put" select='"&#x20;&#x20;&#x20;&#x20;&#x20;&#x27;"'/>
			</xsl:call-template>
			</xsl:otherwise>
		</xsl:choose>	
		<xsl:text disable-output-escaping="yes"><![CDATA["/>]]></xsl:text>
		<xsl:call-template name="_newline"/>
		<xsl:text disable-output-escaping="yes"><![CDATA[<meta name="description" content="]]></xsl:text>
		<xsl:choose>
			<xsl:when test="/*/over_meta/description!=''">
				<xsl:call-template name="meta_string">
					<xsl:with-param name="string"><xsl:value-of select="/*/over_meta/description"/></xsl:with-param>
					<xsl:with-param name="cut" select="'&#x0D;&#x0A;&#x26;&#x3C;&#x3E;&#x22;'"/>
					<xsl:with-param name="put" select='"&#x20;&#x20;&#x20;&#x20;&#x20;&#x27;"'/>
				</xsl:call-template>
			</xsl:when>
			<xsl:otherwise>
			<xsl:call-template name="safe_concat">
				<xsl:with-param name="content"><xsl:apply-templates select="/" mode="overrideable_description"/></xsl:with-param>
				<xsl:with-param name="default"><xsl:call-template name="meta_description_default"/></xsl:with-param>
				<xsl:with-param name="prolog" ><xsl:call-template name="meta_description_prolog" /></xsl:with-param>
				<xsl:with-param name="epilog" ><xsl:call-template name="meta_description_epilog" /></xsl:with-param>
				<xsl:with-param name="concat" select="' '"/>
				<xsl:with-param name="cut" select="'&#x0D;&#x0A;&#x26;&#x3C;&#x3E;&#x22;'"/>
				<xsl:with-param name="put" select='"&#x20;&#x20;&#x20;&#x20;&#x20;&#x27;"'/>
			</xsl:call-template>
			</xsl:otherwise>
		</xsl:choose>	
		<xsl:text disable-output-escaping="yes"><![CDATA["/>]]></xsl:text>	
		<xsl:call-template name="_newline"/>

		<!-- Прочие поисковые и информационные параметры страницы. -->
		<meta name="copyright"      		content="2018 {/*/system/info/pub_site}"/><xsl:call-template name="_newline"/>
		<meta name="document-state" 		content="Dynamic"/><xsl:call-template name="_newline"/>
		<meta name="revisit-after" 		content="3days"/><xsl:call-template name="_newline"/>
		<meta name="distribution"   		content="Global"/><xsl:call-template name="_newline"/>
		<meta name="robots"         		content="INDEX,FOLLOW"/><xsl:call-template name="_newline"/>
		<meta name="rating"         		content="General"/><xsl:call-template name="_newline"/>
		<!--meta http-equiv="content-type" 	content="text/html charset=UTF-8"/>
		<meta http-equiv="content-language" 	content="ru"/-->
		<meta http-equiv="pragma" 		content="cache"/><xsl:call-template name="_newline"/>
		<meta http-equiv="window-target" 	content="_self"/><xsl:call-template name="_newline"/>
		<meta name="abstract" 			content="abstract"/><xsl:call-template name="_newline"/>
		<meta name="classification" 		content="Trade"/><xsl:call-template name="_newline"/>
		<meta name="pics-label"     		content="pics rating"/><xsl:call-template name="_newline"/>
		<link rel="help" 			href="{/*/system/info/pub_site}"/><xsl:call-template name="_newline"/>
		<link rel="shortcut icon"		href="{/*/system/info/pub_root}favicon.ico"/><xsl:call-template name="_newline"/>

		<!-- Глобальные определения (практически константы) JS - чтобы не писать <xsl:value-of> внутри JS'овских CDATA. -->
		<!-- Важно чтобы они были внутри самой страницы, а не во внешних файлах, и чтобы задавались как можно раньше. -->
		<!-- Этот JS верстаем с особой тщательностью (чуть не по символам), потому что важно чтобы он сработал чисто. -->
		<script type="text/javascript">
			<xsl:call-template name="_newline"/>
			<xsl:text>var PUB_SITE = "</xsl:text><xsl:value-of select="php:function('addslashes', string(/*/system/info/pub_site))"/><xsl:text>";</xsl:text><xsl:call-template name="_newline"/>
			<xsl:text>var PUB_ROOT = "</xsl:text><xsl:value-of select="php:function('addslashes', string(/*/system/info/pub_root))"/><xsl:text>";</xsl:text><xsl:call-template name="_newline"/>
		</script>

		<!-- jQuery. -->
		<link rel="stylesheet" href="{/*/system/info/pub_root}css/jquery-ui.min.css"></link>
		<script type="text/javascript" src="{/*/system/info/pub_root}js/jquery-2.1.3.min.js"></script>
		<script type="text/javascript" src="{/*/system/info/pub_root}js/jquery-ui.min.js"></script>

		<!-- Общие (всестраничные, по-страничные и верстальные) JS- и CSS-файлы. -->
		<!-- Причём сначала идут верстальные файлы (main+print), а потом уже наши программистские дописки (stuff). -->
		<!-- Условные комментарии пишем через CDATA, так как иначе возникают ограничения на контент. -->
		<!--
		<script language="javascript">AC_FL_RunContent = 0;</script>
		<script type="text/javascript" src="{/*/system/info/pub_root}js/AC_RunActiveContent.js" language="javascript" />
		<script type="text/javascript" src="{/*/system/info/pub_root}js/ajax.js"/>
		<script type="text/javascript" src="{/*/system/info/pub_root}js/json2.js"/>
		-->
		<script type="text/javascript" src="{/*/system/info/pub_root}js/swfobject.js"/>
		
		<!-- DHTML-календарик (порядок важен: сначала подключаем, потом переопределяем переменные). -->
		<link rel="stylesheet" type="text/css" href="{/*/system/info/pub_root}js/dhtmlgoodies_calendar/dhtmlgoodies_calendar.css" media="screen"></link>
		<script type="text/javascript" src="{/*/system/info/pub_root}js/dhtmlgoodies_calendar/dhtmlgoodies_calendar.js"></script>
		<script type="text/javascript"><![CDATA[
			var pathToImages      = PUB_ROOT + "js/dhtmlgoodies_calendar/images/";
			var monthArray        = ['Январь','Февраль','Март','Апрель','Май','Июнь','Июль','Август','Сентябрь','Октябрь','Ноябрь','Декабрь'];
			var monthArrayShort   = ['января','февраля','марта','апреля','мая','июня','июля','августа','сентября','октября','ноября','декабря'];
			var dayArray          = ['Пон','Вто','Сре','Чет','Пят','Суб','Вос'];
			var weekString        = 'Нед.';
			var todayString       = 'Сегодня:';
			var todayStringFormat = '[todayString] [dayString], [day] [monthString] [year]';
		]]></script>
		
		<!-- Ace Editor -->
		<!--
		<script type="text/javascript" src="{/*/system/info/pub_root}js/ace_editor/ace.js"></script>
		<link rel="stylesheet" type="text/css" href="{/*/system/info/pub_root}css/ace_editor/ace.css"></link>
		-->
		
		<script type="text/javascript" src="{/*/system/info/pub_root}js/jquery.form.min.js"/>
		<script type="text/javascript" src="{/*/system/info/pub_root}js/jquery.livequery.min.js"/>
		<script type="text/javascript" src="{/*/system/info/pub_root}js/jquery.parallax.min.js"></script>
		<script type="text/javascript" src="{/*/system/info/pub_root}js/jquery.event.frame.js"></script>
		<script type="text/javascript" src="{/*/system/info/pub_root}js/site.js"></script>
		<script type="text/javascript" src="{/*/system/info/pub_root}js/sweetalert.min.js"></script>
		
		<script type="text/javascript" src="{/*/system/info/pub_root}js/moment.js"></script>
		
		<script type="text/javascript" src="{/*/system/info/pub_root}vendor/bootstrap/js/bootstrap.min.js"></script>
		<link rel="stylesheet" type="text/css" href="{/*/system/info/pub_root}vendor/bootstrap/css/bootstrap.min.css"></link>
		
		<script type="text/javascript" src="{/*/system/info/pub_root}js/bootstrap-datetimepicker.min.js"></script>
		<script type="text/javascript" src="{/*/system/info/pub_root}js/bootstrap-datetimepicker.ru.js"></script>
		<link rel="stylesheet" type="text/css" href="{/*/system/info/pub_root}css/bootstrap-datetimepicker.min.css"></link>

		<script type="text/javascript" src="{/*/system/info/pub_root}js/ImageTools.js"/>
		<!-- Jquery validation -->
		<script src="{/*/system/info/pub_root}js/validation/jquery.validate.min.js"></script>
		<script src="{/*/system/info/pub_root}js/validation/additional-methods.js"></script>		
		
		<xsl:text disable-output-escaping="yes">&lt;!--[if lt IE 9]&gt;</xsl:text>
		<script type="text/javascript" src="{/*/system/info/pub_root}js/html5.js"></script>
		<xsl:text disable-output-escaping="yes">&lt;![endif]--&gt;</xsl:text>

		<script type="text/javascript" src="{/*/system/info/pub_root}js/stuff.js?12"/>
		
		<script type="text/javascript" src="{/*/system/info/pub_root}js/hotels.js"/>

		<link href="{/*/system/info/pub_root}css/layout_reset.css" type="text/css" rel="stylesheet"/>
		<link href="{/*/system/info/pub_root}css/style.css" type="text/css" rel="stylesheet"/>

		<xsl:if test="/*/print">
		<link rel="stylesheet" type="text/css" media="all" href="{/*/system/info/pub_root}css/print.css"/>
		</xsl:if>
	
		<xsl:call-template name="_newline"/>

	<!-- Условные прицепления для разных браузеров. Идут после ощих файлов, но до дополнительных. -->

		<xsl:text disable-output-escaping="yes">&lt;!--[if lt IE 9]&gt;</xsl:text>
		<link href="{/*/system/info/pub_root}css/ie.css" type="text/css" rel="stylesheet"/>
		<xsl:text disable-output-escaping="yes">&lt;![endif]--&gt;</xsl:text>

		<xsl:call-template name="_newline"/>

		<link rel="stylesheet" type="text/css" media="all"   href="{/*/system/info/pub_root}css/para.css"/>
		<link rel="stylesheet" type="text/css" media="all"   href="{/*/system/info/pub_root}css/stuff.css"/>

		<!-- Дополняемые и переопределяемые заголовки. -->
		<!-- Идут строго после всего фиксированного, так как могут действительно переопределять. -->
		<xsl:apply-templates select="/" mode="overrideable_headers"/>

	</head>
	<!-- Тело страницы с возможностью определения как содержимого, так и набора атрибутов. -->
	<!-- При этом наличие самого тега body гарантируется именно тут, и его нельзя перекрыть. -->
	<body class='rails_admin' xsl:use-attribute-sets="attributes_of_body"> <!--  style="padding-top: 150px;" -->
		<xsl:apply-templates select="/" mode="overrideable_body"/>
	</body>
	</html>
</xsl:template>


<!--
ТЕЛО (BODY) СТРАНИЦЫ.
Задаём тег body страниц, которые не содержат переопределений этого тега (как правило переопределяет только главная страница).
Помещаем сюда всё фиксированное и переопределяемое наполнение и оформление таких страниц.
-->
<xsl:template name="default_body">
<nav class='navbar navbar-default navbar-fixed-top'>
<div class="container-fluid">
	<div class="navbar-header">
	<a class="navbar-brand pjax" href="{/*/system/info/pub_root}">
			<xsl:value-of select="/*/identity/consumer/name" /> (<xsl:value-of select="/*/identity/consumer/email" />)
			<xsl:if test="/*/identity /consumer/roles/role != 'admin'">
			(<xsl:value-of select="/*/branches/branch[id = /*/identity/consumer/branch]/name" />)
			</xsl:if>

	</a>
	</div>
	<!--div class="collapse navbar-collapse" id="secondary-navigation">
	</div-->
	<div class="collapse navbar-collapse" id="secondary-navigation">
		<ul class="nav navbar-nav navbar-right root_links">
		<li>
		<table class="error-unsig-info-table">
			<tr>
				<xsl:choose><xsl:when test="/*/identity/consumer/roles/role = 'hotelier'">
					<xsl:choose><xsl:when test="/*/alerts/error > '0'">
					<!--td class="error-unsig-info"><a href="{/*/system/info/pub_root}?filter_response_state=1">с ошибками<br/><xsl:value-of select="/*/alerts/error"/></a></td-->
					</xsl:when></xsl:choose>
					<xsl:choose><xsl:when test="/*/alerts/unsig > '0'">
					<td class="error-unsig-info"><a href="{/*/system/info/pub_root}?filter_sig=0">не подписано<br/><xsl:value-of select="/*/alerts/unsig"/></a></td>
					</xsl:when></xsl:choose>
				</xsl:when></xsl:choose>
			</tr>
		</table>
		</li>
			<li>
				<a rel="nofollow" data-method="delete" href="{/*/system/info/pub_root}logout/">
					<span class="label">Выйти</span>
				</a>
			</li>
		</ul>
	</div>
</div>
<div class="container-fluid">
	<div class="collapse navbar-collapse" id="secondary-navigation">
		<ul class="nav navbar-nav navbar-left root_links">
			<xsl:apply-templates select="/" mode="overrideable_left_menu" />
		</ul></div>
</div>
	<xsl:apply-templates select="/" mode="overrideable_error_block_req"/>
</nav>
<div class='container-fluid'>
		<!--div class="extra-message" style="
	background: #fff;
	color: red;
    float: left;
    display: inline-block;
    margin-left: 0;
    margin-top: 5px;
    font-weight: bold;
    font-size: 15px;
	padding: 4px 20px;
		">Внимание! С 00:00 - 00:10 будут проводиться профилактические работы на сервере. Сервис может быть недоступен.</div>
		<div class="clearfix"></div-->
<div class='row'>
<!--div class='col-sm-3 col-md-2 sidebar-nav'>
<ul class="nav nav-pills nav-stacked">
	<xsl:apply-templates select="/" mode="overrideable_left_menu" />
</ul>
</div-->
<!--div class='col-sm-9 col-sm-offset-3 col-md-10 col-md-offset-2'-->
<div style='margin-left: 15px'>
<div class='content' data-pjax-container="">
<!--script>$('.nav.nav-pills li.active').removeClass('active');
$('.nav.nav-pills li[data-model="request"]').addClass('active');</script-->
	<h1>
		<xsl:choose>
			<xsl:when test="/*/over_meta/h1!=''">
				<xsl:value-of select="/*/over_meta/h1" disable-output-escaping="yes"/>
			</xsl:when>
			<xsl:otherwise>
				<xsl:apply-templates select="/" mode="overrideable_head"/>
			</xsl:otherwise>
		</xsl:choose>
	</h1>
	<xsl:variable name="overrideable_measurer"><xsl:apply-templates select="/" mode="overrideable_measurer"/></xsl:variable>
	<xsl:if test="$overrideable_measurer != ''">
	<ol class="breadcrumb">
		<li class="false"><a class="pjax" href="{/*/system/info/pub_root}">Главная</a></li>
    	<xsl:apply-templates select="/" mode="overrideable_measurer"/>
	</ol>
	</xsl:if>
	
	<xsl:apply-templates select="/" mode="overrideable_content"/>

</div>
</div>
</div>
</div>
	<div id="ImageBoxOverlay"> </div>
	<div id="popup_banner" class="popup_banner">
		<!--div class="close_img"><img src="{/*/system/info/pub_root}images/close.png" width="13" height="13"/></div-->
		<div id="popup_banner_content" class="popup_banner_content">
			<img src="" style="cursor: pointer" id="request-img-open"/>
		</div>
	</div>
</xsl:template>


<xsl:template name="popup_banner">
	<div id="ImageBoxOverlay"> </div>
	<div id="popup_banner" class="popup_banner">
		<div class="close_img"><img src="{/*/system/info/pub_root}images/close.png" width="13" height="13"/></div>
		<div id="popup_banner_content" class="popup_banner_content">
		      	<a href="{/*/system/info/pub_root}fishing/"><img src="{/*/system/info/pub_root}images/popup_banner.png"/></a>
		</div>
	</div>
</xsl:template>


<xsl:template name="meta_title_prolog">
	<xsl:apply-templates select="/*/inlines/inline[label=':meta:title:prolog']"/>
</xsl:template>
<xsl:template name="meta_title_epilog">
	<xsl:for-each select="/*/menu-categories/service_category"><xsl:value-of select="name"/><xsl:if test="position()!=last()"><xsl:text>, </xsl:text></xsl:if></xsl:for-each>
	<xsl:apply-templates select="/*/inlines/inline[label=':meta:title:epilog']"/>
</xsl:template>
<xsl:template name="meta_title_default">
	<xsl:apply-templates select="/*/inlines/inline[label=':meta:title:default']"/>
</xsl:template>



<xsl:template name="meta_keywords_prolog">
	<xsl:apply-templates select="/*/inlines/inline[label=':meta:keywords:prolog']"/>
</xsl:template>
<xsl:template name="meta_keywords_epilog">
	<xsl:apply-templates select="/*/inlines/inline[label=':meta:keywords:middle']"/>
	<xsl:for-each select="/*/menu-categories/service_category"><xsl:value-of select="name"/><xsl:text>, </xsl:text></xsl:for-each>
	<xsl:apply-templates select="/*/inlines/inline[label=':meta:keywords:epilog']"/>
</xsl:template>
<xsl:template name="meta_keywords_default">
	<xsl:apply-templates select="/*/inlines/inline[label=':meta:keywords:default']"/>
</xsl:template>



<xsl:template name="meta_description_prolog">
	<xsl:apply-templates select="/*/inlines/inline[label=':meta:description:prolog']"/>
</xsl:template>
<xsl:template name="meta_description_epilog">
	<xsl:apply-templates select="/*/inlines/inline[label=':meta:description:epilog']"/>
</xsl:template>
<xsl:template name="meta_description_default">
	<xsl:apply-templates select="/*/inlines/inline[label=':meta:description:default']"/>
</xsl:template>



<xsl:template name="measurer_divider"> / </xsl:template>
<xsl:decimal-format name="cost" decimal-separator="," grouping-separator="&nbsp;" NaN=""/>
<xsl:decimal-format name="size" decimal-separator="," grouping-separator="&nbsp;" NaN=""/>



<xsl:template match="inline">
<xsl:param name="title_inline" select="''"/>
	<xsl:choose>
		<xsl:when test="linked_paras/*">
			<xsl:apply-templates select="linked_paras/linked_para" mode="linked_para">
				<xsl:with-param name="alt" select="$title_inline"/>
			</xsl:apply-templates>
		</xsl:when>
		<xsl:otherwise>
				<xsl:value-of select="content" disable-output-escaping="yes"/>
		</xsl:otherwise>
	</xsl:choose>
</xsl:template>

<xsl:variable name="global_top_menu"><xsl:apply-templates select="/" mode="global_top_menu"/></xsl:variable>

<xsl:template name="top_menu_item">
	<xsl:param name="url"/>
	<xsl:param name="text"/>
		<li>
			<xsl:if test="$url=$global_top_menu">
				<xsl:attribute name="class">act</xsl:attribute>
			</xsl:if>
			<a href="{$LANGROOT}{$url}/">
				<xsl:value-of select="$text"/>
			</a>
		</li>
        <li class="block-1 act"><a href="{$LANGROOT}about/" class="link_photo"  alt="О водоёме" title="О водоёме"><img src="{/*/system/info/pub_root}images/5.jpg" alt="О водоёме" title="О водоёме"/></a> 
          <div class="name"><a href="{$LANGROOT}about/"  alt="О водоёме" title="О водоёме">О водоёме</a></div>
        </li>
</xsl:template>

<xsl:variable name="global_left_menu"><xsl:apply-templates select="/" mode="global_left_menu"/></xsl:variable>

<xsl:template name="left_menu_item">
	<xsl:param name="url"/>
	<xsl:param name="text" select="''"/>
	<xsl:param name="code" select="''"/>
	<xsl:param name="class" select="''"/>
		<li>
		        <xsl:choose>
			<xsl:when test="$code = $global_left_menu">
				<xsl:attribute name="class">act</xsl:attribute>
			</xsl:when>
			<xsl:when test="$class != ''">
				<xsl:attribute name="class"><xsl:value-of select="$class"/></xsl:attribute>
			</xsl:when>
		        </xsl:choose>
			<a href="{$LANGROOT}{$url}">
				<xsl:value-of select="$text"/>
			</a>
		</li>
</xsl:template>

<xsl:template match="*" mode="profile_full_name">
	<xsl:value-of select="concat(lastname, ' ', firstname, ' ', middlename)"/>
</xsl:template>

</xsl:stylesheet>