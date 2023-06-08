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
	<xsl:text>Barybina.ru &mdash; заполнена анкета &mdash; </xsl:text>
	<xsl:value-of select="/*/mail/last_name"/>
</xsl:template>



<xsl:template match="/" mode="overrideable_content">

	<h2>Пользователь отправил запрос на клубную карту с сайта www.barybina.ru.</h2>

	<style>
		span.field { color: #7A96C9; }
		.checkbox_list { float: left; width: 300px; }
	</style>

	<p><a href="{/*/system/info/adm_site}tickets/cards/update/{/*/mail/id}">Управление данными пользователя</a></p>

<p>Анкета:</p>

	<span class="field">Фамилия: </span> <xsl:value-of select="/*/mail/last_name"/>
	<br/>
	<span class="field">Имя: </span> <xsl:value-of select="/*/mail/first_name"/>
	<br/>
	<span class="field">Отчество: </span> <xsl:value-of select="/*/mail/middle_name"/>
	<br/>
	<span class="field">Дата рождения: </span>
	<xsl:call-template name="datetime_numeric_ru">
		<xsl:with-param name="raw"    select="/*/mail/birthday"/>
		<xsl:with-param name="year"   select="/*/mail/birthday_parsed/year"/>
		<xsl:with-param name="month"  select="/*/mail/birthday_parsed/month"/>
		<xsl:with-param name="day"    select="/*/mail/birthday_parsed/day"/>
	</xsl:call-template> г.
	<br/>
	<span class="field">Я живу в: </span> <xsl:value-of select="/*/mail/address"/>
	<br/>
	<span class="field">Адрес электронной почты: </span> <xsl:value-of select="/*/mail/email"/>
	<br/>
	<span class="field">Контактный телефон: </span> <xsl:value-of select="/*/mail/phone"/>
	<br/>
	<table><tr><td valign="top">
          <span class="field">Предпочитаемые виды рыбалки: </span> 
	</td><td>
		  	<xsl:if test="/*/mail/fishing_type/k = 1">карпфишинг<br/></xsl:if>
		  	<xsl:if test="/*/mail/fishing_type/p = 1">поплавочная ловля<br/></xsl:if>
		  	<xsl:if test="/*/mail/fishing_type/d = 1">донные оснастки<br/></xsl:if>
		  	<xsl:if test="/*/mail/fishing_type/s = 1">спиннинг<br/></xsl:if>
		  	<xsl:if test="/*/mail/fishing_type/n = 1">нахлыст<br/></xsl:if>
	</td></tr></table>

	<table><tr><td valign="top">
          <span class="field">Любимый сезон рыбной ловли: </span> 
	</td><td>
		  	<xsl:if test="/*/mail/data/season/v = 1">весна<br/></xsl:if>
		  	<xsl:if test="/*/mail/season/l = 1">лето<br/></xsl:if>
		  	<xsl:if test="/*/mail/season/o = 1">осень<br/></xsl:if>
		  	<xsl:if test="/*/mail/season/z = 1">зима<br/></xsl:if>
	</td></tr></table>

          <span class="field">Я беру с собой семью на рыбалку: </span> 
          	<xsl:choose>
	  	<xsl:when test="/*/mail/family = 1">Да</xsl:when>
	  	<xsl:otherwise>Нет</xsl:otherwise>
          	</xsl:choose>
          <br/>
          <br/>

	<xsl:apply-templates select="/*/inlines/inline[label='mailer:sign']"/>

</xsl:template>



</xsl:stylesheet>
