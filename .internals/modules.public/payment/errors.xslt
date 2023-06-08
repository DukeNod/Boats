<?xml version='1.0' encoding='cp1251' ?>
<!DOCTYPE xsl:stylesheet [
	<!ENTITY % HTMLlat1    PUBLIC "-//W3C//ENTITIES Latin 1 for XHTML//EN" "../../dtds/xhtml-lat1.ent"   > %HTMLlat1;
	<!ENTITY % HTMLspecial PUBLIC "-//W3C//ENTITIES Special for XHTML//EN" "../../dtds/xhtml-special.ent"> %HTMLspecial;
	<!ENTITY % HTMLsymbol  PUBLIC "-//W3C//ENTITIES Symbols for XHTML//EN" "../../dtds/xhtml-symbol.ent" > %HTMLsymbol;
]>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:php="http://php.net/xsl">



<xsl:template mode="contact" match="form/errors/*" priority="-1"><xsl:apply-templates select="."/></xsl:template>

<xsl:template mode="div" match="form/errors/client_required       "><div class="error">Необходимо указать клиента.</div></xsl:template>
<xsl:template mode="div" match="form/errors/manager_required      "><div class="error">Необходимо указать менеджера.</div></xsl:template>
<xsl:template mode="div" match="form/errors/boat_number_required"><div class="error">Необходимо указать номер катера.</div></xsl:template>
<xsl:template mode="div" match="form/errors/contract_order_duplicate"><div class="error">Такой номер договора уже существует.</div></xsl:template>

</xsl:stylesheet>
