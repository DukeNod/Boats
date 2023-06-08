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

<!--
ВНИМАНИЕ:
Тег <meta content-type> (с mime-type и charset) перекрывается автоматически, хотя в документации это нигде явно не описано.
Indent принудительно отключен, потому что XSLT-процессор почему-то его включает (хотя default=no), и это портит вёрстку.
-->
<xsl:output
	method="html" 
	indent="yes"
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

<xsl:template priority="-99" match="/" mode="curr_category"    ></xsl:template>
<xsl:template priority="-99" match="/" mode="overrideable_body"        ><xsl:call-template name="default_body"/></xsl:template>

<xsl:template priority="-99" match="/" mode="global_top_menu"></xsl:template> 
<xsl:template priority="-99" match="/" mode="select_item"></xsl:template> 


<xsl:attribute-set name="attributes_of_body"></xsl:attribute-set>


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
	<xsl:text disable-output-escaping="yes"><![CDATA[<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN"
"http://www.w3.org/TR/html4/loose.dtd">]]></xsl:text>
	<xsl:call-template name="_newline"/>
	
	

	<!-- Самая верхнеуровневая разметка, касающаяся технического представления страницы. -->
	<html>
	<head>
		<!-- Основные теги и конструкции страницы. -->
		<!-- Content-Type с правильной кодировкой подставится сам на основе xsl:output. -->
		<meta http-equiv="content-type"     content="text/html"/>
		<meta http-equiv="content-language" content="ru"/>

		<!-- Поисково-оптимизационные параметры страницы. -->
		<!-- Для вывода используется CDATA чтобы избежать чрезмерно умного квотинга entities (lt+gt+amp) в атрибутах. -->
		<title>
		<xsl:choose>
			<xsl:when test="/*/system/over_meta/title!=''">
				<xsl:call-template name="safe_cut">
				<xsl:with-param name="in_string">
				<xsl:call-template name="meta_string">
					<xsl:with-param name="string"><xsl:value-of select="/*/system/over_meta/title"/></xsl:with-param>
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
		<xsl:text disable-output-escaping="yes"><![CDATA[<meta name="keywords" content="]]></xsl:text>
		<xsl:choose>
			<xsl:when test="/*/system/over_meta/keywords!=''">
				<xsl:call-template name="meta_string">
					<xsl:with-param name="string"><xsl:value-of select="/*/system/over_meta/keywords"/></xsl:with-param>
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
		<xsl:text disable-output-escaping="yes"><![CDATA[<meta name="description" content="]]></xsl:text>
		<xsl:choose>
			<xsl:when test="/*/system/over_meta/description!=''">
				<xsl:call-template name="meta_string">
					<xsl:with-param name="string"><xsl:value-of select="/*/system/over_meta/description"/></xsl:with-param>
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

		<!-- Прочие поисковые и информационные параметры страницы. -->
		<meta name="document-state" 		content="Dynamic"/>
		<meta name="revisit-after" 			content="3days"/>
		<meta name="distribution"   		content="Global"/>
		<meta name="robots"         		content="INDEX,FOLLOW"/>
		<meta name="rating"         		content="General"/>
		<meta http-equiv="content-type" 	content="text/html charset=utf-8"/>
		<meta http-equiv="content-language" 	content="ru"/>
		<meta http-equiv="pragma" 		content="cache"/>
		<meta http-equiv="window-target" 	content="_self"/>
		<meta name="abstract" 			content="abstract"/>
		<meta name="classification" 		content="Trade"/>
		<meta name="pics-label"     		content="pics rating"/>
		<link rel="shortcut icon"		href="{/*/system/info/pub_root}favicon.ico"/>

		<!-- Глобальные определения (практически константы) JS - чтобы не писать <xsl:value-of> внутри JS'овских CDATA. -->
		<!-- Важно чтобы они были внутри самой страницы, а не во внешних файлах, и чтобы задавались как можно раньше. -->
		<!-- Этот JS верстаем с особой тщательностью (чуть не по символам), потому что важно чтобы он сработал чисто. -->
		<script type="text/javascript">
			<xsl:text>&lt;!--</xsl:text><xsl:call-template name="_newline"/>
			<xsl:text>var PUB_SITE = "</xsl:text><xsl:value-of select="php:function('addslashes', string(/*/system/info/pub_site))"/><xsl:text>";</xsl:text><xsl:call-template name="_newline"/>
			<xsl:text>var PUB_ROOT = "</xsl:text><xsl:value-of select="php:function('addslashes', string(/*/system/info/pub_root))"/><xsl:text>";</xsl:text><xsl:call-template name="_newline"/>
			<xsl:text>//--&gt;</xsl:text>
		</script>


		<link href="{/*/system/info/pub_root}css/layout_reset.css" type="text/css" rel="stylesheet"/>
		<link href="{/*/system/info/pub_root}css/style.css" type="text/css" rel="stylesheet"/>
		<link href="{/*/system/info/pub_root}css/flexslider.css" type="text/css" rel="stylesheet"/>

		<!--xsl:if test="/*/print">
		<link rel="stylesheet" type="text/css" media="all" href="{/*/system/info/pub_root}c/print.css"/>
		</xsl:if-->
	
		<xsl:call-template name="_newline"/>

	<!-- Условные прицепления для разных браузеров. Идут после ощих файлов, но до дополнительных. -->

		<xsl:text disable-output-escaping="yes">&lt;!--[if IE 7]&gt;</xsl:text>
		<link href="{/*/system/info/pub_root}css/ie7.css" type="text/css" rel="stylesheet"/>
		<xsl:text disable-output-escaping="yes">&lt;![endif]--&gt;</xsl:text>

		<xsl:text disable-output-escaping="yes">&lt;!--[if IE 6]&gt;</xsl:text>
		<link href="{/*/system/info/pub_root}css/ie6.css" type="text/css" rel="stylesheet"/>
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
	<body xsl:use-attribute-sets="attributes_of_body">
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
	<!--h3><xsl:apply-templates select="/" mode="overrideable_head"/></h3-->
	<xsl:apply-templates select="/" mode="overrideable_content"/>
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



<xsl:template name="measurer_divider">&nbsp;&nbsp;&nbsp;&nbsp;|&nbsp;&nbsp;&nbsp;&nbsp;</xsl:template>
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

</xsl:stylesheet>
