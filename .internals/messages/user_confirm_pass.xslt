<?xml version="1.0" encoding="cp1251" ?>
<!DOCTYPE xsl:stylesheet [
	<!ENTITY % HTMLlat1    PUBLIC "-//W3C//ENTITIES Latin 1 for XHTML//EN" "../dtds/xhtml-lat1.ent"   > %HTMLlat1;
	<!ENTITY % HTMLspecial PUBLIC "-//W3C//ENTITIES Special for XHTML//EN" "../dtds/xhtml-special.ent"> %HTMLspecial;
	<!ENTITY % HTMLsymbol  PUBLIC "-//W3C//ENTITIES Symbols for XHTML//EN" "../dtds/xhtml-symbol.ent" > %HTMLsymbol;
]>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:php="http://php.net/xsl">
<xsl:include href="../xslts/mail.xslt"/>
<!--xsl:include href="../xslts/_common_/quick_mail.xslt"/>
<xsl:include href="../modules.public/registration/form.xslt"/-->



<xsl:template match="/" mode="overrideable_title">
	<xsl:text>Barybina.ru - подтверждение регистрации.</xsl:text>
</xsl:template>



<xsl:template match="/" mode="overrideable_content">

	<h2>Вы зарегистрированы на сайте www.barybina.ru</h2>

	<style>
		span.field { color: #7A96C9; }
	</style>

<p>Ваши регистрационные данные:</p>

	<span class="field">Фамилия: </span> <xsl:value-of select="/*/mail/last_name"/>
	<br/>
	<span class="field">Имя: </span> <xsl:value-of select="/*/mail/first_name"/>
	<br/>
	<span class="field">Отчество: </span> <xsl:value-of select="/*/mail/middle_name"/>
	<br/>
	<span class="field">Номер карты: </span> <xsl:value-of select="/*/mail/card"/>
	<br/>
	<span class="field">Адрес электронной почты: </span> <xsl:value-of select="/*/mail/email"/>
	<br/>
	<span class="field">Пароль: </span> <xsl:value-of select="/*/module/fields/PasswordToEmail/new_pass"/>
	<br/>
	<span class="field">Контактный телефон: </span> <xsl:value-of select="/*/mail/phone"/>
	<br/>
	<span class="field">Дополнительная информация: </span> <xsl:value-of select="/*/mail/comments"/>
	<br/>

<p>Для подтверждения регистрации необходимо перейти по ссылке: <a href="{/*/system/info/pub_site}registration/confirm/{format-number(/*/mail/activator, '0')}"><xsl:value-of select="concat(/*/system/info/pub_site, 'registration/confirm/', format-number(/*/mail/activator, '0'), '/')"/></a></p>

	<xsl:apply-templates select="/*/inlines/inline[label='mailer:sign']"/>

</xsl:template>



</xsl:stylesheet>
