<?xml version='1.0' encoding='cp1251' ?>
<!DOCTYPE xsl:stylesheet [
	<!ENTITY % HTMLlat1    PUBLIC "-//W3C//ENTITIES Latin 1 for XHTML//EN" "../../dtds/xhtml-lat1.ent"   > %HTMLlat1;
	<!ENTITY % HTMLspecial PUBLIC "-//W3C//ENTITIES Special for XHTML//EN" "../../dtds/xhtml-special.ent"> %HTMLspecial;
	<!ENTITY % HTMLsymbol  PUBLIC "-//W3C//ENTITIES Symbols for XHTML//EN" "../../dtds/xhtml-symbol.ent" > %HTMLsymbol;
]>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:php="http://php.net/xsl">

<xsl:template match="form[@for='form_fields']/errors/name_required     ">Необходимо указать название товара.</xsl:template>
<xsl:template match="form[@for='form_fields']/errors/category_required     ">Необходимо указать категорию товара.</xsl:template>
<xsl:template match="form[@for='form_fields']/errors/brand_required     ">Необходимо указать торговую марку товара.</xsl:template>
<xsl:template match="form[@for='form_fields']/errors/currency_bad     ">Необходимо указать торговую марку товара.</xsl:template>
<xsl:template match="form[@for='form_fields']/errors/material_required     ">Необходимо указать торговую марку товара.</xsl:template>
<xsl:template match="form[@for='form_fields']/errors/weight_required     ">Необходимо указать торговую марку товара.</xsl:template>

</xsl:stylesheet>
