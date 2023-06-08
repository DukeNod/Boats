<?xml version='1.0' encoding='cp1251' ?>
<!DOCTYPE xsl:stylesheet [
	<!ENTITY % HTMLlat1    PUBLIC "-//W3C//ENTITIES Latin 1 for XHTML//EN" "../../dtds/xhtml-lat1.ent"   > %HTMLlat1;
	<!ENTITY % HTMLspecial PUBLIC "-//W3C//ENTITIES Special for XHTML//EN" "../../dtds/xhtml-special.ent"> %HTMLspecial;
	<!ENTITY % HTMLsymbol  PUBLIC "-//W3C//ENTITIES Symbols for XHTML//EN" "../../dtds/xhtml-symbol.ent" > %HTMLsymbol;
]>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:php="http://php.net/xsl">



<xsl:template match="disk" mode="sizes">
	<xsl:if test="size_w!='' or size_r!=''">
		<xsl:if test="size_w!=''"><xsl:value-of select="format-number(size_w, '0.#')"/></xsl:if>
		<xsl:text>x</xsl:text>
		<xsl:if test="size_r!=''"><xsl:value-of select="format-number(size_r, '0')"/></xsl:if>
		<xsl:text> </xsl:text>
	</xsl:if>

	<xsl:if test="size_v!=''">
		<xsl:text>ET</xsl:text>
		<xsl:value-of select="format-number(size_v, '0.#')"/>
		<xsl:text> </xsl:text>
	</xsl:if>

	<xsl:if test="size_n!='' or size_d!=''">
		<xsl:if test="size_n!=''">
			<xsl:value-of select="size_n" />
		</xsl:if>
		<xsl:text>*</xsl:text>
		<xsl:if test="size_d!=''">
			<xsl:value-of select="size_d"/>
			<xsl:if test="size_dd!=''">
				<xsl:text>/</xsl:text>
				<xsl:value-of select="size_dd"/>
			</xsl:if>
		</xsl:if>
		<xsl:text> </xsl:text>
	</xsl:if>

	<xsl:if test="size_c!=''">
		<xsl:text>D</xsl:text>
		<xsl:value-of select="format-number(size_c, '0.0')"/>
		<xsl:text> </xsl:text>
	</xsl:if>
</xsl:template>



<xsl:template match="tyre" mode="sizes">
	<xsl:if test="size_w!='' or size_h!=''">
		<xsl:value-of select="size_w"/>
		<xsl:text>/</xsl:text>
		<xsl:value-of select="size_h"/>
		<xsl:text> </xsl:text>
	</xsl:if>

	<xsl:if test="size_r!=''">
		<xsl:text>R</xsl:text>
		<xsl:value-of select="size_r"/>
		<xsl:text> </xsl:text>
	</xsl:if>

	<xsl:if test="index_load!='' or index_speed!=''">
		<xsl:value-of select="index_load"/>
		<xsl:value-of select="index_speed"/>
		<xsl:text> </xsl:text>
	</xsl:if>
</xsl:template>



</xsl:stylesheet>
