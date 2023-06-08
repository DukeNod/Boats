<?xml version='1.0' encoding='cp1251' ?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:php="http://php.net/xsl">



<!--
Шаблоны для обработки и форматирования параграфов (linked_paras).
Речь об обычном текстовом форматировании в публичной части,
а не о форматировании для таблично-системного администрирования.

Тут мы используем push-модель XSLT-процессинга, потому что так удобнее,
нежели заводить кучу именованных шаблонов и вызывать их с аргументами.

Передача uplink_type/uplink_id (для разных каталогов с картинками) в основной шаблон пока
заготовлена, но  реально не используется, потому что у нас сейчас все картинки складываются
в одну папку без деления по аплинкам. Это временное; когда-нибудь деление будет сделано.
-->



<!--
Когда запрашивается обработка целого блока параграфов, это должно выглядеть точно так же,
как если бы запросили обработку каждого параграфа в нём. Потому что не должно быть никаких
форматирований (стилей), зависящих от того, находится ли параграф в блоке таких же,
или идёт сам по себе (например, при ручной эмуляции параграфа).
NB: Учесть, что сюда параметры не принимаются, и в главный шаблон не передаются. Это всего лишь alias.
-->
<xsl:template match="linked_paras">
	<xsl:param name="dir" select="concat(/*/system/info/pub_root, 'linked/paras/')"/>
	<xsl:apply-templates select="linked_para">
		<xsl:with-param name="dir" select="$dir"/>
	</xsl:apply-templates>
</xsl:template>



<!--
Прямой шаблон (по чёткому имени элемента) для форматирования элемента параграфа без указания режима
(который требуется для основного шаблона; см. ниже). То есть для вообще любого элемента мы может
указать режим, и оформить этот элемент как параграф; но когда у нас и так параграф, указывать режим
нет никакого смысла; этот шаблон как раз для краткого применения форматирования заведомо параграфов.
NB: Учесть, что сюда параметры не принимаются, и в главный шаблон не передаются. Это всего лишь alias.
-->
<xsl:template match="linked_para">
	<xsl:param name="dir" select="concat(/*/system/info/pub_root, 'linked/paras/')"/>
	<xsl:apply-templates select="." mode="linked_para">
		<xsl:with-param name="dir" select="$dir"/>
	</xsl:apply-templates>
</xsl:template>



<!--
Основной шаблон для обработки чего угодно, что похоже на параграф и может быть соответствующе обработано
(то есть любой элемент, который полностью или частично представлен нужным набором полей).
Такой шаблон нужен для аналогии с обработкой картинки, в которой в качестве картинки может
быть оформлен любой элемент, который представлен как картинка (в том числе и параграф).

Все критерии, влияющие на форматирование параграфа, вынесены в параметры, что позволяет при необходимости
некоторые из них принудительно перекрыть при вызове шаблона (например, спрятать обе картинки).
Полезный побочный эффект - можно сделать <xsl:apply-templates select="/" mode="linked_para"/>,
а в параметрах указать ему все нужные для форматирования значения; это будет полная эмуляция параграфа с нуля.

Намеренно не использованы именованные шаблоны, так как основной ориентир идёт именно на PUSH-модель
применительно к действительно элементам параграфов, а всё остальное позволяется лишь как следствие.

Намеренно не выносим оформление текстов и картинок в отдельные шаблоны, так как по отдельности они
никогда не используются, а краткости это не прибавит из-за необходмости передавать к ним все параметры.

Внутренняя структура текстовой части (точнее, теги для имени и самого текста) определяются нуждами SEO.
Итоговая структура любого параграфа может получиться примерно такой (css-селекторами):
	div.para(+атрибуты)  div.paraPict {a img, a, img}
	div.para(+атрибуты)  div.paraText {h3, p, p p, ul, p ul, etc}
либо (когда атрибут float равен table_*):
	div.para(+атрибуты)  table.paraGrid tr.paraGrid td.paraGrid.paraImage  div.paraPict {a img, a, img}
	div.para(+атрибуты)  table.paraGrid tr.paraGrid td.paraGrid.paraTexts  div.paraText {h3, p, p p, ul, p ul, etc}
