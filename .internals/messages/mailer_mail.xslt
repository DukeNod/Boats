<?xml version="1.0" encoding="cp1251" ?>
<!DOCTYPE xsl:stylesheet [
	<!ENTITY % HTMLlat1    PUBLIC "-//W3C//ENTITIES Latin 1 for XHTML//EN" "../dtds/xhtml-lat1.ent"   > %HTMLlat1;
	<!ENTITY % HTMLspecial PUBLIC "-//W3C//ENTITIES Special for XHTML//EN" "../dtds/xhtml-special.ent"> %HTMLspecial;
	<!ENTITY % HTMLsymbol  PUBLIC "-//W3C//ENTITIES Symbols for XHTML//EN" "../dtds/xhtml-symbol.ent" > %HTMLsymbol;
]>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:php="http://php.net/xsl">
<xsl:include href="../xslts/mail.xslt"/>



<xsl:template match="/" mode="overrideable_title">
	<xsl:value-of select="/*/current_mailer[last()]/subject" disable-output-escaping="yes"/>
	<xsl:text> &mdash; рассылка круизного агентства &laquo;Атолл Трэвел&raquo;</xsl:text>
</xsl:template>



<xsl:template match="/" mode="overrideable_content">
	<style>
		a { TEXT-DECORATION: none; color: #7A96C9 }
		a:hover { TEXT-DECORATION: underline; color: #7A96C9 }
	</style>


	<h2>
	<xsl:value-of select="/*/current_mailer[last()]/subject" disable-output-escaping="yes"/>
	</h2>

	<xsl:value-of select="/*/current_mailer[last()]/message" disable-output-escaping="yes"/>


	<xsl:apply-templates select="/*/inlines/inline[label='mailer:sign']"/>

<p><i>
Если Вы не хотите более получать эту рассылку, то вы можете отписаться, нажав на ссылку 
<a href="{/*/system/info/pub_site}unsubscribe?email={/*/current_mailer[last()]/email}&amp;code={/*/current_mailer[last()]/code}">отписаться от рассылки</a>.
</i>
</p>
</xsl:template>



</xsl:stylesheet>
