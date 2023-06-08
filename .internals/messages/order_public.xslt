<?xml version="1.0" encoding="cp1251" ?>
<!DOCTYPE xsl:stylesheet [
	<!ENTITY % HTMLlat1    PUBLIC "-//W3C//ENTITIES Latin 1 for XHTML//EN" "../dtds/xhtml-lat1.ent"   > %HTMLlat1;
	<!ENTITY % HTMLspecial PUBLIC "-//W3C//ENTITIES Special for XHTML//EN" "../dtds/xhtml-special.ent"> %HTMLspecial;
	<!ENTITY % HTMLsymbol  PUBLIC "-//W3C//ENTITIES Symbols for XHTML//EN" "../dtds/xhtml-symbol.ent" > %HTMLsymbol;
]>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:php="http://php.net/xsl">
<xsl:include href="../xslts/mail.xslt"/>



<xsl:template match="/" mode="overrideable_title">
		<xsl:text>Ваш заказ продукции на сайте </xsl:text><xsl:value-of select="/*/system/info/sitename"/><xsl:text> принят</xsl:text>
		<xsl:value-of select="/*/mail/id"/>
		<xsl:text> от </xsl:text>
		<xsl:call-template name="datetime_numeric_ru">
			<xsl:with-param name="year"   select="/*/system/now/year"/>
			<xsl:with-param name="month"  select="/*/system/now/mon"/>
			<xsl:with-param name="day"    select="/*/system/now/mday"/>
			<xsl:with-param name="hour"   select="/*/system/now/hours"/>
			<xsl:with-param name="minute" select="/*/system/now/minutes"/>
			<xsl:with-param name="comma"  select="''"/>
		</xsl:call-template>
</xsl:template>



<xsl:template match="/" mode="overrideable_content">

	<h2><xsl:apply-templates select="/" mode="overrideable_title"/></h2>

	<style>
	table			{ border-collapse: collapse; border: none; margin-top: 1em; }
	td, th			{ vertical-align: top; text-align: left; padding: 0 1ex 0 1ex; }
	th			{ color: #7a96c9; }
	.items td, .items th	{ border: solid 1px #7a96c9; }
	</style>
	
	<table class="info">
		<tr>
			<th>Интересует</th>
			<td><xsl:value-of select="/*/mail/interest"/></td>
		</tr>
		<tr>
			<th>Имя</th>
			<td><xsl:value-of select="/*/mail/name"/></td>
		</tr>
		<tr>
			<th>Телефон</th>
			<td><xsl:value-of select="/*/mail/phone"/></td>
		</tr>
		<tr>
			<th>E-mail</th>
			<td><xsl:value-of select="/*/mail/email"/></td>
		</tr>

		<tr><th></th><td>&nbsp;</td></tr>


		<tr>
			<th>Сообщение</th>
			<td><xsl:value-of select="/*/mail/comments"/></td>
		</tr>
		<tr>
			<th>Ссылка на страницу продукции</th>
			<td>
				<xsl:variable name="cur_mr"><xsl:apply-templates select="/*/path/parent" mode="make_mr"/></xsl:variable>
				<xsl:variable name="url" select="concat(/*/system/info/pub_site, 'productions/', $cur_mr, /*/item/mr, '/')"/>
				<a href="{$url}"><xsl:value-of select="$url" disable-output-escaping="yes"/></a>
			</td>
		</tr>
	</table>
	
	<p><i>В ближайшее время наши специалисты обязательно свяжутся с Вами и уточнят все интересующие Вас вопросы.</i></p>

	<xsl:apply-templates select="/*/inlines/inline[label='mailer:sign']"/>

</xsl:template>



</xsl:stylesheet>
