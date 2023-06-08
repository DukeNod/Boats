<?xml version='1.0' encoding='cp1251' ?>
<!DOCTYPE xsl:stylesheet [
	<!ENTITY % HTMLlat1    PUBLIC "-//W3C//ENTITIES Latin 1 for XHTML//EN" "../../dtds/xhtml-lat1.ent"   > %HTMLlat1;
	<!ENTITY % HTMLspecial PUBLIC "-//W3C//ENTITIES Special for XHTML//EN" "../../dtds/xhtml-special.ent"> %HTMLspecial;
	<!ENTITY % HTMLsymbol  PUBLIC "-//W3C//ENTITIES Symbols for XHTML//EN" "../../dtds/xhtml-symbol.ent" > %HTMLsymbol;
]>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:php="http://php.net/xsl">

<xsl:template match="form[@for='news']/errors/ts_required    ">Необходимо указать дату.</xsl:template>
<xsl:template match="form[@for='news']/errors/ts_format      ">Дата указана в непонятном формате (нужно ДД.ММ.ГГГГ или ГГГГ-ММ-ДД).</xsl:template>
<xsl:template match="form[@for='news']/errors/ts_invalid     ">Такой даты не существует в пространственно-временном континууме.</xsl:template>
<xsl:template match="form[@for='news']/errors/title_required ">Необходимо задать название.</xsl:template>
<xsl:template match="form[@for='news']/errors/short_required ">Необходимо задать аннотацию.</xsl:template>
<xsl:template match="form[@for='news']/errors/category_required ">Необходимо указать субдомен.</xsl:template>

</xsl:stylesheet>
