<?xml version="1.0" encoding="cp1251" ?>
<!DOCTYPE xsl:stylesheet [
	<!ENTITY % HTMLlat1    PUBLIC "-//W3C//ENTITIES Latin 1 for XHTML//EN" "../dtds/xhtml-lat1.ent"   > %HTMLlat1;
	<!ENTITY % HTMLspecial PUBLIC "-//W3C//ENTITIES Special for XHTML//EN" "../dtds/xhtml-special.ent"> %HTMLspecial;
	<!ENTITY % HTMLsymbol  PUBLIC "-//W3C//ENTITIES Symbols for XHTML//EN" "../dtds/xhtml-symbol.ent" > %HTMLsymbol;
]>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:php="http://php.net/xsl">
<xsl:include href="../xslts/mail.xslt"/>



<xsl:template match="/" mode="overrideable_title">
	<xsl:value-of select="/*/system/info/sitename"/><xsl:text> - получен ответ на вопрос</xsl:text>
</xsl:template>



<xsl:template match="/" mode="overrideable_content">

	<h2><xsl:value-of select="/*/system/info/sitename"/> - получен ответ на вопрос в разделе "Вопрос-ответ"</h2>

	<style>
	table			{ border-collapse: collapse; border: none; margin-top: 1em; }
	td, th			{ vertical-align: top; text-align: left; padding: 0 1ex 0 1ex; }
	th			{ color: #7a96c9; }
	.items td, .items th	{ border: solid 1px gray; }
	</style>
	
	<table>
		<tr>
			<th>Имя</th>
			<td><xsl:value-of select="/*/mail/author" disable-output-escaping="no"/></td>
		</tr>
		<tr>
			<th>E-mail</th>
			<td><xsl:value-of select="/*/mail/email" disable-output-escaping="no"/></td>
		</tr>
		<tr>
			<th>Вопрос</th>
			<td><xsl:value-of select="/*/mail/question" disable-output-escaping="no"/></td>
		</tr>
		<tr>
			<th>Ответ</th>
			<td><xsl:value-of select="/*/mail/answer" disable-output-escaping="yes"/></td>
		</tr>
	</table>

	<xsl:apply-templates select="/*/inlines/inline[label='mailer:sign']"/>

</xsl:template>



</xsl:stylesheet>
