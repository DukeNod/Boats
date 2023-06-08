<?xml version="1.0" encoding="cp1251" ?>
<!DOCTYPE xsl:stylesheet [
	<!ENTITY % HTMLlat1    PUBLIC "-//W3C//ENTITIES Latin 1 for XHTML//EN" "../../dtds/xhtml-lat1.ent"   > %HTMLlat1;
	<!ENTITY % HTMLspecial PUBLIC "-//W3C//ENTITIES Special for XHTML//EN" "../../dtds/xhtml-special.ent"> %HTMLspecial;
	<!ENTITY % HTMLsymbol  PUBLIC "-//W3C//ENTITIES Symbols for XHTML//EN" "../../dtds/xhtml-symbol.ent" > %HTMLsymbol;
]>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:php="http://php.net/xsl">
<xsl:include href="../../xslts/public.xslt"/>
<xsl:include href="../../xslts/_common_/quick_filters.xslt"/>

<xsl:include href="../../xslts/_common_/calendars.xslt" />

<xsl:template match="/" mode="overrideable_title">
	Лог действий пользователей
</xsl:template>

<xsl:template match="/" mode="overrideable_keywords">
</xsl:template>

<xsl:template match="/" mode="overrideable_description">
</xsl:template>

<xsl:template match="/" mode="overrideable_headers">
</xsl:template>

<xsl:template match="/" mode="global_top_menu">hotels</xsl:template> 
<xsl:template match="/" mode="global_left_menu">hotels</xsl:template> 

<xsl:template match="/" mode="overrideable_head">
	Лог действий пользователей
</xsl:template>

<xsl:template match="/" mode="overrideable_measurer">
	<xsl:call-template name="measurer_divider"/>
	<span class="active">Лог действий пользователей</span>
</xsl:template>

<xsl:template match="/" mode="overrideable_content">

	<!--ul class="nav nav-tabs">
		  <li title="" rel="" class="icon index_collection_link">
			<xsl:if test="/*/filters/*[name='eds_valid']/value = 'expired' or /*/filters/*[name='eds_valid']/value = ''">
				<xsl:attribute name="class">active</xsl:attribute>
			</xsl:if>
			<a class="" href="{/*/system/info/pub_root}hotels/eds_valid/?filter_eds_valid=expired">
			  <i class="icon-th-list"></i>
			  <span>Срок ЭЦП истек</span>
			</a>
		  </li>
		  
		  <li title="" rel="" class="icon index_collection_link">
			<xsl:if test="/*/filters/*[name='eds_valid']/value = '30days'">
				<xsl:attribute name="class">active</xsl:attribute>
			</xsl:if>
			<a class="" href="{/*/system/info/pub_root}hotels/eds_valid/?filter_eds_valid=30days">
			  <i class=""></i>
			  <span>До истечения ЭЦП осталось &lt; 30 дней</span>
			</a>
		</li>
	</ul-->

	<!--xsl:call-template name="hotels_menu">
		<xsl:with-param name="curr_page" select="concat('eds_valid', '_', /*/filters/*[name='eds_valid']/value)"/>
	</xsl:call-template-->

	<form action="{/*/system/info/pub_root}user_log/" method="get">

	<table class="hotels_filters">
	<tr>
		<td colspan="2">
				<div class="filter-row">
					<xsl:apply-templates select="/*/filters/*[name='user']" mode="quick_filters"/>
				</div>
		</td>
	</tr>
	<tr>
		<td>
				<div class="filter-row">
					<xsl:apply-templates select="/*/filters/*[name='id']" mode="quick_filters"/>
				</div>
		</td>
		<!--td>
				<div class="filter-row">
					<xsl:apply-templates select="/*/filters/*[name='type']" mode="quick_filters"/>
				</div>
		</td-->
	</tr>
	<tr>
		<td colspan="2">
				<div class="filter-row filter-date">
					<span class="filter-title">Время</span>
					<xsl:apply-templates select="/*/filters/*[name='from']" mode="quick_filters"/>
					<xsl:apply-templates select="/*/filters/*[name='to']" mode="quick_filters"/>
				</div>
		</td>
	</tr>
	<tr>
		<td>
			<div class="layout">
				<input id="FilterBtn" type="submit" value="Применить" class="btn btn-default clearfix" style="width: 200px; margin-bottom: 20px"/>
			</div>
		</td>
		<td>
			<!--div class="layout">
				<button id="ExportBtn" type="submit" name="export" value="1" class="btn btn-default" style="width: 200px; display: inline-block; margin-left: 20px">Сохранить в Excel</button>
			</div-->
		</td>
	</tr>
	</table>

		<!-- этот кусок нужен, чтобы выставление значения фильтра не сбрасывало установленную сортировку -->
		<input type="hidden" name="sorter">
			<xsl:attribute name="value">
				<xsl:call-template name="arg_val_for_sorters">
					<xsl:with-param name="sorters" select="/*/sorters"/>
				</xsl:call-template>
			</xsl:attribute>
		</input>
		<!--input type="hidden" name="filter_eds_valid" value="{/*/filters/*[name='eds_valid']/value}"/-->

		<xsl:apply-templates select="/*/pager">
			<xsl:with-param name="url" select="concat($LANGROOT, 'user_log/')" />
			<xsl:with-param name="filters" select="/*/filters"/>
			<xsl:with-param name="sorters" select="/*/sorters"/>
		</xsl:apply-templates>
		
		Всего: <xsl:value-of select="/*/pager/total"/>
			
		<div id='list'>

			<table class='table table-condensed table-striped hotels-table'>
			<thead>
				<tr>
					<th class='pjax'>Время</th>
					<th class='pjax'>Метод</th>
					<th class='pjax'>Тип</th>
					<th class='pjax'>URL</th>
					<th class='pjax'>ID</th>
					<th class='pjax'>Пользователь</th>
				</tr>
			</thead>
			<tbody>
			<xsl:for-each select="/*/list/user_log">
				<tr class='request_row'>
					<td class=' string_type'><xsl:apply-templates select="date_parsed" mode="show_datetime_ru"/></td>
					<td class=' string_type'><xsl:value-of select="method" disable-output-escaping="yes"/></td>
					<td class=' string_type'><xsl:value-of select="type" disable-output-escaping="yes"/></td>
					<td class=' string_type'><xsl:value-of select="url" disable-output-escaping="yes"/></td>
					<td class=' string_type'><xsl:value-of select="id" disable-output-escaping="yes"/></td>
					<td class=' string_type'><xsl:value-of select="user" disable-output-escaping="yes"/></td>
				</tr>
			</xsl:for-each>
			</tbody>
			</table>

		</div>

		<xsl:apply-templates select="/*/pager">
			<xsl:with-param name="url" select="concat($LANGROOT, 'user_log/')" />
			<xsl:with-param name="filters" select="/*/filters"/>
			<xsl:with-param name="sorters" select="/*/sorters"/>
		</xsl:apply-templates>
	</form>
	<br/>
	<br/>
	<br/>
	<br/>

