<?xml version="1.0" encoding="cp1251" ?>
<!DOCTYPE xsl:stylesheet [
	<!ENTITY % HTMLlat1    PUBLIC "-//W3C//ENTITIES Latin 1 for XHTML//EN" "../dtds/xhtml-lat1.ent"   > %HTMLlat1;
	<!ENTITY % HTMLspecial PUBLIC "-//W3C//ENTITIES Special for XHTML//EN" "../dtds/xhtml-special.ent"> %HTMLspecial;
	<!ENTITY % HTMLsymbol  PUBLIC "-//W3C//ENTITIES Symbols for XHTML//EN" "../dtds/xhtml-symbol.ent" > %HTMLsymbol;
]>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:php="http://php.net/xsl">
<xsl:include href="../xslts/public.xslt"/>
<xsl:include href="../xslts/index.xslt"/>
<xsl:include href="../xslts/_common_/quick_filters.xslt"/>

<xsl:include href="../xslts/_common_/calendars.xslt" />

<xsl:template match="/" mode="overrideable_title">
	Клиенты и оплата
</xsl:template>

<xsl:template match="/" mode="overrideable_keywords">
</xsl:template>

<xsl:template match="/" mode="overrideable_description">
</xsl:template>

<xsl:template match="/" mode="overrideable_headers">
	<style>
		.table-colored td { background-color: #fff!important; }
		.table-colored tr.red td, .table-colored tr.red th { background-color: #f97373!important; }
		.table-colored tr.pink td, .table-colored tr.pink th { background-color: #F4C7C3!important; }
		.table-colored tr.green td, .table-colored tr.green th { background-color: #48d66e!important; } /*#34A853*/
		.table-colored tr.light_green td, .table-colored tr.light_green th { background-color: #B7E1CD!important; }
		.table-colored tr.orange td, .table-colored tr.orange th { background-color: #FFA500!important; }
	</style>
	
</xsl:template>

<xsl:template match="/" mode="global_top_menu">payment</xsl:template> 
<xsl:template match="/" mode="global_left_menu">payment</xsl:template> 

<xsl:template match="request" mode="overrideable_list_link">
</xsl:template>

<xsl:template match="/" mode="overrideable_content">

	<!-- Фильтры -->
	<form action="{/*/system/info/pub_root}" method="get">
		<table>
			<tr>
				<td style="width: 480px; vertical-align:top">
					<!-- фильтры названий и статуса -->
					<table class="filters_in_req">
						<tr>
							<td>
								<div class="filter-row">
									<xsl:apply-templates select="/*/filters/*[name='client']" mode="quick_filters"/>
								</div>
							</td>
							<td>
								<div class="filter-row">
									<xsl:apply-templates select="/*/filters/*[name='boat_number']" mode="quick_filters"/>
								</div>
							</td>
						</tr>
						<tr>
							<td>
								<div class="filter-row">
									<xsl:apply-templates select="/*/filters/*[name='contract_number']" mode="quick_filters"/>
								</div>
							</td>
							<td>
								<div class="filter-row">
									<xsl:apply-templates select="/*/filters/*[name='branch']" mode="quick_filters"/>
								</div>
							</td>
						</tr>
						<tr>
							<td colspan="2">
								<div class="filter-row filter-date" style="margin-right:0px !important">
									<span class="filter-title">Дата заключения</span>
									<xsl:apply-templates select="/*/filters/*[name='from']" mode="quick_filters"/>
									<xsl:apply-templates select="/*/filters/*[name='to']" mode="quick_filters"/>
								</div>
							</td>
						</tr>
						<tr>
							<td>
								<div class="layout">
									<!-- больше не нужен, но пока сохраним для истории -->
									<!-- <input type="hidden" name="filter_RootCode" value="{/*/filters/*[name='RootCode']/value}"/> -->

									<input type="hidden" name="sorter">
										<xsl:attribute name="value">
											<xsl:call-template name="arg_val_for_sorters">
												<xsl:with-param name="sorters" select="/*/sorters"/>
											</xsl:call-template>
										</xsl:attribute>
									</input>
						
									<input 
										id="FilterBtn" 
										type="submit" 
										value="Применить" 
										class="btn btn-default clearfix" 
										style="width: 200px; margin-top:5px; margin-bottom: 15px; background-color:#DDDDDD"
									/>
								</div>
							</td>
						</tr>
					</table>
					<!-- конец фильтров названий и статуса -->
				</td>
			</tr>
		</table>
	</form>
	<!-- конец фильтров -->

	<div class="layout clearfix">
		<a href="{/*/system/info/pub_root}payment/edit/" class="btn btn-default clearfix edit-btns">Добавить</a>
	</div>
			
	<!-- Таблица списка кампаний -->		

	<xsl:apply-templates select="/*/pager">
		<xsl:with-param name="url" select="concat($LANGROOT, '')" />
		<xsl:with-param name="filters" select="/*/filters"/>
		<xsl:with-param name="sorters" select="/*/sorters"/>
	</xsl:apply-templates>
		
	Всего: <xsl:value-of select="/*/pager/total"/>
			
	<div id="list">
		<table class="table table-condensed table-striped table_text_center table-colored">
			<!-- Заголовки. параметр name здесь - это поле для сортировки, должно быть перечислено в sorters -->
			<thead>
				<tr>
					<xsl:call-template name="table_head">
						<xsl:with-param name="name" select="'phone'"/>
						<xsl:with-param name="text" select="'Номер телефона'"/>
						<xsl:with-param name="title" select="'Номер телефона'"/>
					</xsl:call-template>
					<xsl:call-template name="table_head">
						<xsl:with-param name="name" select="'client'"/>
						<xsl:with-param name="text" select="'Клиент'"/>
						<xsl:with-param name="title" select="'Клиент'"/>
					</xsl:call-template>
					<xsl:call-template name="table_head">
						<xsl:with-param name="name" select="'contract_number'"/>
						<xsl:with-param name="text" select="'Номер договора'"/>
						<xsl:with-param name="title" select="'Номер договора'"/>
					</xsl:call-template>
					<xsl:call-template name="table_head">
						<xsl:with-param name="name" select="'contract_date'"/>
						<xsl:with-param name="text" select="'Дата заключения договора'"/>
						<xsl:with-param name="title" select="'Дата заключения договора'"/>
					</xsl:call-template>
				<xsl:if test="/*/identity /consumer/roles/role = 'admin'">
					<xsl:call-template name="table_head">
						<xsl:with-param name="name" select="'branch'"/>
						<xsl:with-param name="text" select="'Филиал'"/>
						<xsl:with-param name="title" select="'Филиал'"/>
					</xsl:call-template>
				</xsl:if>
				<xsl:if test="/*/identity /consumer/roles/role != 'manager'">
					<xsl:call-template name="table_head">
						<xsl:with-param name="name" select="'manager'"/>
						<xsl:with-param name="text" select="'Менеджер'"/>
						<xsl:with-param name="title" select="'Менеджер'"/>
					</xsl:call-template>
				</xsl:if>
					<xsl:call-template name="table_head">
						<xsl:with-param name="name" select="'model'"/>
						<xsl:with-param name="text" select="'Модель катера'"/>
						<xsl:with-param name="title" select="'Модель катера'"/>
					</xsl:call-template>
					<xsl:call-template name="table_head">
						<xsl:with-param name="name" select="'type'"/>
						<xsl:with-param name="text" select="'Новый/БУ'"/>
						<xsl:with-param name="title" select="'Новый/БУ'"/>
					</xsl:call-template>
					<xsl:call-template name="table_head">
						<xsl:with-param name="name" select="'boat_number'"/>
						<xsl:with-param name="text" select="'Номер катера'"/>
						<xsl:with-param name="title" select="'Номер катера'"/>
					</xsl:call-template>
					<xsl:call-template name="table_head">
						<xsl:with-param name="name" select="'region'"/>
						<xsl:with-param name="text" select="'Регион'"/>
						<xsl:with-param name="title" select="'Регион'"/>
					</xsl:call-template>
				</tr>
			</thead>

			<!-- Тело списка -->
			<tbody>
			<xsl:for-each select="/*/list/payment">
				<xsl:variable name="row" select="((position()+ 1)  mod 2)+1"/>
				<tr class="request_row {color_status}" id="request_row_{ID}" data-file_id="{ID}">
					<td class=' string_type'>
						<xsl:if test="phone != ''">
							<!--a href="{/*/system/info/pub_root}payment/{id}/">+7 <xsl:value-of select="concat(substring(phone,1,3), ' ', substring(phone,4,3), ' ', substring(phone,7,2), ' ', substring(phone,9,2))" disable-output-escaping="yes"/></a-->
							<a href="{/*/system/info/pub_root}payment/{id}/">+7 <xsl:value-of select="phone" disable-output-escaping="yes"/></a>
						</xsl:if>
					</td>
					<td class=' string_type'><a href="{/*/system/info/pub_root}payment/{id}/"><xsl:value-of select="client" disable-output-escaping="yes"/></a></td>
					<td class=' string_type'><a href="{/*/system/info/pub_root}payment/{id}/"><xsl:value-of select="contract_number" disable-output-escaping="yes"/></a></td>
					<td class=' datetime_type'><xsl:apply-templates select="contract_date_parsed" mode="show_date_ru"/></td>
				<xsl:if test="/*/identity /consumer/roles/role = 'admin'">
					<td class=' string_type'><a href="{/*/system/info/pub_root}payment/{id}/"><xsl:value-of select="branch" disable-output-escaping="yes"/></a></td>
				</xsl:if>
				<xsl:if test="/*/identity /consumer/roles/role != 'manager'">
					<td class=' string_type'><a href="{/*/system/info/pub_root}payment/{id}/"><xsl:value-of select="manager" disable-output-escaping="yes"/></a></td>
				</xsl:if>
					<td class=' string_type'><a href="{/*/system/info/pub_root}payment/{id}/"><xsl:value-of select="model" disable-output-escaping="yes"/></a></td>
					<td class=' string_type'><a href="{/*/system/info/pub_root}payment/{id}/"><xsl:value-of select="type" disable-output-escaping="yes"/></a></td>
					<td class=' string_type'><a href="{/*/system/info/pub_root}payment/{id}/"><xsl:value-of select="boat_number" disable-output-escaping="yes"/></a></td>
					<td class=' string_type'><a href="{/*/system/info/pub_root}payment/{id}/"><xsl:value-of select="region" disable-output-escaping="yes"/></a></td>
					<td style="background-color: #fff!important">
						<a href="{/*/system/info/pub_root}payment/edit/{id}/" title="Редактировать" class="">
							<img src="{/*/system/info/pub_root}i/buttons/update2.gif"/>
						</a>
					</td>
					<td style="background-color: #fff!important">
						<a href="{/*/system/info/pub_root}payment/delete/{id}/" title="Удалить" onclick='return confirm_delete()' class="">
							<img src="{/*/system/info/pub_root}i/buttons/delete2.gif"/>
						</a>
					</td>
				</tr>
			</xsl:for-each>
			</tbody>
		</table>

	</div> <!-- id="list" -->

	<xsl:apply-templates select="/*/pager">
		<xsl:with-param name="url" select="concat($LANGROOT, '')" />
		<xsl:with-param name="filters" select="/*/filters"/>
		<xsl:with-param name="sorters" select="/*/sorters"/>
	</xsl:apply-templates>

	<!-- </form> -->
	<br/>
	<br/>
	<br/>
	<br/>
    
</xsl:template>

<xsl:template name="table_head">
	<xsl:param name="name"/>
	<xsl:param name="text"/>
	<xsl:param name="title"/>
	<xsl:param name="filters" select="/*/filters"/>
	<xsl:param name="sorters" select="/*/sorters"/>
	<xsl:param name="url" select="concat(/*/system/info/pub_root, '')"/>
	
	<th class="header pjax">
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
		<xsl:if test="$title!=''">
			<xsl:attribute name="title">
				<xsl:value-of select="$title" disable-output-escaping="yes"/>
			</xsl:attribute>
		</xsl:if>
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

<xsl:template name="sort_link">
	<xsl:param name="name"/>
	<xsl:param name="text"/>
	<xsl:param name="filters" select="/*/filters"/>
	<xsl:param name="sorters" select="/*/sorters"/>
	<xsl:param name="url" select="/*/system/info/pub_root"/>
	
	<a>
		<xsl:if test="$sorters/*[position() = 1 and name() = $name]">
			<xsl:attribute name="class">
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
		<xsl:attribute name="href">
			<xsl:call-template name="head_sorters_url">
				<xsl:with-param name="filters" select="$filters"/>
				<xsl:with-param name="sorters" select="$sorters"/>
				<xsl:with-param name="name" select="$name"/>
				<xsl:with-param name="url" select="$url"/>
			</xsl:call-template>
		</xsl:attribute>
	<xsl:value-of select="$text" disable-output-escaping="yes"/>
	</a>
</xsl:template>

</xsl:stylesheet>
