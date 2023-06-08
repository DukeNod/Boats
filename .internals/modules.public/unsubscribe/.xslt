<?xml version="1.0" encoding="cp1251" ?>
<!DOCTYPE xsl:stylesheet [
	<!ENTITY % HTMLlat1    PUBLIC "-//W3C//ENTITIES Latin 1 for XHTML//EN" "../../dtds/xhtml-lat1.ent"   > %HTMLlat1;
	<!ENTITY % HTMLspecial PUBLIC "-//W3C//ENTITIES Special for XHTML//EN" "../../dtds/xhtml-special.ent"> %HTMLspecial;
	<!ENTITY % HTMLsymbol  PUBLIC "-//W3C//ENTITIES Symbols for XHTML//EN" "../../dtds/xhtml-symbol.ent" > %HTMLsymbol;
]>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:php="http://php.net/xsl">
<xsl:include href="../../xslts/empty.xslt"/>
<xsl:include href="../../xslts/subscribers/public_errors.xslt"/>
<xsl:include href="../../xslts/subscribers/public_macros.xslt"/>



<xsl:template match="/" mode="overrideable_title">
	<xsl:text>Отписка от новостей</xsl:text>
</xsl:template>

<xsl:template match="/" mode="overrideable_keywords">
	<xsl:text>Отписка от новостей</xsl:text>
</xsl:template>

<xsl:template match="/" mode="overrideable_description">
	<xsl:text>Отписка от новостей</xsl:text>
</xsl:template>
<xsl:template match="/" mode="overrideable_head">
	<xsl:text>Отписка от новостей</xsl:text>
</xsl:template>

<xsl:template match="/" mode="overrideable_measurer">
	<xsl:text>Отписка от новостей</xsl:text>
</xsl:template>



<xsl:template match="/" mode="overrideable_content">
	<div class="news-subscribe">
		<xsl:call-template name="subscription"/>
	</div>
</xsl:template>



</xsl:stylesheet>
