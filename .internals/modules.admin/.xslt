<?xml version="1.0" encoding="cp1251" ?>
<!DOCTYPE xsl:stylesheet [
	<!ENTITY % HTMLlat1    PUBLIC "-//W3C//ENTITIES Latin 1 for XHTML//EN" "../dtds/xhtml-lat1.ent"   > %HTMLlat1;
	<!ENTITY % HTMLspecial PUBLIC "-//W3C//ENTITIES Special for XHTML//EN" "../dtds/xhtml-special.ent"> %HTMLspecial;
	<!ENTITY % HTMLsymbol  PUBLIC "-//W3C//ENTITIES Symbols for XHTML//EN" "../dtds/xhtml-symbol.ent" > %HTMLsymbol;
]>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:php="http://php.net/xsl">
<xsl:include href="../xslts/admin.xslt"/>



<xsl:template match="/" mode="overrideable_selector"></xsl:template>

<xsl:template match="/" mode="overrideable_title">
	<xsl:choose>
	<xsl:when test="/*/unknown">Страница не найдена</xsl:when>
	<xsl:when test="/*/main   ">Основное меню</xsl:when>
	</xsl:choose>
</xsl:template>



<xsl:template match="/" mode="overrideable_context">
</xsl:template>



<xsl:template match="/" mode="overrideable_content">
	<xsl:choose>
	<xsl:when test="/*/unknown">
		<div class="http404">
			<p>
				Запрошенной страницы не существует.
			</p>
			<p>
				Вероятно, это ошибка в административной части, приведшая к неправильно сформированной ссылке.
			</p>
			<p>
				Пожалуйста, сообщите разработчикам сайта адрес страницы (смотрите в адресной строке браузера),
				с примечанием о том, какие действия выполнялись перед тем, как появилась эта страница.
			</p>
			<p>
				Вы можете вернуться на <a href="{/*/system/info/adm_root}">главную страницу</a> и продолжить работу.
			</p>
		</div>
	</xsl:when>
	<xsl:when test="/*/main">
		<xsl:apply-templates select="/" mode="overrideable_menu"/>
	</xsl:when>
	</xsl:choose>
</xsl:template>



</xsl:stylesheet>
