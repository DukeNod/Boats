<?xml version="1.0" encoding="cp1251" ?>
<!DOCTYPE xsl:stylesheet [
	<!ENTITY % HTMLlat1    PUBLIC "-//W3C//ENTITIES Latin 1 for XHTML//EN" "../../../dtds/xhtml-lat1.ent"   > %HTMLlat1;
	<!ENTITY % HTMLspecial PUBLIC "-//W3C//ENTITIES Special for XHTML//EN" "../../../dtds/xhtml-special.ent"> %HTMLspecial;
	<!ENTITY % HTMLsymbol  PUBLIC "-//W3C//ENTITIES Symbols for XHTML//EN" "../../../dtds/xhtml-symbol.ent" > %HTMLsymbol;
]>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:php="http://php.net/xsl">
<xsl:include href="../../../xslts/admin.xslt"/>
<xsl:include href="../../../xslts/_common_/lists.xslt"/>
<xsl:include href="../../../xslts/_common_/files.xslt"/>
<xsl:include href="../../../xslts/linked_paras/list.xslt"/>
<xsl:include href="../../../xslts/linked_picts/list.xslt"/>
<xsl:include href="../../../xslts/linked_files/list.xslt" />
<xsl:include href="../../../xslts/linked_paras/form.xslt"/>
<xsl:include href="../../../xslts/linked_picts/form.xslt"/>
<xsl:include href="../../../xslts/linked_files/form.xslt" />
<xsl:include href="../../../xslts/inlines/errors.xslt"/>
<xsl:include href="../../../xslts/inlines/view.xslt"/>



<xsl:template match="/" mode="overrideable_selector">inlines</xsl:template>

<xsl:template match="/" mode="overrideable_title">
	<xsl:text>Просмотр текстовой вставки</xsl:text>
</xsl:template>

<xsl:template match="/" mode="overrideable_path">
	<xsl:call-template name="path_link"><xsl:with-param name="link" select="concat(/*/system/info/adm_root, 'inlines')"/><xsl:with-param name="text" select="'Текстовая вставки'"/></xsl:call-template>
	<xsl:call-template name="path_separator"/>
	<xsl:call-template name="path_this"><xsl:with-param name="text" select="/*/form/data/post"/></xsl:call-template>
</xsl:template>



<xsl:template match="/*/form">

	<xsl:call-template name="view_for_inline">
		<xsl:with-param name="form" select="."/>
	</xsl:call-template>

</xsl:template>



</xsl:stylesheet>
