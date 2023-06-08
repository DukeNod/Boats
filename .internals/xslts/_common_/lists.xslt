<?xml version='1.0' encoding='cp1251' ?>
<!DOCTYPE xsl:stylesheet [
	<!ENTITY % HTMLlat1    PUBLIC "-//W3C//ENTITIES Latin 1 for XHTML//EN" "../../dtds/xhtml-lat1.ent"   > %HTMLlat1;
	<!ENTITY % HTMLspecial PUBLIC "-//W3C//ENTITIES Special for XHTML//EN" "../../dtds/xhtml-special.ent"> %HTMLspecial;
	<!ENTITY % HTMLsymbol  PUBLIC "-//W3C//ENTITIES Symbols for XHTML//EN" "../../dtds/xhtml-symbol.ent" > %HTMLsymbol;
]>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:php="http://php.net/xsl">



<xsl:template name="arg_val_for_sorters">
	<xsl:param name="sorters" select="/.." />
	<xsl:param name="name"    select="''"  />
	<xsl:param name="dir"     select="'*'" />

	<xsl:if test="$sorters">
		<xsl:for-each select="$sorters/*[($name != '') and (name() = $name)]">
			<xsl:value-of select="$dir"/>
			<xsl:value-of select="name()"/>
		</xsl:for-each>
		<xsl:for-each select="$sorters/*[($name  = '') and (position() = 1)]">
			<xsl:value-of select="."/>
			<xsl:value-of select="name()"/>
		</xsl:for-each>
	</xsl:if>
</xsl:template>



<xsl:template name="url_args_for_sorters">
	<xsl:param name="sorters" select="/.." />
	<xsl:param name="name"    select="''"  />
	<xsl:param name="dir"     select="'*'" />

	<xsl:if test="$sorters">
		<xsl:text>sorter=</xsl:text>
		<xsl:call-template name="arg_val_for_sorters">
			<xsl:with-param name="sorters" select="$sorters"/>
			<xsl:with-param name="name"    select="$name"   />
			<xsl:with-param name="dir"     select="$dir"    />
		</xsl:call-template>
	</xsl:if>
</xsl:template>



<xsl:template name="url_args_for_filters">
	<xsl:param name="filters" select="/.." />
	<xsl:param name="name"    select="''"  />

	<xsl:for-each select="$filters/*[(($name = '') or (name() = $name)) and (* or .!='')]">
		<xsl:if test="position()!=1">&amp;</xsl:if>
		<xsl:choose>
		<xsl:when test="value">
		<xsl:for-each select="value">
			<!--xsl:text>filter_</xsl:text-->
			<xsl:value-of select="name(..)"/>
			<xsl:text>[]=</xsl:text>
			<xsl:value-of select="."/>
		</xsl:for-each>
		</xsl:when>
		<xsl:otherwise>
			<!--xsl:text>filter_</xsl:text-->
			<xsl:value-of select="name(.)"/>
			<xsl:text>=</xsl:text>
			<xsl:value-of select="."/>
		</xsl:otherwise>
		</xsl:choose>
	</xsl:for-each>
</xsl:template>



<!--
-->
<xsl:template name="list_head_with_sorters">
	<xsl:param name="filters" select="/.."/>
	<xsl:param name="sorters" select="/.."/>
	<xsl:param name="name" select="''"/>
	<xsl:param name="text" select="''"/>
	<xsl:param name="url" select="''"/>

	<div>
	<xsl:choose>
	<xsl:when test="$sorters">
		<xsl:attribute name="class">sortersField sortersFieldLink</xsl:attribute>
		<a class="sortersFieldLink shy">
			<xsl:attribute name="href">
			        <xsl:value-of select="$url"/>
				<xsl:text>?</xsl:text>
				<xsl:call-template name="url_args_for_sorters">
					<xsl:with-param name="sorters" select="$sorters"/>
					<xsl:with-param name="name"    select="$name" />
					<xsl:with-param name="dir">
						<xsl:choose>
						<xsl:when test="(name($sorters/*[1]) = $name) and ($sorters/*[1] = '+')">-</xsl:when>
						<xsl:otherwise>+</xsl:otherwise>
						</xsl:choose>
					</xsl:with-param>
				</xsl:call-template>
				<xsl:text>&amp;</xsl:text>
				<xsl:call-template name="url_args_for_filters">
					<xsl:with-param name="filters" select="$filters"/>
				</xsl:call-template>
			</xsl:attribute>
			<xsl:copy-of select="$text"/>
		</a>
	</xsl:when>
	<xsl:otherwise>
		<xsl:attribute name="class">sortersField sortersFieldNone</xsl:attribute>
		<nobr><xsl:copy-of select="$text"/></nobr>
	</xsl:otherwise>
	</xsl:choose>
	</div>

</xsl:template>



