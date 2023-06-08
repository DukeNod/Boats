<?xml version="1.0" encoding="cp1251" ?>
<!DOCTYPE xsl:stylesheet [
	<!ENTITY % HTMLlat1    PUBLIC "-//W3C//ENTITIES Latin 1 for XHTML//EN" "../../dtds/xhtml-lat1.ent"   > %HTMLlat1;
	<!ENTITY % HTMLspecial PUBLIC "-//W3C//ENTITIES Special for XHTML//EN" "../../dtds/xhtml-special.ent"> %HTMLspecial;
	<!ENTITY % HTMLsymbol  PUBLIC "-//W3C//ENTITIES Symbols for XHTML//EN" "../../dtds/xhtml-symbol.ent" > %HTMLsymbol;
]>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:php="http://php.net/xsl">
<xsl:include href="../../xslts/public.xslt"/>

<xsl:template priority="-1" match="/" mode="overrideable_title">
<xsl:variable name="global_title"><xsl:apply-templates select="/" mode="global_title"/></xsl:variable>
	<xsl:choose>
		<xsl:when test="$global_title='someunusualsection'">
			Инесс-М – <xsl:value-of select="$inline_title"/>
		</xsl:when>
		<xsl:otherwise>
			<xsl:value-of select="$inline_title"/>
		</xsl:otherwise>
	</xsl:choose>	
</xsl:template>

<xsl:template priority="-1" match="/" mode="overrideable_keywords">
<xsl:variable name="global_title"><xsl:apply-templates select="/" mode="global_title"/></xsl:variable>
	<xsl:choose>
		<xsl:when test="$global_title='someunusualsection'">
			Инесс-М – <xsl:value-of select="$inline_title"/>
		</xsl:when>
		<xsl:otherwise>
			<xsl:value-of select="$inline_title"/>
		</xsl:otherwise>
	</xsl:choose>
</xsl:template>

<xsl:template priority="-1" match="/" mode="overrideable_description">
	<xsl:variable name="global_title"><xsl:apply-templates select="/" mode="global_title"/></xsl:variable>
	<xsl:choose>
		<xsl:when test="$global_title='someunusualsection'">
			Инесс-М - <xsl:value-of select="$inline_title"/>
		</xsl:when>
		<xsl:when test="$global_title='company'">
			<xsl:value-of select="$inline_title"/>
		</xsl:when>
		<xsl:otherwise>
			<xsl:value-of select="$inline_title"/>
		</xsl:otherwise>
	</xsl:choose>
</xsl:template>

<xsl:template priority="-1" match="/" mode="overrideable_path">
	<xsl:value-of select="$inline_title"/>
</xsl:template>

<xsl:template match="/" mode="overrideable_content">
	<xsl:apply-templates select="/*/inlines/inline[label=/*/inline_name]">
		<xsl:with-param name="title_inline" select="$inline_title"/>
	</xsl:apply-templates>
</xsl:template>

</xsl:stylesheet>
