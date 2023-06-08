<?xml version="1.0" encoding="cp1251" ?>
<!DOCTYPE xsl:stylesheet [
	<!ENTITY % HTMLlat1    PUBLIC "-//W3C//ENTITIES Latin 1 for XHTML//EN" "../../dtds/xhtml-lat1.ent"   > %HTMLlat1;
	<!ENTITY % HTMLspecial PUBLIC "-//W3C//ENTITIES Special for XHTML//EN" "../../dtds/xhtml-special.ent"> %HTMLspecial;
	<!ENTITY % HTMLsymbol  PUBLIC "-//W3C//ENTITIES Symbols for XHTML//EN" "../../dtds/xhtml-symbol.ent" > %HTMLsymbol;
]>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:php="http://php.net/xsl">

<xsl:param name="essence_title" select="/*/module/essence_title"/>
<xsl:param name="essence" select="/*/module/essence"/>
<xsl:param name="outfield" select="/*/module/outfield"/>
<xsl:param name="prefix" select="'_'"/>

<xsl:template match="/" mode="overrideable_adm_sub_root"></xsl:template>
<xsl:param name="adm_sub_root"><xsl:apply-templates select="/" mode="overrideable_adm_sub_root"/></xsl:param>

</xsl:stylesheet>
