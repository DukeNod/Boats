<?xml version="1.0" encoding="cp1251" ?>
<!DOCTYPE xsl:stylesheet [
	<!ENTITY % HTMLlat1    PUBLIC "-//W3C//ENTITIES Latin 1 for XHTML//EN" "../../dtds/xhtml-lat1.ent"   > %HTMLlat1;
	<!ENTITY % HTMLspecial PUBLIC "-//W3C//ENTITIES Special for XHTML//EN" "../../dtds/xhtml-special.ent"> %HTMLspecial;
	<!ENTITY % HTMLsymbol  PUBLIC "-//W3C//ENTITIES Symbols for XHTML//EN" "../../dtds/xhtml-symbol.ent" > %HTMLsymbol;
]>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:php="http://php.net/xsl">
<xsl:include href="../../xslts/admin.xslt"/>
<xsl:include href="../../xslts/_common_/lists.xslt" />
<xsl:include href="../../xslts/form_fields/list.xslt"/>
<xsl:include href="./conf.xslt"/>


<xsl:template match="/" mode="overrideable_selector">
	<xsl:value-of select="$essence"/>
</xsl:template>

<xsl:template match="/" mode="overrideable_title">
	<xsl:value-of select="$essence_title"/>
</xsl:template>

<xsl:template match="/" mode="overrideable_path">
	<xsl:call-template name="path_this"><xsl:with-param name="text" select="$essence_title"/></xsl:call-template>
</xsl:template>



<xsl:template match="/*/list">
	<xsl:call-template name="list_of_form_fields">
		<xsl:with-param name="node"    select="."/>
		<xsl:with-param name="filters" select="/*/filters"/>
		<xsl:with-param name="sorters" select="/*/sorters"/>
		<xsl:with-param name="pager"   select="/*/pager"/>
		<xsl:with-param name="essence"   select="$essence"/>
	</xsl:call-template>
</xsl:template>



</xsl:stylesheet>
