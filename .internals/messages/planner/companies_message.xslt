<?xml version="1.0" encoding="cp1251" ?>
<!DOCTYPE xsl:stylesheet [
	<!ENTITY % HTMLlat1    PUBLIC "-//W3C//ENTITIES Latin 1 for XHTML//EN" "../dtds/xhtml-lat1.ent"   > %HTMLlat1;
	<!ENTITY % HTMLspecial PUBLIC "-//W3C//ENTITIES Special for XHTML//EN" "../dtds/xhtml-special.ent"> %HTMLspecial;
	<!ENTITY % HTMLsymbol  PUBLIC "-//W3C//ENTITIES Symbols for XHTML//EN" "../dtds/xhtml-symbol.ent" > %HTMLsymbol;
]>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:php="http://php.net/xsl">

<xsl:include href="../../xslts/mail.xslt"/>
<xsl:include href="companies_table.xslt"/>

<xsl:variable name="now">
	<xsl:text>(</xsl:text>
	<xsl:call-template name="datetime_numeric_ru">
		<xsl:with-param name="year"   select="/*/system/now/year"/>
		<xsl:with-param name="month"  select="/*/system/now/mon"/>
		<xsl:with-param name="day"    select="/*/system/now/mday"/>
		<xsl:with-param name="hour"   select="/*/system/now/hours"/>
		<xsl:with-param name="minute" select="/*/system/now/minutes"/>
	</xsl:call-template>
	<xsl:text>)</xsl:text>
</xsl:variable>

<xsl:template match="/" mode="overrideable_title">
	<xsl:choose>
		<xsl:when test="/*/mail/data/item">
		    <xsl:value-of select="/*/mail/title" disable-output-escaping="yes" />
		</xsl:when>
		<xsl:otherwise>
		    <xsl:value-of select="/*/mail/no_data_title" disable-output-escaping="yes" />
		</xsl:otherwise>
	</xsl:choose>
</xsl:template>

<xsl:template match="/" mode="overrideable_content">
	<h2>
	<xsl:choose>
		<xsl:when test="/*/mail/data/item">
		    <xsl:value-of select="/*/mail/title" disable-output-escaping="yes" />
		</xsl:when>
		<xsl:otherwise>
		    <xsl:value-of select="/*/mail/no_data_title" disable-output-escaping="yes" />
		</xsl:otherwise>
	</xsl:choose>
	на <xsl:value-of select="$now" />
	</h2>
	Отправлено с: <xsl:value-of select="/*/system/info/pub_site" disable-output-escaping="yes"/>
	<br />
	Диапазон проверки от <xsl:apply-templates select="/*/mail/check_start_parsed" mode="show_date_ru"/> 
	до <xsl:apply-templates select="/*/mail/check_end_parsed" mode="show_date_ru"/>

	<xsl:call-template name="companies_table">
		<xsl:with-param name="items" select="/*/mail/data"/>
		<xsl:with-param name="no_data_message" select="/*/mail/no_data_title"/>
	</xsl:call-template>

</xsl:template>

</xsl:stylesheet>
