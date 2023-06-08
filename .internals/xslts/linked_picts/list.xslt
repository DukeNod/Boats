<?xml version='1.0' encoding='cp1251' ?>
<!DOCTYPE xsl:stylesheet [
	<!ENTITY % HTMLlat1    PUBLIC "-//W3C//ENTITIES Latin 1 for XHTML//EN" "../../dtds/xhtml-lat1.ent"   > %HTMLlat1;
	<!ENTITY % HTMLspecial PUBLIC "-//W3C//ENTITIES Special for XHTML//EN" "../../dtds/xhtml-special.ent"> %HTMLspecial;
	<!ENTITY % HTMLsymbol  PUBLIC "-//W3C//ENTITIES Symbols for XHTML//EN" "../../dtds/xhtml-symbol.ent" > %HTMLsymbol;
]>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:php="http://php.net/xsl">


<xsl:template match="/" mode="overrideable_headers">
<style type="text/css">
	.swfupload {
		position: absolute;
		z-index: 1;
	}
</style>

<script type="text/javascript" src="{/*/system/info/adm_root}js/swfupload/swfupload.js"></script>
<script type="text/javascript" src="{/*/system/info/adm_root}js/swfupload/handlers.js"></script>

</xsl:template>


<xsl:template name="list_of_linked_picts">
	<xsl:param name="node" select="/.."/>
	<xsl:param name="filters"/>
	<xsl:param name="sorters"/>
	<xsl:param name="pager"  />
	<xsl:param name="hide_links" />
	<xsl:param name="form_prefix"/>
	<xsl:param name="uplink_type"/>
	<xsl:param name="uplink_id"  />
	<xsl:param name="limit" select="0"/>

	<xsl:if test="not($hide_links) and ($limit != 1 or count($node/*) = 0)">
		<div class="link">
			<div class="linkCommand">
				<a href="{/*/system/info/adm_root}linked_picts/insert/for/{$uplink_type}/{$uplink_id}?back={/*/system/curr_url}" >
					<img src="{/*/system/info/adm_root}img/buttons/insert0.gif" width="17" height="17" alt="добавить" />
					<span>Добавить изображение</span>
				</a>
			</div>
		</div>
		<xsl:if test="$limit != 1">
		<div class="link">
			<div class="linkCommand">
