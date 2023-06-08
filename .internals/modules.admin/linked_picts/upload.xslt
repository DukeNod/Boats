<?xml version="1.0" encoding="cp1251" ?>
<!DOCTYPE xsl:stylesheet [
	<!ENTITY % HTMLlat1    PUBLIC "-//W3C//ENTITIES Latin 1 for XHTML//EN" "../../dtds/xhtml-lat1.ent"   > %HTMLlat1;
	<!ENTITY % HTMLspecial PUBLIC "-//W3C//ENTITIES Special for XHTML//EN" "../../dtds/xhtml-special.ent"> %HTMLspecial;
	<!ENTITY % HTMLsymbol  PUBLIC "-//W3C//ENTITIES Symbols for XHTML//EN" "../../dtds/xhtml-symbol.ent" > %HTMLsymbol;
]>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:php="http://php.net/xsl">
<xsl:include href="../../xslts/admin.xslt"/>
<xsl:include href="../../xslts/linked/uplink.xslt"/>
<xsl:include href="../../xslts/linked_picts/errors.xslt"/>
<xsl:include href="../../xslts/linked_picts/form.xslt"/>



<xsl:template match="/" mode="overrideable_selector"><xsl:call-template name="smart_selector_of_uplink_type"/></xsl:template>

<xsl:template match="/" mode="overrideable_title">
	<xsl:text>Добавление изображения</xsl:text>
</xsl:template>

<xsl:template match="/" mode="overrideable_path">
	<xsl:call-template name="path_link"><xsl:with-param name="text"><xsl:call-template name="smart_name_of_uplink_type"/></xsl:with-param><xsl:with-param name="link"><xsl:call-template name="smart_link_to_uplink_type"/></xsl:with-param></xsl:call-template>
	<xsl:call-template name="path_separator"/>
	<xsl:call-template name="path_link"><xsl:with-param name="text"><xsl:call-template name="smart_name_of_uplink_node"/></xsl:with-param><xsl:with-param name="link"><xsl:call-template name="smart_link_to_uplink_node"/></xsl:with-param></xsl:call-template>
	<xsl:call-template name="path_separator"/>
	<xsl:call-template name="path_link"><xsl:with-param name="text" select="'Изображения'"/><xsl:with-param name="link"><xsl:call-template name="smart_link_to_linked_entity"><xsl:with-param name="entity" select="'linked_picts'"/></xsl:call-template></xsl:with-param></xsl:call-template>
	<xsl:call-template name="path_separator"/>
	<xsl:call-template name="path_this"><xsl:with-param name="text" select="'Добавление'"/></xsl:call-template>
</xsl:template>

<xsl:template match="/" mode="overrideable_redirect">
	<xsl:if test="/*/done">
		<xsl:value-of select="concat(/*/system/info/adm_root, /*/done/data/uplink_type, '/update/', /*/done/data/uplink_id)"/>
	</xsl:if>
</xsl:template>

<xsl:template match="/*/form">
	<xsl:call-template name="form_for_linked_pict_import">
		<xsl:with-param name="form" select="."/>
		<xsl:with-param name="button_alt" select="'Добавить'"/>
		<xsl:with-param name="button_img" select="'insert'"/>
		<xsl:with-param name="button_w"   select="93"/>
		<xsl:with-param name="button_h"   select="19"/>
	</xsl:call-template>
</xsl:template>

<xsl:template match="/*/list">
	<xsl:call-template name="list_for_linked_pict_import">
		<xsl:with-param name="form" select="."/>
		<xsl:with-param name="button_alt" select="'Добавить'"/>
		<xsl:with-param name="button_img" select="'insert'"/>
		<xsl:with-param name="button_w"   select="93"/>
		<xsl:with-param name="button_h"   select="19"/>
	</xsl:call-template>
</xsl:template>


</xsl:stylesheet>
