<?xml version='1.0' encoding='cp1251' ?>
<!DOCTYPE xsl:stylesheet [
	<!ENTITY % HTMLlat1    PUBLIC "-//W3C//ENTITIES Latin 1 for XHTML//EN" "../../dtds/xhtml-lat1.ent"   > %HTMLlat1;
	<!ENTITY % HTMLspecial PUBLIC "-//W3C//ENTITIES Special for XHTML//EN" "../../dtds/xhtml-special.ent"> %HTMLspecial;
	<!ENTITY % HTMLsymbol  PUBLIC "-//W3C//ENTITIES Symbols for XHTML//EN" "../../dtds/xhtml-symbol.ent" > %HTMLsymbol;
]>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:php="http://php.net/xsl">

<xsl:template match="form[@for='linked_paras']/errors/uplink_absent       ">Указанный владелец параграфа не существует (по типу или по идентификатору).</xsl:template>
<xsl:template match="form[@for='linked_paras']/errors/alt_required        ">Необходимо ввести комментарий к картинке.</xsl:template>
<xsl:template match="form[@for='linked_paras']/errors/name_required       ">Необходимо ввести заголовок параграфа.</xsl:template>
<xsl:template match="form[@for='linked_paras']/errors/text_required       ">Необходимо ввести текст параграфа.</xsl:template>
<xsl:template match="form[@for='linked_paras']/errors/clear_required      ">Необходимо указать режим обтекания параграфа.</xsl:template>
<xsl:template match="form[@for='linked_paras']/errors/clear_bad           ">Некорректное значение для режима обтекания параграфа.</xsl:template>
<xsl:template match="form[@for='linked_paras']/errors/align_required      ">Необходимо указать выравнивание текста.</xsl:template>
<xsl:template match="form[@for='linked_paras']/errors/align_bad           ">Некорректное значение для выравнивания текста.</xsl:template>
<xsl:template match="form[@for='linked_paras']/errors/float_required      ">Необходимо указать расположение картинки.</xsl:template>
<xsl:template match="form[@for='linked_paras']/errors/float_bad           ">Некорректное значение для расположения картинки.</xsl:template>

<xsl:template match="form[@for='linked_paras']/errors/small_required      ">Необходимо загрузить маленькую картинку.</xsl:template>
<xsl:template match="form[@for='linked_paras']/errors/small_extension     ">Файл маленькой картинки не принят из-за неподходящего расширения.</xsl:template>
<xsl:template match="form[@for='linked_paras']/errors/small_lost          ">Временный файл маленькой картинки уже не существует. Перезагрузите его.</xsl:template>
<xsl:template match="form[@for='linked_paras']/errors/small_nameless      ">Невозможно определить имя файла маленькой картинки.</xsl:template>
<xsl:template match="form[@for='linked_paras']/errors/small_exists        ">Маленькая картинка с таким именем уже существует в каталоге. Задайте другое имя.</xsl:template>
<xsl:template match="form[@for='linked_paras']/errors/small_w_bad         ">Некорректное значение ширины маленькой картинки.</xsl:template>
<xsl:template match="form[@for='linked_paras']/errors/small_w_too_low     ">Слишком маленькая ширина маленькой картинки.</xsl:template>
<xsl:template match="form[@for='linked_paras']/errors/small_w_too_high    ">Слишком большая ширина маленькой картинки.</xsl:template>
<xsl:template match="form[@for='linked_paras']/errors/small_h_bad         ">Некорректное значение высоты маленькой картинки.</xsl:template>
<xsl:template match="form[@for='linked_paras']/errors/small_h_too_low     ">Слишком маленькая высота маленькой картинки.</xsl:template>
<xsl:template match="form[@for='linked_paras']/errors/small_h_too_high    ">Слишком большая высота маленькой картинки.</xsl:template>

<xsl:template match="form[@for='linked_paras']/errors/large_required      ">Необходимо загрузить большую картинку.</xsl:template>
<xsl:template match="form[@for='linked_paras']/errors/large_extension     ">Файл большой картинки не принят из-за неподходящего расширения.</xsl:template>
<xsl:template match="form[@for='linked_paras']/errors/large_lost          ">Временный файл большой картинки уже не существует. Перезагрузите его.</xsl:template>
<xsl:template match="form[@for='linked_paras']/errors/large_nameless      ">Невозможно определить имя файла большой картинки.</xsl:template>
<xsl:template match="form[@for='linked_paras']/errors/large_exists        ">Большая картинка с таким именем уже существует в каталоге. Задайте другое имя.</xsl:template>
<xsl:template match="form[@for='linked_paras']/errors/large_w_bad         ">Некорректное значение ширины большой картинки.</xsl:template>
<xsl:template match="form[@for='linked_paras']/errors/large_w_too_low     ">Слишком маленькая ширина большой картинки.</xsl:template>
<xsl:template match="form[@for='linked_paras']/errors/large_w_too_high    ">Слишком большая ширина большой картинки.</xsl:template>
<xsl:template match="form[@for='linked_paras']/errors/large_h_bad         ">Некорректное значение высоты большой картинки.</xsl:template>
<xsl:template match="form[@for='linked_paras']/errors/large_h_too_low     ">Слишком маленькая высота большой картинки.</xsl:template>
<xsl:template match="form[@for='linked_paras']/errors/large_h_too_high    ">Слишком большая высота большой картинки.</xsl:template>

</xsl:stylesheet>
