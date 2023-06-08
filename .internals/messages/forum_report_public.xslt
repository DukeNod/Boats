<?xml version="1.0" encoding="cp1251" ?>
<!DOCTYPE xsl:stylesheet [
	<!ENTITY % HTMLlat1    PUBLIC "-//W3C//ENTITIES Latin 1 for XHTML//EN" "../dtds/xhtml-lat1.ent"   > %HTMLlat1;
	<!ENTITY % HTMLspecial PUBLIC "-//W3C//ENTITIES Special for XHTML//EN" "../dtds/xhtml-special.ent"> %HTMLspecial;
	<!ENTITY % HTMLsymbol  PUBLIC "-//W3C//ENTITIES Symbols for XHTML//EN" "../dtds/xhtml-symbol.ent" > %HTMLsymbol;
]>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:php="http://php.net/xsl">
<xsl:include href="../xslts/mail.xslt"/>



<xsl:template match="/" mode="overrideable_title">
	<xsl:text>EuroSharm.ru  &mdash; ответ на форуме</xsl:text>
</xsl:template>



<xsl:template match="/" mode="overrideable_content">

	<h2>EuroSharm.ru &mdash; ответ на форуме</h2>

	<p>
		Здравствуйте! 
	</p>

	<p>
		На Ваше сообщение на форуме был написан ответ.
		<br/>
		Мы можете прочитать его и написать ответ по ссылке:
		<br/>

		<a href="{/*/system/info/pub_site}forum/read/{/*/done/topic_id}/{/*/done/id}">
		<xsl:value-of select="/*/system/info/pub_site"/>forum/read/<xsl:value-of select="/*/done/topic_id"/>/<xsl:value-of select="/*/done/id"/>#<xsl:value-of select="/*/done/id"/></a>
	</p>

	<p>
		С уважением!
	</p>

</xsl:template>



</xsl:stylesheet>
