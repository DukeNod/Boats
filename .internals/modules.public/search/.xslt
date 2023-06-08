<?xml version="1.0" encoding="cp1251" ?>
<!DOCTYPE xsl:stylesheet [
	<!ENTITY % HTMLlat1    PUBLIC "-//W3C//ENTITIES Latin 1 for XHTML//EN" "../../dtds/xhtml-lat1.ent"   > %HTMLlat1;
	<!ENTITY % HTMLspecial PUBLIC "-//W3C//ENTITIES Special for XHTML//EN" "../../dtds/xhtml-special.ent"> %HTMLspecial;
	<!ENTITY % HTMLsymbol  PUBLIC "-//W3C//ENTITIES Symbols for XHTML//EN" "../../dtds/xhtml-symbol.ent" > %HTMLsymbol;
]>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:php="http://php.net/xsl">
<xsl:include href="../../xslts/public.xslt"/>



<xsl:variable name="form" select="/*/form | /*/done"/>



<xsl:template match="/" mode="overrideable_title">
	<xsl:text>Поиск</xsl:text>
	<xsl:if test="$form/data/text!=''"><xsl:text> &mdash; </xsl:text><xsl:value-of select="$form/data/text"/></xsl:if>
</xsl:template>

<xsl:template match="/" mode="overrideable_keywords">
	<xsl:text>Поиск</xsl:text>
	<xsl:if test="$form/data/text!=''"><xsl:text>, </xsl:text><xsl:value-of select="$form/data/text"/></xsl:if>
	<xsl:for-each select="$form/results/*"><xsl:text>, </xsl:text><xsl:value-of select="name | title"/></xsl:for-each>
</xsl:template>

<xsl:template match="/" mode="overrideable_description">
	<xsl:text>Поиск</xsl:text>
	<xsl:if test="$form/data/text!=''"><xsl:text>. </xsl:text><xsl:value-of select="$form/data/text"/></xsl:if>
	<xsl:for-each select="$form/results/*"><xsl:text>. </xsl:text><xsl:value-of select="name | title"/></xsl:for-each>
</xsl:template>

<xsl:template  match="/" mode="overrideable_head">Поиск</xsl:template>

<xsl:template match="/" mode="overrideable_measurer">
	<a class="act">Поиск</a>
</xsl:template>

