<?xml version="1.0" encoding="cp1251" ?>
<!DOCTYPE xsl:stylesheet [
	<!ENTITY % HTMLlat1    PUBLIC "-//W3C//ENTITIES Latin 1 for XHTML//EN" "../dtds/xhtml-lat1.ent"   > %HTMLlat1;
	<!ENTITY % HTMLspecial PUBLIC "-//W3C//ENTITIES Special for XHTML//EN" "../dtds/xhtml-special.ent"> %HTMLspecial;
	<!ENTITY % HTMLsymbol  PUBLIC "-//W3C//ENTITIES Symbols for XHTML//EN" "../dtds/xhtml-symbol.ent" > %HTMLsymbol;
]>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:php="http://php.net/xsl">

<xsl:variable name="select_block"><xsl:apply-templates select="/" mode="global_top_menu"/></xsl:variable>
<xsl:variable name="select_item"><xsl:apply-templates select="/" mode="select_item"/></xsl:variable>

<xsl:template priority="-1" match="/" mode="overrideable_left_menu">

	<xsl:call-template name="left_menu_block">
		<xsl:with-param name="name" select="'Клиенты и оплата'"/>
		<xsl:with-param name="url" select="/*/system/info/pub_root"/>
		<xsl:with-param name="section" select="'payment'"/>
	</xsl:call-template>

	<xsl:if test="/*/identity /consumer/roles/role = 'admin'">
	<xsl:call-template name="left_menu_block">
		<xsl:with-param name="name" select="'Отчёт'"/>
		<xsl:with-param name="url" select="concat(/*/system/info/pub_root, 'report/')"/>
		<xsl:with-param name="section" select="'report'"/>
	</xsl:call-template>
	</xsl:if>
	
	<xsl:if test="/*/identity /consumer/roles/role = 'rop'">
	<xsl:call-template name="left_menu_block">
		<xsl:with-param name="name" select="'Отчёт о продажах'"/>
		<xsl:with-param name="url" select="concat(/*/system/info/pub_root, 'report/sales/')"/>
		<xsl:with-param name="section" select="'report'"/>
	</xsl:call-template>
	</xsl:if>
	
	<xsl:if test="/*/identity /consumer/roles/role = 'admin' or /*/identity /consumer/roles/role = 'rop'">
	<xsl:call-template name="left_menu_block">
		<xsl:with-param name="name" select="'Ежедневный отчёт'"/>
		<xsl:with-param name="url" select="concat(/*/system/info/pub_root, 'daily/')"/>
		<xsl:with-param name="section" select="'daily'"/>
	</xsl:call-template>
	</xsl:if>

	<xsl:if test="/*/identity /consumer/roles/role = 'admin'">
	<xsl:call-template name="left_menu_block">
		<xsl:with-param name="name" select="'Подтверждение платежей'"/>
		<xsl:with-param name="url" select="concat(/*/system/info/pub_root, 'pays/')"/>
		<xsl:with-param name="section" select="'pays'"/>
	</xsl:call-template>
	</xsl:if>
	
</xsl:template>

<xsl:template name="left_menu_block">
	<xsl:param name="name"/>
	<xsl:param name="url"/>
	<xsl:param name="section"/>

	<li><a href="{$url}">
		<xsl:if test="$global_left_menu = $section"><xsl:attribute name="class">act</xsl:attribute></xsl:if>
   		<xsl:value-of select="$name" disable-output-escaping="yes"/>
	</a></li>
</xsl:template>

</xsl:stylesheet>