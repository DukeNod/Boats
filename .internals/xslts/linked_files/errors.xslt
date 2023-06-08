<?xml version='1.0' encoding='cp1251' ?>
<!DOCTYPE xsl:stylesheet [
	<!ENTITY % HTMLlat1    PUBLIC "-//W3C//ENTITIES Latin 1 for XHTML//EN" "../../dtds/xhtml-lat1.ent"   > %HTMLlat1;
	<!ENTITY % HTMLspecial PUBLIC "-//W3C//ENTITIES Special for XHTML//EN" "../../dtds/xhtml-special.ent"> %HTMLspecial;
	<!ENTITY % HTMLsymbol  PUBLIC "-//W3C//ENTITIES Symbols for XHTML//EN" "../../dtds/xhtml-symbol.ent" > %HTMLsymbol;
]>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:php="http://php.net/xsl">

<xsl:template match="form[@for='linked_files']/errors/uplink_absent       ">Указанный владелец файла не существует (по типу или по идентификатору).</xsl:template>
<xsl:template match="form[@for='linked_files']/errors/name_required       ">Необходимо ввести название файла (текст ссылки).</xsl:template>

<xsl:template match="form[@for='linked_files']/errors/attach_required     ">Необходимо загрузить файл.</xsl:template>
<xsl:template match="form[@for='linked_files']/errors/attach_extension    ">Файл не принят из-за неподходящего расширения.</xsl:template>
<xsl:template match="form[@for='linked_files']/errors/attach_lost         ">Временная копия файла уже не существует. Перезагрузите его.</xsl:template>
<xsl:template match="form[@for='linked_files']/errors/attach_nameless     ">Невозможно определить имя файла.</xsl:template>
<xsl:template match="form[@for='linked_files']/errors/attach_exists       ">Файл с таким именем уже существует в каталоге. Задайте другое имя.</xsl:template>
<xsl:template match="form[@for='linked_files']/errors/attach_size_bad     ">Некорректное значение размера файла.</xsl:template>
<xsl:template match="form[@for='linked_files']/errors/attach_size_too_low ">Файл слишком маленький, нужен больше.</xsl:template>
<xsl:template match="form[@for='linked_files']/errors/attach_size_too_high">Файл слишком большой, нужен меньше.</xsl:template>

<xsl:template match="form[@for='linked_files']/errors/preview_required    ">Необходимо загрузить большую картинку.</xsl:template>
<xsl:template match="form[@for='linked_files']/errors/preview_extension   ">Файл большой картинки не принят из-за неподходящего расширения.</xsl:template>
<xsl:template match="form[@for='linked_files']/errors/preview_lost        ">Временный файл большой картинки уже не существует. Перезагрузите его.</xsl:template>
<xsl:template match="form[@for='linked_files']/errors/preview_nameless    ">Невозможно определить имя файла большой картинки.</xsl:template>
<xsl:template match="form[@for='linked_files']/errors/preview_exists      ">Большая картинка с таким именем уже существует в каталоге. Задайте другое имя.</xsl:template>
<xsl:template match="form[@for='linked_files']/errors/preview_w_bad       ">Некорректное значение ширины большой картинки.</xsl:template>
<xsl:template match="form[@for='linked_files']/errors/preview_w_too_low   ">Слишком маленькая ширина большой картинки.</xsl:template>
<xsl:template match="form[@for='linked_files']/errors/preview_w_too_high  ">Слишком большая ширина большой картинки.</xsl:template>
<xsl:template match="form[@for='linked_files']/errors/preview_h_bad       ">Некорректное значение высоты большой картинки.</xsl:template>
<xsl:template match="form[@for='linked_files']/errors/preview_h_too_low   ">Слишком маленькая высота большой картинки.</xsl:template>
<xsl:template match="form[@for='linked_files']/errors/preview_h_too_high  ">Слишком большая высота большой картинки.</xsl:template>

</xsl:stylesheet>
