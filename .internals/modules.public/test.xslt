<?xml version="1.0" encoding="cp1251" ?>
<!DOCTYPE xsl:stylesheet [
	<!ENTITY % HTMLlat1    PUBLIC "-//W3C//ENTITIES Latin 1 for XHTML//EN" "../dtds/xhtml-lat1.ent"   > %HTMLlat1;
	<!ENTITY % HTMLspecial PUBLIC "-//W3C//ENTITIES Special for XHTML//EN" "../dtds/xhtml-special.ent"> %HTMLspecial;
	<!ENTITY % HTMLsymbol  PUBLIC "-//W3C//ENTITIES Symbols for XHTML//EN" "../dtds/xhtml-symbol.ent" > %HTMLsymbol;
]>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:php="http://php.net/xsl">
<xsl:include href="../xslts/public.xslt"/>


<xsl:template match="/" mode="overrideable_title">
	Валидатор
</xsl:template>

<xsl:template match="/" mode="overrideable_keywords">
</xsl:template>

<xsl:template match="/" mode="overrideable_description">
</xsl:template>

<xsl:template match="/" mode="overrideable_measurer">
</xsl:template>

<xsl:template match="/" mode="overrideable_head">
	Валидатор
</xsl:template>

<xsl:template match="/" mode="overrideable_content">
	<div class="error">
		<xsl:value-of select="/*/errors" disable-output-escaping="yes"/>
	</div>
	<form action="{/*/system/info/pub_root}valid/" method="post">
		<textarea name="xml" placeholder="Put XML" style="width: 1000px; height: 500px;">
			<xsl:value-of select="/*/xml" disable-output-escaping="yes"/>
		</textarea>
		<br/>
		<br/>
		<input type="submit" value="Проверить"/>
	</form>
		<br/>
		<br/>
</xsl:template>

</xsl:stylesheet>