-->
<xsl:template match="*" mode="linked_para">
	<xsl:param name="dir"		select="concat(/*/system/info/pub_root, 'linked/paras/')"/>
	<xsl:param name="uplink_type"	select="uplink_type"/>
	<xsl:param name="uplink_id"	select="uplink_id"  />
	<xsl:param name="clear"		select="clear"      />
	<xsl:param name="align"		select="align"      />
	<xsl:param name="float"		select="float"      />
	<xsl:param name="alt"		select="alt"        />
	<xsl:param name="name"		select="name"       />
	<xsl:param name="text"		select="text"       />
	<xsl:param name="url"		select="url"       />
	<xsl:param name="small_file"	select="small_file" />
	<xsl:param name="small_w"	select="small_w"    />
	<xsl:param name="small_h"	select="small_h"    />
	<xsl:param name="large_file"	select="large_file" />
	<xsl:param name="large_w"	select="large_w"    />
	<xsl:param name="large_h"	select="large_h"    />

	<!-- Любой параграф - это всегда один div с несколькими приписанными ему классами. -->
	<div>
			<!-- Стандартный и неизменный класс, определяющий параграф. -->
		<xsl:attribute name="class">
			<xsl:text>para</xsl:text>
		</xsl:attribute>
	<div>
		<!-- Форматирующие атрибуты параграфа преобразуем в классы по определённой системе именования. -->
		<xsl:attribute name="class">

			<!-- Классификация по типу и наличию содержимого. -->
			<!--xsl:choose>
			<xsl:when test="string($name)='' and string($text)='' and string($small_file)='' and string($large_file)=''">paraContentEmpty</xsl:when>
			<xsl:when test="string($name)='' and string($text)=''                                                      ">paraContentPictOnly</xsl:when>
			<xsl:when test="                                          string($small_file)='' and string($large_file)=''">paraContentTextOnly</xsl:when>
			<xsl:otherwise                                                                                              >paraContentNormal</xsl:otherwise>
			</xsl:choose>
			<xsl:text> </xsl:text-->

			<!-- Классификация по режиму сброса обтеканий. -->
			<xsl:choose>
			<xsl:when test="string($clear)='left' ">paraClearLeft</xsl:when>
			<xsl:when test="string($clear)='right'">paraClearRight</xsl:when>
			<xsl:when test="string($clear)='both' ">paraClearBoth</xsl:when>
			<xsl:when test="string($clear)='none' ">paraClearNone</xsl:when>
			<xsl:otherwise                         >paraClearUnknown</xsl:otherwise>
			</xsl:choose>
			<xsl:text> </xsl:text>

			<!-- Классификация по выравниванию текста. -->
			<xsl:choose>
			<xsl:when test="string($align)='left'   ">paraAlignLeft</xsl:when>
			<xsl:when test="string($align)='right'  ">paraAlignRight</xsl:when>
			<xsl:when test="string($align)='center' ">paraAlignCenter</xsl:when>
			<xsl:when test="string($align)='justify'">paraAlignJustify</xsl:when>
			<xsl:otherwise                           >paraAlignUnknown</xsl:otherwise>
			</xsl:choose>
			<xsl:text> </xsl:text>

			<!-- Классификация по расположению картинки. -->
			<xsl:choose>
			<xsl:when test="string($float)='above_center'">paraFloatAboveCenter</xsl:when>
			<xsl:when test="string($float)='above_left'  ">paraFloatAboveLeft</xsl:when>
			<xsl:when test="string($float)='above_right' ">paraFloatAboveRight</xsl:when>
			<xsl:when test="string($float)='below_center'">paraFloatBelowCenter</xsl:when>
			<xsl:when test="string($float)='below_left'  ">paraFloatBelowLeft</xsl:when>
			<xsl:when test="string($float)='below_right' ">paraFloatBelowRight</xsl:when>
			<xsl:when test="string($float)='float_left'  ">paraFloatFloatLeft</xsl:when>
			<xsl:when test="string($float)='float_right' ">paraFloatFloatRight</xsl:when>
			<xsl:when test="string($float)='table_left'  ">paraFloatTableLeft</xsl:when>
			<xsl:when test="string($float)='table_right' ">paraFloatTableRight</xsl:when>
			<!--!!! deprecated. use table_left, table_right, above_center, below_center: -->
			<!--xsl:when test="string($float)='strict_left' ">paraFloatTable paraFloatLeft   paraFloatTableLeft  </xsl:when>
			<xsl:when test="string($float)='strict_right'">paraFloatTable paraFloatRight  paraFloatTableRight </xsl:when>
			<xsl:when test="string($float)='center_above'">paraFloatAbove paraFloatCenter paraFloatAboveCenter</xsl:when>
			<xsl:when test="string($float)='center_below'">paraFloatBelow paraFloatCenter paraFloatBelowCenter</xsl:when-->
			<xsl:otherwise                                >paraFloatUnknown</xsl:otherwise>
			</xsl:choose>
			<xsl:text> </xsl:text>

		</xsl:attribute>

		<!-- Содержимое параграфа формируем и форматируем в соответствии с атрибутами, но уже без приписывания классов. -->
		<!-- По сути здесь только некоторые разные раскладки тегов, наиболее удобные для тех или иных форматирований. -->
		<!--!!!	SQL для обновления проектов под новую модель:
			alter table `linked_paras` modify column `float` enum('above_center','above_left','above_right','below_center','below_left','below_right','float_left','float_right','table_left','table_right','center_above','center_below', 'strict_left', 'strict_right');
			update `linked_paras` set `float` = 'above_center' where `float` = 'center_above';
			update `linked_paras` set `float` = 'below_center' where `float` = 'center_below';
			update `linked_paras` set `float` = 'table_left'   where `float` = 'strict_left' ;
			update `linked_paras` set `float` = 'table_right'  where `float` = 'strict_right';
			alter table `linked_paras` modify column `float` enum('above_center','above_left','above_right','below_center','below_left','below_right','float_left','float_right','table_left','table_right');
		-->
		<xsl:variable name="img_alt">
			<xsl:choose>
				<xsl:when test="$name!=''">
					<xsl:value-of select="$name" disable-output-escaping="yes"/>
				</xsl:when>
				<xsl:otherwise>
					<xsl:value-of select="$alt" disable-output-escaping="yes"/>
				</xsl:otherwise>
			</xsl:choose>
		</xsl:variable>
		<xsl:choose>
		<!-- В случае расположения колонкой без обтекания, вынужденно используем вёрстку таблицей (слоями не получилось). -->
		<!--!!! deprecated: strict_left, strict_right -->
		<!--xsl:when test="string($float)='table_left' or string($float)='strict_left'">
			<table class="paraGrid"><tr class="paraGrid">
			<td class="paraGrid paraImage">
				<xsl:if test="string($small_file)!='' or string($large_file)!=''">
					<div class="paraPict">
						<xsl:apply-templates select="." mode="linked_pict"><xsl:with-param name="dir" select="$dir"/><xsl:with-param name="def" select="$name"/></xsl:apply-templates>
					</div>
				</xsl:if>
			</td>
			<td class="paraGrid paraTexts">
				<xsl:if test="string($name)!='' or string($text)!=''">
					<div class="paraText">
						<xsl:if test="string($name)!=''"><h3><xsl:value-of select="$name" disable-output-escaping="yes"/></h3></xsl:if>
						<xsl:if test="string($text)!=''"><p ><xsl:value-of select="$text" disable-output-escaping="yes"/></p ></xsl:if>
					</div>
				</xsl:if>
			</td>
			</tr></table>
		</xsl:when>
		<xsl:when test="string($float)='table_right' or string($float)='strict_right'">
			<table class="paraGrid"><tr class="paraGrid">
			<td class="paraGrid paraTexts">
				<xsl:if test="string($name)!='' or string($text)!=''">
					<div class="paraText">
						<xsl:if test="string($name)!=''"><h3><xsl:value-of select="$name" disable-output-escaping="yes"/></h3></xsl:if>
						<xsl:if test="string($text)!=''"><p ><xsl:value-of select="$text" disable-output-escaping="yes"/></p ></xsl:if>
					</div>
				</xsl:if>
			</td>
			<td class="paraGrid paraImage">
				<xsl:if test="string($small_file)!='' or string($large_file)!=''">
					<div class="paraPict">
						<xsl:apply-templates select="." mode="linked_pict"><xsl:with-param name="dir" select="$dir"/><xsl:with-param name="def" select="$name"/></xsl:apply-templates>
					</div>
				</xsl:if>
			</td>
			</tr></table>
		</xsl:when-->
		<!-- Под вариант "тексты-картинка" подпадает только несколько режимов форматирования, где картинка идёт снизу. -->
		<!--!!! deprecated: center_below -->
		<!--xsl:when test="string($float)='below_center' or string($float)='below_left' or string($float)='below_right' or string($float)='center_below'"-->
		<xsl:when test="string($float)='below_center' or string($float)='below_left' or string($float)='below_right' or string($float)='center_below'"> <!--  or string($float)='table_right' or string($float)='strict_right' -->
			<xsl:if test="string($name)!=''">
					<h4><xsl:value-of select="$name" disable-output-escaping="yes"/></h4>
			</xsl:if>
			<xsl:if test="string($text)!=''">
				<xsl:value-of select="$text" disable-output-escaping="yes"/>
			</xsl:if>
			<xsl:if test="string($small_file)!='' or string($large_file)!=''">
				<div class="paraPict">
					<xsl:apply-templates select="." mode="linked_pict">
						<xsl:with-param name="dir" select="$dir"/>
						<xsl:with-param name="def" select="$img_alt"/>
						<xsl:with-param name="href" select="$url"/>
						<xsl:with-param name="class" select="'paraPictImage'"/>
						<xsl:with-param name="aclass" select="'paraPictLink'"/>
					</xsl:apply-templates>
				</div>
			</xsl:if>
		</xsl:when>
		<!-- Под вариант "картинка-тексты" подпадают почти все прочие режимы форматирования, -->
		<!-- в том числе дефолтный (т.е. когда не смогли определить или это какой-то новый режим). -->
		<xsl:otherwise>
			<xsl:if test="string($name)!=''">
					<h2><xsl:value-of select="$name" disable-output-escaping="yes"/></h2>
			</xsl:if>
			<xsl:if test="string($small_file)!='' or string($large_file)!=''">
				<div class="paraPict">
					<xsl:apply-templates select="." mode="linked_pict">
						<xsl:with-param name="dir" select="$dir"/>
						<xsl:with-param name="def" select="$img_alt"/>
						<xsl:with-param name="href" select="$url"/>
						<xsl:with-param name="class" select="'paraPictImage'"/>
						<xsl:with-param name="aclass" select="'paraPictLink'"/>
					</xsl:apply-templates>
				</div>
			</xsl:if>
			<xsl:if test="string($text)!=''">		
					<xsl:value-of select="$text" disable-output-escaping="yes"/>
			</xsl:if>
		</xsl:otherwise>
		</xsl:choose>
	</div>
	</div>
</xsl:template>



</xsl:stylesheet>
