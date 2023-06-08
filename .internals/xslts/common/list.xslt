<?xml version='1.0' encoding='cp1251' ?>
<!DOCTYPE xsl:stylesheet [
	<!ENTITY % HTMLlat1    PUBLIC "-//W3C//ENTITIES Latin 1 for XHTML//EN" "../../dtds/xhtml-lat1.ent"   > %HTMLlat1;
	<!ENTITY % HTMLspecial PUBLIC "-//W3C//ENTITIES Special for XHTML//EN" "../../dtds/xhtml-special.ent"> %HTMLspecial;
	<!ENTITY % HTMLsymbol  PUBLIC "-//W3C//ENTITIES Symbols for XHTML//EN" "../../dtds/xhtml-symbol.ent" > %HTMLsymbol;
]>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:php="http://php.net/xsl">



<xsl:template name="list_of_common_elements">
	<xsl:param name="node" select="/.."/>
	<xsl:param name="hide_links" />
	<xsl:param name="add_link" select="1"/>
	<xsl:param name="parent"  />
	<xsl:param name="filters" />
	<xsl:param name="sorters" />
	<xsl:param name="pager" />
	<xsl:param name="module" select="/*/module"/>
	<xsl:param name="essence" />

	<div class="list" id="listDiv">
	<xsl:if test="$filters/*">
		<xsl:call-template name="filters_block">
			<xsl:with-param name="filters" select="$filters"/>
			<xsl:with-param name="sorters" select="$sorters"/>
			<xsl:with-param name="rows">
			        <xsl:apply-templates select="$module/filter_fields/*" mode="admin_quick_filters"/>
			</xsl:with-param>
		</xsl:call-template>
	</xsl:if>

		<xsl:if test="not($hide_links) and $add_link">
		<div class="link">
			<div class="linkCommand">
				<a href="{/*/system/info/adm_root}{$adm_sub_root}{$essence}/insert?{$module/parent_field}={$parent}&amp;back={/*/system/curr_url}" >
					<img src="{/*/system/info/adm_root}img/buttons/insert0.gif" width="17" height="17" alt="добавить" />
					<span>Добавить</span>
				</a>
			</div>
		</div>
		</xsl:if>

	<xsl:choose>
	<xsl:when test="$node/*">
		<form enctype="multipart/form-data" method="post" action="{/*/system/info/adm_root}{$adm_sub_root}{$essence}/multi">
		<xsl:if test="$pager">
			<xsl:call-template name="pager_block">
				<xsl:with-param name="filters" select="$filters"/>
				<xsl:with-param name="sorters" select="$sorters"/>
				<xsl:with-param name="pager"   select="$pager"  />
			</xsl:call-template>
		</xsl:if>

		<table class="listTable" data-url="{concat(/*/system/info/adm_root, $adm_sub_root, $essence)}">
			<xsl:if test="$module/order_field = 'position'">
				<col width="1"/>
			</xsl:if>
			<xsl:for-each select="$module/fields/*[notitle != 1 and list = 1 and ($module/order_field != 'position' or name() != 'PositionField')]">
				<col width="*"/>
			</xsl:for-each>
			<xsl:if test="not($hide_links)">
				<col width="1"/>
				<col width="1"/><col width="1"/><col width="1"/><col width="1"/>
			</xsl:if>
        
			<tr class="listRowHead nodrop nodrag">
			<xsl:if test="$module/order_field = 'position'">
				<th class="listCellHead listCellSplitR">
					<xsl:call-template name="list_head_with_sorters">
						<xsl:with-param name="filters" select="$filters"/>
						<xsl:with-param name="sorters" select="$sorters"/>
						<xsl:with-param name="name"    select="$module/fields/PositionField/name"/>
						<xsl:with-param name="text">
							<xsl:value-of select="$module/fields/PositionField/title"/>
						</xsl:with-param>
					</xsl:call-template>
				</th>
			</xsl:if>
			<xsl:for-each select="$module/fields/*[notitle != 1 and list = 1 and ($module/order_field != 'position' or name() != 'PositionField')]">
				<th class="listCellHead listCellSplitR">
				<xsl:choose>
				<xsl:when test="/*/sorters/*[name() = current()/name]">
					<xsl:call-template name="list_head_with_sorters">
						<xsl:with-param name="filters" select="$filters"/>
						<xsl:with-param name="sorters" select="$sorters"/>
						<xsl:with-param name="name"    select="name"/>
						<xsl:with-param name="text">
							<xsl:value-of select="title"/>
						</xsl:with-param>
					</xsl:call-template>
				</xsl:when>
				<xsl:otherwise>
					<xsl:value-of select="title"/>
				</xsl:otherwise>
				</xsl:choose>
				</th>
			</xsl:for-each>

				<xsl:if test="not($hide_links)">
				<th class="listCellHead listCellSplitL listCellSplitR">
					<a href="#" onClick="select_all(); return false">Все</a>
				</th>
				<script>
				<![CDATA[
					
					function select_all()
					{
						var list = $('[id=ids]');
						window.items_select = (window.items_select) ? 0 : 1;
						for (i=0; i < list.length; i++)
						{
							list[i].checked = window.items_select;
						}
					}
				]]>
				</script>

				<th class="listCellHead listCellSplitL listCellSplitR" colspan="4">
					<xsl:attribute name="colspan">
						<xsl:choose>
						<xsl:when test="$module/order_field = 'position'">4</xsl:when>
						<xsl:otherwise>2</xsl:otherwise>
						</xsl:choose>
					</xsl:attribute>
				</th>
				</xsl:if>
			</tr>
		<xsl:for-each select="$node/*">
			<xsl:variable name="row" select="((position()) mod 2)+1"/>
			<tr id="row{id}">
				<xsl:attribute name="class">
					<xsl:text>listRowData </xsl:text>
					<xsl:if test="position()=1     ">listRowFirst </xsl:if>
					<xsl:if test="position()=last()">listRowLast  </xsl:if>
					<xsl:text>listRow</xsl:text><xsl:value-of select="$row"/>
				</xsl:attribute>

				<xsl:if test="$module/order_field = 'position'">
					<xsl:apply-templates select="$module/fields/PositionField" mode="admin_quick_list">
						<xsl:with-param name="row" select="."/>
					</xsl:apply-templates>
				</xsl:if>
				
				<xsl:apply-templates select="$module/fields/*[list = 1 and ($module/order_field != 'position' or name() != 'PositionField')]" mode="admin_quick_list">
					<xsl:with-param name="row" select="."/>
					<xsl:with-param name="pos" select="$row"/>
					<xsl:with-param name="essence" select="$essence"/>
				</xsl:apply-templates>

			<xsl:if test="not($hide_links)">
				<td class="listCellLink listCellSplitL listCellSplitR">
					<xsl:if test="not(finish) or finish != 1">
						<input type="checkbox" id="ids" name="items[]" value="{id}"/>
					</xsl:if>
				</td>

				<td class="listCellLink listCellSplitL">
					<a href="{/*/system/info/adm_root}{$adm_sub_root}{$essence}/update/{id}?back={/*/system/curr_url}">
					<img src="{/*/system/info/adm_root}img/buttons/update{$row}.gif" width="20" height="20" alt="изменить" /></a>
				</td>
				<td class="listCellLink">
					<xsl:if test="(not(finish) or finish != 1)">
					<a href="{/*/system/info/adm_root}{$adm_sub_root}{$essence}/delete/{id}?back={/*/system/curr_url}" class="delete_link">
					<img src="{/*/system/info/adm_root}img/buttons/delete{$row}.gif" width="20" height="20" alt="удалить" /></a>
					</xsl:if>
				</td>
				<xsl:if test="$module/order_field = 'position'">
				<td class="listCellLink">
					<xsl:choose>
					<xsl:when test="position!=1">
						<a class="a-moveup" href="{/*/system/info/adm_root}{$adm_sub_root}{$essence}/moveup/{id}?back={/*/system/curr_url}">
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
					<!--xsl:when test="position!=/*/pager/total"-->
					
	        				<a class="a-movedn" href="{/*/system/info/adm_root}{$adm_sub_root}{$essence}/movedn/{id}?back={/*/system/curr_url}">
						<img src="{/*/system/info/adm_root}img/buttons/movedn{$row}.gif" width="20" height="20" alt="вниз" /></a>
					</xsl:when>
					<xsl:otherwise>
						<img src="{/*/system/info/adm_root}img/buttons/movedn{$row}_.gif" width="20" height="20" alt="" />
					</xsl:otherwise>
					</xsl:choose>
				</td>
				</xsl:if>
			</xsl:if>
			</tr>
		</xsl:for-each>
		</table><br/><br/>
		<xsl:if test="$pager">
			<xsl:call-template name="pager_block">
				<xsl:with-param name="filters" select="$filters"/>
				<xsl:with-param name="sorters" select="$sorters"/>
				<xsl:with-param name="pager"   select="$pager"  />
			</xsl:call-template>
		</xsl:if>

		<xsl:if test="not($hide_links)">
		<table><tr class="listRow1">
			<td class="listEdit listCellSplitL">
				С выбранными:
			</td>
			<td class="listEdit listCellSplitL">
				<button class="inlineButton" type="submit" name="delete">
					<img src="{/*/system/info/adm_root}img/buttons/delete1.gif"  width="20" height="20" alt="удалить" />
				</button>
			</td>
		</tr></table>
		</xsl:if>
		</form>

	</xsl:when>
	<xsl:otherwise>
		<div class="list listEmpty">Сейчас нет ни одной записи.</div>
	</xsl:otherwise>
	</xsl:choose>
		<script type="text/javascript">
			var prefix = '<xsl:value-of select="$prefix"/>';

			<xsl:call-template name="admin_quick_list_edit"/>
		</script>

	<div id="listTableHide">
		<img src="{/*/system/info/adm_root}img/ajax-loader.gif" style="left:0; top: 0;"/>
	</div>
	</div>
