<?xml version="1.0" encoding="cp1251" ?>
<!DOCTYPE xsl:stylesheet [
	<!ENTITY % HTMLlat1    PUBLIC "-//W3C//ENTITIES Latin 1 for XHTML//EN" "../../dtds/xhtml-lat1.ent"   > %HTMLlat1;
	<!ENTITY % HTMLspecial PUBLIC "-//W3C//ENTITIES Special for XHTML//EN" "../../dtds/xhtml-special.ent"> %HTMLspecial;
	<!ENTITY % HTMLsymbol  PUBLIC "-//W3C//ENTITIES Symbols for XHTML//EN" "../../dtds/xhtml-symbol.ent" > %HTMLsymbol;
]>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:php="http://php.net/xsl">
<xsl:include href="../../xslts/admin.xslt"/>
<xsl:include href="../../xslts/_common_/lists.xslt"/>
<xsl:include href="../../xslts/_common_/files.xslt"/>
<xsl:include href="../../xslts/common/errors.xslt"/>
<xsl:include href="../../xslts/common/form.xslt"/>
<xsl:include href="../../xslts/common/list.xslt"/>
<xsl:include href="../../xslts/linked_paras/list.xslt"/>
<xsl:include href="../../xslts/linked_picts/list.xslt"/>
<xsl:include href="../../xslts/linked_files/list.xslt" />
<xsl:include href="../../xslts/linked_paras/form.xslt"/>
<xsl:include href="../../xslts/linked_picts/form.xslt"/>
<xsl:include href="../../xslts/linked_files/form.xslt" />
<xsl:include href="./conf.xslt"/>


<xsl:template match="/" mode="overrideable_selector">
	<xsl:value-of select="$essence"/>
</xsl:template>

<xsl:template match="/" mode="overrideable_title">
	<xsl:value-of select="$essence_title"/>
</xsl:template>


<xsl:template match="/" mode="overrideable_path">
	<xsl:call-template name="path_link"><xsl:with-param name="link" select="concat(/*/system/info/adm_root, $adm_sub_root, $essence)"/><xsl:with-param name="text" select="$essence_title"/></xsl:call-template>
	<xsl:call-template name="path_separator"/>
	<xsl:call-template name="path_link"><xsl:with-param name="link" select="concat(/*/system/info/adm_root, $adm_sub_root, $essence, '/update/', /*/form/data/id)"/><xsl:with-param name="text" select="/*/form/data/*[name() = /*/module/name_field]"/></xsl:call-template>
	<xsl:call-template name="path_separator"/>
	<xsl:call-template name="path_this"><xsl:with-param name="text" select="'Изменение'"/></xsl:call-template>
</xsl:template>

<xsl:template match="/" mode="overrideable_submenu">
	<xsl:call-template name="list_of_languages">
		<xsl:with-param name="link" select="concat(/*/system/info/adm_root, $adm_sub_root, $essence, '/update/', /*/form/id)"/>
	</xsl:call-template>
</xsl:template>

<xsl:template match="/" mode="overrideable_redirect">
	<xsl:if test="/*/done">
	        <xsl:choose>
        	<xsl:when test="/*/module/return_to_list = 1">
			<xsl:call-template name="_done_"/>
		</xsl:when>
		<xsl:otherwise>
			<xsl:value-of select="concat(/*/system/info/adm_root, $adm_sub_root, $essence, '/update/', /*/done/id)"/>
		</xsl:otherwise>
		</xsl:choose>
	</xsl:if>
</xsl:template>

<xsl:template match="/" mode="overrideable_headers">
	<script type="text/javascript" src="{/*/system/info/adm_root}js/lists.js"/>
</xsl:template>

<xsl:template match="/*/form">
	<xsl:call-template name="form_for_common_element">
		<xsl:with-param name="form" select="."/>
		<xsl:with-param name="button_alt" select="'Изменить'"/>
		<xsl:with-param name="button_img" select="'update'"/>
		<xsl:with-param name="button_w"   select="92"/>
		<xsl:with-param name="button_h"   select="19"/>
	</xsl:call-template>

	<xsl:if test="$essence = 'requests'">
		<h3 class="layoutSubTitle">XML</h3>
		<xsl:call-template name="list_of_common_elements">
			<xsl:with-param name="node" select="info/xml"/>
			<xsl:with-param name="hide_links"  select="0"/>
			<xsl:with-param name="add_link"    select="0"/>
			<xsl:with-param name="essence" select="'xml'"/>
			<xsl:with-param name="module" select="/*/xml_module"/>
			<xsl:with-param name="filters" select="/.."/>
			<xsl:with-param name="sorters" select="/.."/>
			<xsl:with-param name="pager"   select="/.."/>
		</xsl:call-template>
	</xsl:if>
<!--
	<h3 class="layoutSubTitle">Файлы</h3>
	<xsl:call-template name="list_of_linked_files">
		<xsl:with-param name="node" select="info/linked_files"/>
		<xsl:with-param name="uplink_type" select="'article'"/>
		<xsl:with-param name="uplink_id"   select="id"/>
	</xsl:call-template>

	<h3 class="layoutSubTitle">Изображение для списка</h3>
	<xsl:call-template name="list_of_linked_picts">
		<xsl:with-param name="node" select="info/linked_picts"/>
		<xsl:with-param name="uplink_type" select="'article'"/>
		<xsl:with-param name="uplink_id"   select="id"/>
	</xsl:call-template>

	<h3 class="layoutSubTitle">Параграфы</h3>
	<xsl:call-template name="list_of_linked_paras">
		<xsl:with-param name="node" select="info/linked_paras"/>
		<xsl:with-param name="uplink_type" select="'article'"/>
		<xsl:with-param name="uplink_id"   select="id"/>
	</xsl:call-template>
-->
</xsl:template>



</xsl:stylesheet>
