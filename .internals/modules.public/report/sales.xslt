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
			background-color: #2a6496;
		 }
		.table-capacity td, .table-capacity th { padding: 5px; background-color: #FFF; } /*#EAF2FA*/
		.table-capacity tr.plan td { background-color: #ddd; }
		.table-capacity tr.cancel td { background-color: #ffa500; }
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
	<xsl:with-param name="curr_page" select="'sales'"/>
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

	<form action="{/*/system/info/pub_root}report/sales/" method="get">
		<table class="filters_in_req">
			<xsl:if test="/*/filters/*[position() &gt; 8]/value != ''">
				<xsl:attribute name="class">filters_in_req filters_opened</xsl:attribute>
			</xsl:if>
			<tr>
				<td colspan="2">
					<div class="filter-row filter-date">
						<!--xsl:apply-templates select="/*/filters/*[name='time']" mode="quick_filters"/-->
						<span class="filter-title">Период</span>
						<xsl:apply-templates select="/*/filters/*[name='time_from']" mode="quick_filters"/>
						<span class="filter-title"></span>
						<xsl:apply-templates select="/*/filters/*[name='time_to']" mode="quick_filters"/>
					</div>
				</td>
			</tr>
			<tr class="filter-btn-row">
				<td>
					<div class="layout">
						<input id="FilterBtn" type="submit" value="Применить" class="btn btn-default clearfix" style="width: 200px; display: inline-block"/>
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
				<th class='pjax string_type'>Дата</th>
				<th class='pjax string_type'>Модель</th>
				<th class='pjax string_type'>Тип</th>
				<th class='pjax string_type'>Клиент</th>
				<th class='pjax string_type'>Менеджер</th>
				<th class='pjax string_type'>Регион</th>
				<th class='pjax string_type'>Сумма контракта</th>
				<th class='pjax string_type'>Сумма оплаченных</th>
				<th class='pjax string_type'>Остаток по контракту</th>
				<th class='pjax string_type'>Скидка</th>
				<th class='pjax string_type'>Способ оплаты</th>
				<th class='pjax string_type'>Закрытие оплаты</th>
				<th class='pjax string_type'>Телефон</th>
			</tr>
		</thead>
		<tbody>
		<xsl:for-each select="/*/report/*[1]/branch">
			<tr class='request_row'>
				<th class='pjax string_type' colspan="13">
				<xsl:choose>
				<xsl:when test = "not(name)">
					Филиал не указан
				</xsl:when>
				<xsl:otherwise>
					<xsl:value-of select="name" disable-output-escaping="yes"/>
				</xsl:otherwise>
				</xsl:choose>
				
				<xsl:for-each select="counts/*">,
					<xsl:value-of select="name" disable-output-escaping="yes"/>
					&nbsp;<xsl:value-of select="count" disable-output-escaping="yes"/>
				</xsl:for-each>
				</th>
			</tr>
			<xsl:for-each select="payments/payment">
				<tr class='request_row'>
					<xsl:choose>
					<xsl:when test="cancel = 1">
						<xsl:attribute name="class">request_row cancel</xsl:attribute>
					</xsl:when>
					<xsl:when test="plan = 1">
						<xsl:attribute name="class">request_row plan</xsl:attribute>
					</xsl:when>
					</xsl:choose>
					<td><xsl:apply-templates select="date_parsed" mode="show_date_ru"/></td>
					<td>
						<xsl:for-each select="models/model">
							<xsl:value-of select="name" disable-output-escaping="yes"/>
							<xsl:if test="position() != last()">, </xsl:if>
						</xsl:for-each>
					</td>
					<td>
						<xsl:for-each select="models/model">
							<xsl:value-of select="model_type" disable-output-escaping="yes"/>
							<xsl:if test="position() != last()">, </xsl:if>
						</xsl:for-each>
					</td>
					<td><a href="{/*/system/info/pub_root}payment/{id}/"><xsl:value-of select="client" disable-output-escaping="yes"/></a></td>
					<td><xsl:value-of select="manager" disable-output-escaping="yes"/></td>
					<td><xsl:value-of select="region" disable-output-escaping="yes"/></td>
					<td><xsl:apply-templates select="summ" mode="show_price"><xsl:with-param name="currency" select="currency"/></xsl:apply-templates></td>
					<td><xsl:apply-templates select="have_pays" mode="show_price"><xsl:with-param name="currency" select="currency"/></xsl:apply-templates></td>
					<td><xsl:apply-templates select="ost" mode="show_price"><xsl:with-param name="currency" select="currency"/></xsl:apply-templates></td>
					<td><xsl:apply-templates select="discount" mode="show_price"><xsl:with-param name="currency" select="currency"/></xsl:apply-templates></td>
					<td><xsl:value-of select="paytype" disable-output-escaping="yes"/></td>
					<td><xsl:value-of select="status" disable-output-escaping="yes"/></td>
					<td><xsl:value-of select="php:function('str_replace', ' ', '', string(phone))" disable-output-escaping="yes"/></td>
				</tr>
			</xsl:for-each>
		</xsl:for-each>
				<tr class='request_row'>
					<th class='pjax string_type' colspan="6">Всего:
						<!--xsl:for-each select="/*/report/total/counts/*[name() != 'bolot']"-->
						<xsl:for-each select="/*/report/*[1]/total/counts/boat/*">
						<xsl:if test="position() != 1">, </xsl:if>
							<xsl:value-of select="name" disable-output-escaping="yes"/>
							&nbsp;<xsl:value-of select="count" disable-output-escaping="yes"/>
						</xsl:for-each>
					</th>
					<th style='text-align: center'>
						<xsl:apply-templates select="/*/report/*[1]/total/contract/boat" mode="show_prices"/>
					</th>
					<th style='text-align: center'>
						<xsl:apply-templates select="/*/report/*[1]/total/summ/boat" mode="show_prices"/>
						<!--xsl:for-each select="/*/report/total/summ/*">
							<xsl:apply-templates select="." mode="show_price"><xsl:with-param name="currency" select="name()"/></xsl:apply-templates>
						</xsl:for-each-->
					</th>
					<td></td>
					<th style='text-align: center'>
						<xsl:apply-templates select="/*/report/*[1]/total/discount/boat" mode="show_prices"/>
					</th>
					<td colspan="3"></td>
				</tr>
				<xsl:for-each select="/*/report/*[1]/total/paytypes/boat/paytype">
				<tr class='request_row'>
					<td colspan="7" style="text-align: left">
						<xsl:choose>
						<xsl:when test = "name = ''">
							Не указано
						</xsl:when>
						<xsl:otherwise>
							<xsl:value-of select="name" disable-output-escaping="yes"/>
						</xsl:otherwise>
						</xsl:choose>
						<xsl:text>: </xsl:text>
					</td>
					<td>
						<xsl:apply-templates select="summ" mode="show_prices"/>
					</td>
					<td colspan="5"></td>
				</tr>
				</xsl:for-each>
				<tr class='request_row'>
					<th class='pjax string_type' colspan="6">Всего:
						<!--xsl:for-each select="/*/report/total/counts/*[name() = 'bolot']"-->
						<xsl:for-each select="/*/report/*[1]/total/counts/track/*">
						<xsl:if test="position() != 1">, </xsl:if>
							<xsl:value-of select="name" disable-output-escaping="yes"/>
							&nbsp;<xsl:value-of select="count" disable-output-escaping="yes"/>
						</xsl:for-each>
					</th>
					<th style='text-align: center'>
						<xsl:apply-templates select="/*/report/*[1]/total/contract/track" mode="show_prices"/>
					</th>
					<th style='text-align: center'>
						<xsl:apply-templates select="/*/report/*[1]/total/summ/track" mode="show_prices"/>
					</th>
					<td></td>
					<th style='text-align: center'>
						<xsl:apply-templates select="/*/report/*[1]/total/discount/track" mode="show_prices"/>
					</th>
					<td colspan="3"></td>
				</tr>
				<xsl:for-each select="/*/report/*[1]/total/paytypes/track/paytype">
				<tr class='request_row'>
					<td colspan="7" style="text-align: left">
						<xsl:choose>
						<xsl:when test = "name = ''">
							Не указано
						</xsl:when>
						<xsl:otherwise>
							<xsl:value-of select="name" disable-output-escaping="yes"/>
						</xsl:otherwise>
						</xsl:choose>
						<xsl:text>: </xsl:text>
					</td>
					<td>
						<xsl:apply-templates select="summ" mode="show_prices"/>
					</td>
					<td colspan="5"></td>
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
