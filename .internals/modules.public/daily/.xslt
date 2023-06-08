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

<xsl:template match="/" mode="overrideable_title">
	Ежедневный отчёт
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
			background-color: #2a6496;
		 }
		.table-capacity td, .table-capacity th { padding: 5px; background-color: #FFF; } /*#EAF2FA*/
		.table-capacity tr.plan td { background-color: #ddd; }
		.table-capacity td { text-align: center; }
		#daily-table .daily_all { width: 180px; }
	</style>
	
	<script type="text/javascript" src="{/*/system/info/pub_root}js/daily.js"></script>
</xsl:template>

<xsl:template match="/" mode="global_top_menu">daily</xsl:template> 
<xsl:template match="/" mode="global_left_menu">daily</xsl:template> 

<xsl:template match="/" mode="overrideable_head">
	Ежедневный отчёт
</xsl:template>

<xsl:template match="/" mode="overrideable_measurer">
	<xsl:call-template name="measurer_divider"/>
	<span class="active">Ежедневный отчёт</span>
</xsl:template>

<xsl:template match="/" mode="overrideable_content">

	<xsl:if test="/*/identity /consumer/roles/role = 'admin'">
        <ul class="nav nav-tabs">

				<li title="" rel="" class="icon index_collection_link">
					<xsl:if test="/*/filters/*[name='branch']/value = '' or /*/filters/*[name='branch']/value = 'all'">
						<xsl:attribute name="class">active</xsl:attribute>
					</xsl:if>
					<a class="pjax" href="{/*/system/info/pub_root}daily/?filter_branch=all">
						<i class="icon-th-list"></i>
						<span>Все</span>
					</a>
				</li>
				
				<xsl:for-each select="/*/branches/*">
				<li title="" rel="" class="icon index_collection_link">
					<xsl:if test="/*/filters/*[name='branch']/value = id">
						<xsl:attribute name="class">active</xsl:attribute>
					</xsl:if>
					<a class="pjax" href="{/*/system/info/pub_root}daily/?filter_branch={id}">
						<i class="icon-th-list"></i>
						<span><xsl:value-of select="name" disable-output-escaping="yes"/></span>
					</a>
				</li>
				</xsl:for-each>

        </ul>
	</xsl:if>

	<xsl:variable name="filtes_sorters_url">
		<xsl:text>?</xsl:text>
		<xsl:if test="/*/filters/*/value != ''">
			<xsl:text>&amp;</xsl:text>
			<xsl:call-template name="url_args_for_filters">
				<xsl:with-param name="filters" select="/*/filters"/>
			</xsl:call-template>
		</xsl:if>
	</xsl:variable>

	<form action="{/*/system/info/pub_root}daily/" method="get">
		<table class="filters_in_req">
			<xsl:if test="/*/filters/*[position() &gt; 8]/value != ''">
				<xsl:attribute name="class">filters_in_req filters_opened</xsl:attribute>
			</xsl:if>
			<tr>
				<td colspan="2">
					<div class="filter-row filter-date">
						<xsl:apply-templates select="/*/filters/*[name='time']" mode="quick_filters"/>
						<!--span class="filter-title">Дата</span>
						<xsl:apply-templates select="/*/filters/*[name='time_from']" mode="quick_filters"/>
						<span class="filter-title"></span>
						<xsl:apply-templates select="/*/filters/*[name='time_to']" mode="quick_filters"/-->
					</div>
				</td>
			</tr>
			<tr class="filter-btn-row">
				<!--td>
					<div class="layout">
						<button id="ExportBtn" type="submit" name="export" value="1" class="btn btn-default" style="width: 200px; display: inline-block; margin-left: 20px">Сохранить в Excel</button>
					</div>
				</td-->
			</tr>
		</table>
		<input type="hidden" name="filter_branch" value="{/*/filters/*[name='branch']/value}"/>
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
		<table class='table-capacity' id="daily-table">
		<thead>
			<tr>
				<th class='pjax string_type'>Дата</th>
				<th class='pjax string_type'>Визиты</th>
				<th class='pjax string_type'>Входящие звонки</th>
				<th class='pjax string_type'>Заявки с сайта</th>
				<th class='pjax string_type'>Лиды</th>
				<th class='pjax string_type'>Кол-во продаж</th>
				<th class='pjax string_type'>Сумма продаж</th>
				<th class='pjax string_type'>Рубли</th>
				<th class='pjax string_type'>Доллары</th>
			</tr>
		</thead>
		<tbody>
		<xsl:choose>
		<xsl:when test="/*/identity /consumer/roles/role = 'admin' and (/*/filters/*[name='branch']/value = '' or /*/filters/*[name='branch']/value = 'all')">
		<xsl:for-each select="/*/report/day">
			<tr class='request_row'>
				<td><xsl:apply-templates select="date_parsed" mode="show_date_ru"/></td>
				<td class="daily_all"><xsl:value-of select="visit" disable-output-escaping="yes"/></td>
				<td class="daily_all"><xsl:value-of select="calls" disable-output-escaping="yes"/></td>
				<td class="daily_all"><xsl:value-of select="sites" disable-output-escaping="yes"/></td>
				<td class="daily_all"><xsl:value-of select="lids" disable-output-escaping="yes"/></td>
				<td class="daily_all"><xsl:value-of select="sales" disable-output-escaping="yes"/></td>
				<td class="daily_all"><xsl:apply-templates select="summ" mode="show_price"><xsl:with-param name="currency" select="'rub'"/></xsl:apply-templates></td>
				<td class="daily_all"><xsl:apply-templates select="rub" mode="show_price"><xsl:with-param name="currency" select="'rub'"/></xsl:apply-templates></td>
				<td class="daily_all"><xsl:apply-templates select="usd" mode="show_price"><xsl:with-param name="currency" select="'usd'"/></xsl:apply-templates></td>
			</tr>
		</xsl:for-each>
		</xsl:when>
		<xsl:otherwise>
		<xsl:for-each select="/*/report/day">
			<tr class='request_row' data-id="{id}">
				<td>
					<xsl:apply-templates select="date_parsed" mode="show_date_ru"/>
					<input type="hidden" name="date">
						<xsl:attribute name="value">
							<xsl:apply-templates select="date_parsed" mode="show_date_ru"/>
						</xsl:attribute>
					</input>
					<xsl:if test="/*/identity /consumer/roles/role = 'admin'">
						<input type="hidden" name="branch" value="{/*/filters/*[name='branch']/value}"/>
					</xsl:if>
				</td>
				<td><input type="text" name="visit" value="{visit}" class="daily_input"/></td>
				<td><input type="text" name="calls" value="{calls}" class="daily_input"/></td>
				<td><input type="text" name="sites" value="{sites}" class="daily_input"/></td>
				<td><input type="text" name="lids" value="{lids}" class="daily_input"/></td>
				<td><input type="text" name="sales" value="{sales}" class="daily_input"/></td>
				<td>
					<input type="text" name="summ" value="{summ}" class="daily_input" input-mask="number"/>
					<xsl:if test="summ &gt; 0"> p.</xsl:if>
				</td>
				<td>
					<input type="text" name="rub" value="{rub}" class="daily_input"/>
					<xsl:if test="rub &gt; 0"> p.</xsl:if>
				</td>
				<td>
					<xsl:if test="usd &gt; 0">$</xsl:if>
					<input type="text" name="usd" value="{usd}" class="daily_input"/>
				</td>
			</tr>
		</xsl:for-each>
		</xsl:otherwise>
		</xsl:choose>
		</tbody>
		</table>
	</div>
	<br/>
	<br/>
	<br/>
	<br/>
</xsl:template>

</xsl:stylesheet>
