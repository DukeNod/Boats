<?xml version="1.0" encoding="cp1251" ?>
<!DOCTYPE xsl:stylesheet [
	<!ENTITY % HTMLlat1    PUBLIC "-//W3C//ENTITIES Latin 1 for XHTML//EN" "../dtds/xhtml-lat1.ent"   > %HTMLlat1;
	<!ENTITY % HTMLspecial PUBLIC "-//W3C//ENTITIES Special for XHTML//EN" "../dtds/xhtml-special.ent"> %HTMLspecial;
	<!ENTITY % HTMLsymbol  PUBLIC "-//W3C//ENTITIES Symbols for XHTML//EN" "../dtds/xhtml-symbol.ent" > %HTMLsymbol;
]>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:php="http://php.net/xsl">
<xsl:include href="../xslts/public.xslt"/>
<xsl:include href="../xslts/_common_/calendars.xslt" />



<xsl:template match="/" mode="overrideable_title">
	Страница не найдена
</xsl:template>

<xsl:template match="/" mode="overrideable_keywords">
</xsl:template>

<xsl:template match="/" mode="overrideable_description">
</xsl:template>

<xsl:template match="/" mode="overrideable_leftpad">
</xsl:template>


<xsl:template match="/" mode="overrideable_menu_left">
</xsl:template>

<xsl:template match="/" mode="overrideable_content">
<h1>Страница 403</h1>
<p><strong>К сожалению, у вас пока нет доступа к информации, которая вас так заинтересовала.</strong></p>

<p><img src="{/*/system/info/pub_root}images/hangryboy.jpg"/></p>

<p><strong>
Чтобы получить расширенный доступ к материалам сайта, вам нужно пройти простую процедуру
регистрации.
</strong></p>

<p><strong>
Если вы уже являетесь зарегистрированным пользователем, то это значит, что ваш текущий уровень
доступа не такой полный, как вам хотелось бы. В этом случае, пожалуйста, 
<a href="{$LANGROOT}contacts/">напишите</a> нам и мы подумаем, что можно сделать в этой ситуации. 
</strong></p>

	<span class="inner_icon icon-3"></span>
</xsl:template>

<xsl:attribute-set name="attributes_of_body">
	<xsl:attribute name="class">inner</xsl:attribute>
</xsl:attribute-set>	


</xsl:stylesheet>