<script type="text/javascript">
		var uplink_type = '<xsl:value-of select="$uplink_type"/>';
		var uplink_id = '<xsl:value-of select="$uplink_id"/>';
		<![CDATA[

		var swfu;
		window.onload = function () {
			swfu = new SWFUpload({
				// Backend Settings
				upload_url: ADM_ROOT + "linked_picts/upload/for/" + uplink_type + "/" + uplink_id,
				post_params: { "path" : "1"}, // "PHPSESSID": "dc84169d92f2af9fb2eebbc5d797fb1f"},

				// File Upload Settings
				file_size_limit : "",
				file_types : "*.jpg;*.jpeg;*.gif;*.png",
				file_types_description : " Images: jpg; jpeg; gif; png",
				file_upload_limit : 0,

				// Event Handler Settings
				swfupload_preload_handler : preLoad,
				swfupload_load_failed_handler : loadFailed,
				file_queue_error_handler : fileQueueError,
				file_dialog_complete_handler : fileDialogComplete,
				upload_progress_handler : uploadProgress,
				upload_error_handler : uploadError,
				upload_success_handler : uploadSuccess,
				upload_complete_handler : uploadComplete,

				// Button Settings
				//button_image_url : "../modules/Gallery/images/SmallSpyGlassWithTransperancy_17x18.png",
				button_placeholder_id : "spanButtonPlaceholder",
				button_width: 260,
				button_height: 32,
				//button_text : '<span class="button">Select Images <span class="buttonSmall">( Max)</span></span>',
				//button_text_style : '.button { font-family: Helvetica, Arial, sans-serif; font-size: 12pt; } .buttonSmall { font-size: 10pt; }',
				//button_text_top_padding: 0,
				//button_text_left_padding: 18,
				button_window_mode: SWFUpload.WINDOW_MODE.TRANSPARENT,
				button_cursor: SWFUpload.CURSOR.HAND,

				// Flash Settings
				flash_url : ADM_ROOT + "js/swfupload/swfupload.swf",
				flash9_url : ADM_ROOT + "js/swfupload/swfupload_fp9.swf",

				custom_settings : {
					upload_target : "divFileProgressContainer",
					//thumbnail_height: 748,
					//thumbnail_width: 496,
					thumbnail_quality: 100,
					url: ADM_ROOT + "linked_picts/import/for/" + uplink_type + "/" + uplink_id + "?path=1&list=1"
				},

				// Debug Settings
				debug: false
			});
		};
]]></script>
				<div class="pageoverflow">
					  <span id="spanButtonPlaceholder"></span>
					<a href="{/*/system/info/adm_root}linked_picts/import/for/{$uplink_type}/{$uplink_id}?back={/*/system/curr_url}" >
						<img src="{/*/system/info/adm_root}img/buttons/insert0.gif" width="17" height="17" alt="добавить" />
						<span>Добавить несколько изображений</span>
					</a>

				</div>			
				<div class="pageoverflow">
					<div id="divFileProgressContainer"></div>
					<div id="thumbnails">
					</div>
				</div>
			</div>
		</div>
		</xsl:if>
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

		<form class="list" method="post" action="{/*/system/info/adm_root}linked_picts/multi">
		<table class="listBlock">
		<xsl:for-each select="$node/*">
			<xsl:variable name="row" select="2"/>

		<xsl:if test="position()!=1">
			<tr class="listRowSpace"><td class="listCellSpace"></td></tr>
		</xsl:if>
			
			<tr class="listRowLinks">
				<td class="listCellPosition" style="vertical-align: top;"><xsl:value-of select="position"/>.</td>
				<td class="listCellImage">
					<xsl:apply-templates select="." mode="linked_pict">
						<xsl:with-param name="dir" select="concat(/*/system/info/pub_root, 'linked/picts/')"/>
					</xsl:apply-templates>
				</td>
		<xsl:if test="not($hide_links)">
				<td class="listCellLinks">
				<nobr>
					<a href="{/*/system/info/adm_root}linked_picts/update/{id}?back={/*/system/curr_url}">
					<img src="{/*/system/info/adm_root}img/buttons/update{$row}.gif" width="20" height="20" alt="изменить" /></a>
					<br/>
					<a href="{/*/system/info/adm_root}linked_picts/delete/{id}?back={/*/system/curr_url}">
					<img src="{/*/system/info/adm_root}img/buttons/delete{$row}.gif" width="20" height="20" alt="удалить" /></a>
					<xsl:if test="not($limit=1)">
					<br/>
					<xsl:choose>
					<xsl:when test="position&gt;1">
						<a href="{/*/system/info/adm_root}linked_picts/moveup/{id}?back={/*/system/curr_url}">
						<img src="{/*/system/info/adm_root}img/buttons/moveup{$row}.gif" width="20" height="20" alt="вверх" /></a>
					</xsl:when>
					<xsl:otherwise>
						<img src="{/*/system/info/adm_root}img/buttons/moveup{$row}_.gif" width="20" height="20" alt="" />
					</xsl:otherwise>
					</xsl:choose>
					<br/>
					<xsl:choose>
					<xsl:when test="position&lt;count($node/*)">
	        				<a href="{/*/system/info/adm_root}linked_picts/movedn/{id}?back={/*/system/curr_url}">
						<img src="{/*/system/info/adm_root}img/buttons/movedn{$row}.gif" width="20" height="20" alt="вниз" /></a>
					</xsl:when>
					<xsl:otherwise>
						<img src="{/*/system/info/adm_root}img/buttons/movedn{$row}_.gif" width="20" height="20" alt="" />
					</xsl:otherwise>
					</xsl:choose>
					</xsl:if>
					<br/>
	                        </nobr>
				</td>
		</xsl:if>
				<td class="listCellData">
					<xsl:value-of select="alt" disable-output-escaping="yes"/>
				</td>
			</tr>
		</xsl:for-each>
		</table>
		</form>
	</xsl:when>
	<xsl:otherwise>
		<div class="list listEmpty">Сейчас нет ни одного изображения.</div>
	</xsl:otherwise>
	</xsl:choose>

</xsl:template>


</xsl:stylesheet>
