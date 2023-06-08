<?xml version='1.0' encoding='cp1251' ?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:php="http://php.net/xsl">



<!--
Шаблоны для обработки и форматирования изображений (linked_picts).
Речь об обычном выводе и форматировании в публичной части,
а не о форматировании для таблично-системного администрирования.

Тут мы используем push-модель XSLT-процессинга, потому что так удобнее,
нежели заводить кучу именованных шаблонов и вызывать их с аргументами.

Передача uplink_type/uplink_id (для разных каталогов с картинками) в основной шаблон пока
заготовлена, но  реально не используется, потому что у нас сейчас все картинки складываются
в одну папку без деления по аплинкам. Это временное; когда-нибудь деление будет сделано.
-->



<!--
Когда запрашивается обработка целого блока картинок, это должно выглядеть точно так же,
как если бы запросили обработку каждой картинки в нём. Потому что не должно быть никаких
форматирований (стилей), зависящих от того, находится ли картинка в блоке таких же,
или идёт сама по себе (например, при ручной эмуляции).
NB: Учесть, что сюда параметры не принимаются, и в главный шаблон не передаются. Это всего лишь alias.
-->
<xsl:template match="linked_picts">
	<xsl:param name="dir" select="concat(/*/system/info/pub_root, 'linked/picts/')"/>
	<xsl:apply-templates select="linked_pict">
		<xsl:with-param name="dir" select="$dir"/>
	</xsl:apply-templates>
</xsl:template>



<!--
Прямой шаблон (по чёткому имени элемента) для форматирования элемента картинки без указания режима
(который требуется для основного шаблона; см. ниже). То есть для вообще любого элемента мы можем
указать режим, и оформить этот элемент как картинку; но когда у нас и так картинка, указывать режим
нет никакого смысла; этот шаблон как раз для краткого применения форматирования заведомо картинок.
NB: Учесть, что сюда параметры не принимаются, и в главный шаблон не передаются. Это всего лишь alias.
-->
<xsl:template match="linked_pict">
	<xsl:param name="dir" select="concat(/*/system/info/pub_root, 'linked/picts/')"/>
	<xsl:apply-templates select="linked_pict">
		<xsl:with-param name="dir" select="$dir"/>
	</xsl:apply-templates>
</xsl:template>



<!--
Основной шаблон для обработки чего угодно, что похоже на картиинку и может быть соответствующе обработано
(то есть любой элемент, который полностью или частично представлен нужным набором полей).

Все критерии, влияющие на форматирование картинки, вынесены в параметры, что позволяет при необходимости
некоторые из них принудительно перекрыть при вызове шаблона (например, спрятать маленькую или большую картинки).
Полезный побочный эффект - можно сделать <xsl:apply-templates select="/" mode="linked_pict"/>,
а в параметрах указать ему все нужные для форматирования значения; это будет полная эмуляция картинки с нуля.

