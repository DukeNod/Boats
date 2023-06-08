<?xml version='1.0' encoding='cp1251' ?>
<!DOCTYPE xsl:stylesheet [
	<!ENTITY % HTMLlat1    PUBLIC "-//W3C//ENTITIES Latin 1 for XHTML//EN" "../../dtds/xhtml-lat1.ent"   > %HTMLlat1;
	<!ENTITY % HTMLspecial PUBLIC "-//W3C//ENTITIES Special for XHTML//EN" "../../dtds/xhtml-special.ent"> %HTMLspecial;
	<!ENTITY % HTMLsymbol  PUBLIC "-//W3C//ENTITIES Symbols for XHTML//EN" "../../dtds/xhtml-symbol.ent" > %HTMLsymbol;
]>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:php="http://php.net/xsl">

<xsl:template match="form/errors/uplink_absent       ">Указанный владелец изображения не существует (по типу или по идентификатору).</xsl:template>
<xsl:template match="form/errors/uplink_id_required  "></xsl:template>
<xsl:template match="form/errors/alt_required        ">Необходимо ввести комментарий к картинке.</xsl:template>

<xsl:template match="form/errors/small_required      ">Необходимо загрузить маленькую картинку.</xsl:template>
<xsl:template match="form/errors/small_extension     ">Файл маленькой картинки не принят из-за неподходящего расширения.</xsl:template>
<xsl:template match="form/errors/small_lost          ">Временный файл маленькой картинки уже не существует. Перезагрузите его.</xsl:template>
<xsl:template match="form/errors/small_nameless      ">Невозможно определить имя файла маленькой картинки.</xsl:template>
<xsl:template match="form/errors/small_exists        ">Маленькая картинка с таким именем уже существует в каталоге. Задайте другое имя.</xsl:template>
<xsl:template match="form/errors/small_w_bad         ">Некорректное значение ширины маленькой картинки.</xsl:template>
<xsl:template match="form/errors/small_w_too_low     ">Слишком маленькая ширина маленькой картинки.</xsl:template>
<xsl:template match="form/errors/small_w_too_high    ">Слишком большая ширина маленькой картинки.</xsl:template>
<xsl:template match="form/errors/small_h_bad         ">Некорректное значение высоты маленькой картинки.</xsl:template>
<xsl:template match="form/errors/small_h_too_low     ">Слишком маленькая высота маленькой картинки.</xsl:template>
<xsl:template match="form/errors/small_h_too_high    ">Слишком большая высота маленькой картинки.</xsl:template>

<xsl:template match="form/errors/middle_required      ">Необходимо загрузить среднюю картинку.</xsl:template>
<xsl:template match="form/errors/middle_extension     ">Файл средней картинки не принят из-за неподходящего расширения.</xsl:template>
<xsl:template match="form/errors/middle_lost          ">Временный файл средней картинки уже не существует. Перезагрузите его.</xsl:template>
<xsl:template match="form/errors/middle_nameless      ">Невозможно определить имя файла средней картинки.</xsl:template>
<xsl:template match="form/errors/middle_exists        ">Средняя картинка с таким именем уже существует в каталоге. Задайте другое имя.</xsl:template>
<xsl:template match="form/errors/middle_w_bad         ">Некорректное значение ширины средней картинки.</xsl:template>
<xsl:template match="form/errors/middle_w_too_low     ">Слишком маленькая ширина средней картинки.</xsl:template>
<xsl:template match="form/errors/middle_w_too_high    ">Слишком большая ширина средней картинки.</xsl:template>
<xsl:template match="form/errors/middle_h_bad         ">Некорректное значение высоты средней картинки.</xsl:template>
<xsl:template match="form/errors/middle_h_too_low     ">Слишком маленькой высота средней картинки.</xsl:template>
<xsl:template match="form/errors/middle_h_too_high    ">Слишком большая высота средней картинки.</xsl:template>

<xsl:template match="form/errors/large_required      ">Необходимо загрузить большую картинку.</xsl:template>
<xsl:template match="form/errors/large_extension     ">Файл большой картинки не принят из-за неподходящего расширения.</xsl:template>
<xsl:template match="form/errors/large_lost          ">Временный файл большой картинки уже не существует. Перезагрузите его.</xsl:template>
<xsl:template match="form/errors/large_nameless      ">Невозможно определить имя файла большой картинки.</xsl:template>
<xsl:template match="form/errors/large_exists        ">Большая картинка с таким именем уже существует в каталоге. Задайте другое имя.</xsl:template>
<xsl:template match="form/errors/large_w_bad         ">Некорректное значение ширины большой картинки.</xsl:template>
<xsl:template match="form/errors/large_w_too_low     ">Слишком маленькая ширина большой картинки.</xsl:template>
<xsl:template match="form/errors/large_w_too_high    ">Слишком большая ширина большой картинки.</xsl:template>
<xsl:template match="form/errors/large_h_bad         ">Некорректное значение высоты большой картинки.</xsl:template>
<xsl:template match="form/errors/large_h_too_low     ">Слишком маленькая высота большой картинки.</xsl:template>
<xsl:template match="form/errors/large_h_too_high    ">Слишком большая высота большой картинки.</xsl:template>

</xsl:stylesheet>
