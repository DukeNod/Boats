<?xml version='1.0' encoding='cp1251' ?>
<!DOCTYPE xsl:stylesheet [
	<!ENTITY % HTMLlat1    PUBLIC "-//W3C//ENTITIES Latin 1 for XHTML//EN" "../../dtds/xhtml-lat1.ent"   > %HTMLlat1;
	<!ENTITY % HTMLspecial PUBLIC "-//W3C//ENTITIES Special for XHTML//EN" "../../dtds/xhtml-special.ent"> %HTMLspecial;
	<!ENTITY % HTMLsymbol  PUBLIC "-//W3C//ENTITIES Symbols for XHTML//EN" "../../dtds/xhtml-symbol.ent" > %HTMLsymbol;
]>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:php="http://php.net/xsl">



<xsl:template name="list_of_linked_video">
	<xsl:param name="node" select="/.."/>
	<xsl:param name="filters"/>
	<xsl:param name="sorters"/>
	<xsl:param name="pager"  />
	<xsl:param name="hide_links" />
	<xsl:param name="form_prefix"/>
	<xsl:param name="uplink_type"/>
	<xsl:param name="uplink_id"  />

	<xsl:if test="not($hide_links)">
		<div class="link">
			<div class="linkCommand">
				<a href="{/*/system/info/adm_root}linked_video/insert/for/{$uplink_type}/{$uplink_id}?back={/*/system/curr_url}" >
					<img src="{/*/system/info/adm_root}img/buttons/insert0.gif" width="17" height="17" alt="добавить" />
					<span>Добавить видео</span>
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

		<form class="list" method="post" action="{/*/system/info/adm_root}linked_video/multi">
		<table class="listTable">
			<col width="1"/><col width="*"/><col width="1"/><col width="*"/><col width="1"/>
			<xsl:if test="not($hide_links)">
			<col width="1"/><col width="1"/><col width="1"/><col width="1"/>
			</xsl:if>
	        
			<tr class="listRowHead">

				<th class="listCellHead listCellSplitL">
					<xsl:call-template name="list_head_with_sorters">
						<xsl:with-param name="filters" select="$filters"/>
						<xsl:with-param name="sorters" select="$sorters"/>
						<xsl:with-param name="name"    select="'position'"/>
						<xsl:with-param name="text">№</xsl:with-param>
					</xsl:call-template>
				</th>
				<th class="listCellHead">
					<xsl:call-template name="list_head_with_sorters">
						<xsl:with-param name="filters" select="$filters"/>
						<xsl:with-param name="sorters" select="$sorters"/>
						<xsl:with-param name="name"    select="'name'"/>
						<xsl:with-param name="text">Название</xsl:with-param>
					</xsl:call-template>
				</th>
				<th class="listCellHead">
					<xsl:call-template name="list_head_with_sorters">
						<xsl:with-param name="filters" select="$filters"/>
						<xsl:with-param name="sorters" select="$sorters"/>
						<xsl:with-param name="name"    select="'time'"/>
						<xsl:with-param name="text">Длительность</xsl:with-param>
					</xsl:call-template>
				</th>
				<th class="listCellHead listCellSplitR">
					<xsl:text>Превью</xsl:text>
				</th>

				<xsl:if test="not($hide_links)">
				<th class="listCellHead listCellSplitL listCellSplitR" colspan="4">
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
					<xsl:value-of select="position" disable-output-escaping="no"/>
				</td>
				<td class="listCellData">
					<xsl:value-of select="name" disable-output-escaping="yes"/>
				</td>
				<td class="listCellData">
					<xsl:value-of select="time" disable-output-escaping="yes"/>
				</td>
				<td class="listCellLink listCellMergeR">
					<img src="{preview}" width="{preview_w}" height="{preview_h}" />
				</td>

			<xsl:if test="not($hide_links)">
				<td class="listCellLink listCellSplitL">
					<a href="{/*/system/info/adm_root}linked_video/update/{id}?back={/*/system/curr_url}">
					<img src="{/*/system/info/adm_root}img/buttons/update{$row}.gif" width="20" height="20" alt="изменить" /></a>
				</td>
				<td class="listCellLink">
					<a href="{/*/system/info/adm_root}linked_video/delete/{id}?back={/*/system/curr_url}">
					<img src="{/*/system/info/adm_root}img/buttons/delete{$row}.gif" width="20" height="20" alt="удалить" /></a>
				</td>
				<td class="listCellLink">
					<xsl:choose>
					<xsl:when test="position&gt;1">
						<a href="{/*/system/info/adm_root}linked_video/moveup/{id}?back={/*/system/curr_url}">
						<img src="{/*/system/info/adm_root}img/buttons/moveup{$row}.gif" width="20" height="20" alt="вверх" /></a>
					</xsl:when>
					<xsl:otherwise>
						<img src="{/*/system/info/adm_root}img/buttons/moveup{$row}_.gif" width="20" height="20" alt="" />
					</xsl:otherwise>
					</xsl:choose>
				</td>
				<td class="listCellLink listCellSplitR">
					<xsl:choose>
					<xsl:when test="position&lt;count($node/*)">
	        				<a href="{/*/system/info/adm_root}linked_video/movedn/{id}?back={/*/system/curr_url}">
						<img src="{/*/system/info/adm_root}img/buttons/movedn{$row}.gif" width="20" height="20" alt="вниз" /></a>
					</xsl:when>
					<xsl:otherwise>
						<img src="{/*/system/info/adm_root}img/buttons/movedn{$row}_.gif" width="20" height="20" alt="" />
					</xsl:otherwise>
					</xsl:choose>
				</td>
			</xsl:if>
			</tr>
		</xsl:for-each>
		</table>
		</form>
	</xsl:when>
	<xsl:otherwise>
		<div class="list listEmpty">Сейчас нет ни одного прикреплённого видео.</div>
	</xsl:otherwise>
	</xsl:choose>

</xsl:template>



</xsl:stylesheet>