</xsl:template>



<xsl:template name="list_of_common_elements_list">
	<xsl:param name="node" select="/.."/>
	<xsl:param name="hide_links" />
	<xsl:param name="parent"  />
	<xsl:param name="filters" />
	<xsl:param name="sorters" />
	<xsl:param name="pager" />
	<xsl:param name="essence" />
	<xsl:param name="module" select="/*/module"/>

		<xsl:if test="not($hide_links)">
		<div class="link">
			<div class="linkCommand">
				<a href="{/*/system/info/adm_root}{$adm_sub_root}{$essence}/insert?back={/*/system/curr_url}" >
					<img src="{/*/system/info/adm_root}img/buttons/insert0.gif" width="17" height="17" alt="добавить" />
					<span>Добавить</span>
				</a>
			</div>
		</div>
		</xsl:if>

	<xsl:choose>
	<xsl:when test="$node/*">
		<form enctype="multipart/form-data" method="post" action="{/*/system/info/adm_root}{$adm_sub_root}{$essence}/multi">
		<xsl:if test="$pager">
			<xsl:call-template name="pager_block">
				<xsl:with-param name="filters" select="$filters"/>
				<xsl:with-param name="sorters" select="$sorters"/>
				<xsl:with-param name="pager"   select="$pager"  />
			</xsl:call-template>
		</xsl:if>

		<table class="listTable" data-url="{concat(/*/system/info/adm_root, $adm_sub_root, $essence)}">
			<xsl:if test="$module/order_field = 'position'">
				<col width="1"/>
			</xsl:if>4
			<xsl:for-each select="$module/fields/*[notitle != 1 and list = 1 and ($module/order_field != 'position' or name() != 'PositionField')]">
				<col width="*"/>
			</xsl:for-each>
			<col width="1"/>
			<xsl:if test="not($hide_links)">
			<col width="1"/><col width="1"/><col width="1"/><col width="1"/>
			</xsl:if>
        
			<tr class="listRowHead nodrop nodrag">
			<xsl:if test="$module/order_field = 'position'">
				<th class="listCellHead listCellSplitR">
					<xsl:call-template name="list_head_with_sorters">
						<xsl:with-param name="filters" select="$filters"/>
						<xsl:with-param name="sorters" select="$sorters"/>
						<xsl:with-param name="name"    select="$module/fields/PositionField/name"/>
						<xsl:with-param name="text">
							<xsl:value-of select="$module/fields/PositionField/title"/>
						</xsl:with-param>
					</xsl:call-template>
				</th>
			</xsl:if>
			<xsl:for-each select="$module/fields/*[notitle != 1 and list = 1 and ($module/order_field != 'position' or name() != 'PositionField')]">
				<th class="listCellHead listCellSplitR">
				<nobr>
				<xsl:choose>
				<xsl:when test="/*/sorters/*[name() = current()/name]">
					<xsl:call-template name="list_head_with_sorters">
						<xsl:with-param name="filters" select="$filters"/>
						<xsl:with-param name="sorters" select="$sorters"/>
						<xsl:with-param name="name"    select="name"/>
						<xsl:with-param name="text">
							<xsl:value-of select="title"/>
						</xsl:with-param>
					</xsl:call-template>
				</xsl:when>
				<xsl:otherwise>
					<xsl:value-of select="title"/>
				</xsl:otherwise>
				</xsl:choose>
				</nobr>
				</th>
			</xsl:for-each>

				<th class="listCellHead listCellSplitL listCellSplitR">
					<a href="#" onClick="select_all(); return false">Все</a>
				</th>
				<script>
				<![CDATA[
					
					function select_all()
					{
						var list = $('[id=ids]');
						window.items_select = (window.items_select) ? 0 : 1;
						for (i=0; i < list.length; i++)
						{
							list[i].checked = window.items_select;
						}
					}
				]]>
				</script>

				<xsl:if test="not($hide_links)">
				<th class="listCellHead listCellSplitL listCellSplitR" colspan="4">
					<xsl:attribute name="colspan">
						<xsl:choose>
						<xsl:when test="$module/order_field = 'position'">4</xsl:when>
						<xsl:otherwise>2</xsl:otherwise>
						</xsl:choose>
					</xsl:attribute>
				</th>
				</xsl:if>
			</tr>
		<xsl:for-each select="$node/*">
			<xsl:variable name="row" select="((position()-1) mod 2)+1"/>
			<tr id="row{id}">
				<xsl:attribute name="class">
					<xsl:text>listRowData </xsl:text>
					<xsl:if test="position()=1     ">listRowFirst </xsl:if>
					<xsl:if test="position()=last()">listRowLast  </xsl:if>
					<xsl:text>listRow</xsl:text><xsl:value-of select="$row"/>
				</xsl:attribute>

				<xsl:if test="$module/order_field = 'position'">
					<xsl:apply-templates select="$module/fields/PositionField" mode="admin_quick_list">
						<xsl:with-param name="row" select="."/>
					</xsl:apply-templates>
				</xsl:if>
				<xsl:apply-templates select="$module/fields/*[list = 1 and ($module/order_field != 'position' or name() != 'PositionField')]" mode="admin_quick_list">
					<xsl:with-param name="row" select="."/>
					<xsl:with-param name="pos" select="$row"/>
				</xsl:apply-templates>

				<td class="listCellLink listCellSplitL listCellSplitR">
					<input type="checkbox" id="ids" name="items[]" value="{id}"/>
				</td>

			<xsl:if test="not($hide_links)">
				<td class="listCellLink listCellSplitL">
					<a href="{/*/system/info/adm_root}{$adm_sub_root}{$essence}/update/{id}?back={/*/system/curr_url}">
					<img src="{/*/system/info/adm_root}img/buttons/update{$row}.gif" width="20" height="20" alt="изменить" /></a>
				</td>
				<td class="listCellLink">
					<a href="{/*/system/info/adm_root}{$adm_sub_root}{$essence}/delete/{id}?back={/*/system/curr_url}" class="delete_link">
					<img src="{/*/system/info/adm_root}img/buttons/delete{$row}.gif" width="20" height="20" alt="удалить" /></a>
				</td>
				<xsl:if test="$module/order_field = 'position'">
				<td class="listCellLink">
					<xsl:choose>
					<xsl:when test="position!=1">
						<a class="a-moveup" href="{/*/system/info/adm_root}{$adm_sub_root}{$essence}/moveup/{id}?back={/*/system/curr_url}">
						<img src="{/*/system/info/adm_root}img/buttons/moveup{$row}.gif" width="20" height="20" alt="вверх" /></a>
					</xsl:when>
					<xsl:otherwise>
						<img src="{/*/system/info/adm_root}img/buttons/moveup{$row}_.gif" width="20" height="20" alt="" />
					</xsl:otherwise>
					</xsl:choose>
				</td>
				<td class="listCellLink listCellSplitR">
					<xsl:choose>
					<!--xsl:when test="position!=count($node/*)"-->
					<xsl:when test="position!=/*/pager/total">
					
	        				<a class="a-movedn" href="{/*/system/info/adm_root}{$adm_sub_root}{$essence}/movedn/{id}?back={/*/system/curr_url}">
						<img src="{/*/system/info/adm_root}img/buttons/movedn{$row}.gif" width="20" height="20" alt="вниз" /></a>
					</xsl:when>
					<xsl:otherwise>
						<img src="{/*/system/info/adm_root}img/buttons/movedn{$row}_.gif" width="20" height="20" alt="" />
					</xsl:otherwise>
					</xsl:choose>
				</td>
				</xsl:if>
			</xsl:if>
			</tr>
		</xsl:for-each>
		</table><br/><br/>
		<xsl:if test="$pager">
			<xsl:call-template name="pager_block">
				<xsl:with-param name="filters" select="$filters"/>
				<xsl:with-param name="sorters" select="$sorters"/>
				<xsl:with-param name="pager"   select="$pager"  />
			</xsl:call-template>
		</xsl:if>

		<table><tr class="listRow1">
			<td class="listEdit listCellSplitL">
				С выбранными:
			</td>
			<td class="listEdit listCellSplitL">
				<button class="inlineButton" type="submit" name="delete">
					<img src="{/*/system/info/adm_root}img/buttons/delete1.gif"  width="20" height="20" alt="удалить" />
				</button>
			</td>
		</tr></table>
		</form>

	</xsl:when>
	<xsl:otherwise>
		<div class="list listEmpty">Сейчас нет ни одной записи.</div>
	</xsl:otherwise>
	</xsl:choose>
</xsl:template>

</xsl:stylesheet>
