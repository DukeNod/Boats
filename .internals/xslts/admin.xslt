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
<xsl:include href="./_common_/picts.xslt" />
<xsl:include href="./_common_/paras.xslt" />
<xsl:include href="./_common_/dates.xslt" />
<xsl:include href="./_common_/langs.xslt" />
<xsl:include href="./_common_/quick_form.xslt" />
<xsl:include href="./_common_/admin_quick_form.xslt" />
<xsl:include href="./_common_/admin_quick_list.xslt" />
<xsl:include href="./_common_/calendars.xslt"/>

<!--
Тег meta с кодировкой и mime-type проставляется автоматически, хотя в документации это нигде явно не описано.
-->
<xsl:output
	method="html" 
/>



<!--
ПЕРЕОПРЕДЕЛЯЕМЫЕ ПУСТЫШКИ.
Задаём секции и шаблоны, которые можно переопределять на страницах
(чтобы они были хоть как-то определены на тот случай, если не будут переопределены;
а если будут переопределены - то больший приоритет, даже дефолтный, перекроет наши пустышки).
В левую секцию вписываем (дефолтно) список новинок, который
есть на всех страницах, кроме главной (там перекрывается пустотой).
-->
<xsl:template priority="-10" match="/" mode="overrideable_selector"   ></xsl:template>
<xsl:template priority="-10" match="/" mode="overrideable_title"      ></xsl:template>
<xsl:template priority="-10" match="/" mode="overrideable_keywords"   ></xsl:template>
<xsl:template priority="-10" match="/" mode="overrideable_description"></xsl:template>
<xsl:template priority="-10" match="/" mode="overrideable_headers"    ></xsl:template>
<xsl:template priority="-10" match="/" mode="overrideable_adm_sub_root"></xsl:template>

<xsl:template priority="-10" match="/" mode="overrideable_context">
	<xsl:apply-templates select="/" mode="overrideable_menu"/>
</xsl:template>
<xsl:template priority="-10" match="/" mode="overrideable_path">
	<xsl:call-template name="path_this"><xsl:with-param name="text"><xsl:apply-templates select="/" mode="overrideable_title"/></xsl:with-param></xsl:call-template>
</xsl:template>
<xsl:template priority="-10" match="/" mode="overrideable_title"  ></xsl:template>
<xsl:template priority="-10" match="/" mode="overrideable_submenu">
	<xsl:call-template name="list_of_languages_main">
		<xsl:with-param name="link" select="/*/system/curr_raw"/>
	</xsl:call-template>
</xsl:template>
<xsl:template priority="-10" match="/" mode="overrideable_content">
	<!--
	Обрбатываем только один из узлов, причём порядок перехвата важен (особенно для exception),
	Для этого используем choose вместо apply-templates select="...|...|...|".
	При этом из перехвата исключаются вспомогательные узлы типа system, enums, и пр.
	-->
	<xsl:choose>
	<xsl:when test="/*/main"><xsl:apply-templates select="/*/main[1]"/></xsl:when>
	<xsl:when test="/*/list"><xsl:apply-templates select="/*/list[1]"/></xsl:when>
	<xsl:when test="/*/item"><xsl:apply-templates select="/*/item[1]"/></xsl:when>
	<xsl:when test="/*/done"><xsl:apply-templates select="/*/done[1]"/></xsl:when>
	<xsl:when test="/*/form"><xsl:apply-templates select="/*/form[1]"/></xsl:when>
	<xsl:otherwise><!--???--></xsl:otherwise>
	</xsl:choose>
</xsl:template>

<xsl:template priority="-10" match="/" mode="overrideable_redirect">
	<xsl:call-template name="_done_"/>
</xsl:template>

<xsl:template name="_done_">
	<xsl:if test="/*/done">
		<xsl:variable name="back1">
			<xsl:choose>
			<xsl:when test="contains(/*/system/back_raw, '::')"><xsl:value-of select="substring-before(/*/system/back_raw, '::')"/></xsl:when>
			<xsl:otherwise><xsl:value-of select="/*/system/back_raw"/></xsl:otherwise>
			</xsl:choose>
		</xsl:variable>
		<xsl:variable name="back2">
			<xsl:choose>
			<xsl:when test="contains(/*/system/back_url, '%3A%3A')"><xsl:value-of select="substring-after(/*/system/back_url, '%3A%3A')"/></xsl:when>
			<xsl:otherwise></xsl:otherwise>
			</xsl:choose>
		</xsl:variable>

		<xsl:value-of select="$back1"/>
		<xsl:if test="$back2!=''">
			<xsl:choose><xsl:when test="contains($back1, '?')">&amp;</xsl:when><xsl:otherwise>?</xsl:otherwise></xsl:choose>
			<xsl:text>back=</xsl:text>
			<xsl:value-of select="$back2"/>
		</xsl:if>
	</xsl:if>
