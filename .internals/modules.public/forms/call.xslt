<?xml version="1.0" encoding="cp1251" ?>
<!DOCTYPE xsl:stylesheet [
	<!ENTITY % HTMLlat1    PUBLIC "-//W3C//ENTITIES Latin 1 for XHTML//EN" "../../dtds/xhtml-lat1.ent"   > %HTMLlat1;
	<!ENTITY % HTMLspecial PUBLIC "-//W3C//ENTITIES Special for XHTML//EN" "../../dtds/xhtml-special.ent"> %HTMLspecial;
	<!ENTITY % HTMLsymbol  PUBLIC "-//W3C//ENTITIES Symbols for XHTML//EN" "../../dtds/xhtml-symbol.ent" > %HTMLsymbol;
]>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
<xsl:include href="form_public.xslt"/>
<xsl:include href="../../xslts/call/errors.xslt"/>
<xsl:include href="../../xslts/empty2.xslt"/>
<xsl:include href="../../xslts/_common_/quick_form.xslt"/>


<xsl:template match="/" mode="overrideable_content">
	<xsl:variable name="form" select="/*/form | /*/done"/>

	<xsl:choose>
	<xsl:when test="/*/done">
		<form action="#" method="post" id="{$form/form/mr}_form">
			<fieldset>
				<div class="title_form">
					<p>
					<xsl:value-of select="$form/form/sent" disable-output-escaping="yes"/>
					</p>
					<!--xsl:apply-templates select="/*/inlines/inline[label='retail:sent']"/-->
				</div>
			</fieldset>
		</form>
	</xsl:when>
	<xsl:otherwise>
        <div class="title_popup2"><xsl:value-of select="$form/form/name" disable-output-escaping="yes"/></div>
        <div class="text0"> <p><xsl:value-of select="$form/form/short" disable-output-escaping="yes"/></p>
          <p> Все поля обязательны для заполнения.</p>
        </div>

		<form action="{$LANGROOT}forms/{$form/form/mr}/" method="post" id="{$form/form/mr}_form">
	          <fieldset>
				<xsl:apply-templates select="$form/errors/*"/> 

				<xsl:apply-templates select="/*/fields/*"		mode="quick_form"/>

				<input type="submit" class="sub" value="Отправить"/>
	          </fieldset>
		</form>
	</xsl:otherwise>
	</xsl:choose>
</xsl:template>

</xsl:stylesheet>
