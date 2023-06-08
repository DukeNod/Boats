<?xml version="1.0" encoding="cp1251" ?>
<!DOCTYPE xsl:stylesheet [
	<!ENTITY % HTMLlat1    PUBLIC "-//W3C//ENTITIES Latin 1 for XHTML//EN" "../../dtds/xhtml-lat1.ent"   > %HTMLlat1;
	<!ENTITY % HTMLspecial PUBLIC "-//W3C//ENTITIES Special for XHTML//EN" "../../dtds/xhtml-special.ent"> %HTMLspecial;
	<!ENTITY % HTMLsymbol  PUBLIC "-//W3C//ENTITIES Symbols for XHTML//EN" "../../dtds/xhtml-symbol.ent" > %HTMLsymbol;
]>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:php="http://php.net/xsl">
<xsl:include href="../../xslts/admin.xslt"/>
<xsl:include href="../../xslts/_common_/lists.xslt"/>
<xsl:include href="../../xslts/subscribers/errors.xslt"/>
<xsl:include href="../../xslts/subscribers/form.xslt"/>



<xsl:template match="/" mode="overrideable_title">
	<xsl:text>Импорт подписчиков</xsl:text>
</xsl:template>

<xsl:template match="/" mode="overrideable_path">
	<xsl:call-template name="path_link"><xsl:with-param name="link" select="concat(/*/system/info/adm_root, 'subscribers')"/><xsl:with-param name="text" select="'Подписчики'"/></xsl:call-template>
	<xsl:call-template name="path_separator"/>
	<xsl:call-template name="path_this"><xsl:with-param name="text" select="'Изменение'"/></xsl:call-template>
</xsl:template>


<xsl:template match="/*/done">

        <p>Импорт завершен.</p>
        <p>Добавлено <xsl:value-of select="/*/done/result"/> подписчиков.</p>
        <p><a href="{/*/system/back_raw}">Продолжить</a></p>

</xsl:template>

<xsl:template match="/*/form">

	<xsl:call-template name="form_for_import_subscribers">
		<xsl:with-param name="form" select="."/>
		<xsl:with-param name="button" select="'Импорт'"/>
	</xsl:call-template>

</xsl:template>



</xsl:stylesheet>
