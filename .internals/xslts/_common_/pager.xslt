<?xml version='1.0' encoding='cp1251' ?>
<!DOCTYPE xsl:stylesheet [
	<!ENTITY % HTMLlat1    PUBLIC "-//W3C//ENTITIES Latin 1 for XHTML//EN" "../../dtds/xhtml-lat1.ent"   > %HTMLlat1;
	<!ENTITY % HTMLspecial PUBLIC "-//W3C//ENTITIES Special for XHTML//EN" "../../dtds/xhtml-special.ent"> %HTMLspecial;
	<!ENTITY % HTMLsymbol  PUBLIC "-//W3C//ENTITIES Symbols for XHTML//EN" "../../dtds/xhtml-symbol.ent" > %HTMLsymbol;
]>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:php="http://php.net/xsl">


<xsl:template match="pager">
	<xsl:param name="url" select="/*/system/info/pub_root" />
	<xsl:param name="filters" select="/.."/>
	<xsl:param name="sorters" select="/.."/>
	
	<xsl:if test="count(cycle/page)&gt;1">
	
			<xsl:variable name="filtes_sorters_url">
				<xsl:text>?</xsl:text>
				<xsl:call-template name="url_args_for_sorters">
					<xsl:with-param name="sorters" select="$sorters"/>
				</xsl:call-template>
				<xsl:if test="$filters/*/value != ''">
					<xsl:text>&amp;</xsl:text>
					<xsl:call-template name="url_args_for_filters">
						<xsl:with-param name="filters" select="$filters"/>
					</xsl:call-template>
				</xsl:if>
			</xsl:variable>
	
			<div class="listing_block">
               	<xsl:if test="number(page)&gt;1">
					<a href="{$url}page/{number(page)-1}/{$filtes_sorters_url}">&lt;</a>&nbsp;&nbsp;&nbsp;
               	</xsl:if>
			<!--xsl:for-each select="cycle/page[number(.) &gt; number(../../page) - 5 and number(.) &lt; number(../../page) + 5]"-->
			<xsl:for-each select="cycle/page[number(.) &gt; number(../../page) - 5 ][position() &lt; 11]">
				<!--xsl:if test="position() &lt; 10"-->
				<xsl:choose>
					<xsl:when test="number(.)=number(../../page)"><a class="act"><xsl:value-of select="."/></a></xsl:when>
					<xsl:when test="number(.)=1"><a href="{$url}{$filtes_sorters_url}"><xsl:value-of select="."/></a></xsl:when>
					<xsl:otherwise><a href="{$url}page/{.}/{$filtes_sorters_url}"><xsl:value-of select="."/></a></xsl:otherwise>
				</xsl:choose>
				<!--/xsl:if-->
				<!--xsl:if test="position()!=last()"><span class="divider">|</span> </xsl:if-->
			</xsl:for-each>
               	<xsl:if test="number(page)&lt;cycle/page[last()]">
					&nbsp;&nbsp;&nbsp;<a href="{$url}page/{number(page)+1}/{$filtes_sorters_url}">&gt;</a>
               	</xsl:if>
				<!--&nbsp;&nbsp;&nbsp;&nbsp;|&nbsp;&nbsp;&nbsp; <a href="{$url}page/all/">Показать все</a>-->
			</div>
	</xsl:if>
</xsl:template>

<xsl:template name="head_sorters_url">
	<xsl:param name="filters" select="/.."/>
	<xsl:param name="sorters" select="/.."/>
	<xsl:param name="name" select="''"/>
	<xsl:param name="url" select="''"/>

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

</xsl:template>


<!-- Эти шаблоны дублируют аналогичные из админки. ToDo: Перепланировать размещение. -->
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

	<xsl:for-each select="$filters/*[(($name = '') or (name = $name)) and (value !='')]">
		<xsl:if test="position()!=1">&amp;</xsl:if>
		<xsl:choose>
		<xsl:when test="value/value">
		<xsl:for-each select="value">
			<xsl:text>filter_</xsl:text>
			<xsl:value-of select="../name"/>
			<xsl:text>[]=</xsl:text>
			<xsl:value-of select="."/>
		</xsl:for-each>
		</xsl:when>
		<xsl:otherwise>
			<xsl:text>filter_</xsl:text>
			<xsl:value-of select="name"/>
			<xsl:text>=</xsl:text>
			<xsl:value-of select="value"/>
		</xsl:otherwise>
		</xsl:choose>
	</xsl:for-each>
</xsl:template>

<!--xsl:template match="pager">
	<xsl:param name="url_prefix"/>
	<xsl:param name="url_suffix"/>

	<div class="pager">
		<xsl:for-each select="page">
			<xsl:choose>
			<xsl:when test="number(.)=1                 "><span class="pager-selected">&lt;&lt;</span></xsl:when>
			<xsl:when test="number(.)=2                 "><a    class="pager-fast" href="{$url_prefix}{$url_suffix}"                   >&lt;&lt;</a></xsl:when>
			<xsl:otherwise                               ><a    class="pager-fast" href="{$url_prefix}/page/{number(.)-1}{$url_suffix}">&lt;&lt;</a></xsl:otherwise>
			</xsl:choose>
		</xsl:for-each>
		<xsl:text>&nbsp;</xsl:text>
		<xsl:for-each select="cycle/page">
			<xsl:choose>
			<xsl:when test="number(.)=number(../../page)"><span class="pager-selected"><xsl:value-of select="."/></span></xsl:when>
			<xsl:when test="number(.)=1                 "><a    class="pager-this" href="{$url_prefix}{$url_suffix}"                 ><xsl:value-of select="."/></a></xsl:when>
			<xsl:otherwise                               ><a    class="pager-link" href="{$url_prefix}/page/{number(.)}{$url_suffix}"><xsl:value-of select="."/></a></xsl:otherwise>
			</xsl:choose>
			<xsl:if test="position()!=last()"><xsl:text> </xsl:text></xsl:if>
		</xsl:for-each>
		<xsl:text>&nbsp;</xsl:text>
		<xsl:for-each select="page">
			<xsl:choose>
			<xsl:when test="number(.)=number(../pages)  "><span class="pager-selected">&gt;&gt;</span></xsl:when>
			<xsl:otherwise                               ><a    class="pager-fast" href="{$url_prefix}/page/{number(.)+1}{$url_suffix}">&gt;&gt;</a></xsl:otherwise>
			</xsl:choose>
		</xsl:for-each>
	</div>
</xsl:template-->



</xsl:stylesheet>