</xsl:template>

<xsl:template name="table_head">
	<xsl:param name="name"/>
	<xsl:param name="text"/>
	<xsl:param name="filters" select="/*/filters"/>
	<xsl:param name="sorters" select="/*/sorters"/>
	<xsl:param name="url" select="concat(/*/system/info/pub_root, 'user_log/')"/>
	
	<th class='header pjax'>
		<xsl:if test="$sorters/*[position() = 1 and name() = $name]">
			<xsl:attribute name="class">
				<xsl:text>header pjax </xsl:text>
				<xsl:choose>
					<xsl:when test="$sorters/*[position() = 1 and name() = $name] = '-'">
						<xsl:text>headerSortUp</xsl:text>
					</xsl:when>
					<xsl:otherwise>
						<xsl:text>headerSortDown</xsl:text>
					</xsl:otherwise>
				</xsl:choose>
			</xsl:attribute>
		</xsl:if>

		<!-- Атрибут data-sorter необходим для корректной работы сортера -->
		<!-- Если он отсутствует - клики по стрелочке справа заголовка столбца приводят к ошибке -->
		<xsl:attribute name="data-sorter">
			<xsl:call-template name="head_sorters_url">
					<xsl:with-param name="filters" select="$filters"/>
					<xsl:with-param name="sorters" select="$sorters"/>
					<xsl:with-param name="name" select="$name"/>
					<xsl:with-param name="url" select="$url"/>
			</xsl:call-template>
		</xsl:attribute>

		<xsl:attribute name="href">
			<xsl:call-template name="head_sorters_url">
				<xsl:with-param name="filters" select="$filters"/>
				<xsl:with-param name="sorters" select="$sorters"/>
				<xsl:with-param name="name" select="$name"/>
				<xsl:with-param name="url" select="$url"/>
			</xsl:call-template>
		</xsl:attribute>
	<xsl:value-of select="$text" disable-output-escaping="yes"/>
	</th>
</xsl:template>

</xsl:stylesheet>
