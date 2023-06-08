<?xml version="1.0" encoding="cp1251" ?>
<!DOCTYPE xsl:stylesheet [
	<!ENTITY % HTMLlat1    PUBLIC "-//W3C//ENTITIES Latin 1 for XHTML//EN" "../../../dtds/xhtml-lat1.ent"   > %HTMLlat1;
	<!ENTITY % HTMLspecial PUBLIC "-//W3C//ENTITIES Special for XHTML//EN" "../../../dtds/xhtml-special.ent"> %HTMLspecial;
	<!ENTITY % HTMLsymbol  PUBLIC "-//W3C//ENTITIES Symbols for XHTML//EN" "../../../dtds/xhtml-symbol.ent" > %HTMLsymbol;
]>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:php="http://php.net/xsl">
<xsl:include href="../../../../xslts/ajax2.xslt"/>
<xsl:include href="../../../../xslts/_common_/lists.xslt"/>
<xsl:include href="../../../../xslts/_common_/files.xslt"/>
<xsl:include href="../../../../xslts/_common_/admin_quick_view.xslt" />
<xsl:include href="../../../../xslts/common/errors.xslt"/>
<xsl:include href="../../../../xslts/common/view.xslt"/>
<xsl:include href="../../../../xslts/linked_paras/list.xslt"/>
<xsl:include href="../../../../xslts/linked_picts/list.xslt"/>
<xsl:include href="../../../../xslts/linked_files/list.xslt" />
<xsl:include href="../../../../xslts/linked_paras/form.xslt"/>
<xsl:include href="../../../../xslts/linked_picts/form.xslt"/>
<xsl:include href="../../../../xslts/linked_files/form.xslt" />
<xsl:include href="../../fish_menu.xslt" />
<xsl:include href="../conf.xslt"/>


<xsl:template match="/" mode="overrideable_selector">
	<xsl:value-of select="$essence"/>
</xsl:template>

<xsl:template match="/" mode="overrideable_title">
	<xsl:value-of select="$essence_title"/>
</xsl:template>

<xsl:template match="/" mode="overrideable_path">
	<xsl:call-template name="path_link"><xsl:with-param name="link" select="concat(/*/system/info/adm_root, $adm_sub_root, $essence)"/><xsl:with-param name="text" select="$essence_title"/></xsl:call-template>
	<xsl:call-template name="path_separator"/>
	<xsl:call-template name="path_this">
		<xsl:with-param name="text">
			<xsl:for-each select="/*/form[1]/data">
				<xsl:value-of select="name"/>
			</xsl:for-each>	
		</xsl:with-param>
	</xsl:call-template>
</xsl:template>

<xsl:template match="/*/form">
	<xsl:call-template name="view_for_common_element">
		<xsl:with-param name="form" select="."/>
	</xsl:call-template>
<!--
	<h3 class="layoutSubTitle">Файлы</h3>
	<xsl:call-template name="list_of_linked_files">
		<xsl:with-param name="node" select="info/linked_files"/>
		<xsl:with-param name="hide_links"  select="1"/>
	</xsl:call-template>

	<h3 class="layoutSubTitle">Изображения</h3>
	<xsl:call-template name="list_of_linked_picts">
		<xsl:with-param name="node" select="info/linked_picts"/>
		<xsl:with-param name="hide_links"  select="1"/>
	</xsl:call-template>

	<h3 class="layoutSubTitle">Параграфы</h3>
	<xsl:call-template name="list_of_linked_paras">
		<xsl:with-param name="node" select="info/linked_paras"/>
		<xsl:with-param name="hide_links"  select="1"/>
	</xsl:call-template>
-->
</xsl:template>



</xsl:stylesheet>