Намеренно не использованы именованные шаблоны, так как основной ориентир идёт именно на PUSH-модель
применительно к действительно элементам картинок, а всё остальное позволяется лишь как следствие.
-->
<xsl:template match="*" mode="linked_pict">
	<xsl:param name="dir"		select="concat(/*/system/info/pub_root, 'linked/picts/')"/>
	<xsl:param name="uplink_type"	select="uplink_type"/>
	<xsl:param name="uplink_id"	select="uplink_id"  />
	<xsl:param name="alt"		select="alt"        />
	<xsl:param name="def"		select="name"       />
	<xsl:param name="small_file"	select="small_file" />
	<xsl:param name="small_w"	select="small_w"    />
	<xsl:param name="small_h"	select="small_h"    />
	<xsl:param name="large_file"	select="large_file" />
	<xsl:param name="large_w"	select="large_w"    />
	<xsl:param name="large_h"	select="large_h"    />
	<xsl:param name="href"		/>
	<xsl:param name="popup"		select="string($href)=''"/>
	<xsl:param name="blank"		select="$popup"/>
	<xsl:param name="id"		/>
	<xsl:param name="rel"		/>
	<xsl:param name="class"		/>
	<xsl:param name="aclass"	/>
	<xsl:param name="style"		/>
	<xsl:param name="onClick"	/>
	<xsl:param name="onDblClick"	/>
	<xsl:param name="onMouseOver"	/>
	<xsl:param name="onMouseOut"	/>

	<xsl:variable name="alt_real">
		<xsl:choose>
		<xsl:when test="string($alt)!=''"><xsl:value-of select="$alt"/></xsl:when>
		<xsl:otherwise><xsl:value-of select="$def"/></xsl:otherwise>
		</xsl:choose>
	</xsl:variable>

	<xsl:variable name="href_real">
		<xsl:choose>
		<xsl:when test="string($href)!=''"><xsl:value-of select="$href"/></xsl:when>
		<xsl:otherwise><xsl:if test="string($large_file)!=''"><xsl:value-of select="concat($dir, 'large/', $uplink_type, '/', $uplink_id, '/', $large_file)"/></xsl:if></xsl:otherwise>
		</xsl:choose>
	</xsl:variable>

	<xsl:choose>
	<xsl:when test="$small_file!='' and $href_real!=''">
		<a href="{$href_real}">
			<xsl:if test="$blank"><xsl:attribute name="target">_blank</xsl:attribute></xsl:if>
			<xsl:if test="$popup"><xsl:attribute name="onClick">return smart_image_popup('<xsl:value-of select="$href_real"/>', '<xsl:value-of select="$large_w"/>', '<xsl:value-of select="$large_h"/>')</xsl:attribute></xsl:if>
			<xsl:if test="$aclass"><xsl:attribute name="class"><xsl:value-of select="$aclass"/></xsl:attribute></xsl:if>
			<xsl:if test="$rel"><xsl:attribute name="rel"><xsl:value-of select="$rel"/></xsl:attribute></xsl:if>
			<xsl:call-template name="media">
				<xsl:with-param name="src"		select="concat($dir, 'small/', $uplink_type, '/', $uplink_id, '/', $small_file)"/>
				<xsl:with-param name="w"		select="$small_w"/>
				<xsl:with-param name="h"		select="$small_h"/>
				<xsl:with-param name="alt"		select="$alt_real"/>
				<xsl:with-param name="title"		select="$alt_real"/>
				<xsl:with-param name="id"		select="$id"/>
				<xsl:with-param name="class"		select="$class"/>
				<xsl:with-param name="style"		select="$style"/>
				<xsl:with-param name="onClick"		select="$onClick"/>
				<xsl:with-param name="onDblClick"	select="$onDblClick"/>
				<xsl:with-param name="onMouseOver"	select="$onMouseOver"/>
				<xsl:with-param name="onMouseOut"	select="$onMouseOut"/>
			</xsl:call-template>
		</a>
	</xsl:when>
	<xsl:when test="$small_file!=''">
			<xsl:call-template name="media">
				<xsl:with-param name="src"		select="concat($dir, 'small/', $uplink_type, '/', $uplink_id, '/', $small_file)"/>
				<xsl:with-param name="w"		select="$small_w"/>
				<xsl:with-param name="h"		select="$small_h"/>
				<xsl:with-param name="alt"		select="$alt_real"/>
				<xsl:with-param name="title"		select="$alt_real"/>
				<xsl:with-param name="id"		select="$id"/>
				<xsl:with-param name="class"		select="$class"/>
				<xsl:with-param name="style"		select="$style"/>
				<xsl:with-param name="onClick"		select="$onClick"/>
				<xsl:with-param name="onDblClick"	select="$onDblClick"/>
				<xsl:with-param name="onMouseOver"	select="$onMouseOver"/>
				<xsl:with-param name="onMouseOut"	select="$onMouseOut"/>
			</xsl:call-template>
	</xsl:when>
	<xsl:when test="$large_file!='' and $href_real!=''">
		<a href="{$href_real}">
			<xsl:if test="$blank"><xsl:attribute name="target">_blank</xsl:attribute></xsl:if>
			<xsl:if test="$popup"><xsl:attribute name="onClick">return smart_image_popup('<xsl:value-of select="$href_real"/>', '<xsl:value-of select="$large_w"/>', '<xsl:value-of select="$large_h"/>')</xsl:attribute></xsl:if>
			<xsl:call-template name="media">
				<xsl:with-param name="src"		select="concat($dir, 'large/', $uplink_type, '/', $uplink_id, '/', $large_file)"/>
				<xsl:with-param name="w"		select="$large_w"/>
				<xsl:with-param name="h"		select="$large_h"/>
				<xsl:with-param name="alt"		select="$alt_real"/>
				<xsl:with-param name="title"		select="$alt_real"/>
				<xsl:with-param name="id"		select="$id"/>
				<xsl:with-param name="class"		select="$class"/>
				<xsl:with-param name="style"		select="$style"/>
				<xsl:with-param name="onClick"		select="$onClick"/>
				<xsl:with-param name="onDblClick"	select="$onDblClick"/>
				<xsl:with-param name="onMouseOver"	select="$onMouseOver"/>
				<xsl:with-param name="onMouseOut"	select="$onMouseOut"/>
			</xsl:call-template>
		</a>
	</xsl:when>
	<xsl:when test="$large_file!=''">
			<xsl:call-template name="media">
				<xsl:with-param name="src"		select="concat($dir, 'large/', $uplink_type, '/', $uplink_id, '/', $large_file)"/>
				<xsl:with-param name="w"		select="$large_w"/>
				<xsl:with-param name="h"		select="$large_h"/>
				<xsl:with-param name="alt"		select="$alt_real"/>
				<xsl:with-param name="title"		select="$alt_real"/>
				<xsl:with-param name="id"		select="$id"/>
				<xsl:with-param name="class"		select="$class"/>
				<xsl:with-param name="style"		select="$style"/>
				<xsl:with-param name="onClick"		select="$onClick"/>
				<xsl:with-param name="onDblClick"	select="$onDblClick"/>
				<xsl:with-param name="onMouseOver"	select="$onMouseOver"/>
				<xsl:with-param name="onMouseOut"	select="$onMouseOut"/>
			</xsl:call-template>
	</xsl:when>
	</xsl:choose>
