<?xml version="1.0" encoding="cp1251" ?>
<!DOCTYPE xsl:stylesheet [
	<!ENTITY % HTMLlat1    PUBLIC "-//W3C//ENTITIES Latin 1 for XHTML//EN" "../dtds/xhtml-lat1.ent"   > %HTMLlat1;
	<!ENTITY % HTMLspecial PUBLIC "-//W3C//ENTITIES Special for XHTML//EN" "../dtds/xhtml-special.ent"> %HTMLspecial;
	<!ENTITY % HTMLsymbol  PUBLIC "-//W3C//ENTITIES Symbols for XHTML//EN" "../dtds/xhtml-symbol.ent" > %HTMLsymbol;
]>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:php="http://php.net/xsl">
<xsl:include href="../xslts/mail.xslt"/>



<xsl:template match="/" mode="overrideable_title">
	<xsl:text>Новое сообщение на форуме EuroSharm.ru </xsl:text>
</xsl:template>



<xsl:template match="/" mode="overrideable_content">
	<style><![CDATA[
		table	{ border-collapse: collapse; }
		td, th	{ vertical-align: top; border: solid 1px gray; }
	]]></style>

	<h2>EuroSharm.ru  &mdash; сообщение на форуме</h2>

	<table width="100%">
		<tr>
			<th><nobr>Ссылка</nobr></th>
			<td>
				<xsl:choose>
				<xsl:when test="/*/done/topic_id!=''">
					<a href="{/*/system/info/pub_site}forum/read/{/*/done/topic_id}/{/*/done/id}">
					<xsl:value-of select="/*/system/info/pub_site"/>forum/read/<xsl:value-of select="/*/done/topic_id"/>/<xsl:value-of select="/*/done/id"/></a>
				</xsl:when>
				<xsl:otherwise>
					<a href="{/*/system/info/pub_site}forum/read/{/*/done/id}/{/*/done/id}">
					<xsl:value-of select="/*/system/info/pub_site"/>forum/read/<xsl:value-of select="/*/done/id"/>/<xsl:value-of select="/*/done/id"/></a>
				</xsl:otherwise>
				</xsl:choose>
			</td>
		</tr>
		<tr>
			<th><nobr>Удалить</nobr></th>
			<td>
				<a href="{/*/system/info/adm_site}forum/delete/{/*/done/id}">
				<xsl:value-of select="/*/system/info/adm_site"/>forum/delete/<xsl:value-of select="/*/done/id"/></a>
			</td>
		</tr>
		<tr>
			<th><nobr>Автор</nobr></th>
			<td><xsl:value-of select="/*/done/data/author" disable-output-escaping="no"/></td>
		</tr>
		<tr>
			<th><nobr>E-mail</nobr></th>
			<td><xsl:value-of select="/*/done/data/email" disable-output-escaping="no"/></td>
		</tr>
		<tr>
			<th><nobr>Тема</nobr></th>
			<td><xsl:value-of select="/*/done/data/subject" disable-output-escaping="no"/></td>
		</tr>
		<tr>
			<th><nobr>Текст</nobr></th>
			<td><xsl:value-of select="/*/done/data/message" disable-output-escaping="no"/></td>
		</tr>
	</table>

</xsl:template>



</xsl:stylesheet>
