<?xml version='1.0' encoding='cp1251' ?>
<!DOCTYPE xsl:stylesheet [
	<!ENTITY % HTMLlat1    PUBLIC "-//W3C//ENTITIES Latin 1 for XHTML//EN" "../../dtds/xhtml-lat1.ent"   > %HTMLlat1;
	<!ENTITY % HTMLspecial PUBLIC "-//W3C//ENTITIES Special for XHTML//EN" "../../dtds/xhtml-special.ent"> %HTMLspecial;
	<!ENTITY % HTMLsymbol  PUBLIC "-//W3C//ENTITIES Symbols for XHTML//EN" "../../dtds/xhtml-symbol.ent" > %HTMLsymbol;
]>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:php="http://php.net/xsl">

<xsl:template priority="-1" match="*" mode="admin_quick_view">
</xsl:template>

<xsl:template match="TextField" mode="admin_quick_view">
			<tr class="formRowView">
				<th class="formCellHead"><nobr><xsl:value-of select="title" disable-output-escaping="yes"/></nobr></th>
				<td class="formCellFlag"></td>
				<td class="formCellData">
					<xsl:value-of select="value" disable-output-escaping="no"/>
				</td>
			</tr>
</xsl:template>

<xsl:template match="TextField1" mode="admin_quick_view">
			<tr class="formRowView">
				<th class="formCellHead"><nobr><xsl:value-of select="title" disable-output-escaping="yes"/></nobr></th>
				<td class="formCellFlag"></td>
				<td class="formCellData">
					<xsl:value-of select="value" disable-output-escaping="no"/>
				</td>
			</tr>
</xsl:template>

<xsl:template match="Email" mode="admin_quick_view">
			<tr class="formRowView">
				<th class="formCellHead"><nobr><xsl:value-of select="title" disable-output-escaping="yes"/></nobr></th>
				<td class="formCellFlag"></td>
				<td class="formCellData">
					<xsl:value-of select="value" disable-output-escaping="no"/>
				</td>
			</tr>
</xsl:template>

<xsl:template match="DateField" mode="admin_quick_view">
			<tr class="formRowView">
				<th class="formCellHead"><nobr><xsl:value-of select="title" disable-output-escaping="yes"/></nobr></th>
				<td class="formCellFlag"></td>
				<td class="formCellData">
					<xsl:call-template name="datetime_numeric_ru">
						<xsl:with-param name="raw"   select="value" />
						<xsl:with-param name="year"  select="value_parsed/year" />
						<xsl:with-param name="month" select="value_parsed/month"/>
						<xsl:with-param name="day"   select="value_parsed/day"  />
					</xsl:call-template>
				</td>
			</tr>
</xsl:template>

<xsl:template match="TextArea" mode="admin_quick_view">
			<tr class="formRowView">
				<th class="formCellHead"><nobr><xsl:value-of select="title" disable-output-escaping="yes"/></nobr></th>
				<td class="formCellFlag"></td>
				<td class="formCellData">
					<xsl:value-of select="value" disable-output-escaping="no"/>
				</td>
			</tr>
</xsl:template>

<xsl:template match="PositionField" mode="admin_quick_view">
			<tr class="formRowView">
				<th class="formCellHead"><nobr><xsl:value-of select="title" disable-output-escaping="yes"/></nobr></th>
				<td class="formCellFlag"></td>
				<td class="formCellData">
					<xsl:value-of select="value" disable-output-escaping="no"/>
				</td>
			</tr>
</xsl:template>

<xsl:template match="SelectList" mode="admin_quick_view">
			<tr class="formRowView">
				<th class="formCellHead"><nobr><xsl:value-of select="title" disable-output-escaping="yes"/></nobr></th>
				<td class="formCellFlag"></td>
				<td class="formCellData">
					<xsl:value-of select="/*/enums[@for=$essence]/*[name() = current()/linked_module]/*[id = current()/value]/name" disable-output-escaping="yes"/>
				</td>
			</tr>
</xsl:template>

<xsl:template match="Select" mode="admin_quick_view">
			<tr class="formRowView">
				<th class="formCellHead"><nobr><xsl:value-of select="title" disable-output-escaping="yes"/></nobr></th>
				<td class="formCellFlag"></td>
				<td class="formCellData">
					<xsl:value-of select="values_list/value[id = current()/value]/value" disable-output-escaping="yes"/>
				</td>
			</tr>
</xsl:template>

