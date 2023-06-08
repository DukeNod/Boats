<?xml version="1.0" encoding="cp1251" ?>
<!DOCTYPE xsl:stylesheet [
	<!ENTITY % HTMLlat1    PUBLIC "-//W3C//ENTITIES Latin 1 for XHTML//EN" "../dtds/xhtml-lat1.ent"   > %HTMLlat1;
	<!ENTITY % HTMLspecial PUBLIC "-//W3C//ENTITIES Special for XHTML//EN" "../dtds/xhtml-special.ent"> %HTMLspecial;
	<!ENTITY % HTMLsymbol  PUBLIC "-//W3C//ENTITIES Symbols for XHTML//EN" "../dtds/xhtml-symbol.ent" > %HTMLsymbol;
]>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:php="http://php.net/xsl">
<xsl:include href="../xslts/public.xslt"/>


<xsl:template match="/" mode="overrideable_title">
	Редактор
</xsl:template>

<xsl:template match="/" mode="overrideable_keywords">
</xsl:template>

<xsl:template match="/" mode="overrideable_description">
</xsl:template>

<xsl:template match="/" mode="overrideable_measurer">
</xsl:template>

<xsl:template match="/" mode="overrideable_headers">
		<!-- Ace Editor -->
		<script type="text/javascript" src="{/*/system/info/pub_root}js/ace_editor/ace.js"></script>
		<link rel="stylesheet" type="text/css" href="{/*/system/info/pub_root}css/ace_editor/ace.css"></link>
		<script type="text/javascript" src="{/*/system/info/pub_root}js/edit_page.js"/>
</xsl:template>

<xsl:template match="/" mode="overrideable_head">
	Редактор
</xsl:template>

<xsl:template match="error" mode="xml_error">
	<div class="error">
		<xsl:value-of select="." disable-output-escaping="yes"/>
	</div>
</xsl:template>

<xsl:template match="/" mode="overrideable_content">

	<xsl:apply-templates select="/*/errors/error" mode="xml_error"/>
	
	<div>
		<xsl:value-of select="/*/success" disable-output-escaping="yes"/>
	</div>
	<form action="#" method="post">
		ID: <input id="file_id" name="id" value="{/*/id}"/> <button onClick="window.location='{/*/system/info/adm_root}edit/'+document.getElementById('file_id').value+'/';return false" >Перейти</button>
	</form>
	<br/>
	<br/>
	<div style="height:700px;">
		<pre id="ace_edit_pre" class=" ace_editor ace-tm">
		</pre>
	</div>
	<br/>
	<br/>
	<input type="submit" value="Сохранить" id="visible_submit"/>
	<div style="margin-top:20px">&nbsp;</div>
	<form action="{/*/system/info/adm_root}edit/{/*/id}/" method="post" style="display:none">
		<textarea id="textxml" name="xml" placeholder="Put XML" style="width: 1000px; height: 500px;">
			<xsl:value-of select="/*/xml" disable-output-escaping="yes"/>
		</textarea>
		<br/>
		<input type="submit" value="Сохранить" id="nonvisible_submit"/>
	</form>
</xsl:template>

</xsl:stylesheet>
