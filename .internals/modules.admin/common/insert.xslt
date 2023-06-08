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
<xsl:include href="../../xslts/common/errors.xslt"/>
<xsl:include href="../../xslts/common/form.xslt"/>
<xsl:include href="./conf.xslt"/>


<xsl:template match="/" mode="overrideable_selector">
	<xsl:value-of select="$essence"/>
</xsl:template>

<xsl:template match="/" mode="overrideable_title">
	<xsl:value-of select="$essence_title"/>
</xsl:template>

<xsl:template match="/" mode="overrideable_path">
	<xsl:call-template name="path_link"><xsl:with-param name="link" select="concat(/*/system/info/adm_root, $adm_sub_root, $essence)"/><xsl:with-param name="text" select="$essence_title"/></xsl:call-template>
	<xsl:call-template name="path_separator"/>
	<xsl:call-template name="path_this"><xsl:with-param name="text" select="'Добавление записи'"/></xsl:call-template>
</xsl:template>

<xsl:template match="/" mode="overrideable_redirect">
	<xsl:if test="/*/done">
	        <xsl:choose>
        	<xsl:when test="/*/module/return_to_list = 1">
			<xsl:call-template name="_done_"/>
		</xsl:when>
		<xsl:otherwise>
			<xsl:value-of select="concat(/*/system/info/adm_root, $adm_sub_root, $essence, '/update/', /*/done/id)"/>
		</xsl:otherwise>
		</xsl:choose>
	</xsl:if>
</xsl:template>

<xsl:template match="/*/form">
	<xsl:call-template name="form_for_common_element">
		<xsl:with-param name="form" select="."/>
		<xsl:with-param name="button_alt" select="'Добавить'"/>
		<xsl:with-param name="button_img" select="'insert'"/>
		<xsl:with-param name="button_w"   select="93"/>
		<xsl:with-param name="button_h"   select="19"/>
	</xsl:call-template>
</xsl:template>



</xsl:stylesheet>
