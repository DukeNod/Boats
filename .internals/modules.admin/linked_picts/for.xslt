<?xml version="1.0" encoding="cp1251" ?>
<!DOCTYPE xsl:stylesheet [
	<!ENTITY % HTMLlat1    PUBLIC "-//W3C//ENTITIES Latin 1 for XHTML//EN" "../../dtds/xhtml-lat1.ent"   > %HTMLlat1;
	<!ENTITY % HTMLspecial PUBLIC "-//W3C//ENTITIES Special for XHTML//EN" "../../dtds/xhtml-special.ent"> %HTMLspecial;
	<!ENTITY % HTMLsymbol  PUBLIC "-//W3C//ENTITIES Symbols for XHTML//EN" "../../dtds/xhtml-symbol.ent" > %HTMLsymbol;
]>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:php="http://php.net/xsl">
<xsl:include href="../../xslts/admin.xslt"/>
<xsl:include href="../../xslts/_common_/lists.xslt"/>
<xsl:include href="../../xslts/linked/uplink.xslt"/>
<xsl:include href="../../xslts/linked_picts/list.xslt"/>
<xsl:include href="../../xslts/linked_picts/form.xslt"/>



<xsl:template match="/" mode="overrideable_selector"><xsl:call-template name="smart_selector_of_uplink_type"/></xsl:template>

<xsl:template match="/" mode="overrideable_title">
	<xsl:text>Изображения</xsl:text>
<!--!!!этот choose надо вынести в какой-нибудь общий шаблон, чтоли:
	<xsl:choose>
	<xsl:when test="/*/list and /*/uplink/project">Изображения для проекта            #<xsl:value-of select="/*/uplink/*/id"/> (<xsl:value-of select="/*/uplink/*/name" disable-output-escaping="yes"/>)</xsl:when>
	<xsl:when test="/*/list and /*/uplink/client ">Изображения для клиента            #<xsl:value-of select="/*/uplink/*/id"/> (<xsl:value-of select="/*/uplink/*/name" disable-output-escaping="yes"/>)</xsl:when>
	<xsl:when test="/*/list and /*/uplink/field  ">Изображения для сферы деятельности #<xsl:value-of select="/*/uplink/*/id"/> (<xsl:value-of select="/*/uplink/*/name" disable-output-escaping="yes"/>)</xsl:when>
	<xsl:when test="/*/list and /*/uplink/work   ">Изображения для вида работ         #<xsl:value-of select="/*/uplink/*/id"/> (<xsl:value-of select="/*/uplink/*/name" disable-output-escaping="yes"/>)</xsl:when>
	<xsl:when test="/*/list and /*/uplink/service">Изображения для услуги             #<xsl:value-of select="/*/uplink/*/id"/> (<xsl:value-of select="/*/uplink/*/name" disable-output-escaping="yes"/>)</xsl:when>
	<xsl:when test="/*/list and /*/uplink/cover  ">Изображения для обложки            #<xsl:value-of select="/*/uplink/*/id"/></xsl:when>
	<xsl:when test="/*/list                      ">Изображения</xsl:when>
	<xsl:when test="/*/item"></xsl:when>
	</xsl:choose>
-->
</xsl:template>

<xsl:template match="/" mode="overrideable_path">
	<xsl:call-template name="path_link"><xsl:with-param name="text"><xsl:call-template name="smart_name_of_uplink_type"/></xsl:with-param><xsl:with-param name="link"><xsl:call-template name="smart_link_to_uplink_type"/></xsl:with-param></xsl:call-template>
	<xsl:call-template name="path_separator"/>
	<xsl:call-template name="path_link"><xsl:with-param name="text"><xsl:call-template name="smart_name_of_uplink_node"/></xsl:with-param><xsl:with-param name="link"><xsl:call-template name="smart_link_to_uplink_node"/></xsl:with-param></xsl:call-template>
	<xsl:call-template name="path_separator"/>
	<xsl:call-template name="path_this"><xsl:with-param name="text" select="'Изображения'"/></xsl:call-template>
</xsl:template>



<xsl:template match="/*/list">
	<xsl:call-template name="list_of_linked_picts">
		<xsl:with-param name="node"    select="."/>
		<xsl:with-param name="filters" select="/*/filters"/>
		<xsl:with-param name="sorters" select="/*/sorters"/>
		<xsl:with-param name="pager"   select="/*/pager"  />
		<xsl:with-param name="uplink_type" select="/*/uplink/@type"/>
		<xsl:with-param name="uplink_id"   select="/*/uplink/@id"  />
	</xsl:call-template>
</xsl:template>



</xsl:stylesheet>
