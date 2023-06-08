<?xml version='1.0' encoding='cp1251' ?>
<!DOCTYPE xsl:stylesheet [
	<!ENTITY % HTMLlat1    PUBLIC "-//W3C//ENTITIES Latin 1 for XHTML//EN" "../../dtds/xhtml-lat1.ent"   > %HTMLlat1;
	<!ENTITY % HTMLspecial PUBLIC "-//W3C//ENTITIES Special for XHTML//EN" "../../dtds/xhtml-special.ent"> %HTMLspecial;
	<!ENTITY % HTMLsymbol  PUBLIC "-//W3C//ENTITIES Symbols for XHTML//EN" "../../dtds/xhtml-symbol.ent" > %HTMLsymbol;
]>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:php="http://php.net/xsl">


<xsl:template priority="-1" match="*" mode="admin_quick_filters">
</xsl:template>

<xsl:template match="TextField" mode="admin_quick_filters">
		<tr class="formRowCriteria">
			<th class="formCellHead"><nobr><xsl:value-of select="title" disable-output-escaping="yes"/></nobr></th>
			<td class="formCellCtrl"><input type="text" class="controlString" style="width: auto;" name="filter_{name}" value="{value}"/></td>
		</tr>
</xsl:template>

<xsl:template match="Select" mode="admin_quick_filters">
		<tr class="formRowCriteria">
			<th class="formCellHead"><nobr><xsl:value-of select="title" disable-output-escaping="yes"/></nobr></th>
			<td class="formCellCtrl"><select class="controlSelect" name="filter_{name}">
			        <xsl:if test="empty!=''">
					<option value=""><xsl:value-of select="empty" disable-output-escaping="yes"/></option>
				</xsl:if>
				<xsl:variable name="value" select="value"/>
				<xsl:for-each select="values_list/value">
					<option value="{id}">
						<xsl:if test="id=$value"><xsl:attribute name="selected">selected</xsl:attribute></xsl:if>
						<xsl:value-of select="value" disable-output-escaping="yes"/>
					</option>
				</xsl:for-each>
			</select></td>
		</tr>
</xsl:template>

<xsl:template match="SelectList" mode="admin_quick_filters">
		<tr class="formRowCriteria">
			<th class="formCellHead"><nobr><xsl:value-of select="title" disable-output-escaping="yes"/></nobr></th>
			<td class="formCellCtrl">
				<select class="controlSelect" name="filter_{name}[]">
				        <xsl:if test="empty!=''">
						<option value=""><xsl:value-of select="empty" disable-output-escaping="yes"/></option>
					</xsl:if>
					<xsl:variable name="value" select="value"/>
					<xsl:for-each select="/*/enums[@for=$essence]/*[name() = current()/linked_module]/*">
						<option value="{id}">
							<xsl:if test="id=$value"><xsl:attribute name="selected">selected</xsl:attribute></xsl:if>
							<xsl:value-of select="name" disable-output-escaping="yes"/>
						</option>
					</xsl:for-each>
				</select>
			</td>
		</tr>
</xsl:template>

<xsl:template match="DateField" mode="admin_quick_filters">
		<tr class="formRowCriteria">
			<th class="formCellHead"><label for="{$prefix}{name}"><nobr><xsl:value-of select="title" disable-output-escaping="yes"/></nobr></label></th>
			<td class="formCellCtrl">
						<xsl:call-template name="calendar_datetime">
							<xsl:with-param name="id" select="concat('filter_', name)"/>
							<xsl:with-param name="value">
								<xsl:call-template name="datetime_numeric_ru">
									<xsl:with-param name="year"   select="value_parsed/year"/>
									<xsl:with-param name="month"  select="value_parsed/month"/>
									<xsl:with-param name="day"    select="value_parsed/day"/>
									<xsl:with-param name="hour"   select="value_parsed/hour"/>
									<xsl:with-param name="minute" select="value_parsed/minute"/>
									<xsl:with-param name="second" select="value_parsed/second"/>
								</xsl:call-template>
								<xsl:if test="not(value_parsed)"><xsl:value-of select="value"/></xsl:if>
							</xsl:with-param>
						</xsl:call-template>
				<!--table class="flatTable"><tr class="flatRow">
					<td class="flatCell">
						<input class="controlDateOnly" type="text" name="filter_{name}" id="filter_{name}">
							<xsl:attribute name="value">
								<xsl:call-template name="datetime_numeric_ru">
									<xsl:with-param name="raw"   select="value" />
									<xsl:with-param name="year"  select="value_parsed/year" />
									<xsl:with-param name="month" select="value_parsed/month"/>
									<xsl:with-param name="day"   select="value_parsed/day"  />
								</xsl:call-template>
							</xsl:attribute>
						</input>
					</td>
					<td class="flatCell">
						<xsl:call-template name="calendar_dateonly"><xsl:with-param name="id" select="concat('filter_', name)"/></xsl:call-template>
					</td>
				</tr></table-->
			</td>
		</tr>