<xsl:template match="SelectText" mode="admin_quick_view">
			<tr class="formRowView">
				<th class="formCellHead"><nobr><xsl:value-of select="title" disable-output-escaping="yes"/></nobr></th>
				<td class="formCellFlag"></td>
				<td class="formCellData">
					<xsl:value-of select="value" disable-output-escaping="yes"/>
				</td>
			</tr>
</xsl:template>

<xsl:template match="PriceField" mode="admin_quick_view">
			<tr class="formRowView">
				<th class="formCellHead"><nobr><xsl:value-of select="title" disable-output-escaping="yes"/></nobr></th>
				<td class="formCellFlag"></td>
				<td class="formCellData">
					<xsl:value-of select="format-number(value, '# ###,##', 'pricef')" />
				</td>
			</tr>
</xsl:template>

<xsl:template match="SqlSelected" mode="admin_quick_view">
			<tr class="formRowView">
				<th class="formCellHead"><nobr><xsl:value-of select="title" disable-output-escaping="yes"/></nobr></th>
				<td class="formCellFlag"></td>
				<td class="formCellData">
					<xsl:value-of select="format-number(value, '# ###,##', 'pricef')" />
				</td>
			</tr>
</xsl:template>

<xsl:template match="TotalWeight" mode="admin_quick_view">
			<tr class="formRowView">
				<th class="formCellHead"><nobr><xsl:value-of select="title" disable-output-escaping="yes"/></nobr></th>
				<td class="formCellFlag"></td>
				<td class="formCellData">
					<xsl:value-of select="format-number(value, '# ###,##', 'pricef')" />
				</td>
			</tr>
</xsl:template>

<xsl:template match="CheckBox" mode="admin_quick_view">
			<tr class="formRowView">
				<th class="formCellHead"><nobr><xsl:value-of select="title" disable-output-escaping="yes"/></nobr></th>
				<td class="formCellFlag"></td>
				<td class="formCellData">
					<xsl:choose>
						<xsl:when test="value=1">Да</xsl:when>
						<xsl:otherwise>Нет</xsl:otherwise>
					</xsl:choose>
				</td>
			</tr>
</xsl:template>

<xsl:template match="CheckBox1" mode="admin_quick_view">
			<tr class="formRowView">
				<th class="formCellHead"><nobr><xsl:value-of select="title" disable-output-escaping="yes"/></nobr></th>
				<td class="formCellFlag"></td>
				<td class="formCellData">
					<xsl:choose>
						<xsl:when test="value=1">Да</xsl:when>
						<xsl:otherwise>Нет</xsl:otherwise>
					</xsl:choose>
				</td>
			</tr>
			<tr class="formRowView">
				<th class="formCellHead"></th>
				<td class="formCellFlag"></td>
				<td class="formCellData">
					<a target="_blank" href="{/*/system/info/adm_root}{$adm_sub_root}{$essence}/kvit/{/*/form/id}">Квитанция</a>
				</td>
			</tr>
</xsl:template>

<xsl:template match="CheckBoxList" mode="admin_quick_view">
			<tr class="formRowView">
				<th class="formCellHead"><nobr><xsl:value-of select="title" disable-output-escaping="yes"/></nobr></th>
				<td class="formCellFlag"></td>
				<td class="formCellData">
					<xsl:for-each select="values_list/*">
					        <xsl:variable name="tagname" select="name()" />
						<xsl:if test="../../value/*[name() = $tagname] = 1">
							<xsl:value-of select="." disable-output-escaping="yes"/>
							<br/>
						</xsl:if>
					</xsl:for-each>
				</td>
			</tr>
</xsl:template>

<xsl:template match="CardField" mode="admin_quick_view">
			<tr class="formRowView">
				<th class="formCellHead"><nobr>ID пользователя</nobr></th>
				<td class="formCellFlag"></td>
				<td class="formCellData">
					<xsl:value-of select="value" />
				</td>
			</tr>
			<tr class="formRowView">
				<th class="formCellHead"><nobr><xsl:value-of select="title" disable-output-escaping="yes"/></nobr></th>
				<td class="formCellFlag"></td>
				<td class="formCellData">
					<xsl:value-of select="/*/form/data/user_info/card" />
				</td>
			</tr>
</xsl:template>

