<?xml version="1.0" encoding="cp1251" ?>
<!DOCTYPE xsl:stylesheet [
	<!ENTITY % HTMLlat1    PUBLIC "-//W3C//ENTITIES Latin 1 for XHTML//EN" "../../dtds/xhtml-lat1.ent"   > %HTMLlat1;
	<!ENTITY % HTMLspecial PUBLIC "-//W3C//ENTITIES Special for XHTML//EN" "../../dtds/xhtml-special.ent"> %HTMLspecial;
	<!ENTITY % HTMLsymbol  PUBLIC "-//W3C//ENTITIES Symbols for XHTML//EN" "../../dtds/xhtml-symbol.ent" > %HTMLsymbol;
]>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:php="http://php.net/xsl">
<xsl:include href="../../xslts/public.xslt"/>
<xsl:include href="../../xslts/contacts/errors.xslt"/>
<xsl:include href="form.xslt"/>
<xsl:include href="../../xslts/_common_/quick_form.xslt"/>

<xsl:template match="/" mode="overrideable_title">
</xsl:template>

<xsl:template match="/" mode="overrideable_keywords">
</xsl:template>

<xsl:template match="/" mode="overrideable_description">
</xsl:template>

<xsl:template match="/" mode="overrideable_measurer">
	<a class="act">Контакты</a>
</xsl:template>

<xsl:template match="/" mode="global_top_menu">contacts</xsl:template> 

<xsl:template match="/" mode="overrideable_head">Контакты</xsl:template>

<xsl:attribute-set name="attributes_of_body">
	<xsl:attribute name="onclick">hide_all();</xsl:attribute>
</xsl:attribute-set>

<xsl:template match="/" mode="overrideable_content">
	<!--xsl:apply-templates select="/*/item/linked_paras"/-->
	<xsl:for-each select="/*/page_content/linked_paras/linked_para[position() = 1]">
		<xsl:if test="small_file != ''">
		<div style="float: right"> 
			<div class="b-contacts-map">
			<xsl:variable name="big_url" select="concat(/*/system/info/pub_root, 'linked/paras/large/', uplink_type, '/', uplink_id, '/', large_file)"/>
			<xsl:variable name="small_url" select="concat(/*/system/info/pub_root, 'linked/paras/small/', uplink_type, '/', uplink_id, '/', small_file)"/>
				<img src="{$small_url}" width="{small_w}" height="{small_h}" alt="увеличить" title="увеличить" class="pic pic_right b-contacts-map__min"/>
				<img src="{$big_url}" width="{large_w}" height="{large_h}" alt="закрыть" title="закрыть" class="b-contacts-map__big"/>
			</div>
		</div>
	        </xsl:if>
	        <xsl:if test="name!=''">
			<h2><xsl:value-of select="name" disable-output-escaping="yes"/></h2>
	        </xsl:if>

		<xsl:value-of select="text" disable-output-escaping="yes"/>
	</xsl:for-each>

	<xsl:apply-templates select="/*/page_content/linked_paras/linked_para[position() &gt; 1]" />

    <xsl:if test="/*/page_content/linked_files/*">
    <hr/>
    <div  class="docs"> 
      <h2>Необходимые документы</h2>
      <ul>
      	<xsl:for-each select="/*/page_content/linked_files/linked_file">
        <li><xsl:apply-templates select="."/> </li>
        </xsl:for-each>
      </ul>
    </div>
    </xsl:if>
<div class="clearfix"></div>
      <div class="form_block"> 
		<h2>Для Ваших вопросов и предложений:</h2>
		<a name="form"/>
		<xsl:variable name="form" select="/*/form"/>
		<xsl:choose>
		<xsl:when test="/*/done">	
			<form action="#" method="post" class="content_form">
				<fieldset>
					<xsl:apply-templates select="/*/inlines/inline[label='contacts:sent']"/>
				</fieldset>
			</form>
		</xsl:when>
		<xsl:otherwise>
			<form action="{/*/system/info/pub_root}contacts/#form" method="post" class="content_form">
				<fieldset>
					<xsl:apply-templates select="$form/errors/*" mode="contact"/>
					<xsl:apply-templates select="/*/fields/TextField[name='name']"		mode="quick_form"/>
					<br/>
					<xsl:apply-templates select="/*/fields/TextField[name='phone']"		mode="quick_form"/>
					<br/>
					<xsl:apply-templates select="/*/fields/TextField[name='email']"		mode="quick_form"/>
					<br/>
					<xsl:apply-templates select="/*/fields/TextArea [name='comments']"	mode="quick_form"/>
					<br/>
					<xsl:apply-templates select="/*/fields/Gp" mode="quick_form"/>
					<br/>
					<!--div class="capcha_block"> * - поля со звездочкой обязательны для заполнения<br/>
						<xsl:apply-templates select="/*/fields/Gp" mode="quick_form"/>
					</div-->
					<input type="submit" class="sub" value="Отправить"/>
				</fieldset>
			</form>
		</xsl:otherwise>
		</xsl:choose>
      </div> 
</xsl:template>



</xsl:stylesheet>
