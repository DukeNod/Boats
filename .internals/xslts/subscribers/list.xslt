<?xml version='1.0' encoding='cp1251' ?>
<!DOCTYPE xsl:stylesheet [
	<!ENTITY % HTMLlat1    PUBLIC "-//W3C//ENTITIES Latin 1 for XHTML//EN" "../../dtds/xhtml-lat1.ent"   > %HTMLlat1;
	<!ENTITY % HTMLspecial PUBLIC "-//W3C//ENTITIES Special for XHTML//EN" "../../dtds/xhtml-special.ent"> %HTMLspecial;
	<!ENTITY % HTMLsymbol  PUBLIC "-//W3C//ENTITIES Symbols for XHTML//EN" "../../dtds/xhtml-symbol.ent" > %HTMLsymbol;
]>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:php="http://php.net/xsl">



<xsl:template name="list_of_subscribers">
	<xsl:param name="node" select="/.."/>
	<xsl:param name="hide_links" />
	<xsl:param name="parent"  />
	<xsl:param name="filters" />
	<xsl:param name="sorters" />
	<xsl:param name="pager" />

	<xsl:if test="$filters">
		<xsl:call-template name="filters_block">
			<xsl:with-param name="filters" select="$filters"/>
			<xsl:with-param name="sorters" select="$sorters"/>
			<xsl:with-param name="rows">
				<tr class="formRowCriteria">
					<th class="formCellHead"><nobr>E-mail содержит</nobr></th>
					<td class="formCellCtrl"><input type="text" class="controlString" style="width: auto;" name="filter_email" value="{$filters/email}"/></td>
				</tr>
				<tr class="formRowCriteria">
					<th class="formCellHead"><nobr>Состояние подписки</nobr></th>
					<td class="formCellCtrl"><select class="controlSelect" name="filter_is_active[]">
						<option value="" >Не учитывать</option>
						<option value="0"><xsl:if test="number($filters/is_active)=0"><xsl:attribute name="selected"/></xsl:if>Не подтверждена или приостановлена</option>
						<option value="1"><xsl:if test="number($filters/is_active)=1"><xsl:attribute name="selected"/></xsl:if>Подтверждена и активна</option>
					</select></td>
				</tr>
				<tr class="formRowCriteria">
					<th class="formCellHead"><nobr>Статус тестера</nobr></th>
					<td class="formCellCtrl"><select class="controlSelect" name="filter_is_tester[]">
						<option value="" >Не учитывать</option>
						<option value="0"><xsl:if test="number($filters/is_tester)=0"><xsl:attribute name="selected"/></xsl:if>Только обычные подписчики</option>
						<option value="1"><xsl:if test="number($filters/is_tester)=1"><xsl:attribute name="selected"/></xsl:if>Только подписчики-тестеры</option>
					</select></td>
				</tr>
				<tr class="formRowCriteria">
					<th class="formCellHead"><nobr>Группа</nobr></th>
					<td class="formCellCtrl"><select class="controlSelect" name="filter_group">
						<option value="" >Все</option>
						<xsl:for-each select="/*/enum/subscriber_groups/group">
						<option value="{id}"><xsl:if test="number($filters/group)=id"><xsl:attribute name="selected"/></xsl:if><xsl:value-of select="name" /></option>
						</xsl:for-each>
						<option value="0"><xsl:if test="number($filters/group)=0"><xsl:attribute name="selected"/></xsl:if>Прочие</option>
					</select></td>
				</tr>
			</xsl:with-param>
		</xsl:call-template>
	</xsl:if>

	<xsl:if test="not($hide_links)">
		<div class="link">
			<div class="linkCommand">
				<a href="{/*/system/info/adm_root}subscribers/import?back={/*/system/curr_url}" >
					<img src="{/*/system/info/adm_root}img/buttons/insert0.gif" width="17" height="17" alt="импорт" />
					<span>Импорт подписчиков</span>
				</a>
			</div>
		</div>
		<div class="link">
			<div class="linkCommand">
				<a href="{/*/system/info/adm_root}subscribers/export?back={/*/system/curr_url}" >
					<img src="{/*/system/info/adm_root}img/buttons/insert0.gif" width="17" height="17" alt="экспорт" />
					<span>Экспорт в файл</span>
				</a>
			</div>
		</div>
		<div class="link">
			<div class="linkCommand">
				<a href="{/*/system/info/adm_root}subscribers/insert?back={/*/system/curr_url}" >
					<img src="{/*/system/info/adm_root}img/buttons/insert0.gif" width="17" height="17" alt="добавить" />
					<span>Добавить подписчика</span>
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

		<form class="list" method="get" action="{/*/system/info/adm_root}subscribers/massop">
		<table class="listTable">
			<col width="1"/><col width="1"/><col width="1"/>
			<xsl:if test="not($hide_links)">
			<col width="1"/><col width="1"/>
			</xsl:if>
        
			<tr class="listRowHead">
				<th class="listCellHead listCellSplitL">
					<xsl:call-template name="list_head_with_sorters">
						<xsl:with-param name="filters" select="$filters"/>
						<xsl:with-param name="sorters" select="$sorters"/>
						<xsl:with-param name="name"    select="'email'"/>
						<xsl:with-param name="text">E-mail</xsl:with-param>
					</xsl:call-template>
				</th>
				<th class="listCellHead">
					<xsl:call-template name="list_head_with_sorters">
						<xsl:with-param name="filters" select="$filters"/>
						<xsl:with-param name="sorters" select="$sorters"/>
						<xsl:with-param name="name"    select="'is_active'"/>
						<xsl:with-param name="text">Активность</xsl:with-param>
					</xsl:call-template>
				</th>
				<th class="listCellHead listCellSplitR">
					<xsl:call-template name="list_head_with_sorters">
						<xsl:with-param name="filters" select="$filters"/>
						<xsl:with-param name="sorters" select="$sorters"/>
						<xsl:with-param name="name"    select="'is_tester'"/>
						<xsl:with-param name="text">Тестер</xsl:with-param>
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
					<a href="{/*/system/info/adm_root}subscribers/view/{id}">
						<xsl:value-of select="email" disable-output-escaping="no"/>
					</a>
					</nobr>
				</td>
				<td class="listCellData listCellCommand">
					<xsl:choose>
					<xsl:when test="$hide_links">
						<xsl:choose>
						<xsl:when test="number(is_active)&gt;0">
							<img src="{/*/system/info/adm_root}img/buttons/turnof{$row}.gif" width="20" height="20" alt="выключено"/>
						</xsl:when>
						<xsl:otherwise>
							<img src="{/*/system/info/adm_root}img/buttons/turnon{$row}.gif"  width="20" height="20" alt="выключено"/>
						</xsl:otherwise>
						</xsl:choose>
					</xsl:when>
					<xsl:otherwise>
						<xsl:choose>
						<xsl:when test="number(is_active)&gt;0">
							<a href="{/*/system/info/adm_root}subscribers/switch/{id}/is_active/0?back={/*/system/curr_url}">
							<img src="{/*/system/info/adm_root}img/buttons/turnof{$row}.gif" width="20" height="20" alt="выключить"/></a>
						</xsl:when>
						<xsl:otherwise>
							<a href="{/*/system/info/adm_root}subscribers/switch/{id}/is_active/1?back={/*/system/curr_url}">
							<img src="{/*/system/info/adm_root}img/buttons/turnon{$row}.gif"  width="20" height="20" alt="включить"/></a>
						</xsl:otherwise>
						</xsl:choose>
					</xsl:otherwise>
					</xsl:choose>
				</td>
				<td class="listCellData listCellCommand listCellSplitR">
					<xsl:choose>
					<xsl:when test="$hide_links">
						<xsl:choose>
						<xsl:when test="number(is_tester)&gt;0">
							<img src="{/*/system/info/adm_root}img/buttons/turnof{$row}.gif" width="20" height="20" alt="выключено"/>
						</xsl:when>
						<xsl:otherwise>
							<img src="{/*/system/info/adm_root}img/buttons/turnon{$row}.gif" width="20" height="20" alt="выключено"/>
						</xsl:otherwise>
						</xsl:choose>
					</xsl:when>
					<xsl:otherwise>
						<xsl:choose>
						<xsl:when test="number(is_tester)&gt;0">
							<a href="{/*/system/info/adm_root}subscribers/switch/{id}/is_tester/0?back={/*/system/curr_url}">
							<img src="{/*/system/info/adm_root}img/buttons/turnof{$row}.gif" width="20" height="20" alt="выключить"/></a>
						</xsl:when>
						<xsl:otherwise>
							<a href="{/*/system/info/adm_root}subscribers/switch/{id}/is_tester/1?back={/*/system/curr_url}">
							<img src="{/*/system/info/adm_root}img/buttons/turnon{$row}.gif" width="20" height="20" alt="включить"/></a>
						</xsl:otherwise>
						</xsl:choose>
					</xsl:otherwise>
					</xsl:choose>
				</td>
        
			<xsl:if test="not($hide_links)">
				<td class="listCellData listCellCommand listCellSplitL">
					<a href="{/*/system/info/adm_root}subscribers/update/{id}?back={/*/system/curr_url}">
					<img src="{/*/system/info/adm_root}img/buttons/update{$row}.gif" width="20" height="20" alt="изменить" /></a>
				</td>
				<td class="listCellData listCellCommand listCellSplitR">
					<a href="{/*/system/info/adm_root}subscribers/delete/{id}?back={/*/system/curr_url}">
					<img src="{/*/system/info/adm_root}img/buttons/delete{$row}.gif" width="20" height="20" alt="удалить" /></a>
				</td>
			</xsl:if>
			</tr>
		</xsl:for-each>
		</table>
		</form>
	</xsl:when>
	<xsl:otherwise>
		<div class="list listEmpty">Сейчас нет ни одного подписчика.</div>
	</xsl:otherwise>
	</xsl:choose>

</xsl:template>



</xsl:stylesheet>
