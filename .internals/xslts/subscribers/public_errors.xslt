<?xml version='1.0' encoding='cp1251' ?>
<!DOCTYPE xsl:stylesheet [
	<!ENTITY % HTMLlat1    PUBLIC "-//W3C//ENTITIES Latin 1 for XHTML//EN" "../../dtds/xhtml-lat1.ent"   > %HTMLlat1;
	<!ENTITY % HTMLspecial PUBLIC "-//W3C//ENTITIES Special for XHTML//EN" "../../dtds/xhtml-special.ent"> %HTMLspecial;
	<!ENTITY % HTMLsymbol  PUBLIC "-//W3C//ENTITIES Symbols for XHTML//EN" "../../dtds/xhtml-symbol.ent" > %HTMLsymbol;
]>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:php="http://php.net/xsl">


<xsl:template match="form[@for=  'subscribe-request']/errors/email_required    ">Необходимо указать e-mail.</xsl:template>
<xsl:template match="form[@for=  'subscribe-request']/errors/email_bad         ">Неверный формат e-mail.</xsl:template>
<xsl:template match="form[@for=  'subscribe-request']/errors/is_active_already ">Этот e-mail уже подписан и активирован.</xsl:template>

<xsl:template match="form[@for=  'subscribe-confirm']/errors/email_required    ">Необходимо указать e-mail.</xsl:template>
<xsl:template match="form[@for=  'subscribe-confirm']/errors/email_bad         ">Неверный формат e-mail.</xsl:template>
<xsl:template match="form[@for=  'subscribe-confirm']/errors/email_wrong       ">Такого e-mail не обнаружено.</xsl:template>
<xsl:template match="form[@for=  'subscribe-confirm']/errors/code_wrong        ">Код активации не подходит к этому e-mail.</xsl:template>


<xsl:template match="form[@for='unsubscribe-request']/errors/email_required    ">Необходимо указать e-mail.</xsl:template>
<xsl:template match="form[@for='unsubscribe-request']/errors/email_bad         ">Неверный формат e-mail.</xsl:template>
<xsl:template match="form[@for='unsubscribe-request']/errors/email_wrong       ">Этот e-mail и так не подписан или отписан.</xsl:template>

<xsl:template match="form[@for='unsubscribe-confirm']/errors/email_required    ">Необходимо указать e-mail.</xsl:template>
<xsl:template match="form[@for='unsubscribe-confirm']/errors/email_bad         ">Неверный формат e-mail.</xsl:template>
<xsl:template match="form[@for='unsubscribe-confirm']/errors/email_wrong       ">Такого e-mail не обнаружено.</xsl:template>
<xsl:template match="form[@for='unsubscribe-confirm']/errors/code_wrong        ">Код активации не подходит к этому e-mail.</xsl:template>


</xsl:stylesheet>
