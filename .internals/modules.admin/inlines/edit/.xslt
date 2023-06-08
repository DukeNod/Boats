<?xml version="1.0" encoding="cp1251" ?>
<!DOCTYPE xsl:stylesheet [
	<!ENTITY % HTMLlat1    PUBLIC "-//W3C//ENTITIES Latin 1 for XHTML//EN" "../../../dtds/xhtml-lat1.ent"   > %HTMLlat1;
	<!ENTITY % HTMLspecial PUBLIC "-//W3C//ENTITIES Special for XHTML//EN" "../../../dtds/xhtml-special.ent"> %HTMLspecial;
	<!ENTITY % HTMLsymbol  PUBLIC "-//W3C//ENTITIES Symbols for XHTML//EN" "../../../dtds/xhtml-symbol.ent" > %HTMLsymbol;
]>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:php="http://php.net/xsl">
<xsl:include href="../../../xslts/admin.xslt"/>
<xsl:include href="../../../xslts/_common_/lists.xslt" />
<xsl:include href="../../../xslts/inlines/list.xslt"/>



<xsl:template match="/" mode="overrideable_selector">inlines</xsl:template>

<xsl:template match="/" mode="overrideable_title">
	<xsl:text>Текстовые вставки</xsl:text>
</xsl:template>

<xsl:template match="/" mode="overrideable_path">
	<xsl:choose>
	<xsl:when test="/*/group != 'text' and /*/group!=''">
		<xsl:call-template name="path_link"><xsl:with-param name="link" select="concat(/*/system/info/adm_root, 'inlines')"/><xsl:with-param name="text" select="'Текстовые вставки'"/></xsl:call-template>
		<xsl:call-template name="path_separator"/>
		<xsl:call-template name="path_this"><xsl:with-param name="text" select="/*/group"/></xsl:call-template>
	</xsl:when>
	<xsl:otherwise>
		<xsl:call-template name="path_this"><xsl:with-param name="text" select="'Текстовые вставки'"/></xsl:call-template>
	</xsl:otherwise>
	</xsl:choose>
</xsl:template>



<xsl:template match="/*/list">
	<xsl:call-template name="list_of_inlines_full">
		<xsl:with-param name="node"    select="."/>
		<xsl:with-param name="filters" select="/*/filters"/>
		<xsl:with-param name="sorters" select="/*/sorters"/>
		<xsl:with-param name="pager"   select="/*/pager"/>
		<xsl:with-param name="group"   select="/*/group"/>
	</xsl:call-template>
</xsl:template>



</xsl:stylesheet>
