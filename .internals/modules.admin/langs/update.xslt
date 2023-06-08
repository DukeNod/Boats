<?xml version="1.0" encoding="cp1251" ?>
<!DOCTYPE xsl:stylesheet [
	<!ENTITY % HTMLlat1    PUBLIC "-//W3C//ENTITIES Latin 1 for XHTML//EN" "../../dtds/xhtml-lat1.ent"   > %HTMLlat1;
	<!ENTITY % HTMLspecial PUBLIC "-//W3C//ENTITIES Special for XHTML//EN" "../../dtds/xhtml-special.ent"> %HTMLspecial;
	<!ENTITY % HTMLsymbol  PUBLIC "-//W3C//ENTITIES Symbols for XHTML//EN" "../../dtds/xhtml-symbol.ent" > %HTMLsymbol;
]>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:php="http://php.net/xsl">
<xsl:include href="../../xslts/admin.xslt"/>
<xsl:include href="../../xslts/_common_/lists.xslt"/>
<xsl:include href="../../xslts/_common_/files.xslt"/>
<xsl:include href="../../xslts/langs/list.xslt"/>
<xsl:include href="../../xslts/langs/errors.xslt"/>
<xsl:include href="../../xslts/langs/form.xslt"/>
<xsl:include href="../../xslts/regions/list.xslt"/>
<xsl:include href="./conf.xslt"/>


<xsl:template match="/" mode="overrideable_selector">
	<xsl:value-of select="$essence"/>
</xsl:template>

<xsl:template match="/" mode="overrideable_title">
	<xsl:value-of select="$essence_title"/>
</xsl:template>


<xsl:template match="/" mode="overrideable_redirect">
	<xsl:if test="/*/done">
		<xsl:value-of select="concat(/*/system/info/adm_root, $essence)"/>
	</xsl:if>
</xsl:template>

<xsl:template match="/" mode="overrideable_path">
	<xsl:call-template name="path_link"><xsl:with-param name="link" select="concat(/*/system/info/adm_root, $essence)"/><xsl:with-param name="text" select="$essence_title"/></xsl:call-template>
	<xsl:call-template name="path_separator"/>
	<xsl:call-template name="path_this"><xsl:with-param name="text" select="'Изменение'"/></xsl:call-template>
</xsl:template>

<xsl:template match="/*/form">

	<xsl:call-template name="form_for_lang">
		<xsl:with-param name="form" select="."/>
		<xsl:with-param name="button_alt" select="'Изменить'"/>
		<xsl:with-param name="button_img" select="'update'"/>
		<xsl:with-param name="button_w"   select="92"/>
		<xsl:with-param name="button_h"   select="19"/>
	</xsl:call-template>

	<h3 class="layoutSubTitle">Регионы (округа)</h3>
	<xsl:call-template name="list_of_regions">
		<xsl:with-param name="node"     select="info/regions"/>
		<xsl:with-param name="domain" select="id"/>
		<xsl:with-param name="essence" select="'regions'"/>
	</xsl:call-template>

</xsl:template>



</xsl:stylesheet>
