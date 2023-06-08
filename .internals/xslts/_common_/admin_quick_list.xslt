<?xml version='1.0' encoding='cp1251' ?>
<!DOCTYPE xsl:stylesheet [
	<!ENTITY % HTMLlat1    PUBLIC "-//W3C//ENTITIES Latin 1 for XHTML//EN" "../../dtds/xhtml-lat1.ent"   > %HTMLlat1;
	<!ENTITY % HTMLspecial PUBLIC "-//W3C//ENTITIES Special for XHTML//EN" "../../dtds/xhtml-special.ent"> %HTMLspecial;
	<!ENTITY % HTMLsymbol  PUBLIC "-//W3C//ENTITIES Symbols for XHTML//EN" "../../dtds/xhtml-symbol.ent" > %HTMLsymbol;
]>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:php="http://php.net/xsl">


<xsl:template priority="-1" match="*" mode="admin_quick_list">
</xsl:template>

<xsl:template match="TextField" mode="admin_quick_list">
	<xsl:param name="row" select="''"/>
	<xsl:param name="essence" select="''"/>
				<td class="listCellData listCellSplitR" data-value="{$row/*[name() = current()/name]}" data-name="{name}" style="padding-right: 15px">
					<xsl:if test="edit = 1">
						<xsl:attribute name="class">listCellData listCellSplitR typeTextField</xsl:attribute>
					</xsl:if>
					<a href="{/*/system/info/adm_root}{$adm_sub_root}{$essence}/update/{$row/id}?back={/*/system/curr_url}">
						<xsl:value-of select="$row/*[name() = current()/name]" disable-output-escaping="yes"/>
					</a>
				</td>
</xsl:template>

<xsl:template match="TextArea" mode="admin_quick_list">
	<xsl:param name="row" select="''"/>
	<xsl:param name="essence" select="''"/>
				<td class="listCellData listCellSplitR" data-value="{$row/*[name() = current()/name]}" data-name="{name}" style="padding-right: 15px">
					<xsl:if test="edit = 1">
						<xsl:attribute name="class">listCellData listCellSplitR typeTextField</xsl:attribute>
					</xsl:if>
					<a href="{/*/system/info/adm_root}{$adm_sub_root}{$essence}/update/{$row/id}?back={/*/system/curr_url}">
						<xsl:value-of select="$row/*[name() = current()/name]" disable-output-escaping="yes"/>
					</a>
				</td>
</xsl:template>

<xsl:template match="TextField1" mode="admin_quick_list">
	<xsl:param name="row" select="''"/>
	<xsl:param name="essence" select="''"/>
				<td class="listCellData listCellSplitR" data-value="{$row/*[name() = current()/name]}" data-name="{name}" style="padding-right: 15px">
					<xsl:if test="edit = 1">
						<xsl:attribute name="class">listCellData listCellSplitR typeTextField</xsl:attribute>
					</xsl:if>
					<a href="{/*/system/info/adm_root}{$adm_sub_root}{$essence}/update/{$row/id}?back={/*/system/curr_url}">
						<xsl:value-of select="$row/*[name() = current()/name]" disable-output-escaping="yes"/>
					</a>
				</td>
</xsl:template>

<xsl:template match="Email" mode="admin_quick_list">
	<xsl:param name="row" select="''"/>
	<xsl:param name="essence" select="''"/>
				<td class="listCellData listCellSplitR typeTextField" data-value="{$row/*[name() = current()/name]}" data-name="{name}" style="padding-right: 5px">
					<nobr>
					<a href="{/*/system/info/adm_root}{$adm_sub_root}{$essence}/update/{$row/id}?back={/*/system/curr_url}">
						<xsl:value-of select="$row/*[name() = current()/name]" disable-output-escaping="yes"/>
					</a>
					</nobr>
				</td>
</xsl:template>

<xsl:template match="PriceField" mode="admin_quick_list">
	<xsl:param name="row" select="''"/>
	<xsl:param name="essence" select="''"/>
				<td class="listCellData listCellSplitR typeTextField" data-value="{$row/*[name() = current()/name]}" data-name="{name}" style="padding-right: 5px">
			                <xsl:if test="$row/*[name() = current()/name] != ''">
						<xsl:value-of select="format-number($row/*[name() = current()/name], '# ###,##', 'pricef')" disable-output-escaping="yes"/> руб.
			                </xsl:if>
				</td>
</xsl:template>