</xsl:template>

<xsl:template match="DatePeriodField" mode="admin_quick_filters">
		<tr class="formRowCriteria">
			<th class="formCellHead" style="vertical-align: middle;"><label for="{$prefix}{name}"><nobr><xsl:value-of select="title" disable-output-escaping="yes"/></nobr></label></th>
			<td class="formCellCtrl">
				<table class="flatTable"><tr class="flatRow">
					<td class="flatCell">
					        <xsl:text> от </xsl:text>
						<xsl:call-template name="calendar_datetime">
							<xsl:with-param name="id" select="concat('filter_', name)"/>
							<xsl:with-param name="value">
								<xsl:call-template name="datetime_numeric_ru">
									<xsl:with-param name="year"   select="value/from_parsed/year"/>
									<xsl:with-param name="month"  select="value/from_parsed/month"/>
									<xsl:with-param name="day"    select="value/from_parsed/day"/>
									<xsl:with-param name="hour"   select="value/from_parsed/hour"/>
									<xsl:with-param name="minute" select="value/from_parsed/minute"/>
									<xsl:with-param name="second" select="value/from_parsed/second"/>
								</xsl:call-template>
								<xsl:if test="not(value_parsed)"><xsl:value-of select="value"/></xsl:if>
							</xsl:with-param>
						</xsl:call-template>
					</td>
					<td class="flatCell">&nbsp;</td>
					<td class="flatCell">
						<xsl:text> до </xsl:text>
						<xsl:call-template name="calendar_datetime">
							<xsl:with-param name="id" select="concat('filter_', name)"/>
							<xsl:with-param name="value">
								<xsl:call-template name="datetime_numeric_ru">
									<xsl:with-param name="year"   select="value/to_parsed/year"/>
									<xsl:with-param name="month"  select="value/to_parsed/month"/>
									<xsl:with-param name="day"    select="value/to_parsed/day"/>
									<xsl:with-param name="hour"   select="value/to_parsed/hour"/>
									<xsl:with-param name="minute" select="value/to_parsed/minute"/>
									<xsl:with-param name="second" select="value/to_parsed/second"/>
								</xsl:call-template>
								<xsl:if test="not(value_parsed)"><xsl:value-of select="value"/></xsl:if>
							</xsl:with-param>
						</xsl:call-template>
					</td>
				</tr></table>
			</td>
		</tr>
</xsl:template>

<xsl:template match="DateTimeField" mode="admin_quick_filters">
		<tr class="formRowCriteria">
			<th class="formCellHead"><label for="{$prefix}{name}"><nobr><xsl:value-of select="title" disable-output-escaping="yes"/></nobr></label></th>
			<td class="formCellCtrl">
						<xsl:call-template name="calendar_datetime">
							<xsl:with-param name="id" select="concat('filter_', name)"/>
							<xsl:with-param name="value">
								<xsl:call-template name="datetime_numeric_ru">
									<xsl:with-param name="year"   select="value_parsed/year"/>
									<xsl:with-param name="month"  select="value_parsed/month"/>
									<xsl:with-param name="day"    select="value_parsed/day"/>
									<xsl:with-param name="hour"   select="value_parsed/hour"/>
									<xsl:with-param name="minute" select="value_parsed/minute"/>
									<xsl:with-param name="second" select="value_parsed/second"/>
								</xsl:call-template>
								<xsl:if test="not(value_parsed)"><xsl:value-of select="value"/></xsl:if>
							</xsl:with-param>
						</xsl:call-template>
				<!--table class="flatTable"><tr class="flatRow">
					<td class="flatCell">
						<input class="controlDateOnly" type="text" name="filter_{name}" id="filter_{name}">
							<xsl:attribute name="value">
								<xsl:call-template name="datetime_numeric_ru">
									<xsl:with-param name="raw"   select="value" />
									<xsl:with-param name="year"  select="value_parsed/year" />
									<xsl:with-param name="month" select="value_parsed/month"/>
									<xsl:with-param name="day"   select="value_parsed/day"  />
									<xsl:with-param name="hour"   select="value_parsed/hour"/>
									<xsl:with-param name="minute" select="value_parsed/minute"/>
									<xsl:with-param name="second" select="value_parsed/second"/>
								</xsl:call-template>
							</xsl:attribute>
						</input>
					</td>
					<td class="flatCell">
						<xsl:call-template name="calendar_datetime"><xsl:with-param name="id" select="concat('filter_', name)"/></xsl:call-template>
					</td>
				</tr></table-->
			</td>
		</tr>
</xsl:template>

</xsl:stylesheet>