<xsl:template match="TarifField" mode="admin_quick_view">
			<tr class="formRowView">
				<th class="formCellHead"><nobr><xsl:value-of select="title" disable-output-escaping="yes"/></nobr></th>
				<td class="formCellFlag"></td>
				<td class="formCellData">
					<xsl:value-of select="/*/enums[@for=$essence]/*[name() = current()/linked_module]/*[id = current()/value]/name" disable-output-escaping="yes"/>
				</td>
			</tr>
</xsl:template>

<xsl:template match="NormPrice" mode="admin_quick_view">
			<tr class="formRowView">
				<th class="formCellHead"><nobr><xsl:value-of select="title" disable-output-escaping="yes"/></nobr></th>
				<td class="formCellFlag"></td>
				<td class="formCellData">
					<xsl:if test="value &gt; 0"><xsl:value-of select="format-number(value, '# ###,##', 'pricef')" /> руб.</xsl:if>
				</td>
			</tr>
</xsl:template>

<xsl:template match="TicketFish" mode="admin_quick_view">
			<tr class="formRowSpace"><th class="formCellSpace"></th><td class="formCellSpace"></td><td class="formCellSpace"></td></tr>

			<tr class="formRowView">
				<th class="formCellHead"><nobr><xsl:value-of select="title" disable-output-escaping="yes"/></nobr></th>
				<td class="formCellFlag"></td>
				<td class="formCellData">

		<table class="listTable TableField">
			<col width="1"/><col width="1"/><col width="*"/>
        
			<tr class="listRowHead nodrop nodrag">
				<th class="listCellHead listCellSplitR">
					<xsl:text>№</xsl:text>
				</th>
				<th class="listCellHead listCellSplitR">
					<nobr>Вид рыбы</nobr>
				</th>
				<th class="listCellHead listCellSplitR">
					<nobr>Стоимость</nobr>
				</th>
				<th class="listCellHead listCellSplitR">
					<nobr>Норма вылова</nobr>
				</th>
				<th class="listCellHead listCellSplitR">
					<nobr>Тип нормы</nobr>
				</th>
				<th class="listCellHead listCellSplitR">
					<nobr>Пруд</nobr>
				</th>
				<th class="listCellHead listCellSplitR">
					<nobr>Выловлено</nobr>
				</th>
			</tr>
	<xsl:choose>
	<xsl:when test="value/*">
		<xsl:for-each select="value/*">
			<xsl:variable name="row" select="((position()-1) mod 2)+1"/>
			<tr>
				<xsl:attribute name="class">
					<xsl:text>listRowData </xsl:text>
					<xsl:if test="position()=1     ">listRowFirst </xsl:if>
					<xsl:if test="position()=last()">listRowLast  </xsl:if>
					<xsl:text>listRow</xsl:text><xsl:value-of select="$row"/>
				</xsl:attribute>

				<td class="listCellData listCellSplitL">
				        <xsl:value-of select="position"/>
				</td>
				<td class="listCellData listCellSplitR">
						<xsl:value-of select="/*/enums/fish_types/fish_type[id = current()/fish_type]/name" disable-output-escaping="yes"/>
				</td>
				<td class="listCellData listCellSplitR fishPricesInc" data-val="{price}">
					<xsl:if test="price &gt; 0">
						<xsl:value-of select="format-number(price, '# ###,##', 'pricef')" disable-output-escaping="yes"/> руб.
					</xsl:if>
				</td>
				<td class="listCellData listCellSplitR" data-val="{norm_weight}">
					<xsl:if test="norm_weight &gt; 0">
						<xsl:value-of select="format-number(norm_weight, '# ###,##', 'pricef')" disable-output-escaping="yes"/>
					</xsl:if>
				</td>
				<td class="listCellData listCellSplitR" data-val="{weight_type}">
						<xsl:value-of select="../../fields/Select/values_list/value[id = current()/weight_type]/value" disable-output-escaping="yes"/>
				</td>
				<td class="listCellData listCellSplitR">
						<xsl:value-of select="/*/enums/ponds/pond[id = current()/pond]/name" disable-output-escaping="yes"/>
				</td>
				<td class="listCellData listCellSplitR">
					<xsl:value-of select="format-number(weight, '# ###,##', 'pricef')" disable-output-escaping="yes"/>
				</td>
			</tr>
		</xsl:for-each>
	</xsl:when>
	</xsl:choose>
		</table>
				</td>
			</tr>
</xsl:template>

