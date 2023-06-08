<?xml version='1.0' encoding='cp1251' ?>
<!DOCTYPE xsl:stylesheet [
	<!ENTITY % HTMLlat1    PUBLIC "-//W3C//ENTITIES Latin 1 for XHTML//EN" "../../dtds/xhtml-lat1.ent"   > %HTMLlat1;
	<!ENTITY % HTMLspecial PUBLIC "-//W3C//ENTITIES Special for XHTML//EN" "../../dtds/xhtml-special.ent"> %HTMLspecial;
	<!ENTITY % HTMLsymbol  PUBLIC "-//W3C//ENTITIES Symbols for XHTML//EN" "../../dtds/xhtml-symbol.ent" > %HTMLsymbol;
]>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:php="http://php.net/xsl">



<xsl:template name="list_of_news">
	<xsl:param name="node" select="/.."/>
	<xsl:param name="hide_links" />
	<xsl:param name="parent"  />
	<xsl:param name="filters" />
	<xsl:param name="sorters" />
	<xsl:param name="pager" />
	<xsl:param name="category" />

	<!--xsl:if test="$filters">
		<xsl:call-template name="filters_block">
			<xsl:with-param name="filters" select="$filters"/>
			<xsl:with-param name="sorters" select="$sorters"/>
			<xsl:with-param name="rows">
				<tr class="formRowCriteria">
					<th class="formCellHead"><nobr>Домен</nobr></th>
					<td class="formCellCtrl"><select class="controlSelect" name="filter_domain">
						<option value="" >Все</option>
						<xsl:for-each select="/*/enums/domains/lang">
						<option value="{id}"><xsl:if test="$filters/domain=id"><xsl:attribute name="selected"/></xsl:if><xsl:value-of select="code" /></option>
						</xsl:for-each>
					</select></td>
				</tr>
				<input type="hidden" name="group" value="{/*/news_group}"/>
			</xsl:with-param>
		</xsl:call-template>
	</xsl:if-->

	<xsl:if test="not($hide_links)">
		<div class="link">
			<div class="linkCommand">
				<a href="{/*/system/info/adm_root}news/insert?group={/*/news_group}&amp;back={/*/system/curr_url}" >
					<img src="{/*/system/info/adm_root}img/buttons/insert0.gif" width="17" height="17" alt="добавить" />
					<span>Добавить новость</span>
				</a>
			</div>
		</div>
	</xsl:if>

	<xsl:choose>
	<xsl:when test="$node/*">
		<xsl:if test="$pager">
			<xsl:call-template name="pager_block">
				<xsl:with-param name="filters" select="$filters"/>
				<xsl:with-param name="sorters" select="$sorters"/>
				<xsl:with-param name="pager"   select="$pager"  />
			</xsl:call-template>
		</xsl:if>

		<form class="list" method="post" action="{/*/system/info/adm_root}news/multi">
		<table class="listTable">
			<col width="1"/><col width="*"/>
			<xsl:if test="not($hide_links)">
			<col width="1"/><col width="1"/>
			</xsl:if>
        
			<tr class="listRowHead">
				<th class="listCellHead listCellSplitL">
					<xsl:call-template name="list_head_with_sorters">
						<xsl:with-param name="filters" select="$filters"/>
						<xsl:with-param name="sorters" select="$sorters"/>
						<xsl:with-param name="name"    select="'ts'"/>
						<xsl:with-param name="text">Дата</xsl:with-param>
					</xsl:call-template>
				</th>
				<th class="listCellHead listCellSplitR">
					<xsl:call-template name="list_head_with_sorters">
						<xsl:with-param name="filters" select="$filters"/>
						<xsl:with-param name="sorters" select="$sorters"/>
						<xsl:with-param name="name"    select="'title'"/>
						<xsl:with-param name="text">Название</xsl:with-param>
					</xsl:call-template>
				</th>

				<xsl:if test="not($hide_links)">
				<th class="listCellHead listCellSplitL listCellSplitR" colspan="2">
				</th>
				</xsl:if>
			</tr>
			<tr class="listRowNull"></tr>
		<xsl:for-each select="$node/*">
			<tr>
				<xsl:variable name="row" select="((position()-1) mod 2)+1"/>
				<xsl:attribute name="class">
					<xsl:text>listRowData </xsl:text>
					<xsl:if test="position()=1     ">listRowFirst </xsl:if>
					<xsl:if test="position()=last()">listRowLast  </xsl:if>
					<xsl:text>listRow</xsl:text><xsl:value-of select="$row"/>
				</xsl:attribute>

				<td class="listCellData listCellSplitL">
					<nobr>
						<xsl:call-template name="datetime_numeric_ru">
							<xsl:with-param name="raw"   select="ts" />
							<xsl:with-param name="year"  select="ts_parsed/year" />
							<xsl:with-param name="month" select="ts_parsed/month"/>
							<xsl:with-param name="day"   select="ts_parsed/day"  />
						</xsl:call-template>
					</nobr>
				</td>
				<td class="listCellData listCellSplitR">
       					<a href="{/*/system/info/adm_root}news/update/{id}?back={/*/system/curr_url}">
						<xsl:value-of select="title" disable-output-escaping="yes"/>
					</a>
				</td>

			<xsl:if test="not($hide_links)">
				<td class="listCellLink listCellSplitL">
					<a href="{/*/system/info/adm_root}news/update/{id}?back={/*/system/curr_url}">
					<img src="{/*/system/info/adm_root}img/buttons/update{$row}.gif" width="20" height="20" alt="изменить" /></a>
				</td>
				<td class="listCellLink listCellSplitR">
					<a href="{/*/system/info/adm_root}news/delete/{id}?back={/*/system/curr_url}">
					<img src="{/*/system/info/adm_root}img/buttons/delete{$row}.gif" width="20" height="20" alt="удалить" /></a>
				</td>
			</xsl:if>
			</tr>
		</xsl:for-each>
		</table>
		</form>
	</xsl:when>
	<xsl:otherwise>
		<div class="list listEmpty">Сейчас нет ни одной новости.</div>
	</xsl:otherwise>
	</xsl:choose>

</xsl:template>



</xsl:stylesheet>
