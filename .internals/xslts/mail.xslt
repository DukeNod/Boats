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
	indent="yes"
/>



<!--
ПЕРЕОПРЕДЕЛЯЕМЫЕ ПУСТЫШКИ.
Задаём секции и шаблоны, которые можно переопределять на страницах
(чтобы они были хоть как-то определены на тот случай, если не будут переопределены;
а если будут переопределены - то больший приоритет, даже дефолтный, перекроет наши пустышки).
-->
<xsl:template priority="-10" match="/" mode="overrideable_title"       ></xsl:template>
<xsl:template priority="-10" match="/" mode="overrideable_headers"        ></xsl:template>
<xsl:template priority="-10" match="/" mode="overrideable_content"     ></xsl:template>



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
		<title>
			<xsl:apply-templates select="/" mode="overrideable_title"/>
		</title>

		<!-- Локальные по-страничные перекрытия, только после всех прочих конструкций. -->
		<xsl:apply-templates select="/" mode="overrideable_headers"/>
	</head>
	<body>
		<xsl:apply-templates select="/" mode="overrideable_content"/>
	</body>
	</html>

</xsl:template>



<xsl:template match="inline">
	<xsl:value-of select="content" disable-output-escaping="yes"/>
</xsl:template>

</xsl:stylesheet>
