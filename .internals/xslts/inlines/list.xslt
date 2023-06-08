<?xml version='1.0' encoding='cp1251' ?>
<!DOCTYPE xsl:stylesheet [
	<!ENTITY % HTMLlat1    PUBLIC "-//W3C//ENTITIES Latin 1 for XHTML//EN" "../../dtds/xhtml-lat1.ent"   > %HTMLlat1;
	<!ENTITY % HTMLspecial PUBLIC "-//W3C//ENTITIES Special for XHTML//EN" "../../dtds/xhtml-special.ent"> %HTMLspecial;
	<!ENTITY % HTMLsymbol  PUBLIC "-//W3C//ENTITIES Symbols for XHTML//EN" "../../dtds/xhtml-symbol.ent" > %HTMLsymbol;
]>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:php="http://php.net/xsl">



<xsl:template name="list_of_inlines">
	<xsl:param name="node" select="/.."/>
	<xsl:param name="hide_links" />
	<xsl:param name="parent"  />
	<xsl:param name="filters" />
	<xsl:param name="sorters" />
	<xsl:param name="pager" />
	<xsl:param name="group" select="''"/>

	<!-- Фильтров нет. -->

	<xsl:choose>
	<xsl:when test="$node/*">
		<xsl:if test="$pager">
			<xsl:call-template name="pager_block">
				<xsl:with-param name="filters" select="$filters"/>
				<xsl:with-param name="sorters" select="$sorters"/>
				<xsl:with-param name="pager"   select="$pager"  />
			</xsl:call-template>
		</xsl:if>

		<form class="list" method="post" action="{/*/system/info/adm_root}inlines/multi">
		<table class="listTable">
			<col width="1"/><col width="*"/>
			<xsl:if test="not($hide_links)">
			<col width="1"/>
			</xsl:if>
        
			<tr class="listRowHead">
				<th class="listCellHead listCellSplitL">
					<xsl:call-template name="list_head_with_sorters">
						<xsl:with-param name="filters" select="$filters"/>
						<xsl:with-param name="sorters" select="$sorters"/>
						<xsl:with-param name="name"    select="'label'"/>
						<xsl:with-param name="text">Метка</xsl:with-param>
					</xsl:call-template>
				</th>
				<th class="listCellHead listCellSplitR">
					<xsl:call-template name="list_head_with_sorters">
						<xsl:with-param name="filters" select="$filters"/>
						<xsl:with-param name="sorters" select="$sorters"/>
						<xsl:with-param name="name"    select="'comment'"/>
						<xsl:with-param name="text">Примечание</xsl:with-param>
					</xsl:call-template>
				</th>

				<xsl:if test="not($hide_links)">
				<th class="listCellHead listCellSplitL listCellSplitR" colspan="1">
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
       					<a href="{/*/system/info/adm_root}inlines/update/{id}">
						<xsl:value-of select="label" disable-output-escaping="no"/>
					</a>
					</nobr>
				</td>
				<td class="listCellData listCellSplitR">
						<xsl:value-of select="comment" disable-output-escaping="yes"/>
				</td>

			<xsl:if test="not($hide_links)">
				<td class="listCellLink listCellSplitL listCellSplitR">
					<a href="{/*/system/info/adm_root}inlines/update/{id}?back={/*/system/curr_url}">
					<img src="{/*/system/info/adm_root}img/buttons/update{$row}.gif" width="20" height="20" alt="изменить" /></a>
				</td>
			</xsl:if>
			</tr>
		</xsl:for-each>
		</table>
		</form>
	</xsl:when>
	<xsl:otherwise>
		<div class="list listEmpty">Сейчас нет ни одной текстовой вставки.</div>
	</xsl:otherwise>
	</xsl:choose>

</xsl:template>


<xsl:template name="list_of_inlines_full">
	<xsl:param name="node" select="/.."/>
	<xsl:param name="hide_links" />
	<xsl:param name="parent"  />
	<xsl:param name="filters" />
	<xsl:param name="sorters" />
	<xsl:param name="pager" />
	<xsl:param name="group" select="''"/>

	<!-- Фильтров нет. -->

	<xsl:if test="not($hide_links)">
		<div class="link">
			<div class="linkCommand">
				<a href="{/*/system/info/adm_root}inlines/edit/insert?group={$group}&amp;back={/*/system/curr_url}" >
					<img src="{/*/system/info/adm_root}img/buttons/insert0.gif" width="17" height="17" alt="добавить" />
					<span>Добавить текстовую вставку</span>
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

		<form class="list" method="post" action="{/*/system/info/adm_root}inlines/multi">
		<table class="listTable">
			<col width="1"/><col width="*"/>
			<xsl:if test="not($hide_links)">
			<col width="1"/>
			</xsl:if>
        
			<tr class="listRowHead">
				<th class="listCellHead listCellSplitL">
					<xsl:call-template name="list_head_with_sorters">
						<xsl:with-param name="filters" select="$filters"/>
						<xsl:with-param name="sorters" select="$sorters"/>
						<xsl:with-param name="name"    select="'label'"/>
						<xsl:with-param name="text">Метка</xsl:with-param>
					</xsl:call-template>
				</th>
				<th class="listCellHead listCellSplitR">
					<xsl:call-template name="list_head_with_sorters">
						<xsl:with-param name="filters" select="$filters"/>
						<xsl:with-param name="sorters" select="$sorters"/>
						<xsl:with-param name="name"    select="'comment'"/>
						<xsl:with-param name="text">Примечание</xsl:with-param>
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
       					<a href="{/*/system/info/adm_root}inlines/update/{id}">
						<xsl:value-of select="label" disable-output-escaping="no"/>
					</a>
					</nobr>
				</td>
				<td class="listCellData listCellSplitR">
						<xsl:value-of select="comment" disable-output-escaping="yes"/>
				</td>

			<xsl:if test="not($hide_links)">
				<td class="listCellLink listCellSplitL listCellSplitR">
					<a href="{/*/system/info/adm_root}inlines/edit/update/{id}?back={/*/system/curr_url}">
					<img src="{/*/system/info/adm_root}img/buttons/update{$row}.gif" width="20" height="20" alt="изменить" /></a>
				</td>
				<td class="listCellLink listCellSplitR">
					<a href="{/*/system/info/adm_root}inlines/edit/delete/{id}?back={/*/system/curr_url}">
					<img src="{/*/system/info/adm_root}img/buttons/delete{$row}.gif" width="20" height="20" alt="удалить" /></a>
				</td>
			</xsl:if>
			</tr>
		</xsl:for-each>
		</table>
		</form>
	</xsl:when>
	<xsl:otherwise>
		<div class="list listEmpty">Сейчас нет ни одной текстовой вставки.</div>
	</xsl:otherwise>
	</xsl:choose>

</xsl:template>

</xsl:stylesheet>