<xsl:template name="filters_block">
	<xsl:param name="action"  select="''"/>
	<xsl:param name="filters" select="/.."/>
	<xsl:param name="sorters" select="/.."/>
	<xsl:param name="rows"    select="/.."/>

	<xsl:variable name="filtered" select="$filters/*/*  or  $filters/*!=''"/>

	<form class="form filter" method="get" action="{$action}">
		<input type="hidden" name="sorter">
			<xsl:attribute name="value">
				<xsl:call-template name="arg_val_for_sorters">
					<xsl:with-param name="sorters" select="$sorters"/>
				</xsl:call-template>
			</xsl:attribute>
		</input>

		<table class="formTable">
			<xsl:copy-of select="$rows"/>

			<tr class="formRowCommands">
				<td class=""></td>
				<td class="formCellCommands">
					<table class="flatTable"><tr class="flatRow">
						<td class="flatCell">
							<button class="inlineButton" type="submit" style="width: 147px; height: 20px;">
								<img src="{/*/system/info/adm_root}img/buttons/filter_apply.gif" width="147" height="20" alt="Применить фильтр"/>
							</button>
						</td>
						<td class="flatCell" style="padding-left: 8px;">
							<a class="inlineButton" style="width: 134px; height: 20px;">
								<xsl:attribute name="href">
									<xsl:text>?</xsl:text>
									<xsl:call-template name="url_args_for_sorters">
										<xsl:with-param name="sorters" select="$sorters"/>
									</xsl:call-template>
								</xsl:attribute>
								<img src="{/*/system/info/adm_root}img/buttons/filter_clear.gif" width="134" height="20" alt="Сбросить фильтр"/>
							</a>
						</td>
					</tr></table>
				</td>
			</tr>
		</table>
	</form>

</xsl:template>


<xsl:template name="pager_block">
	<xsl:param name="filters" select="/.."/>
	<xsl:param name="sorters" select="/.."/>
	<xsl:param name="pager"   select="/.."/>
	<xsl:param name="url" select="''"/>

	<xsl:if test="$pager and count($pager/cycle/page)&gt;1"> <!--  and number($pager/pages)&gt;1 -->
		<div class="pager">
			<span class="pagerTitle">Страницы:</span>
			<xsl:for-each select="$pager/cycle/*">
				<xsl:text> </xsl:text>
				<xsl:call-template name="pager_block_page">
					<xsl:with-param name="filters" select="$filters"/>
					<xsl:with-param name="sorters" select="$sorters"/>
					<xsl:with-param name="pager"   select="$pager"  />
					<xsl:with-param name="url"     select="$url"  />
					<xsl:with-param name="page"    select="."/>
				</xsl:call-template>
			</xsl:for-each>
		</div>
	</xsl:if>
</xsl:template>



<xsl:template name="pager_block_page">
	<xsl:param name="filters" select="/.."/>
	<xsl:param name="sorters" select="/.."/>
	<xsl:param name="pager"   select="/.."/>
	<xsl:param name="page"/>
	<xsl:param name="url" select="''"/>

	<xsl:choose>
	<xsl:when test="number($page) = number($pager/page)">
		<span class="pagerThis">
			<xsl:value-of select="$page"/>
		</span>
	</xsl:when>
	<xsl:otherwise>
		<span class="pagerLink">
			<a><xsl:attribute name="href">
			        <xsl:value-of select="$url"/>
				<xsl:text>?</xsl:text>
				<xsl:text>page=</xsl:text>
				<xsl:value-of select="$page"/>
				<xsl:text>&amp;</xsl:text>
				<xsl:call-template name="url_args_for_sorters">
					<xsl:with-param name="sorters" select="$sorters"/>
				</xsl:call-template>
				<xsl:text>&amp;</xsl:text>
				<xsl:call-template name="url_args_for_filters">
					<xsl:with-param name="filters" select="$filters"/>
				</xsl:call-template>
			</xsl:attribute>
			<xsl:value-of select="$page"/></a>
		</span>
	</xsl:otherwise>
	</xsl:choose>
</xsl:template>

<!--xsl:template name="pager_block">
	<xsl:param name="filters" select="/.."/>
	<xsl:param name="sorters" select="/.."/>
	<xsl:param name="pager"   select="/.."/>
	<xsl:param name="url"   select="'/'"/>

	<xsl:if test="$pager and number($pager/pages)&gt;1">
		<div class="pager">
			<xsl:for-each select="$pager/iterator/*">
				<xsl:text> </xsl:text>
				<xsl:call-template name="pager_block_page">
					<xsl:with-param name="filters" select="$filters"/>
					<xsl:with-param name="sorters" select="$sorters"/>
					<xsl:with-param name="pager"   select="$pager"  />
					<xsl:with-param name="page"    select="."/>
					<xsl:with-param name="url"    select="$url"/>
				</xsl:call-template>
			</xsl:for-each>
		</div>
	</xsl:if>
</xsl:template>



<xsl:template name="pager_block_page">
	<xsl:param name="filters" select="/.."/>
	<xsl:param name="sorters" select="/.."/>
	<xsl:param name="pager"   select="/.."/>
	<xsl:param name="page"/>
	<xsl:param name="url"   select="/.."/>

	<xsl:choose>
	<xsl:when test="number($page) = number($pager/page)">
		<span class="page">
			<xsl:value-of select="$page"/>
		</span>
	</xsl:when>
	<xsl:otherwise>
		<span class="page">
			<a><xsl:attribute name="href">
				<xsl:value-of select="$url"/>
				<xsl:text>?</xsl:text>
				<xsl:text>page=</xsl:text>
				<xsl:value-of select="$page"/>
				<xsl:if test="$sorters">
					<xsl:text>&amp;</xsl:text>
					<xsl:call-template name="url_args_for_sorters">
						<xsl:with-param name="sorters" select="$sorters"/>
					</xsl:call-template>
				</xsl:if>
				<xsl:if test="$filters">
					<xsl:text>&amp;</xsl:text>
					<xsl:call-template name="url_args_for_filters">
						<xsl:with-param name="filters" select="$filters"/>
					</xsl:call-template>
				</xsl:if>	
			</xsl:attribute>
			<xsl:value-of select="$page"/></a>
		</span>
	</xsl:otherwise>
	</xsl:choose>
</xsl:template-->



</xsl:stylesheet>