<xsl:template match="/" mode="overrideable_content">
    <div class="search_page_block"> 
    <form class="search_form" action="{/*/system/info/pub_root}search/" method="get">
    <fieldset>
            <input type="text" name="text" class="input_text" value="{/*/done/data/text}"/>
            <input type="submit" class="sub" value="" />
    </fieldset>
    </form>
    </div>

			<xsl:choose>
			<xsl:when test="($form/data/text='')">
			</xsl:when>
			<xsl:when test="not($form/results/*)">
			        <br/>
				<div class="para">
					<h4>Ничего не найдено.</h4>
				</div>
			</xsl:when>
			<xsl:otherwise>
			        <br/>
				<div class="para">
					<h4>Результаты поиска:</h4>

				    <ul class="list-type-3">
					<xsl:for-each select="$form/results/*">
					<xsl:sort select="relativity" data-type="number" order="descending"/>

					<xsl:choose>
					<xsl:when test="name()='inline'">
						<li>
							<a href="{/*/system/info/pub_root}{substring(search_url, 1+number(starts-with(search_url, '/')))}">
							<xsl:value-of select="search_title" disable-output-escaping="yes"/>
							</a>
						</li>
					</xsl:when>
					<xsl:when test="name()='page'">
						<li>
					            <xsl:for-each select="parents/parent">
					              <xsl:variable name="fullmr"><xsl:apply-templates select="preceding-sibling::parent" mode="make_mr"/></xsl:variable>
							<a href="{$LANGROOT}{$fullmr}{mr}/"><xsl:value-of select="name" disable-output-escaping="yes"/></a>&nbsp;&nbsp;>&nbsp;&nbsp;
					            </xsl:for-each>

					              <xsl:variable name="fullmr"><xsl:apply-templates select="parents/parent" mode="make_mr"/></xsl:variable>
							<a href="{$LANGROOT}{$fullmr}{mr}/"><xsl:value-of select="name" disable-output-escaping="yes"/></a>
						</li>
					</xsl:when>
					<xsl:when test="name()='category'">
						<li class="li">
						<a href="{$LANGROOT}catalog/"><xsl:value-of select="/*/inlines/inline[label='text:catalog']/content"/></a>&nbsp;&nbsp;>&nbsp;&nbsp;
				            <xsl:for-each select="parents/parent">
				              <xsl:variable name="fullmr"><xsl:apply-templates select="preceding-sibling::parent" mode="make_mr"/></xsl:variable>
						<a href="{$LANGROOT}catalog/{$fullmr}{mr}/"><xsl:value-of select="name" disable-output-escaping="yes"/></a>&nbsp;&nbsp;>&nbsp;&nbsp;
				            </xsl:for-each>
				              <xsl:variable name="fullmr"><xsl:apply-templates select="parents/parent" mode="make_mr"/></xsl:variable>
						<a href="{$LANGROOT}catalog/{$fullmr}{mr}/"><xsl:value-of select="name" disable-output-escaping="yes"/></a>
						</li>
					</xsl:when>
					<xsl:when test="name()='production'">
						<li>
						<a href="{$LANGROOT}production/">Продукция</a>
						<a href="{$LANGROOT}production/{mr}/"><xsl:value-of select="name" disable-output-escaping="yes"/></a>
						</li>
					</xsl:when>
					<xsl:when test="name()='service'">
						<li>
						<a href="{$LANGROOT}services/">Услуги</a>
						<a href="{$LANGROOT}services/{mr}/"><xsl:value-of select="name" disable-output-escaping="yes"/></a>
						</li>
					</xsl:when>
					<xsl:when test="name()='equipment'">
						<li>
						<a href="{$LANGROOT}equipments/">Оборудование</a>
						<a href="{$LANGROOT}equipments/{mr}/"><xsl:value-of select="name" disable-output-escaping="yes"/></a>
						</li>
					</xsl:when>
					<xsl:when test="name()='news'">
						<li>
					            <!--xsl:choose>
					            <xsl:when test="group = 'news'"-->
							<a href="{$LANGROOT}news/">Новости</a>&nbsp;&nbsp;>&nbsp;&nbsp;
							<a href="{$LANGROOT}news/{id}/"><xsl:value-of select="title" disable-output-escaping="yes"/></a>
					            <!--/xsl:when>
					            </xsl:choose-->
						</li>
					</xsl:when>
					<xsl:when test="name()='action'">
						<li>
					            <!--xsl:choose>
					            <xsl:when test="group = 'news'"-->
							<a href="{$LANGROOT}actions/">Мероприятия клуба</a>&nbsp;&nbsp;>&nbsp;&nbsp;
							<a href="{$LANGROOT}actions/{id}/"><xsl:value-of select="name" disable-output-escaping="yes"/></a>
					            <!--/xsl:when>
					            </xsl:choose-->
						</li>
					</xsl:when>
					<xsl:when test="name()='gallery'">
						<li>
					            <!--xsl:choose>
					            <xsl:when test="group = 'news'"-->
							<a href="{$LANGROOT}gallery/">Фото и видео</a>&nbsp;&nbsp;>&nbsp;&nbsp;
							<a href="{$LANGROOT}gallery/{mr}/"><xsl:value-of select="name" disable-output-escaping="yes"/></a>
					            <!--/xsl:when>
					            </xsl:choose-->
						</li>
					</xsl:when>
					<xsl:when test="name()='item'">
						<li class="li">
						<a href="{$LANGROOT}catalog/"><xsl:value-of select="/*/inlines/inline[label='text:catalog']/content"/></a>&nbsp;&nbsp;>&nbsp;&nbsp;
				            <xsl:for-each select="parents/parent">
				              <xsl:variable name="fullmr"><xsl:apply-templates select="preceding-sibling::parent" mode="make_mr"/></xsl:variable>
						<a href="{$LANGROOT}catalog/{$fullmr}{mr}/"><xsl:value-of select="name" disable-output-escaping="yes"/></a>&nbsp;&nbsp;>&nbsp;&nbsp;
				            </xsl:for-each>
				              <xsl:variable name="fullmr"><xsl:apply-templates select="parents/parent" mode="make_mr"/></xsl:variable>
						<a href="{$LANGROOT}catalog/{$fullmr}{category_mr}/"><xsl:value-of select="category_name" disable-output-escaping="yes"/></a>&nbsp;&nbsp;>&nbsp;&nbsp;
						<a href="{$LANGROOT}catalog/{$fullmr}{category_mr}/{mr}/"><xsl:value-of select="name" disable-output-escaping="yes"/></a>
						</li>
					</xsl:when>
					<xsl:when test="name()='offer'">
						<li class="li">
						<a href="{/*/system/info/pub_root}offers/"><b>Спецпредложения</b></a>&nbsp;&nbsp;>&nbsp;&nbsp;
						<a href="{/*/system/info/pub_root}offers/{mr}/"><b><xsl:value-of select="name"/></b></a>
						</li>
					</xsl:when>
					<xsl:when test="name()='article'">
						<li class="li">
							<a href="{/*/system/info/pub_root}catalog/technologies/"><xsl:value-of select="/*/inlines/inline[label='text:technologies']/content"/></a>&nbsp;&nbsp;>&nbsp;&nbsp;
							<a href="{/*/system/info/pub_root}catalog/technologies/#{mr}"><xsl:value-of select="name"/></a>
						</li>
					</xsl:when>
					<xsl:when test="name()='vacancies'">
						<li class="li">
							<a href="{/*/system/info/pub_root}vacancies/">Вакансии</a>&nbsp;&nbsp;>&nbsp;&nbsp;
							<a href="{/*/system/info/pub_root}vacancies/#{id}"><xsl:value-of select="name"/></a>
						</li>
					</xsl:when>
					<xsl:otherwise>
						<li class="li">
							<xsl:value-of select="name()"/>
							<xsl:text> </xsl:text>
							<xsl:value-of select="name"/>
						</li>
					</xsl:otherwise>
					</xsl:choose>
					</xsl:for-each>
					</ul>
				</div>
			</xsl:otherwise>
			</xsl:choose>	
</xsl:template>

<xsl:template match="parent" mode="make_mr"><xsl:value-of select="mr"/>/</xsl:template>

<xsl:attribute-set name="attributes_of_body">
	<xsl:attribute name="class">inner</xsl:attribute>
</xsl:attribute-set>	

</xsl:stylesheet>
