<?xml version='1.0' encoding='cp1251' ?>
<!DOCTYPE xsl:stylesheet [
	<!ENTITY % HTMLlat1    PUBLIC "-//W3C//ENTITIES Latin 1 for XHTML//EN" "../../dtds/xhtml-lat1.ent"   > %HTMLlat1;
	<!ENTITY % HTMLspecial PUBLIC "-//W3C//ENTITIES Special for XHTML//EN" "../../dtds/xhtml-special.ent"> %HTMLspecial;
	<!ENTITY % HTMLsymbol  PUBLIC "-//W3C//ENTITIES Symbols for XHTML//EN" "../../dtds/xhtml-symbol.ent" > %HTMLsymbol;
]>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:php="http://php.net/xsl">


<xsl:template name="smart_selector_of_uplink_type">
	<xsl:param name="uplink"      select="/*/uplink"/>
	<xsl:param name="uplink_id"   select="$uplink/@id"/>
	<xsl:param name="uplink_type" select="$uplink/@type"/>
	<xsl:param name="uplink_sname" select="$uplink/@sname"/>
	<xsl:param name="uplink_stitle" select="$uplink/@stitle"/>
	<xsl:value-of select="$uplink_sname"/>
</xsl:template>

<xsl:template name="smart_name_of_uplink_type">
	<xsl:param name="uplink"      select="/*/uplink"/>
	<xsl:param name="uplink_id"   select="$uplink/@id"/>
	<xsl:param name="uplink_type" select="$uplink/@type"/>
	<xsl:param name="uplink_sname" select="$uplink/@sname"/>
	<xsl:param name="uplink_stitle" select="$uplink/@stitle"/>
	<xsl:value-of select="$uplink_stitle"/>
</xsl:template>

<xsl:template name="smart_link_to_uplink_type">
	<xsl:param name="uplink"      select="/*/uplink"/>
	<xsl:param name="uplink_id"   select="$uplink/@id"/>
	<xsl:param name="uplink_type" select="$uplink/@type"/>
	<xsl:param name="uplink_sname" select="$uplink/@sname"/>
	<xsl:param name="uplink_stitle" select="$uplink/@stitle"/>
	<xsl:value-of select="/*/system/info/adm_root"/><xsl:value-of select="$uplink_sname"/>
</xsl:template>

<xsl:template name="smart_name_of_uplink_node">
	<xsl:param name="uplink"      select="/*/uplink"/>
	<xsl:param name="uplink_id"   select="$uplink/@id"/>
	<xsl:param name="uplink_type" select="$uplink/@type"/>
	<xsl:param name="uplink_sname" select="$uplink/@sname"/>
	<xsl:param name="uplink_stitle" select="$uplink/@stitle"/>
	<xsl:param name="uplink_fieldname" select="$uplink/@fieldname"/>
	<xsl:value-of select="$uplink/*/*[name()=$uplink_fieldname]"/>
</xsl:template>

<xsl:template name="smart_link_to_uplink_node">
	<xsl:param name="uplink"      select="/*/uplink"/>
	<xsl:param name="uplink_id"   select="$uplink/@id"/>
	<xsl:param name="uplink_type" select="$uplink/@type"/>
	<xsl:param name="uplink_sname" select="$uplink/@sname"/>
	<xsl:param name="uplink_stitle" select="$uplink/@stitle"/>
	<xsl:value-of select="/*/system/info/adm_root"/><xsl:value-of select="$uplink_sname"/>/update/<xsl:value-of select="$uplink_id"/>
</xsl:template>

<xsl:template name="smart_link_to_linked_entity">
	<xsl:param name="uplink_type" select="/*/uplink/@type"/>
	<xsl:param name="uplink_id"   select="/*/uplink/@id"  />
	<xsl:param name="uplink"      select="/*/uplink"/>
	<xsl:param name="entity"      select="/.."/>
	<xsl:choose>
	<xsl:when test="$entity">
		<xsl:value-of select="/*/system/info/adm_root"/>
		<xsl:value-of select="$entity"/>
		<xsl:text>/for/</xsl:text>
		<xsl:value-of select="$uplink_type"/>
		<xsl:text>/</xsl:text>
		<xsl:value-of select="$uplink_id"/>
	</xsl:when>
	</xsl:choose>
</xsl:template>


</xsl:stylesheet>
