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
	<xsl:text>Barybina.ru - клубная карта.</xsl:text>
</xsl:template>



<xsl:template match="/" mode="overrideable_content">

	<h2>Спасибо за регистрацию на сайте www.barybina.ru</h2>

<p>
Вы успешно зарегистрированы на сайте Рыболовного Клуба "Ба!Рыбина!".<br/>
Вы можете отправить заявку на получения клубной карты на странице <br/>
Вашего <a href="{/*/system/info/pub_site}registration/">"Личного кабинета"</a>, заполнив все необходимые поля в анкете.
</p>
<p>Ждём Вас в нашем клубе!</p>

<xsl:apply-templates select="/*/inlines/inline[label='mailer:sign']"/>

</xsl:template>



</xsl:stylesheet>
