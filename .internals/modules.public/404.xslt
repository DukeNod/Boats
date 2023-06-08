<?xml version="1.0" encoding="cp1251" ?>
<!DOCTYPE xsl:stylesheet [
	<!ENTITY % HTMLlat1    PUBLIC "-//W3C//ENTITIES Latin 1 for XHTML//EN" "../dtds/xhtml-lat1.ent"   > %HTMLlat1;
	<!ENTITY % HTMLspecial PUBLIC "-//W3C//ENTITIES Special for XHTML//EN" "../dtds/xhtml-special.ent"> %HTMLspecial;
	<!ENTITY % HTMLsymbol  PUBLIC "-//W3C//ENTITIES Symbols for XHTML//EN" "../dtds/xhtml-symbol.ent" > %HTMLsymbol;
]>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:php="http://php.net/xsl">
<xsl:include href="../xslts/empty.xslt"/>


<xsl:template match="/" mode="overrideable_title">
	Страница не найдена
</xsl:template>

<xsl:template match="/" mode="overrideable_keywords">
</xsl:template>

<xsl:template match="/" mode="overrideable_description">
</xsl:template>

<xsl:template match="/" mode="overrideable_measurer">
	<a class="act"><xsl:value-of select="/*/page_content/name"/></a>
</xsl:template>

<xsl:template match="/" mode="overrideable_head">
	<xsl:value-of select="/*/page_content/name" disable-output-escaping="yes"/>
</xsl:template>

<xsl:template match="/" mode="overrideable_content">

	<h1>404 Not Found</h1>
<xsl:apply-templates select="/*/page_content/linked_paras"/>

</xsl:template>

</xsl:stylesheet>
