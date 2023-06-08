<?xml version="1.0" encoding="cp1251" ?>
<!DOCTYPE xsl:stylesheet [
	<!ENTITY % HTMLlat1    PUBLIC "-//W3C//ENTITIES Latin 1 for XHTML//EN" "../../dtds/xhtml-lat1.ent"   > %HTMLlat1;
	<!ENTITY % HTMLspecial PUBLIC "-//W3C//ENTITIES Special for XHTML//EN" "../../dtds/xhtml-special.ent"> %HTMLspecial;
	<!ENTITY % HTMLsymbol  PUBLIC "-//W3C//ENTITIES Symbols for XHTML//EN" "../../dtds/xhtml-symbol.ent" > %HTMLsymbol;
]>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:php="http://php.net/xsl">
<xsl:include href="../../xslts/public.xslt"/>
<xsl:include href="../../xslts/index.xslt"/>
<xsl:include href="../../xslts/req_list.xslt"/>
<xsl:include href="form.xslt"/>
<xsl:include href="errors.xslt"/>
<xsl:include href="../../xslts/_common_/quick_form.xslt"/>

<xsl:include href="../../xslts/_common_/calendars.xslt" />

<xsl:template match="/" mode="overrideable_title">
	Клиенты и оплата
</xsl:template>

<xsl:template match="/" mode="overrideable_keywords">
</xsl:template>

<xsl:template match="/" mode="overrideable_description">
</xsl:template>

<xsl:template match="/" mode="overrideable_headers">
    <!-- dadata -->
    <link href="https://cdn.jsdelivr.net/npm/suggestions-jquery@17.10.1/dist/css/suggestions.min.css" type="text/css" rel="stylesheet" />
    <script type="text/javascript" src="https://cdn.jsdelivr.net/npm/suggestions-jquery@17.10.1/dist/js/jquery.suggestions.min.js"></script>
	<script type="text/javascript" src="{/*/system/info/pub_root}js/inputmask.min.js"></script>
	<script type="text/javascript" src="{/*/system/info/pub_root}js/selects.js"/>
	<script type="text/javascript" src="{/*/system/info/pub_root}js/payment.js"/>
</xsl:template>

<xsl:template match="/" mode="global_top_menu">payment</xsl:template> 
<xsl:template match="/" mode="global_left_menu">payment</xsl:template> 

<xsl:template match="/" mode="overrideable_head">
	Клиенты и оплата
</xsl:template>

<xsl:template match="/" mode="overrideable_measurer">
	<xsl:call-template name="measurer_divider"/>
	<span class="active">Клиенты и оплата</span>
</xsl:template>

<xsl:template match="/" mode="overrideable_content">
<form enctype="multipart/form-data" action="" id="form_add" method="post" novalidate="novalidate" style='margin-right: 15px;'>
		<xsl:apply-templates select="/*/form/errors/*" mode="div"/>
		<xsl:apply-templates select="/*/fields/*"    mode="quick_form_request"/>
</form>
</xsl:template>

</xsl:stylesheet>