<xsl:template match="DateField" mode="admin_quick_list">
	<xsl:param name="row" select="''"/>
				<td class="listCellData listCellSplitR" data-value="{$row/*[name() = current()/name]}" data-name="{name}" style="padding-right: 5px">
					<xsl:if test="edit = 1">
						<xsl:attribute name="class">listCellData listCellSplitR typeDataField</xsl:attribute>
					</xsl:if>
					<nobr>
						<xsl:variable name="parsed" select="concat(current()/name, '_parsed')"/>
						<xsl:call-template name="datetime_numeric_ru">
							<!--xsl:with-param name="raw"   select="$row/*[name() = current()/name]" /-->
							<xsl:with-param name="year"  select="$row/*[name() = $parsed]/year" />
							<xsl:with-param name="month" select="$row/*[name() = $parsed]/month"/>
							<xsl:with-param name="day"   select="$row/*[name() = $parsed]/day"  />
						</xsl:call-template>
					</nobr>
				</td>
</xsl:template>

<xsl:template match="PositionField" mode="admin_quick_list">
	<xsl:param name="essence" select="''"/>
	<xsl:param name="row" select="''"/>
				<td id="td{$row/id}" class="listCellData listCellSplitR dragHandle">
						<xsl:value-of select="$row/*[name() = current()/name]" disable-output-escaping="no"/>
				</td>
</xsl:template>

<xsl:template match="SelectList" mode="admin_quick_list">
	<xsl:param name="row" select="''"/>
	<xsl:param name="essence" select="''"/>
				<td class="listCellData listCellSplitL typeSelectList" data-value="{$row/*[name() = current()/name]}" data-name="{name}">
					<a href="{/*/system/info/adm_root}{$adm_sub_root}{$essence}/update/{$row/id}?back={/*/system/curr_url}">
						<!--xsl:value-of select="/*/enums[@for=$essence]/*[name() = current()/linked_module]/*[id = $row/*[name() = current()/name]]/name" disable-output-escaping="yes"/-->
						<xsl:value-of select="enums/*[id = $row/*[name() = current()/name]]/name" disable-output-escaping="yes"/>
					</a>
				</td>
</xsl:template>

<xsl:template match="TarifField" mode="admin_quick_list">
	<xsl:param name="row" select="''"/>
				<td class="listCellData listCellSplitL typeSelectList" data-value="{$row/*[name() = current()/name]}" data-name="{name}">
						<xsl:value-of select="/*/enums[@for=$essence]/*[name() = current()/linked_module]/*[id = $row/*[name() = current()/name]]/name" disable-output-escaping="yes"/>
				</td>
</xsl:template>

<xsl:template match="Select" mode="admin_quick_list">
	<xsl:param name="row" select="''"/>
	<xsl:param name="essence" select="''"/>
				<td class="listCellData listCellSplitL typeSelect" data-value="{$row/*[name() = current()/name]}" data-name="{name}">
					<nobr>
					<a href="{/*/system/info/adm_root}{$adm_sub_root}{$essence}/update/{$row/id}?back={/*/system/curr_url}">
						<xsl:value-of select="values_list/value[id = $row/*[name() = current()/name]]/value" disable-output-escaping="yes"/>
					</a>
					</nobr>
				</td>
</xsl:template>

<xsl:template match="SelectText" mode="admin_quick_list">
	<xsl:param name="row" select="''"/>
				<td class="listCellData listCellSplitL typeSelectText" data-value="{$row/*[name() = current()/name]}" data-name="{name}">
					<nobr>
						<xsl:value-of select="$row/*[name() = current()/name]" disable-output-escaping="yes"/>
					</nobr>
				</td>
</xsl:template>

<xsl:template match="SqlSelected" mode="admin_quick_list">
	<xsl:param name="row" select="''"/>
				<td class="listCellData listCellSplitR">
				<nobr>
					<xsl:value-of select="format-number($row/*[name() = current()/name], '# ###,##', 'pricef')" disable-output-escaping="yes"/>
				</nobr>
				</td>
</xsl:template>

<xsl:template match="TotalPrice" mode="admin_quick_list">
	<xsl:param name="row" select="''"/>
				<td class="listCellData listCellSplitR">
				<nobr>
					<xsl:variable name="value" select="$row/*[name() = current()/name]"/>
					<xsl:if test="$value &gt; 0"><xsl:value-of select="format-number($value, '# ###,##', 'pricef')" /> руб.</xsl:if>
				</nobr>
				</td>
</xsl:template>

<xsl:template match="PayPrice" mode="admin_quick_list">
	<xsl:param name="row" select="''"/>
				<td class="listCellData listCellSplitR">
				<nobr>
					<xsl:variable name="value" select="$row/*[name() = current()/name]"/>
					<xsl:if test="$value &gt; 0"><xsl:value-of select="format-number($value, '# ###,##', 'pricef')" /> руб.</xsl:if>
				</nobr>
				</td>
