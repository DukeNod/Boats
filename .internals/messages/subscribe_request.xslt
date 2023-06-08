<?xml version="1.0" encoding="cp1251" ?>
<!DOCTYPE xsl:stylesheet [
	<!ENTITY % HTMLlat1    PUBLIC "-//W3C//ENTITIES Latin 1 for XHTML//EN" "../dtds/xhtml-lat1.ent"   > %HTMLlat1;
	<!ENTITY % HTMLspecial PUBLIC "-//W3C//ENTITIES Special for XHTML//EN" "../dtds/xhtml-special.ent"> %HTMLspecial;
	<!ENTITY % HTMLsymbol  PUBLIC "-//W3C//ENTITIES Symbols for XHTML//EN" "../dtds/xhtml-symbol.ent" > %HTMLsymbol;
]>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:php="http://php.net/xsl">
<xsl:include href="../xslts/mail.xslt"/>


<xsl:template match="/" mode="overrideable_title">
	<xsl:text>Barybina.ru - подтверждение подписки на новости</xsl:text>
</xsl:template>



<xsl:template match="/" mode="overrideable_content">

	<h2>Barybina.ru - подтверждение подписки на новости</h2>
	
	<p>
		Здравствуйте!
	</p>
	<p>
		Вы получили это сообщение, так как ваш адрес <i>(<xsl:value-of select="/*/mail/email"/>)</i> был подписан на рассылку сайта <xsl:value-of select="/*/system/info/sitename"/>.
	</p>
	<p>
		Для подтверждения подписки перейдите по следующей ссылке:
		<br/>
		<a href="{/*/system/info/pub_site}subscribe?email={/*/mail/email}&amp;code={/*/mail/code}">
			<xsl:value-of select="/*/system/info/pub_site"/>subscribe?email=<xsl:value-of select="/*/mail/email"/>&amp;code=<xsl:value-of select="/*/mail/code"/>
		</a>
	</p>
	<p>
		Если Вы не подписывались на нашу рассылку новостей, не предпринимайте никаких действий.
	</p>

	<xsl:apply-templates select="/*/inlines/inline[label='mailer:sign']"/>

</xsl:template>



</xsl:stylesheet>
