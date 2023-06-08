<?xml version="1.0" encoding="cp1251" ?>
<!DOCTYPE xsl:stylesheet [
	<!ENTITY % HTMLlat1    PUBLIC "-//W3C//ENTITIES Latin 1 for XHTML//EN" "../../dtds/xhtml-lat1.ent"   > %HTMLlat1;
	<!ENTITY % HTMLspecial PUBLIC "-//W3C//ENTITIES Special for XHTML//EN" "../../dtds/xhtml-special.ent"> %HTMLspecial;
	<!ENTITY % HTMLsymbol  PUBLIC "-//W3C//ENTITIES Symbols for XHTML//EN" "../../dtds/xhtml-symbol.ent" > %HTMLsymbol;
]>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:php="http://php.net/xsl">
<xsl:include href="../../xslts/public.xslt"/>
<xsl:include href="../../xslts/index.xslt"/>
<xsl:include href="../../xslts/_common_/quick_filters.xslt"/>

<xsl:include href="../../xslts/_common_/calendars.xslt" />

<xsl:include href="menu.xslt" />

<xsl:template match="/" mode="overrideable_title">
	Отчёт
</xsl:template>

<xsl:template match="/" mode="overrideable_keywords">
</xsl:template>

<xsl:template match="/" mode="overrideable_description">
</xsl:template>

<xsl:template match="/" mode="overrideable_headers">
	<style>
		.table-capacity {
			border-collapse: unset;
			border-spacing: 1px;		
		 }
		.table-capacity td, .table-capacity th { padding: 5px; background-color: #EAF2FA; }
		.table-capacity td { text-align: center; }
	</style>
</xsl:template>

<xsl:template match="/" mode="global_top_menu">report</xsl:template> 
<xsl:template match="/" mode="global_left_menu">report</xsl:template> 

<xsl:template match="/" mode="overrideable_head">
	Отчёт
</xsl:template>

<xsl:template match="/" mode="overrideable_measurer">
	<xsl:call-template name="measurer_divider"/>
	<span class="active">Отчёт</span>
</xsl:template>

<xsl:template match="/" mode="overrideable_content">

<xsl:call-template name="report_menu">
	<xsl:with-param name="curr_page" select="''"/>
</xsl:call-template>


	<xsl:variable name="filtes_sorters_url">
		<xsl:text>?</xsl:text>
		<xsl:if test="/*/filters/*/value != ''">
			<xsl:text>&amp;</xsl:text>
			<xsl:call-template name="url_args_for_filters">
				<xsl:with-param name="filters" select="/*/filters"/>
			</xsl:call-template>
		</xsl:if>
	</xsl:variable>

	<form action="{/*/system/info/pub_root}report/" method="get">
		<table class="filters_in_req">
			<xsl:if test="/*/filters/*[position() &gt; 8]/value != ''">
				<xsl:attribute name="class">filters_in_req filters_opened</xsl:attribute>
			</xsl:if>
			<tr>
				<td colspan="2">
					<div class="filter-row filter-date">
						<span class="filter-title">Дата</span>
						<xsl:apply-templates select="/*/filters/*[name='time_from']" mode="quick_filters"/>
						<span class="filter-title"></span>
						<xsl:apply-templates select="/*/filters/*[name='time_to']" mode="quick_filters"/>
					</div>
				</td>
			</tr>
			<tr class="filter-btn-row">
				<td>
					<div class="layout">
						<input id="FilterBtn" type="submit" value="Применить" class="btn btn-default clearfix" style="width: 200px; display: inline-block; margin-left: 20px"/>
					</div>
				</td>
				<td>
					<div class="layout">
						<button id="ExportBtn" type="submit" name="export" value="1" class="btn btn-default" style="width: 200px; display: inline-block; margin-left: 20px">Сохранить в Excel</button>
					</div>
				</td>
			</tr>
		</table>
		<input type="hidden" name="filter_client" value="{/*/filters/*[name='client']/value}"/>
		<input type="hidden" name="sorter">
			<xsl:attribute name="value">
				<xsl:call-template name="arg_val_for_sorters">
					<xsl:with-param name="sorters" select="/*/sorters"/>
				</xsl:call-template>
			</xsl:attribute>
		</input>
	</form>
	<div class="clearfix"></div>

	<br/>

	<div id='list'>
		<table class='table-capacity'>
		<thead>
			<tr>
				<th class='pjax string_type'>Клиент</th>
				<th class='pjax string_type'>Сумма запланированных неоплаченных</th>
				<th class='pjax string_type'>Сумма поступивших</th>
			</tr>
		</thead>
		<tbody>
			<tr class='request_row'>
				<th class='pjax string_type' style="width: 300px">Всего за период</th>
				<td class=' string_type'>
					<xsl:apply-templates select="/*/report/wait_pays" mode="show_prices"/>
					<!--xsl:for-each select="/*/report/wait_pays/*">
						<xsl:apply-templates select="." mode="show_price"><xsl:with-param name="currency" select="name()"/></xsl:apply-templates>
					</xsl:for-each-->
					</td>
				<td class=' string_type'>
					<xsl:apply-templates select="/*/report/have_pays" mode="show_prices"/>
					<!--xsl:for-each select="/*/report/have_pays/*">
						<xsl:apply-templates select="." mode="show_price"><xsl:with-param name="currency" select="name()"/></xsl:apply-templates>
					</xsl:for-each-->
				</td>
			</tr>
		<xsl:for-each select="/*/report/data/payment">
			<tr class='request_row'>
				<th class='pjax string_type' style="width: 300px"><a href="{/*/system/info/pub_root}payment/{id}/"><xsl:value-of select="client" disable-output-escaping="yes"/></a></th>
				<td class=' string_type'>
					<xsl:apply-templates select="wait_pays" mode="show_price"><xsl:with-param name="currency" select="currency"/></xsl:apply-templates>
				</td>
				<td class=' string_type'>
					<xsl:apply-templates select="have_pays" mode="show_price"><xsl:with-param name="currency" select="currency"/></xsl:apply-templates>
				</td>
			</tr>
		</xsl:for-each>
		</tbody>
		</table>
	</div>
	<br/>
	<br/>
	<br/>
	<br/>
</xsl:template>

</xsl:stylesheet>
