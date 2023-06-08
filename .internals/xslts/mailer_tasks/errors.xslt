<?xml version='1.0' encoding='cp1251' ?>
<!DOCTYPE xsl:stylesheet [
	<!ENTITY % HTMLlat1    PUBLIC "-//W3C//ENTITIES Latin 1 for XHTML//EN" "../../dtds/xhtml-lat1.ent"   > %HTMLlat1;
	<!ENTITY % HTMLspecial PUBLIC "-//W3C//ENTITIES Special for XHTML//EN" "../../dtds/xhtml-special.ent"> %HTMLspecial;
	<!ENTITY % HTMLsymbol  PUBLIC "-//W3C//ENTITIES Symbols for XHTML//EN" "../../dtds/xhtml-symbol.ent" > %HTMLsymbol;
]>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:php="http://php.net/xsl">



<xsl:template mode="mailer_task" match="form/errors/*" priority="-1"><xsl:apply-templates select="."/></xsl:template>

<xsl:template mode="mailer_task" match="form/errors/subject_required"><div class="error">Необходимо задать заголовок сообщения.</div></xsl:template>
<xsl:template mode="mailer_task" match="form/errors/message_required"><div class="error">Необходимо задать текст сообщения.</div></xsl:template>
<xsl:template mode="mailer_task" match="form/errors/is_test_required    "><div class="error">Необходимо задать статус тестовости задания.</div></xsl:template>
<xsl:template mode="mailer_task" match="form/errors/is_test_bad         "><div class="error">Неприемлимое значение статуса тестовости задания.</div></xsl:template>
<xsl:template mode="mailer_task" match="form/errors/groups_list_required"><div class="error">Ни одной группы подписчиков не выбрано.</div></xsl:template>



</xsl:stylesheet>
