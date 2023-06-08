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
<xsl:include href="../../xslts/mailer_files/form.xslt"/>



<xsl:template match="/" mode="overrideable_selector">mailer_tasks</xsl:template>

<xsl:template match="/" mode="overrideable_title">
	<xsl:text>Почтовые файлы</xsl:text>
</xsl:template>

<xsl:template match="/" mode="overrideable_path">
	<xsl:call-template name="path_link"><xsl:with-param name="link" select="concat(/*/system/info/adm_root,'mailer_tasks')"/><xsl:with-param name="text" select="'Задания рассылок'"/></xsl:call-template>
	<xsl:call-template name="path_separator"/>
	<xsl:call-template name="path_link"><xsl:with-param name="link" select="concat(/*/system/info/adm_root,'mailer_tasks/view/', /*/uplink/@id)"/><xsl:with-param name="text"><xsl:choose><xsl:when test="/*/uplink/*"><xsl:value-of select="/*/uplink/*/subject"/></xsl:when><xsl:otherwise>#<xsl:value-of select="/*/uplink/@id"/></xsl:otherwise></xsl:choose></xsl:with-param></xsl:call-template>
	<xsl:call-template name="path_separator"/>
	<xsl:call-template name="path_this"><xsl:with-param name="text" select="'Почтовые файлы'"/></xsl:call-template>
</xsl:template>



<xsl:template match="/*/list">
	<xsl:call-template name="list_of_mailer_files">
		<xsl:with-param name="node"    select="."/>
		<xsl:with-param name="filters" select="/*/filters"/>
		<xsl:with-param name="sorters" select="/*/sorters"/>
		<xsl:with-param name="pager"   select="/*/pager"  />
		<xsl:with-param name="mailer_task" select="/*/uplink/@id"/>
	</xsl:call-template>
</xsl:template>



</xsl:stylesheet>
