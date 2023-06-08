<?xml version="1.0" encoding="cp1251" ?>
<!DOCTYPE xsl:stylesheet [
	<!ENTITY % HTMLlat1    PUBLIC "-//W3C//ENTITIES Latin 1 for XHTML//EN" "../dtds/xhtml-lat1.ent"   > %HTMLlat1;
	<!ENTITY % HTMLspecial PUBLIC "-//W3C//ENTITIES Special for XHTML//EN" "../dtds/xhtml-special.ent"> %HTMLspecial;
	<!ENTITY % HTMLsymbol  PUBLIC "-//W3C//ENTITIES Symbols for XHTML//EN" "../dtds/xhtml-symbol.ent" > %HTMLsymbol;
]>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:php="http://php.net/xsl">
<xsl:include href="../xslts/maint.xslt"/>



<xsl:template match="/" mode="overrideable_title">
	<xsl:text>Отладочный режим</xsl:text>
</xsl:template>



<xsl:template match="/" mode="overrideable_content">
	<xsl:choose>
	<xsl:when test="/*/on">
		ВКЛючён
		<br/><a href="{/*/system/info/mnt_root}_debug_/off">выключить</a>
	</xsl:when>
	<xsl:when test="/*/off">
		ВЫКЛючён
		<br/><a href="{/*/system/info/mnt_root}_debug_/on">включить</a>
	</xsl:when>
	<xsl:otherwise>
		А фиг его знает
		<br/><a href="{/*/system/info/mnt_root}_debug_/on">включить</a>
		<br/><a href="{/*/system/info/mnt_root}_debug_/off">выключить</a>
	</xsl:otherwise>
	</xsl:choose>
</xsl:template>



</xsl:stylesheet>