<xsl:template match="TicketFish2" mode="admin_quick_view">
			<tr class="formRowSpace"><th class="formCellSpace"></th><td class="formCellSpace"></td><td class="formCellSpace"></td></tr>

			<tr class="formRowView">
				<th class="formCellHead"><nobr><xsl:value-of select="title" disable-output-escaping="yes"/></nobr></th>
				<td class="formCellFlag"></td>
				<td class="formCellData">

		<table class="listTable TableField">
			<col width="1"/><col width="1"/><col width="*"/>
        
			<tr class="listRowHead nodrop nodrag">
				<th class="listCellHead listCellSplitR">
					<xsl:text>№</xsl:text>
				</th>

			<xsl:for-each select="fields/*[name!='additional']">
				<th class="listCellHead listCellSplitR">
				<nobr>
					<xsl:value-of select="title"/>
				</nobr>
				</th>
			</xsl:for-each>

			</tr>
	<xsl:choose>
	<xsl:when test="value/*">
		<xsl:for-each select="value/*">
			<xsl:variable name="row" select="((position()-1) mod 2)+1"/>
			<tr>
				<xsl:attribute name="class">
					<xsl:text>listRowData </xsl:text>
					<xsl:if test="position()=1     ">listRowFirst </xsl:if>
					<xsl:if test="position()=last()">listRowLast  </xsl:if>
					<xsl:text>listRow</xsl:text><xsl:value-of select="$row"/>
				</xsl:attribute>

				<td class="listCellData listCellSplitL dragHandle">
				        <xsl:value-of select="position"/>
				</td>
				<td class="listCellData listCellSplitR">
					<xsl:value-of select="/*/enums/fish_types/fish_type[id = current()/fish_type]/name" disable-output-escaping="yes"/>
				</td>
				<td class="listCellData listCellSplitR">
					<xsl:if test="price &gt; 0">
						<xsl:value-of select="format-number(price, '# ###,##', 'pricef')" disable-output-escaping="yes"/> руб.
					</xsl:if>
				</td>
				<td class="listCellData listCellSplitR">
						<xsl:value-of select="/*/enums/ponds/pond[id = current()/pond]/name" disable-output-escaping="yes"/>
				</td>
				<td class="listCellData listCellSplitR">
					<xsl:value-of select="format-number(weight, '# ###,##', 'pricef')" disable-output-escaping="yes"/>
				</td>
			</tr>
		</xsl:for-each>
	</xsl:when>
	</xsl:choose>
		</table>
				</td>
			</tr>
</xsl:template>

<xsl:template match="PriceComputed" mode="admin_quick_view">
			<tr class="formRowView">
				<th class="formCellHead"><nobr><xsl:value-of select="title" disable-output-escaping="yes"/></nobr></th>
				<td class="formCellFlag"></td>
				<td class="formCellData">
					<xsl:if test="value &gt; 0"><xsl:value-of select="format-number(value, '# ###,##', 'pricef')" /> руб.</xsl:if>
				</td>
			</tr>
</xsl:template>

<xsl:template match="ServiceField" mode="admin_quick_view">
			<tr class="formRowSpace"><th class="formCellSpace"></th><td class="formCellSpace"></td><td class="formCellSpace"></td></tr>

			<tr class="formRowView">
				<th class="formCellHead"><nobr><xsl:value-of select="title" disable-output-escaping="yes"/></nobr></th>
				<td class="formCellFlag"></td>
				<td class="formCellData">

		<table class="listTable TableField">
			<col width="1"/><col width="1"/><col width="*"/>
        
			<tr class="listRowHead nodrop nodrag">
				<th class="listCellHead listCellSplitR">
					<xsl:text>№</xsl:text>
				</th>
			<xsl:for-each select="fields/*">
				<th class="listCellHead listCellSplitR">
				<nobr>
					<xsl:value-of select="title"/>
				</nobr>
				</th>
			</xsl:for-each>
			</tr>
	<xsl:choose>
	<xsl:when test="value/*">
		<xsl:for-each select="value/*">
			<xsl:variable name="row" select="((position()-1) mod 2)+1"/>
			<tr>
				<xsl:attribute name="class">
					<xsl:text>listRowData </xsl:text>
					<xsl:if test="position()=1     ">listRowFirst </xsl:if>
					<xsl:if test="position()=last()">listRowLast  </xsl:if>
					<xsl:text>listRow</xsl:text><xsl:value-of select="$row"/>
				</xsl:attribute>

				<td class="listCellData listCellSplitL">
				        <xsl:value-of select="position"/>
				</td>
				<td class="listCellData listCellSplitR">
						<xsl:value-of select="/*/enums/services/service[id = current()/service]/name" disable-output-escaping="yes"/>
				</td>
				<td class="listCellData listCellSplitR servicePricesInc" data-val="{price}">
					<xsl:if test="price &gt; 0">
						<xsl:value-of select="format-number(price, '# ###,##', 'pricef')" disable-output-escaping="yes"/> руб.
					</xsl:if>
				</td>
				<td class="listCellData listCellSplitR">
						<xsl:value-of select="time" disable-output-escaping="yes"/>
				</td>
				<td class="listCellData listCellSplitR" data-val="{service_count}">
						<xsl:value-of select="service_count" disable-output-escaping="yes"/>
				</td>
				<td class="listCellData listCellSplitR">
					<xsl:value-of select="weight" disable-output-escaping="yes"/>
				</td>
			</tr>
		</xsl:for-each>
	</xsl:when>
	</xsl:choose>
		</table>
				</td>
			</tr>