</xsl:template>

<xsl:template priority="-10" match="/" mode="overrideable_menu">
	<xsl:variable name="selector"><xsl:apply-templates select="/" mode="overrideable_selector"/></xsl:variable>

	<div class="menu">
	<ul class="menuList">
	<li><xsl:attribute name="class"><xsl:choose><xsl:when test="$selector='users'	">menuThis</xsl:when><xsl:otherwise>menuLink</xsl:otherwise></xsl:choose></xsl:attribute><a href="{/*/system/info/adm_root}users"	>Пользователи</a></li>
	<li><xsl:attribute name="class">menuLine</xsl:attribute>&nbsp;</li>
	<li><xsl:attribute name="class"><xsl:choose><xsl:when test="$selector='models'	">menuThis</xsl:when><xsl:otherwise>menuLink</xsl:otherwise></xsl:choose></xsl:attribute><a href="{/*/system/info/adm_root}models"	>Модели</a></li>
	<li><xsl:attribute name="class"><xsl:choose><xsl:when test="$selector='model_types'	">menuThis</xsl:when><xsl:otherwise>menuLink</xsl:otherwise></xsl:choose></xsl:attribute><a href="{/*/system/info/adm_root}model_types"	>Типы моделей</a></li>
	<li><xsl:attribute name="class"><xsl:choose><xsl:when test="$selector='branches'	">menuThis</xsl:when><xsl:otherwise>menuLink</xsl:otherwise></xsl:choose></xsl:attribute><a href="{/*/system/info/adm_root}branches"	>Филиалы</a></li>
	<li><xsl:attribute name="class"><xsl:choose><xsl:when test="$selector='organization'">menuThis</xsl:when><xsl:otherwise>menuLink</xsl:otherwise></xsl:choose></xsl:attribute><a href="{/*/system/info/adm_root}organization">Организации</a></li>
	<li><xsl:attribute name="class"><xsl:choose><xsl:when test="$selector='paytype'		">menuThis</xsl:when><xsl:otherwise>menuLink</xsl:otherwise></xsl:choose></xsl:attribute><a href="{/*/system/info/adm_root}paytype"		>Способ оплаты</a></li>
	<li><xsl:attribute name="class"><xsl:choose><xsl:when test="$selector='regions'		">menuThis</xsl:when><xsl:otherwise>menuLink</xsl:otherwise></xsl:choose></xsl:attribute><a href="{/*/system/info/adm_root}regions"		>Регионы</a></li>
	</ul>
	</div>
</xsl:template>