</xsl:template>


<xsl:template match="*" mode="linked_pict_middle">
	<xsl:param name="dir"		select="concat(/*/system/info/pub_root, 'linked/picts/')"/>
	<xsl:param name="uplink_type"	select="uplink_type"/>
	<xsl:param name="uplink_id"	select="uplink_id"  />
	<xsl:param name="alt"		select="alt"        />
	<xsl:param name="def"		select="name"       />
	<xsl:param name="small_file"	select="middle_file" />
	<xsl:param name="small_w"	select="middle_w"    />
	<xsl:param name="small_h"	select="middle_h"    />
	<xsl:param name="large_file"	select="large_file" />
	<xsl:param name="large_w"	select="large_w"    />
	<xsl:param name="large_h"	select="large_h"    />
	<xsl:param name="href"		/>
	<xsl:param name="popup"		select="string($href)=''"/>
	<xsl:param name="blank"		select="$popup"/>
	<xsl:param name="id"		/>
	<xsl:param name="rel"		/>
	<xsl:param name="class"		/>
	<xsl:param name="aclass"	/>
	<xsl:param name="style"		/>
	<xsl:param name="onClick"	/>
	<xsl:param name="onDblClick"	/>
	<xsl:param name="onMouseOver"	/>
	<xsl:param name="onMouseOut"	/>

	<xsl:variable name="alt_real">
		<xsl:choose>
		<xsl:when test="string($alt)!=''"><xsl:value-of select="$alt"/></xsl:when>
		<xsl:otherwise><xsl:value-of select="$def"/></xsl:otherwise>
		</xsl:choose>
	</xsl:variable>

	<xsl:variable name="href_real">
		<xsl:choose>
		<xsl:when test="string($href)!=''"><xsl:value-of select="$href"/></xsl:when>
		<xsl:otherwise><xsl:if test="string($large_file)!=''"><xsl:value-of select="concat($dir, 'large/', $uplink_type, '/', $uplink_id, '/', $large_file)"/></xsl:if></xsl:otherwise>
		</xsl:choose>
	</xsl:variable>

	<xsl:choose>
	<xsl:when test="$small_file!='' and $href_real!=''">
		<a href="{$href_real}">
			<xsl:if test="$blank"><xsl:attribute name="target">_blank</xsl:attribute></xsl:if>
			<xsl:if test="$popup"><xsl:attribute name="onClick">return smart_image_popup('<xsl:value-of select="$href_real"/>', '<xsl:value-of select="$large_w"/>', '<xsl:value-of select="$large_h"/>')</xsl:attribute></xsl:if>
			<xsl:if test="$aclass"><xsl:attribute name="class"><xsl:value-of select="$aclass"/></xsl:attribute></xsl:if>
			<xsl:if test="$rel"><xsl:attribute name="rel"><xsl:value-of select="$rel"/></xsl:attribute></xsl:if>
			<xsl:call-template name="media">
				<xsl:with-param name="src"		select="concat($dir, 'middle/', $uplink_type, '/', $uplink_id, '/', $small_file)"/>
				<xsl:with-param name="w"		select="$small_w"/>
				<xsl:with-param name="h"		select="$small_h"/>
				<xsl:with-param name="alt"		select="$alt_real"/>
				<xsl:with-param name="title"		select="$alt_real"/>
				<xsl:with-param name="id"		select="$id"/>
				<xsl:with-param name="class"		select="$class"/>
				<xsl:with-param name="style"		select="$style"/>
				<xsl:with-param name="onClick"		select="$onClick"/>
				<xsl:with-param name="onDblClick"	select="$onDblClick"/>
				<xsl:with-param name="onMouseOver"	select="$onMouseOver"/>
				<xsl:with-param name="onMouseOut"	select="$onMouseOut"/>
			</xsl:call-template>
		</a>
	</xsl:when>
	<xsl:when test="$small_file!=''">
			<xsl:call-template name="media">
				<xsl:with-param name="src"		select="concat($dir, 'middle/', $uplink_type, '/', $uplink_id, '/', $small_file)"/>
				<xsl:with-param name="w"		select="$small_w"/>
				<xsl:with-param name="h"		select="$small_h"/>
				<xsl:with-param name="alt"		select="$alt_real"/>
				<xsl:with-param name="title"		select="$alt_real"/>
				<xsl:with-param name="id"		select="$id"/>
				<xsl:with-param name="class"		select="$class"/>
				<xsl:with-param name="style"		select="$style"/>
				<xsl:with-param name="onClick"		select="$onClick"/>
				<xsl:with-param name="onDblClick"	select="$onDblClick"/>
				<xsl:with-param name="onMouseOver"	select="$onMouseOver"/>
				<xsl:with-param name="onMouseOut"	select="$onMouseOut"/>
			</xsl:call-template>
	</xsl:when>
	<xsl:when test="$large_file!='' and $href_real!='' and (($lagre_w &gt; $small_w) or ($lagre_h &gt; $small_h))">
		<a href="{$href_real}">
			<xsl:if test="$blank"><xsl:attribute name="target">_blank</xsl:attribute></xsl:if>
			<xsl:if test="$popup"><xsl:attribute name="onClick">return smart_image_popup('<xsl:value-of select="$href_real"/>', '<xsl:value-of select="$large_w"/>', '<xsl:value-of select="$large_h"/>')</xsl:attribute></xsl:if>
			<xsl:call-template name="media">
				<xsl:with-param name="src"		select="concat($dir, 'large/', $uplink_type, '/', $uplink_id, '/', $large_file)"/>
				<xsl:with-param name="w"		select="$large_w"/>
				<xsl:with-param name="h"		select="$large_h"/>
				<xsl:with-param name="alt"		select="$alt_real"/>
				<xsl:with-param name="title"		select="$alt_real"/>
				<xsl:with-param name="id"		select="$id"/>
				<xsl:with-param name="class"		select="$class"/>
				<xsl:with-param name="style"		select="$style"/>
				<xsl:with-param name="onClick"		select="$onClick"/>
				<xsl:with-param name="onDblClick"	select="$onDblClick"/>
				<xsl:with-param name="onMouseOver"	select="$onMouseOver"/>
				<xsl:with-param name="onMouseOut"	select="$onMouseOut"/>
			</xsl:call-template>
		</a>
	</xsl:when>
	<xsl:when test="$large_file!=''">
			<xsl:call-template name="media">
				<xsl:with-param name="src"		select="concat($dir, 'large/', $uplink_type, '/', $uplink_id, '/', $large_file)"/>
				<xsl:with-param name="w"		select="$large_w"/>
				<xsl:with-param name="h"		select="$large_h"/>
				<xsl:with-param name="alt"		select="$alt_real"/>
				<xsl:with-param name="title"		select="$alt_real"/>
				<xsl:with-param name="id"		select="$id"/>
				<xsl:with-param name="class"		select="$class"/>
				<xsl:with-param name="style"		select="$style"/>
				<xsl:with-param name="onClick"		select="$onClick"/>
				<xsl:with-param name="onDblClick"	select="$onDblClick"/>
				<xsl:with-param name="onMouseOver"	select="$onMouseOver"/>
				<xsl:with-param name="onMouseOut"	select="$onMouseOut"/>
			</xsl:call-template>
	</xsl:when>
	</xsl:choose>
</xsl:template>


</xsl:stylesheet>
