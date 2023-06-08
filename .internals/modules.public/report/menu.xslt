<?xml version="1.0" encoding="cp1251" ?>
<!DOCTYPE xsl:stylesheet [
        <!ENTITY % HTMLlat1    PUBLIC "-//W3C//ENTITIES Latin 1 for XHTML//EN" "../../dtds/xhtml-lat1.ent"   > %HTMLlat1;
        <!ENTITY % HTMLspecial PUBLIC "-//W3C//ENTITIES Special for XHTML//EN" "../../dtds/xhtml-special.ent"> %HTMLspecial;
        <!ENTITY % HTMLsymbol  PUBLIC "-//W3C//ENTITIES Symbols for XHTML//EN" "../../dtds/xhtml-symbol.ent" > %HTMLsymbol;
        ]>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:php="http://php.net/xsl">

    <xsl:template match="/" mode="global_left_menu">report</xsl:template>

    <xsl:template name="report_menu" >
        <xsl:param name="curr_page"/>

	<xsl:if test="/*/identity /consumer/roles/role = 'admin'">
        <ul class="nav nav-tabs">

				<li title="" rel="" class="icon index_collection_link">
					<!--xsl:if test="$curr_page = 'report_active'"-->
					<xsl:if test="/*/filters/*[name='client']/value = '' and $curr_page = ''">
						<xsl:attribute name="class">active</xsl:attribute>
					</xsl:if>
					<a class="pjax" href="{/*/system/info/pub_root}report/">
						<i class="icon-th-list"></i>
						<span>Активные договоры</span>
					</a>
				</li>
				
				<li title="" rel="" class="icon index_collection_link">
					<xsl:if test="/*/filters/*[name='client']/value = 'all'">
					<!--xsl:if test="$curr_page = 'report_all'"-->
						<xsl:attribute name="class">active</xsl:attribute>
					</xsl:if>
					<a class="pjax" href="{/*/system/info/pub_root}report/?filter_client=all">
						<i class="icon-th-list"></i>
						<span>Все договоры</span>
					</a>
				</li>

				<li title="" rel="" class="icon index_collection_link">
					<xsl:if test="$curr_page = 'sales'">
						<xsl:attribute name="class">active</xsl:attribute>
					</xsl:if>
					<a class="pjax" href="{/*/system/info/pub_root}report/sales">
						<i class="icon-th-list"></i>
						<span>Отчет по продажам</span>
					</a>
				</li>

        </ul>
       </xsl:if>
    </xsl:template>

</xsl:stylesheet>