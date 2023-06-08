<?xml version="1.0" encoding="cp1251" ?>
<!DOCTYPE xsl:stylesheet [
	<!ENTITY % HTMLlat1    PUBLIC "-//W3C//ENTITIES Latin 1 for XHTML//EN" "../../dtds/xhtml-lat1.ent"   > %HTMLlat1;
	<!ENTITY % HTMLspecial PUBLIC "-//W3C//ENTITIES Special for XHTML//EN" "../../dtds/xhtml-special.ent"> %HTMLspecial;
	<!ENTITY % HTMLsymbol  PUBLIC "-//W3C//ENTITIES Symbols for XHTML//EN" "../../dtds/xhtml-symbol.ent" > %HTMLsymbol;
]>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:php="http://php.net/xsl">
<xsl:include href="../../xslts/admin.xslt"/>
<xsl:include href="../../xslts/linked/uplink.xslt"/>
<xsl:include href="../../xslts/linked_files/errors.xslt"/>
<xsl:include href="../../xslts/linked_files/form.xslt"/>



<xsl:template match="/" mode="overrideable_selector"><xsl:call-template name="smart_selector_of_uplink_type"/></xsl:template>

<xsl:template match="/" mode="overrideable_title">
	<xsl:text>Добавление файла</xsl:text>
</xsl:template>

<xsl:template match="/" mode="overrideable_path">
	<xsl:call-template name="path_link"><xsl:with-param name="text"><xsl:call-template name="smart_name_of_uplink_type"/></xsl:with-param><xsl:with-param name="link"><xsl:call-template name="smart_link_to_uplink_type"/></xsl:with-param></xsl:call-template>
	<xsl:call-template name="path_separator"/>
	<xsl:call-template name="path_link"><xsl:with-param name="text"><xsl:call-template name="smart_name_of_uplink_node"/></xsl:with-param><xsl:with-param name="link"><xsl:call-template name="smart_link_to_uplink_node"/></xsl:with-param></xsl:call-template>
	<xsl:call-template name="path_separator"/>
	<xsl:call-template name="path_link"><xsl:with-param name="text" select="'Файлы'"/><xsl:with-param name="link"><xsl:call-template name="smart_link_to_linked_entity"><xsl:with-param name="entity" select="'linked_files'"/></xsl:call-template></xsl:with-param></xsl:call-template>
	<xsl:call-template name="path_separator"/>
	<xsl:call-template name="path_this"><xsl:with-param name="text" select="'Добавление'"/></xsl:call-template>
</xsl:template>



<xsl:template match="/*/form">
	<xsl:call-template name="form_for_linked_file">
		<xsl:with-param name="form" select="."/>
		<xsl:with-param name="button_alt" select="'Добавить'"/>
		<xsl:with-param name="button_img" select="'insert'"/>
		<xsl:with-param name="button_w"   select="93"/>
		<xsl:with-param name="button_h"   select="19"/>
	</xsl:call-template>
</xsl:template>



</xsl:stylesheet>
