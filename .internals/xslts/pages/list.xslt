<?xml version='1.0' encoding='cp1251' ?>
<!DOCTYPE xsl:stylesheet [
	<!ENTITY % HTMLlat1    PUBLIC "-//W3C//ENTITIES Latin 1 for XHTML//EN" "../../dtds/xhtml-lat1.ent"   > %HTMLlat1;
	<!ENTITY % HTMLspecial PUBLIC "-//W3C//ENTITIES Special for XHTML//EN" "../../dtds/xhtml-special.ent"> %HTMLspecial;
	<!ENTITY % HTMLsymbol  PUBLIC "-//W3C//ENTITIES Symbols for XHTML//EN" "../../dtds/xhtml-symbol.ent" > %HTMLsymbol;
]>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:php="http://php.net/xsl">



<xsl:template name="list_of_pages">
	<xsl:param name="node" select="/.."/>
	<xsl:param name="hide_links" />
	<xsl:param name="parent"  />
	<xsl:param name="filters" />
	<xsl:param name="sorters" />
	<xsl:param name="pager" />

	<xsl:if test="not($hide_links)">
		<div class="link">
			<div class="linkCommand">
			<xsl:choose>
			<xsl:when test="$parent!=''">
				<a href="{/*/system/info/adm_root}{$essence}/insert?parent={$parent}&amp;back={/*/system/curr_url}" >
					<img src="{/*/system/info/adm_root}img/buttons/insert0.gif" width="16" height="16" alt="добавить" />
					<span>Добавить вложенную страницу к этой странице</span>
				</a>
			</xsl:when>
			<xsl:otherwise>
				<a href="{/*/system/info/adm_root}{$essence}/insert?back={/*/system/curr_url}" >
					<img src="{/*/system/info/adm_root}img/buttons/insert0.gif" width="16" height="16" alt="добавить" />
					<span>Добавить страницу</span>
				</a>
			</xsl:otherwise>
			</xsl:choose>
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
				<th class="listCellHead">
					<xsl:call-template name="list_head_with_sorters">
						<xsl:with-param name="filters" select="$filters"/>
						<xsl:with-param name="sorters" select="$sorters"/>
						<xsl:with-param name="name"    select="'mr'"/>
						<xsl:with-param name="text">mod_rewrite</xsl:with-param>
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
				<th class="listCellHead">
					<xsl:call-template name="list_head_with_sorters">
						<xsl:with-param name="filters" select="$filters"/>
						<xsl:with-param name="sorters" select="$sorters"/>
						<xsl:with-param name="name"    select="'public'"/>
						<xsl:with-param name="text">Опубликован</xsl:with-param>
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
				<td class="listCellData">
					<a href="{/*/system/info/adm_root}{$essence}/update/{id}">
					<nobr>
						<xsl:value-of select="mr" disable-output-escaping="no"/>
					</nobr>
					</a>
				</td>
				<td class="listCellData listCellSplitR">
					<a href="{/*/system/info/adm_root}{$essence}/update/{id}">
					<nobr>
						<xsl:value-of select="name" disable-output-escaping="yes"/>
					</nobr>
					</a>
				</td>
				<td class="listCellData listCellSplitR" align="center" id="hidden_public{id}">
				<xsl:variable name="turn_off"><xsl:choose>
					<xsl:when test="public=1">0</xsl:when>
					<xsl:otherwise>1</xsl:otherwise>
				</xsl:choose></xsl:variable>
					<a href="javascript: void(0);" onClick="toggleHidden({id}, {$turn_off}, {$row}, 'public')">
						<xsl:choose>
							<xsl:when test="public=1">
							<img src="{/*/system/info/adm_root}img/buttons/turnof{$row}.gif" title="Да" />
							</xsl:when>
							<xsl:otherwise>
							<img src="{/*/system/info/adm_root}img/buttons/turnon{$row}.gif" title="Нет" />
							</xsl:otherwise>
						</xsl:choose>
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
		<script type="text/javascript">
		<![CDATA[
		var prefix = '_';

		function toggleHidden(id, state, row, field)
		{

			if (id != '')
			ajax({
				url		: ADM_ROOT+'pages/ajax/toggle?toggle='+id+'&hidden='+state+'&field='+field,
				parse_response	: true,
				on_success	: function(params, response_object) {
					var rowName  = "#hidden_" + field + id;
					var rowState = ((response_object.field == 1)? "of" : "on") + row;
					var rowTitle = (response_object.field == 1)? "Да": "Нет";
					var rowImage  = ADM_ROOT+"img/buttons/turn"+ rowState +".gif";
					$( rowName ).empty();
					$( rowName ).append( '<a href="javascript: void(0);" id="hidden_' + field + id +'" onClick="toggleHidden('+ id +', '+(0+!response_object.field)+', '+ row +', \'' + field + '\')"><img src="'+ rowImage +'" title="'+ rowTitle +'" border="0" /></a>' );
				},
				on_exception	: ajax_elemental_on_exception,
				on_httperror	: ajax_elemental_on_httperror,
				on_timeout	: ajax_elemental_on_timeout,
				on_state	: ajax_elemental_on_state,
				on_start	: ajax_elemental_on_start,
				on_timer	: ajax_elemental_on_timer,
//				on_debug	: ajax_debug,
				interval	: 500,
				timeout		: 10000
//				elemental_id    : prefix+'filter_status',//for ajax_elemental
//				object		: { category: val }
			});
			return false;
		}
		]]>
		</script>
	</xsl:when>
	<xsl:otherwise>
		<div class="list listEmpty">Сейчас нет ни одной статьи.</div>
	</xsl:otherwise>
	</xsl:choose>

</xsl:template>



</xsl:stylesheet>