<!--
КОРНЕВОЙ УЗЕЛ.
Задаём оформление корневого узла (он единственный по стандарту XML, так что об имени и не заботимся).
В это оформление записываем весь HTML-код, который мы желаем получить в итоге,
включая "вызовы" переопределяемых частей (overrideables). Остальные части, которые не меняются
от страницы к странице, оформляем вызовами именнованных шаблонов (просто для лучшей читабельности кода).
-->
<xsl:template match="/">

	<!-- Выводим DOCTYPE в самой первой строчке с переводом строки в конце (для пущей красоты результата). -->
	<xsl:text disable-output-escaping="yes"><![CDATA[<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">]]></xsl:text>
	<xsl:call-template name="_newline"/>

	<!-- Шапка страницы и базовая вёрстка (общая для всех страниц без исключения). -->
	<html>
	<head>
		<!-- Основные теги и конструкции страницы. -->
		<!-- Content-Type подставится сам на основе xsl:output, так что тут его не указывать. -->
		<meta http-equiv="content-language" content="ru"/>
		<title><xsl:apply-templates select="/" mode="overrideable_title"/></title>

		<xsl:variable name="redirect"><xsl:apply-templates select="/" mode="overrideable_redirect"/></xsl:variable>
		<xsl:if test="$redirect!=''">
			<meta http-equiv="refresh" content="0; url={$redirect}"/>
		</xsl:if>

		<link rel="shortcut icon" href="{/*/system/info/adm_root}favicon.ico"/>
		<link rel="start"         href="{/*/system/info/adm_site}" />
		<link rel="top"           href="{/*/system/info/adm_site}" />
		<link rel="home"          href="{/*/system/info/adm_site}" />
<!--		<link rel="help"          href="{/*/system/info/adm_site}help" /> -->
		<link rel="index"         href="{/*/system/info/adm_site}" />
		<link rel="contents"      href="{/*/system/info/adm_site}" />
<!--		<link rel="search"        href="{/*/system/info/adm_site}search" /> -->
		<link rel="author"        href="http://www.howard-studio.ru/"/>

		<!-- Глобальные определения (практически константы) JS - чтобы не писать <xsl:value-of> внутри JS'овских CDATA. -->
		<!-- Важно чтобы они были внутри самой страницы, а не во внешних файлах, и чтобы задавались как можно раньше. -->
		<!-- Этот JS верстаем с особой тщательностью (чуть не по символам), потому что важно чтобы он сработал чисто. -->
		<script type="text/javascript">
			<xsl:text>&lt;!--</xsl:text>
			<xsl:for-each select="/*/system/info/*[not(*)]">
				<xsl:call-template name="_newline"/>
				<xsl:text>var </xsl:text>
				<xsl:value-of select="php:function('strtoupper', string(name()))"/>
				<xsl:text> = "</xsl:text>
				<xsl:value-of select="php:function('addslashes', string(.))"/>
				<xsl:text>";</xsl:text>
			</xsl:for-each>
				<xsl:call-template name="_newline"/>
				<xsl:text>var bookmark = "</xsl:text>
				<xsl:value-of select="/*/bookmark"/>
				<xsl:text>";</xsl:text>
			<xsl:call-template name="_newline"/>
			<xsl:text>//--&gt;</xsl:text>
		</script>

		<!-- jQuery и его плугины (должны быть до прочих левоскриптов, но лучше после наших variable-выносок). -->
		<!--script type="text/javascript" src="{/*/system/info/adm_root}js/jquery-1.2.5.js"></script-->
		<link rel="stylesheet" href="//code.jquery.com/ui/1.12.1/themes/base/jquery-ui.css"></link>
		<script type="text/javascript" src="https://ajax.googleapis.com/ajax/libs/jquery/2.1.3/jquery.min.js"></script>
		<script src="https://code.jquery.com/ui/1.12.1/jquery-ui.js"></script>
		<script type="text/javascript" src="{/*/system/info/adm_root}js/jquery.livequery.min.js"></script>
		<script type="text/javascript" src="{/*/system/info/adm_root}js/jquery.form.min.js"></script>
		<script type="text/javascript" src="{/*/system/info/adm_root}js/jquery.tablednd.js"></script>
		<script type="text/javascript" src="{/*/system/info/adm_root}js/jquery.cookie.js"></script>
		<script type="text/javascript" src="{/*/system/info/adm_root}js/jquery.debug.js" charset="windows-1251"></script>
		<script type="text/javascript" src="{/*/system/info/adm_root}js/jquery.color.js"></script>
<!--		<script type="text/javascript" src="{/*/system/info/adm_root}js/jquery.hotkeys.js"></script>-->
		<script type="text/javascript" src="{/*/system/info/adm_root}js/jquery.timer.js" charset="windows-1251"></script>
		<script type="text/javascript" src="{/*/system/info/adm_root}js/jquery.selection.js" charset="windows-1251"></script>
		<script type="text/javascript" src="{/*/system/info/adm_root}js/jquery.hiddentext.js" charset="windows-1251"></script>
		<script type="text/javascript" src="{/*/system/info/adm_root}js/jquery.keyboard.js" charset="windows-1251"></script>
		<script type="text/javascript" src="{/*/system/info/adm_root}js/jquery.keyboard-typograph.js"></script>
		<script type="text/javascript" src="{/*/system/info/adm_root}js/tiny_mce/tiny_mce.js"></script>

		<!-- DHTML-календарик (порядок важен: сначала подключаем, потом переопределяем переменные). -->
		<link rel="stylesheet" type="text/css" href="{/*/system/info/adm_root}ext/dhtmlgoodies_calendar/dhtmlgoodies_calendar.css" media="screen"></link>
		<script type="text/javascript" src="{/*/system/info/adm_root}ext/dhtmlgoodies_calendar/dhtmlgoodies_calendar.js"></script>
		<script type="text/javascript"><![CDATA[
			var pathToImages      = ADM_ROOT + "ext/dhtmlgoodies_calendar/images/";
			var monthArray        = ['Январь','Февраль','Март','Апрель','Май','Июнь','Июль','Август','Сентябрь','Октябрь','Ноябрь','Декабрь'];
			var monthArrayShort   = ['января','февраля','марта','апреля','мая','июня','июля','августа','сентября','октября','ноября','декабря'];
			var dayArray          = ['Пон','Вто','Сре','Чет','Пят','Суб','Вос'];
			var weekString        = 'Нед.';
			var todayString       = 'Сегодня:';
			var todayStringFormat = '[todayString] [dayString], [day] [monthString] [year]';
		]]></script>
		
		<script type="text/javascript" src="{/*/system/info/pub_root}js/moment.js"></script>
		
		<script type="text/javascript" src="{/*/system/info/pub_root}vendor/bootstrap/js/bootstrap.min.js"></script>
		<link rel="stylesheet" type="text/css" href="{/*/system/info/pub_root}vendor/bootstrap/css/bootstrap.min.css"></link>
		
		<script type="text/javascript" src="{/*/system/info/pub_root}js/bootstrap-datetimepicker.min.js"></script>
		<script type="text/javascript" src="{/*/system/info/pub_root}js/bootstrap-datetimepicker.ru.js"></script>
		<link rel="stylesheet" type="text/css" href="{/*/system/info/pub_root}css/bootstrap-datetimepicker.min.css"></link>
		
		<!-- Jquery arcticle Modal -->
		<link rel="stylesheet" type="text/css" href="{/*/system/info/adm_root}css/arcticmodal/jquery.arcticmodal-0.3.css"></link>
        <link rel="stylesheet" type="text/css" href="{/*/system/info/adm_root}css/arcticmodal/simple.css"></link>
        <script type="text/javascript" src="{/*/system/info/adm_root}js/arcticmodal/jquery.arcticmodal-0.3.min.js"></script>
		
		<!-- Ace Editor -->
		<script type="text/javascript" src="{/*/system/info/adm_root}js/ace_editor/ace.js"></script>
		<link rel="stylesheet" type="text/css" href="{/*/system/info/adm_root}css/ace_editor/ace.css"></link>

		<!-- Общие (всестраничные, по-страничные и верстальные) JS- и CSS-файлы. -->
		<link rel="stylesheet" type="text/css" href="{/*/system/info/adm_root}css/admin.css"></link>
		<script type="text/javascript" src="{/*/system/info/adm_root}js/json2.js"></script>
		<script type="text/javascript" src="{/*/system/info/adm_root}js/ajax.js"></script>
		<script type="text/javascript" src="{/*/system/info/adm_root}js/typograph.js"></script>
		<script type="text/javascript" src="{/*/system/info/adm_root}js/stuff.js"></script>
		<script type="text/javascript" src="{/*/system/info/adm_root}js/selects.js"/>

		<!-- Локальные по-страничные перекрытия, только после всех прочих конструкций. -->
		<xsl:apply-templates select="/" mode="overrideable_headers"/>
	</head>
	<body>
		<div class="layoutHeader">
		<div class="layoutHeaderRounderTL">
		<div class="layoutHeaderRounderTR">
			<table class="layoutHeaderDivision">
			<tr>
				<td class="layoutHeaderSection">
					<nobr>Административный раздел сайта</nobr>
				</td>
				<td class="layoutHeaderSiteURL">
					<nobr><a href="{/*/system/info/adm_to_pub}" target="_blank"><xsl:value-of select="/*/system/info/pub_site"/></a></nobr>
				</td>
			</tr>
			</table>
		</div>
		</div>
		</div>

		<div class="layoutBody">
			<xsl:choose>
			<xsl:when test="/*/exception">
				<div class="layoutException">
					<xsl:for-each select="/*/exception">
						<h1 class="layoutExceptionTitle">Ошибка!</h1>
						<xsl:if test="string(id  )!=''"><p class="layoutExceptionId"  >Код <xsl:value-of select="id  "/></p></xsl:if>
						<xsl:if test="string(type)!=''"><p class="layoutExceptionType">Тип <xsl:value-of select="type"/></p></xsl:if>
						<xsl:if test="string(text)!=''"><p class="layoutExceptionText"><xsl:value-of select="text"/></p></xsl:if>
					</xsl:for-each>
				</div>
			</xsl:when>
			<xsl:otherwise>
				<div class="layoutContext">
					<xsl:apply-templates select="/" mode="overrideable_context"/>
				</div>
				<div class="layoutLocator">
					<xsl:choose>
					<xsl:when test="/*/main">
						<!-- Вообще не рисуем путь страниц когда у нас главная страница. -->
						<!-- Но оставляем один пробельный символ чтобы он занял высоту шрифта. -->
						<xsl:text>&nbsp;</xsl:text>
					</xsl:when>
					<xsl:otherwise>
						<div class="path">
					        	<xsl:variable name="adm_sub"><xsl:apply-templates select="/" mode="overrideable_adm_sub_root"/></xsl:variable>
							<xsl:call-template name="path_link"><xsl:with-param name="link" select="concat(/*/system/info/adm_root, $adm_sub)"/><xsl:with-param name="text" select="'Главная'"/></xsl:call-template>
							<xsl:call-template name="path_separator"/>
							<xsl:apply-templates select="/" mode="overrideable_path"/>
						</div>
					</xsl:otherwise>
					</xsl:choose>
				</div>
				<h1 class="layoutTitle">
					<xsl:apply-templates select="/" mode="overrideable_title"/>
				</h1>

				<xsl:if test="/*/auth_extended_policy">
					<div style="width:1200px">
						<xsl:apply-templates select="/*/auth_extended_policy" mode="auth_extended_policy_desc"/>
						<br /><br />
					</div>
				</xsl:if>

				<div class="layoutContent">
					<xsl:apply-templates select="/" mode="overrideable_submenu"/>
					<xsl:apply-templates select="/" mode="overrideable_content"/>
				</div>
			</xsl:otherwise>
			</xsl:choose>
		</div>
		<div id="log"></div>
	
	<div id="ImageBoxOverlay"> </div>
	<div id="popup_window" class="popup_window" style="width: 750px">
		<div class="close_img"><img src="{/*/system/info/adm_root}img/buttons/delete2.gif" width="24" height="22"/></div>
	<div id="popup__content" class="popup_content">
	</div>
	</div>

	</body>
	</html>

</xsl:template>



<xsl:template match="/*/done" priority="-1">
	<xsl:variable name="redirect"><xsl:apply-templates select="/" mode="overrideable_redirect"/></xsl:variable>
	<div class="operDone">
		<p>
			Операция выполнена.
			<br/>
			<i>Вы будете автоматически перенаправлены на исходную страницу через 1 сек.</i>
			<br/>
			<a href="{$redirect}">Продолжить работу</a>.
		</p>
	</div>
</xsl:template>



<xsl:template name="path_separator">
	<span class="pathSeparator">&nbsp;&gt; </span>
</xsl:template>

<xsl:template name="path_this">
	<xsl:param name="text"/>
	<span class="pathThis"><xsl:value-of select="$text" disable-output-escaping="yes"/></span>
</xsl:template>

<xsl:template name="path_link">
	<xsl:param name="link"/>
	<xsl:param name="text"/>
	<xsl:choose>
	<xsl:when test="$text!='' and $link!=''">
		<span class="pathLink"><a class="shy" href="{$link}"><xsl:value-of select="$text" disable-output-escaping="yes"/></a></span>
	</xsl:when>
	<xsl:when test="$text!=''">
		<span class="pathLink"><xsl:value-of select="$text" disable-output-escaping="yes"/></span>
	</xsl:when>
	<xsl:otherwise>
	</xsl:otherwise>
	</xsl:choose>
</xsl:template>




<xsl:template name="typograph">
	<xsl:param name="id"/>
	<table class="flatTable"><tr class="flatRow">
		<td class="flatCell" style="padding-left: 5px;">
			<img class="buttonTypograph" id="typograph_{$id}" src="{/*/system/info/adm_root}img/buttons/tool_typograph.gif" width="25" height="19" alt="типограф"
				onclick="return typograph('{$id}', '{$id}_status', '{/*/system/info/adm_root}typograph');" />
		</td>
		<td class="flatCell">
<!--???!!! оставить кнопочку? или сделать настройку "выводить клавиатуру при фокусе инпута"?
			<img class="buttonKeyboard" id="keyboard_{$id}" src="{/*/system/info/adm_root}img/buttons/tool_keyboard.gif" width="25" height="19" alt="клавиатура"
				onclick="return keyboard('{$id}', this);" />
-->
			<script type="text/javascript">
				$(function(){
					$(document.getElementById('<xsl:value-of select="$id"/>'))
					.focus(function(e){ $('.keyboard').keyboardAttach(this); })
					.blur (function(e){ $('.keyboard').keyboardDetach(    ); })
					;
				});
			</script>
		</td>
	</tr></table>
	<span class="ajax ajaxStatus" id="{$id}_status"></span>
<!--OLD!!!
	<button type="button" class="buttonTypograph" onclick="return typograph('{$id}', '{$id}_status', '{/*/system/info/adm_root}typograph')">
		<nobr>
			<span class="l1">T</span>
			<span class="l2">T</span>
		</nobr>
	</button>
	<span class="ajaxStatus" id="{$id}_status"></span>
-->
</xsl:template>

<!--xsl:template name="calendar_dateonly">
	<xsl:param name="id"/>
	<script type="text/javascript">
		<xsl:text>&lt;!- -</xsl:text>
		<xsl:call-template name="_newline"/>
		<![CDATA[document.write('<img'
			+' class="inlineCalendar"'
			+' src="'+ADM_ROOT+'img/buttons/calendar.gif"'
			+' width="25" height="19" alt=""'
			+' onclick="displayCalendar(document.getElementById('
			+	'\']]><xsl:value-of select="$id"/><![CDATA[\''
			+	'), \'dd.mm.yyyy\', this, false)"'
			+' />');]]>
		<xsl:call-template name="_newline"/>
		<xsl:text>//- -&gt;</xsl:text>
	</script>
	<noscript>
		<span class="nojs nojsCalendar">
			<xsl:text>(В формате ДД.ММ.ГГГГ)</xsl:text>
		</span>
	</noscript>
</xsl:template>

<xsl:template name="calendar_datetime">
	<xsl:param name="id"/>
	<script type="text/javascript">
		<xsl:text>&lt;!- -</xsl:text>
		<xsl:call-template name="_newline"/>
		<![CDATA[document.write('<img'
			+' class="inlineCalendar"'
			+' src="'+ADM_ROOT+'img/buttons/calendar.gif"'
			+' width="25" height="19" alt=""'
			+' onclick="displayCalendar(document.getElementById('
			+	'\']]><xsl:value-of select="$id"/><![CDATA[\''
			+	'), \'dd.mm.yyyy hh:ii\', this, true)"'
			+' />');]]>
		<xsl:call-template name="_newline"/>
		<xsl:text>// - -&gt;</xsl:text>
	</script>
	<noscript>
		<span class="nojs nojsCalendar">
			<xsl:text>(В формате ДД.ММ.ГГГГ ЧЧ:ММ)</xsl:text>
		</span>
	</noscript>
</xsl:template-->



<!--
Описания типичных ошибок (mode-less, но с пониженным приоритетом), свойственных всем формам и сущностям,
чтобы не обязательно было их дублировать и описывать в каждом каталоге (пр желании всегда можно перекрыть);
а также для тогочтобы в случае отсутствия специфического описания (template mode) они всё-таки выводились.
И самый общий (ещё более низкоприоритетный) шаблон для ошибки как таковой.
-->
<xsl:template priority="-10" match="form/errors/mr_duplicate		">Такой mod_rewrite уже занят.</xsl:template>
<xsl:template priority="-10" match="form/errors/mr_required		">Необходимо задать mod_rewrite.</xsl:template>
<xsl:template priority="-10" match="form/errors/mr_char			">Неприемлимый символ в mod_rewrite.</xsl:template>
<xsl:template priority="-10" match="form/errors/position_required	">Необходимо указать позицию.</xsl:template>
<xsl:template priority="-10" match="form/errors/position_bad		">Некорректное значение для позиции.</xsl:template>
<xsl:template priority="-10" match="form/errors/position_moved		">Необходимо указать позицию при перемещении между родительскими элементами.</xsl:template>



</xsl:stylesheet>
