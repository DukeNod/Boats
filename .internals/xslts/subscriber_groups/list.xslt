<?xml version='1.0' encoding='cp1251' ?>
<!DOCTYPE xsl:stylesheet [
	<!ENTITY % HTMLlat1    PUBLIC "-//W3C//ENTITIES Latin 1 for XHTML//EN" "../../dtds/xhtml-lat1.ent"   > %HTMLlat1;
	<!ENTITY % HTMLspecial PUBLIC "-//W3C//ENTITIES Special for XHTML//EN" "../../dtds/xhtml-special.ent"> %HTMLspecial;
	<!ENTITY % HTMLsymbol  PUBLIC "-//W3C//ENTITIES Symbols for XHTML//EN" "../../dtds/xhtml-symbol.ent" > %HTMLsymbol;
]>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:php="http://php.net/xsl">



<xsl:template name="list_of_subscriber_groups">
	<xsl:param name="node" select="/.."/>
	<xsl:param name="hide_links" />
	<xsl:param name="domain"  />
	<xsl:param name="filters" />
	<xsl:param name="sorters" />
	<xsl:param name="pager" />
	<xsl:param name="essence" />

	<xsl:if test="not($hide_links)">
		<div class="link">
			<div class="linkCommand">
				<a href="{/*/system/info/adm_root}{$essence}/insert?back={/*/system/curr_url}" >
					<img src="{/*/system/info/adm_root}img/buttons/insert0.gif" width="16" height="16" alt="добавить" />
					<span>Добавить группу</span>
				</a>
			</div>
		</div>
	</xsl:if>

	<xsl:choose>
	<xsl:when test="$node/*">
		<table class="listTable">
			<col width="1"/><col width="1"/><col width="*"/>
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
				<th class="listCellHead listCellSplitR">
					<xsl:call-template name="list_head_with_sorters">
						<xsl:with-param name="filters" select="$filters"/>
						<xsl:with-param name="sorters" select="$sorters"/>
						<xsl:with-param name="name"    select="'name'"/>
						<xsl:with-param name="text">Название</xsl:with-param>
					</xsl:call-template>
				</th>
        
				<xsl:if test="not($hide_links)">
				<th class="listCellHead listCellSplitL listCellSplitR" colspan="4">
				</th>
				</xsl:if>
			</tr>
		<xsl:for-each select="$node/*">
			<xsl:variable name="row" select="((position()-1) mod 2)+1"/>
			<tr>
				<xsl:attribute name="class">
					<xsl:text>listRowData </xsl:text>
					<xsl:if test="position()=1     ">listRowFirst </xsl:if>
					<xsl:if test="position()=last()">listRowLast  </xsl:if>
					<xsl:text>listRow</xsl:text><xsl:value-of select="$row"/>
				</xsl:attribute>

				<td class="listCellData listCellSplitL">
					<nobr>
						<xsl:value-of select="position" disable-output-escaping="no"/>
					</nobr>
				</td>
				<td class="listCellData listCellSplitR">
					<a href="{/*/system/info/adm_root}{$essence}/update/{id}?back={/*/system/curr_url}">
					<nobr>
						<xsl:value-of select="name" disable-output-escaping="yes"/>
					</nobr>
					</a>
				</td>

			<xsl:if test="not($hide_links)">
				<td class="listCellLink listCellSplitL">
					<a href="{/*/system/info/adm_root}{$essence}/update/{id}?back={/*/system/curr_url}">
					<img src="{/*/system/info/adm_root}img/buttons/update{$row}.gif" width="20" height="20" alt="изменить" /></a>
				</td>
				<td class="listCellLink">
					<a href="{/*/system/info/adm_root}{$essence}/delete/{id}?back={/*/system/curr_url}">
					<img src="{/*/system/info/adm_root}img/buttons/delete{$row}.gif" width="20" height="20" alt="удалить" /></a>
				</td>
				<td class="listCellLink">
					<xsl:choose>
					<xsl:when test="position!=1">
						<a href="{/*/system/info/adm_root}{$essence}/moveup/{id}?back={/*/system/curr_url}">
						<img src="{/*/system/info/adm_root}img/buttons/moveup{$row}.gif" width="20" height="20" alt="вверх" /></a>
					</xsl:when>
					<xsl:otherwise>
						<img src="{/*/system/info/adm_root}img/buttons/moveup{$row}_.gif" width="20" height="20" alt="" />
					</xsl:otherwise>
					</xsl:choose>
				</td>
				<td class="listCellLink listCellSplitR">
					<xsl:choose>
					<xsl:when test="position!=count($node/*)">
	        				<a href="{/*/system/info/adm_root}{$essence}/movedn/{id}?back={/*/system/curr_url}">
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
	</xsl:when>
	<xsl:otherwise>
		<div class="list listEmpty">Сейчас нет ни одного класса.</div>
	</xsl:otherwise>
	</xsl:choose>
	<br />

</xsl:template>



</xsl:stylesheet>
