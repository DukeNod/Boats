<?xml version="1.0" encoding="cp1251" ?>
<!DOCTYPE xsl:stylesheet [
	<!ENTITY % HTMLlat1    PUBLIC "-//W3C//ENTITIES Latin 1 for XHTML//EN" "../../dtds/xhtml-lat1.ent"   > %HTMLlat1;
	<!ENTITY % HTMLspecial PUBLIC "-//W3C//ENTITIES Special for XHTML//EN" "../../dtds/xhtml-special.ent"> %HTMLspecial;
	<!ENTITY % HTMLsymbol  PUBLIC "-//W3C//ENTITIES Symbols for XHTML//EN" "../../dtds/xhtml-symbol.ent" > %HTMLsymbol;
]>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:php="http://php.net/xsl">

<xsl:param name="essence_title">
	<xsl:apply-templates select="/*/news_group" mode="news_group_title"/>
</xsl:param>
<xsl:param name="essence" select="'news'"/>

<xsl:template match="/" mode="overrideable_selector"><xsl:value-of select="/*/news_group" /></xsl:template>

<xsl:template match="*" mode="news_group_title">
	<xsl:choose>
	<xsl:when test=". = 'news'">Новости</xsl:when>
	<xsl:when test=". = 'special'">Специальные акции</xsl:when>
	<xsl:when test=". = 'outdoor'">Наружная реклама</xsl:when>
	<xsl:when test=". = 'pressa'">Публикации в прессе</xsl:when>
	<xsl:when test=". = 'exhibition'">Выставочная деятельность</xsl:when>
	<xsl:when test=". = 'pos'">POS материалы Timberk</xsl:when>
	<xsl:when test=". = 'combined'">Совместные рекламные акции</xsl:when>
	<xsl:when test=". = 'printing'">Полиграфические материалы</xsl:when>
	</xsl:choose>
</xsl:template>

</xsl:stylesheet>
