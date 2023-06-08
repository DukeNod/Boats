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
	<xsl:value-of select="/*/system/info/sitename"/><xsl:text> - рассылка завершена - рассылка круизного агентства &laquo;Атолл Трэвел&raquo; - </xsl:text><xsl:value-of select="$now"/>
</xsl:template>



<xsl:template match="/" mode="overrideable_content">

	<style type="text/css"><![CDATA[
	]]></style>

	<h2><xsl:value-of select="/*/system/info/sitename"/> &mdash; рассылка завершена</h2>

	<font color="#7A96C9">Заголовок сообщения:</font><xsl:text> </xsl:text><i><xsl:value-of select="/*/current_mailer[last()]/subject" disable-output-escaping="yes"/></i><br/>
	<font color="#7A96C9">Рассылка успешно завершена</font><xsl:text> </xsl:text><xsl:value-of select="$now"/><br/>

	<xsl:apply-templates select="/*/inlines/inline[label='mailer:sign']"/>

</xsl:template>



</xsl:stylesheet>
