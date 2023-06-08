<?xml version="1.0" encoding="cp1251" ?>
<!DOCTYPE xsl:stylesheet [
	<!ENTITY % HTMLlat1    PUBLIC "-//W3C//ENTITIES Latin 1 for XHTML//EN" "../../dtds/xhtml-lat1.ent"   > %HTMLlat1;
	<!ENTITY % HTMLspecial PUBLIC "-//W3C//ENTITIES Special for XHTML//EN" "../../dtds/xhtml-special.ent"> %HTMLspecial;
	<!ENTITY % HTMLsymbol  PUBLIC "-//W3C//ENTITIES Symbols for XHTML//EN" "../../dtds/xhtml-symbol.ent" > %HTMLsymbol;
]>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">

<xsl:output
	method="xml" 
	encoding="UTF-8"
	indent="yes"
/>

<xsl:variable name="pub_site">http://www.barybina.ru/</xsl:variable>

<xsl:template match="/">
<urlset xmlns="http://www.sitemaps.org/schemas/sitemap/0.9" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xsi:schemaLocation="http://www.sitemaps.org/schemas/sitemap/0.9 http://www.sitemaps.org/schemas/sitemap/0.9/sitemap.xsd">
   <url>
      <loc><xsl:value-of select="$pub_site"/></loc>
      <changefreq>daily</changefreq>
      <priority>0.8</priority>
   </url>

	<xsl:apply-templates  select="/*/pages/page[mr!='404' and mr!='index']" mode="map_page_item"/>
	<xsl:for-each select="/*/gpages/gallery">
	<url xmlns="http://www.sitemaps.org/schemas/sitemap/0.9">
		<loc><xsl:value-of select="concat($pub_site, 'gallery/', mr, '/')"/></loc>
		<changefreq>daily</changefreq>
		<priority>0.6</priority>
	</url>
	</xsl:for-each>
	
	<xsl:for-each select="/*/nlist/news">
	<url xmlns="http://www.sitemaps.org/schemas/sitemap/0.9">
		<loc><xsl:value-of select="concat($pub_site, 'news/', id, '/')"/></loc>
		<changefreq>daily</changefreq>
		<priority>0.6</priority>
	</url>
	</xsl:for-each>
	
	<xsl:for-each select="/*/alist/action">
	<url xmlns="http://www.sitemaps.org/schemas/sitemap/0.9">
		<loc><xsl:value-of select="concat($pub_site, 'actions/', id, '/')"/></loc>
		<changefreq>daily</changefreq>
		<priority>0.6</priority>
	</url>
	</xsl:for-each>
</urlset>
</xsl:template>

<xsl:template  match="*" mode="map_page_item">
<!--	<xsl:param name="level" select="1"/>
	<xsl:param name="url" select="''"/>

	<xsl:variable name="mr" select="concat($url, mr, '/')"/>
	
	
	<xsl:choose>
	<xsl:when test="$url = concat(mr, '/')">
		<xsl:if test="category_tree/*">
		<xsl:for-each select="category_tree/page">
			<xsl:apply-templates  select="page" mode="map_page_item">
				<xsl:with-param name="level" select="$level"/>
				<xsl:with-param name="url" select="$url"/>
			</xsl:apply-templates>
		</xsl:for-each>
		</xsl:if>
	</xsl:when>
	<xsl:otherwise>
		   <url xmlns="http://www.sitemaps.org/schemas/sitemap/0.9">
		      <loc><xsl:value-of select="concat($pub_site, $mr)"/></loc>
		      <changefreq>daily</changefreq>
		      <priority>0.6</priority>
		   </url>
	</xsl:otherwise>
	</xsl:choose>-->
	<url xmlns="http://www.sitemaps.org/schemas/sitemap/0.9">
		    <loc><xsl:value-of select="concat($pub_site, mr, '/')"/></loc>
		    <changefreq>daily</changefreq>
		    <priority>0.6</priority>
	</url>
	<xsl:for-each select="category_tree/page">
		<url xmlns="http://www.sitemaps.org/schemas/sitemap/0.9">
		    <loc><xsl:value-of select="concat($pub_site, mr, '/')"/></loc>
		    <changefreq>daily</changefreq>
		    <priority>0.6</priority>
		 </url>
	</xsl:for-each>
</xsl:template>

</xsl:stylesheet>
