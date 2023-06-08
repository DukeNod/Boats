<?xml version="1.0" encoding="cp1251" ?>
<!DOCTYPE xsl:stylesheet [
	<!ENTITY % HTMLlat1    PUBLIC "-//W3C//ENTITIES Latin 1 for XHTML//EN" "../dtds/xhtml-lat1.ent"   > %HTMLlat1;
	<!ENTITY % HTMLspecial PUBLIC "-//W3C//ENTITIES Special for XHTML//EN" "../dtds/xhtml-special.ent"> %HTMLspecial;
	<!ENTITY % HTMLsymbol  PUBLIC "-//W3C//ENTITIES Symbols for XHTML//EN" "../dtds/xhtml-symbol.ent" > %HTMLsymbol;
]>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:php="http://php.net/xsl">
<xsl:include href="../xslts/mail.xslt"/>

<xsl:variable name="now">
	<xsl:call-template name="datetime_numeric_ru">
		<xsl:with-param name="year"   select="/*/system/now/year"/>
		<xsl:with-param name="month"  select="/*/system/now/mon"/>
		<xsl:with-param name="day"    select="/*/system/now/mday"/>
		<xsl:with-param name="hour"   select="/*/system/now/hours"/>
		<xsl:with-param name="minute" select="/*/system/now/minutes"/>
	</xsl:call-template>
</xsl:variable>


<xsl:template match="/" mode="overrideable_title">
	<xsl:text>Barybina.ru - оставлен отзыв от </xsl:text><xsl:value-of select="$now"/>
</xsl:template>


<xsl:template match="/" mode="overrideable_content">

	<h2>Barybina.ru - оставлен отзыв на сайте от <xsl:value-of select="$now"/></h2>

	<style>
	table			{ border-collapse: collapse; border: none; margin-top: 1em; }
	td, th			{ vertical-align: top; text-align: left; padding: 0 1ex 0 1ex; }
	th			{ color: #7a96c9; }
	.items td, .items th	{ border: solid 1px gray; }
	</style>
	
	<table>
		<tr>
			<th>Имя</th>
			<td><xsl:value-of select="/*/mail/author"/></td>
		</tr>
		<tr>
			<th>E-mail</th>
			<td><xsl:value-of select="/*/mail/email"/></td>
		</tr>
		<tr>
			<th>Телефон</th>
			<td><xsl:value-of select="/*/mail/phone"/></td>
		</tr>
		<xsl:if test="/*/object/*">
		<tr>
			<th>Отзыв о </th>
			<td>
				<xsl:apply-templates select="/*/mail/object_type"/> "<xsl:value-of select="/*/object/name" disable-output-escaping="yes"/>"
			</td>
		</tr>
		</xsl:if>
		<tr>
			<th>Заголовок</th>
			<td><xsl:value-of select="/*/mail/title"/></td>
		</tr>
		<tr>
			<th>Отзыв</th>
			<td><xsl:value-of select="/*/mail/response"/></td>
		</tr>
	</table>

	<xsl:apply-templates select="/*/inlines/inline[label='mailer:sign']"/>

</xsl:template>



</xsl:stylesheet>
