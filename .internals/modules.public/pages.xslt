<?xml version="1.0" encoding="cp1251" ?>
<!DOCTYPE xsl:stylesheet [
	<!ENTITY % HTMLlat1    PUBLIC "-//W3C//ENTITIES Latin 1 for XHTML//EN" "../../dtds/xhtml-lat1.ent"   > %HTMLlat1;
	<!ENTITY % HTMLspecial PUBLIC "-//W3C//ENTITIES Special for XHTML//EN" "../../dtds/xhtml-special.ent"> %HTMLspecial;
	<!ENTITY % HTMLsymbol  PUBLIC "-//W3C//ENTITIES Symbols for XHTML//EN" "../../dtds/xhtml-symbol.ent" > %HTMLsymbol;
]>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:php="http://php.net/xsl">
	<xsl:param name="inline_title" select="/*/page_content/name"/>
	<xsl:include href="../xslts/pages/public.xslt"/>

	<xsl:template  match="/" mode="overrideable_head"><xsl:value-of select="$inline_title" disable-output-escaping="yes"/></xsl:template>
	<xsl:template  match="/" mode="global_top_menu"><xsl:value-of select="/*/page_path/parent[1]/mr"/></xsl:template>
	<xsl:template  match="/" mode="select_item"><xsl:value-of select="/*/page_content/mr"/></xsl:template>
		
</xsl:stylesheet>
