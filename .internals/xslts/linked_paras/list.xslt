<?xml version='1.0' encoding='cp1251' ?>
<!DOCTYPE xsl:stylesheet [
	<!ENTITY % HTMLlat1    PUBLIC "-//W3C//ENTITIES Latin 1 for XHTML//EN" "../../dtds/xhtml-lat1.ent"   > %HTMLlat1;
	<!ENTITY % HTMLspecial PUBLIC "-//W3C//ENTITIES Special for XHTML//EN" "../../dtds/xhtml-special.ent"> %HTMLspecial;
	<!ENTITY % HTMLsymbol  PUBLIC "-//W3C//ENTITIES Symbols for XHTML//EN" "../../dtds/xhtml-symbol.ent" > %HTMLsymbol;
]>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:php="http://php.net/xsl">



<xsl:template name="list_of_linked_paras">
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
				<a href="{/*/system/info/adm_root}linked_paras/insert/for/{$uplink_type}/{$uplink_id}?back={/*/system/curr_url}&amp;lang={/*/language}" >
					<img src="{/*/system/info/adm_root}img/buttons/insert0.gif" width="17" height="17" alt="добавить" />
					<span>Добавить параграф</span>
				</a>
			</div>
		</div>
	</xsl:if>

	<xsl:choose>
	<xsl:when test="$node/*">
		<form class="list" method="post" action="{/*/system/info/adm_root}linked_paras/multi">
		<table class="listBlock">

		<xsl:for-each select="$node/*">
			<xsl:variable name="row" select="2"/>

		<xsl:if test="position()!=1">
			<tr class="listRowSpace"><td class="listCellSpace"></td></tr>
		</xsl:if>

		<xsl:if test="not($hide_links)">
			<tr class="listRowLinks">
				<td class="listCellPosition"><xsl:value-of select="position"/>.</td>
				<td class="listCellLinks">
				<nobr>
					<a href="{/*/system/info/adm_root}linked_paras/update/{id}?back={/*/system/curr_url}&amp;lang={/*/language}">
					<img src="{/*/system/info/adm_root}img/buttons/update{$row}.gif" width="20" height="20" alt="изменить" /></a>

					<a href="{/*/system/info/adm_root}linked_paras/delete/{id}?back={/*/system/curr_url}&amp;lang={/*/language}">
					<img src="{/*/system/info/adm_root}img/buttons/delete{$row}.gif" width="20" height="20" alt="удалить" /></a>

					<xsl:choose>
					<xsl:when test="position&gt;1">
						<a href="{/*/system/info/adm_root}linked_paras/moveup/{id}?back={/*/system/curr_url}&amp;lang={/*/language}">
						<img src="{/*/system/info/adm_root}img/buttons/moveup{$row}.gif" width="20" height="20" alt="вверх" /></a>
					</xsl:when>
					<xsl:otherwise>
						<img src="{/*/system/info/adm_root}img/buttons/moveup{$row}_.gif" width="20" height="20" alt="" />
					</xsl:otherwise>
					</xsl:choose>

					<xsl:choose>
					<xsl:when test="position&lt;count($node/*)">
	        				<a href="{/*/system/info/adm_root}linked_paras/movedn/{id}?back={/*/system/curr_url}&amp;lang={/*/language}">
						<img src="{/*/system/info/adm_root}img/buttons/movedn{$row}.gif" width="20" height="20" alt="вниз" /></a>
					</xsl:when>
					<xsl:otherwise>
						<img src="{/*/system/info/adm_root}img/buttons/movedn{$row}_.gif" width="20" height="20" alt="" />
					</xsl:otherwise>
					</xsl:choose>
	                        </nobr>
				</td>
			</tr>
		</xsl:if>
			<tr class="listRowViews">
				<td class="listCellEmpty"></td>
				<td class="listCellView">
					<xsl:apply-templates select="." mode="linked_para">
						<xsl:with-param name="dir" select="concat(/*/system/info/pub_root, 'linked/paras/')"/>
					</xsl:apply-templates>
				</td>
			</tr>
		</xsl:for-each>
		</table>
		</form>
	</xsl:when>
	<xsl:otherwise>
		<div class="list listEmpty">Сейчас нет ни одного параграфа.</div>
	</xsl:otherwise>
	</xsl:choose>

<!--!!!???
	<xsl:if test="not($hide_links)">
		<tr class="listParasRowSpace"><td class="listParasCellSpace"></td></tr>

		<tr class="listParasRowLinks">
			<td class="listParasCellLinks">
				<nobr>Новый параграф</nobr>
			</td>
		</tr>

		<tr class="listParasRowForm">
			<td class="listParasCellForm">
				<xsl:call-template name="form_for_linked_para">
					<xsl:with-param name="back" select="/*/system/curr_raw"/>
					<xsl:with-param name="action" select="concat(/*/system/info/adm_root, 'linked_paras/insert/for/', $uplink_type, '/', $uplink_id)"/>
					<xsl:with-param name="button" select="'Добавить'"/>
					<xsl:with-param name="prefix" select="$form_prefix"/>
				</xsl:call-template>
			</td>
		</tr>
	</xsl:if>
-->
</xsl:template>



</xsl:stylesheet>
