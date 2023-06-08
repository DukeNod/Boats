<?xml version="1.0" encoding="cp1251" ?>
<!DOCTYPE xsl:stylesheet [
	<!ENTITY % HTMLlat1    PUBLIC "-//W3C//ENTITIES Latin 1 for XHTML//EN" "../../dtds/xhtml-lat1.ent"   > %HTMLlat1;
	<!ENTITY % HTMLspecial PUBLIC "-//W3C//ENTITIES Special for XHTML//EN" "../../dtds/xhtml-special.ent"> %HTMLspecial;
	<!ENTITY % HTMLsymbol  PUBLIC "-//W3C//ENTITIES Symbols for XHTML//EN" "../../dtds/xhtml-symbol.ent" > %HTMLsymbol;
]>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:php="http://php.net/xsl">
<xsl:include href="../../xslts/admin.xslt"/>
<xsl:include href="../../xslts/_common_/lists.xslt"/>
<xsl:include href="../../xslts/mailer_files/list.xslt"/>
<xsl:include href="../../xslts/mailer_tasks/errors.xslt"/>
<xsl:include href="../../xslts/mailer_tasks/view.xslt"/>



<xsl:template match="/" mode="overrideable_selector">mailer_tasks</xsl:template>

<xsl:template match="/" mode="overrideable_title">
	<xsl:text>Запуск задания для рассылки</xsl:text>
</xsl:template>

<xsl:template match="/" mode="overrideable_path">
	<xsl:call-template name="path_link"><xsl:with-param name="link" select="concat(/*/system/info/adm_root, 'mailer_tasks')"/><xsl:with-param name="text" select="'Задания рассылки'"/></xsl:call-template>
	<xsl:call-template name="path_separator"/>
	<xsl:call-template name="path_this"><xsl:with-param name="text" select="'Запуск'"/></xsl:call-template>
</xsl:template>



<xsl:template match="/*/form">

	<xsl:call-template name="view_for_mailer_task">
		<xsl:with-param name="form" select="."/>
		<xsl:with-param name="button_alt" select="'Запустить рассылку'"/>
		<xsl:with-param name="button_img" select="'send'"/>
		<xsl:with-param name="button_w"   select="92"/>
		<xsl:with-param name="button_h"   select="19"/>
	</xsl:call-template>

	<h3 class="layoutSubTitle">Файлы</h3>
	<xsl:call-template name="list_of_mailer_files">
		<xsl:with-param name="node" select="info/mailer_files"/>
		<xsl:with-param name="hide_links" select="1"/>
	</xsl:call-template>

</xsl:template>



</xsl:stylesheet>