</xsl:template>

<xsl:template match="ServiceField2" mode="admin_quick_view">
			<tr class="formRowSpace"><th class="formCellSpace"></th><td class="formCellSpace"></td><td class="formCellSpace"></td></tr>

			<tr class="formRowView">
				<th class="formCellHead"><nobr><xsl:value-of select="title" disable-output-escaping="yes"/></nobr></th>
				<td class="formCellFlag"></td>
				<td class="formCellData">

		<table class="listTable TableField">
			<col width="1"/><col width="1"/><col width="*"/>
        
			<tr class="listRowHead nodrop nodrag">
				<th class="listCellHead listCellSplitR">
					<xsl:text>№</xsl:text>
				</th>

			<xsl:for-each select="fields/*[name!='additional']">
				<th class="listCellHead listCellSplitR">
				<nobr>
					<xsl:value-of select="title"/>
				</nobr>
				</th>
			</xsl:for-each>
			</tr>
	<xsl:choose>
	<xsl:when test="value/*">
		<xsl:for-each select="value/*">
			<xsl:variable name="row" select="((position()-1) mod 2)+1"/>
			<tr>
				<xsl:attribute name="class">
					<xsl:text>listRowData </xsl:text>
					<xsl:if test="position()=1     ">listRowFirst </xsl:if>
					<xsl:if test="position()=last()">listRowLast  </xsl:if>
					<xsl:text>listRow</xsl:text><xsl:value-of select="$row"/>
				</xsl:attribute>

				<td class="listCellData listCellSplitL dragHandle">
				        <xsl:value-of select="position"/>
				</td>
				<td class="listCellData listCellSplitR">
					<xsl:value-of select="/*/enums/services/service[id = current()/service]/name" disable-output-escaping="yes"/>
				</td>
				<td class="listCellData listCellSplitR">
					<xsl:if test="price &gt; 0">
						<xsl:value-of select="format-number(price, '# ###,##', 'pricef')" disable-output-escaping="yes"/> руб.
					</xsl:if>
				</td>
				<td class="listCellData listCellSplitR">
					<xsl:value-of select="time" disable-output-escaping="yes"/>
				</td>
				<td class="listCellData listCellSplitR">
					<xsl:value-of select="weight" disable-output-escaping="yes"/>
				</td>
			</tr>
		</xsl:for-each>
	</xsl:when>
	</xsl:choose>
		</table>
				</td>
			</tr>
</xsl:template>

<xsl:template match="TotalPrice" mode="admin_quick_view">
			<tr class="formRowView">
				<th class="formCellHead"><nobr><xsl:value-of select="title" disable-output-escaping="yes"/></nobr></th>
				<td class="formCellFlag"></td>
				<td class="formCellData">
					<xsl:if test="value &gt; 0"><xsl:value-of select="format-number(value, '# ###,##', 'pricef')" /> руб.</xsl:if>
				</td>
			</tr>
</xsl:template>

<xsl:template match="PayPrice" mode="admin_quick_view">
			<tr class="formRowView">
				<th class="formCellHead"><nobr><xsl:value-of select="title" disable-output-escaping="yes"/></nobr></th>
				<td class="formCellFlag"></td>
				<td class="formCellData">
					<xsl:if test="value &gt; 0"><xsl:value-of select="format-number(value, '# ###,##', 'pricef')" /> руб.</xsl:if>
				</td>
			</tr>
</xsl:template>

</xsl:stylesheet>