</xsl:template>

<xsl:template match="CardField" mode="admin_quick_list">
	<xsl:param name="row" select="''"/>
				<td class="listCellData listCellSplitR">
				<nobr>
					<xsl:value-of select="$row/user_info/card" /> <!-- $row/*[name() = current()/name] -->
				</nobr>
				</td>
</xsl:template>

<xsl:template match="SqlSelectedFish" mode="admin_quick_list">
	<xsl:param name="row" select="''"/>
				<td class="listCellData listCellSplitR">
				<!--nobr>
					<xsl:value-of select="format-number($row/*[name() = current()/name], '# ###,##', 'pricef')"/>
				</nobr-->
					<xsl:for-each select="$row/fish_types/fish_type">
						<nobr>
						<xsl:if test="count != 0">
							<xsl:value-of select="name" disable-output-escaping="yes"/>:
							<xsl:value-of select="format-number(count, '# ###,##', 'pricef')" />
							<br/>
						</xsl:if>
						</nobr>
					</xsl:for-each>
				</td>
</xsl:template>

<xsl:template match="SqlSelectedPonds" mode="admin_quick_list">
	<xsl:param name="row" select="''"/>
				<td class="listCellData listCellSplitR">
					<xsl:for-each select="$row/ponds/pond">
						<nobr>
						<xsl:if test="count != 0">
							<xsl:value-of select="name" disable-output-escaping="yes"/>:
							<xsl:value-of select="format-number(count, '# ###,##', 'pricef')" />
							<br/>
						</xsl:if>
						</nobr>
					</xsl:for-each>
				</td>
</xsl:template>

<xsl:template match="TotalWeight" mode="admin_quick_list">
	<xsl:param name="row" select="''"/>
				<td class="listCellData listCellSplitR">
					<xsl:value-of select="format-number($row/*[name() = current()/name], '# ###,##', 'pricef')"/>
				</td>
</xsl:template>

<xsl:template match="CheckBox" mode="admin_quick_list">
	<xsl:param name="row" select="''"/>
	<xsl:param name="pos" select="''"/>
                                <xsl:variable name="value" select="$row/*[name() = current()/name]"/>
				<xsl:variable name="turn_off"><xsl:choose>
					<xsl:when test="$value=1">0</xsl:when>
					<xsl:otherwise>1</xsl:otherwise>
				</xsl:choose></xsl:variable>
				<td class="listCellData listCellSplitR typeCheckBox" align="center"> <!-- id="hidden_public{id}" -->
					<xsl:choose>
					<xsl:when test="listedit = 1">
					<a href="#" data-value="{$turn_off}" data-name="{name}">
						<xsl:choose>
							<xsl:when test="$value=1">
							<img src="{/*/system/info/adm_root}img/buttons/turnof{$pos}.gif" title="Да" />
							</xsl:when>
							<xsl:otherwise>
							<img src="{/*/system/info/adm_root}img/buttons/turnon{$pos}.gif" title="Нет" />
							</xsl:otherwise>
						</xsl:choose>
					</a>
					</xsl:when>
					<xsl:otherwise>
						<xsl:choose>
							<xsl:when test="$value=1">
							<img src="{/*/system/info/adm_root}img/buttons/turnof{$pos}.gif" title="Да" />
							</xsl:when>
							<xsl:otherwise>
							<img src="{/*/system/info/adm_root}img/buttons/turnon{$pos}.gif" title="Нет" />
							</xsl:otherwise>
						</xsl:choose>
					</xsl:otherwise>
					</xsl:choose>
				</td>
</xsl:template>

<xsl:template match="CheckBox1" mode="admin_quick_list">
	<xsl:param name="row" select="''"/>
	<xsl:param name="pos" select="''"/>
                                <xsl:variable name="value" select="$row/*[name() = current()/name]"/>
				<xsl:variable name="turn_off"><xsl:choose>
					<xsl:when test="$value=1">0</xsl:when>
					<xsl:otherwise>1</xsl:otherwise>
				</xsl:choose></xsl:variable>
				<td class="listCellData listCellSplitR typeCheckBox" align="center"> <!-- id="hidden_public{id}" -->
					<xsl:choose>
					<xsl:when test="listedit = 1">
					<a href="#" data-value="{$turn_off}" data-name="{name}">
						<xsl:choose>
							<xsl:when test="$value=1">
							<img src="{/*/system/info/adm_root}img/buttons/turnof{$pos}.gif" title="Да" />
							</xsl:when>
							<xsl:otherwise>
							<img src="{/*/system/info/adm_root}img/buttons/turnon{$pos}.gif" title="Нет" />
							</xsl:otherwise>
						</xsl:choose>
					</a>
					</xsl:when>
					<xsl:otherwise>
						<xsl:choose>
							<xsl:when test="$value=1">
							<img src="{/*/system/info/adm_root}img/buttons/turnof{$pos}.gif" title="Да" />
							</xsl:when>
							<xsl:otherwise>
							<img src="{/*/system/info/adm_root}img/buttons/turnon{$pos}.gif" title="Нет" />
							</xsl:otherwise>
						</xsl:choose>
					</xsl:otherwise>
					</xsl:choose>
				</td>
