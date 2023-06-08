<?xml version='1.0' encoding='cp1251' ?>
<!DOCTYPE xsl:stylesheet [
	<!ENTITY % HTMLlat1    PUBLIC "-//W3C//ENTITIES Latin 1 for XHTML//EN" "../dtds/xhtml-lat1.ent"   > %HTMLlat1;
	<!ENTITY % HTMLspecial PUBLIC "-//W3C//ENTITIES Special for XHTML//EN" "../dtds/xhtml-special.ent"> %HTMLspecial;
	<!ENTITY % HTMLsymbol  PUBLIC "-//W3C//ENTITIES Symbols for XHTML//EN" "../dtds/xhtml-symbol.ent" > %HTMLsymbol;
]>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:php="http://php.net/xsl">
<xsl:include href="_all_.xslt" />
<xsl:include href="./_common_/media.xslt" />
<xsl:include href="./_common_/picts.xslt" />
<xsl:include href="./_common_/paras.xslt" />
<xsl:include href="./_common_/dates.xslt" />

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
<xsl:template priority="-10" match="/" mode="overrideable_title"      ></xsl:template>
<xsl:template priority="-10" match="/" mode="overrideable_keywords"   ></xsl:template>
<xsl:template priority="-10" match="/" mode="overrideable_description"></xsl:template>
<xsl:template priority="-10" match="/" mode="overrideable_headers"       ></xsl:template>
<xsl:template priority="-10" match="/" mode="overrideable_content"></xsl:template>



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
			<xsl:text>//--&gt;</xsl:text>
		</script>

		<!-- Общие (всестраничные, по-страничные и верстальные) JS- и CSS-файлы. -->
		<link rel="stylesheet" type="text/css" href="{/*/system/info/adm_root}css/admin.css"></link>

		<!-- Локальные по-страничные перекрытия, только после всех прочих конструкций. -->
		<xsl:apply-templates select="/" mode="overrideable_headers"/>
	</head>
	<body>
		<div class="layoutHeader">
			<a href="{/*/system/info/adm_to_pub}" target="_blank">
				<xsl:value-of select="/*/system/info/pub_site"/>
			</a>
		</div>

		<div class="layoutBorderL">
		<div class="layoutBorderR">
			<xsl:choose>
			<xsl:when test="/*/exception">
				<xsl:for-each select="/*/exception">
					<div class="layoutException">
						<h1 class="layoutExceptionTitle">Ошибка!</h1>
						<xsl:if test="string(id  )!=''"><p class="layoutExceptionId"  >Код <xsl:value-of select="id  "/></p></xsl:if>
						<xsl:if test="string(type)!=''"><p class="layoutExceptionType">Тип <xsl:value-of select="type"/></p></xsl:if>
						<xsl:if test="string(text)!=''"><p class="layoutExceptionText"><xsl:value-of select="text"/></p></xsl:if>
					</div>
				</xsl:for-each>
			</xsl:when>
			<xsl:otherwise>
				<div class="layoutBody">
					<h1 class="layoutTitle">
						<xsl:apply-templates select="/" mode="overrideable_title"/>
					</h1>
					<div class="layoutContent">
						<xsl:apply-templates select="/" mode="overrideable_content"/>
					</div>
				</div>
			</xsl:otherwise>
			</xsl:choose>
		</div>
		</div>

<!--???		<div class="layoutFooter"></div>-->
	</body>
	</html>

</xsl:template>



</xsl:stylesheet>