</xsl:template>

<xsl:template name="admin_quick_list_edit">

	var lists = {};

	<xsl:apply-templates select="/*/module/fields/SelectList" mode="admin_quick_list_options"/>
	<xsl:apply-templates select="/*/module/fields/Select" mode="admin_quick_list_options"/>
	<xsl:apply-templates select="/*/module/fields/SelectText" mode="admin_quick_list_options"/>

</xsl:template>

<xsl:template match="SelectList" mode="admin_quick_list_options">
	<xsl:variable name="enums" select="/*/enums[@for=$essence]/*[name() = current()/linked_module]" />

lists.<xsl:value-of select="name"/> = [
{id: '', name: '<xsl:value-of select="empty"/>'}
<xsl:for-each select="$enums/*">
,{id: '<xsl:value-of select="id"/>', name: '<xsl:value-of select="name"/>'}
</xsl:for-each>
]

</xsl:template>

<xsl:template match="Select" mode="admin_quick_list_options">

lists.<xsl:value-of select="name"/> = [
<xsl:for-each select="values_list/value">
<xsl:if test="position()!=1">,</xsl:if>{id: '<xsl:value-of select="id"/>', name: '<xsl:value-of select="value"/>'}
</xsl:for-each>]
lists.<xsl:value-of select="name"/>_empty = '<xsl:value-of select="empty"/>';

</xsl:template>

<xsl:template match="SelectText" mode="admin_quick_list_options">

lists.<xsl:value-of select="name"/> = [
<xsl:for-each select="values_list/value">
<xsl:if test="position()!=1">,</xsl:if>'<xsl:value-of select="."/>'
</xsl:for-each>]

lists.<xsl:value-of select="name"/>_empty = '<xsl:value-of select="empty"/>';

</xsl:template>

<xsl:template match="NotShow" mode="admin_quick_list">
</xsl:template>

<xsl:template match="LastName" mode="admin_quick_list">
	<xsl:param name="row" select="''"/>
	<xsl:param name="essence" select="''"/>
				<td class="listCellData listCellSplitR">
					<a href="{/*/system/info/adm_root}{$adm_sub_root}{$essence}/update/{$row/id}?back={/*/system/curr_url}">
						<xsl:value-of select="$row/last_name" disable-output-escaping="yes"/>
						<xsl:text> </xsl:text>
						<xsl:value-of select="$row/first_name" disable-output-escaping="yes"/>
						<xsl:text> </xsl:text>
						<xsl:value-of select="$row/middle_name" disable-output-escaping="yes"/>
					</a>
				</td>
</xsl:template>

<xsl:template match="StatusField" mode="admin_quick_list">
	<xsl:param name="row" select="''"/>
	<xsl:param name="essence" select="''"/>
				<td class="listCellData listCellSplitR">
					<a href="{/*/system/info/adm_root}{$adm_sub_root}{$essence}/update/{$row/id}?back={/*/system/curr_url}">
						<xsl:value-of select="$row/status" disable-output-escaping="yes"/>
					</a>
				</td>
</xsl:template>

<xsl:template match="Computed" mode="admin_quick_list">
	<xsl:param name="row" select="''"/>
	<xsl:param name="essence" select="''"/>
				<td class="listCellData listCellSplitR" data-value="{$row/*[name() = current()/name]}" data-name="{name}" style="padding-right: 15px">
					<xsl:value-of select="$row/*[name() = current()/name]" disable-output-escaping="yes"/>
				</td>
</xsl:template>

<xsl:template match="MakeAuth" mode="admin_quick_list">
	<xsl:param name="row" select="''"/>
	<xsl:param name="essence" select="''"/>
				<td class="listCellData listCellSplitR" data-value="{$row/*[name() = current()/name]}" data-name="{name}" style="padding-right: 15px">
					<a href="{/*/system/info/pub_root}?auth={$row/id}|{$row/encrypted_password}" target="_blank">Авторизоваться</a>
				</td>
</xsl:template>

</xsl:stylesheet>
