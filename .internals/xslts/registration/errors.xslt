<?xml version='1.0' encoding='cp1251' ?>
<!DOCTYPE xsl:stylesheet [
	<!ENTITY % HTMLlat1    PUBLIC "-//W3C//ENTITIES Latin 1 for XHTML//EN" "../../dtds/xhtml-lat1.ent"   > %HTMLlat1;
	<!ENTITY % HTMLspecial PUBLIC "-//W3C//ENTITIES Special for XHTML//EN" "../../dtds/xhtml-special.ent"> %HTMLspecial;
	<!ENTITY % HTMLsymbol  PUBLIC "-//W3C//ENTITIES Symbols for XHTML//EN" "../../dtds/xhtml-symbol.ent" > %HTMLsymbol;
]>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:php="http://php.net/xsl">



<xsl:template match="form/errors/sname_required	">Необходимо указать фамилию.</xsl:template>
<xsl:template match="form/errors/fname_required	">Необходимо указать имя.</xsl:template>
<xsl:template match="form/errors/email_required	">Необходимо указать E-mail.</xsl:template>
<xsl:template match="form/errors/password_required	">Необходимо указать пароль.</xsl:template>
<xsl:template match="form/errors/password1_required	">Необходимо указать пароль.</xsl:template>
<xsl:template match="form/errors/password2_required	">Необходимо подтвердить пароль.</xsl:template>
<xsl:template match="form/errors/bad_password	">Пароль не совпадает.</xsl:template>
<xsl:template match="form/errors/password_not_equal	">Пароль не совпадает.</xsl:template>

<xsl:template match="form/errors/user_duplicate	">Пользователь с таким e-mail адресом уже зарегистрирован.</xsl:template>

<xsl:template match="form/errors/user_exists	">Вы уже ранее подтвердили регистрацию в нашем интернет-магазине. Вы можете продолжить покупки после <a href="{/*/system/info/pub_root}login/">авторизации</a></xsl:template>
<xsl:template match="form/errors/user_not_found	">Аккаунт не найден.</xsl:template>

<xsl:template match="form/errors/delivery_region_required	">Регион доставки указан не верно.</xsl:template>
<xsl:template match="form/errors/delivery_region_bad	">Регион доставки указан не верно.</xsl:template>
<xsl:template match="form/errors/delivery_address_required	">Необходимо указать адрес доставки.</xsl:template>

<xsl:template match="form/errors/reg_index_bad	">Почтовый индекс указан не верно.</xsl:template>
<xsl:template match="form/errors/reg_address_required	">Необходимо указать адрес прописки.</xsl:template>
<xsl:template match="form/errors/passport_serial_required	">Необходимо указать серию паспорта.</xsl:template>
<xsl:template match="form/errors/passport_number_required	">Необходимо указать номер паспорта.</xsl:template>
<xsl:template match="form/errors/passport_dept_required	">Необходимо указать кем выдан паспорт.</xsl:template>
<xsl:template match="form/errors/passport_date_required	">Необходимо указать дату выдачи паспорта.</xsl:template>
<xsl:template match="form/errors/agree_bad	">Необходимо принять условия регистрации.</xsl:template>
<xsl:template match="form/errors/auth_wrong	">Неверный логин или пароль.</xsl:template>

<!-- ошибки для расширенной политики безопасности -->
<xsl:template match="errors/auth_wrong">Неверный логин или пароль</xsl:template>
<xsl:template match="errors/auth_expired">Требуется сменить пароль для пользователя <xsl:value-of select="." disable-output-escaping="yes"/></xsl:template>
<xsl:template match="errors/auth_newpassword_mismatch">Новый пароль и подтверждение нового пароля не совпадают</xsl:template>
<xsl:template match="errors/auth_newpassword_tooshort">Минимальная длина пароля - <xsl:value-of select="." disable-output-escaping="yes"/> символов</xsl:template>
<xsl:template match="errors/auth_newpassword_duplicate_old">Новый пароль и старый пароль должны отличаться</xsl:template>
<xsl:template match="errors/auth_newpassword_badchars">В пароле допустимы только большие и маленькие латинские буквы и цифры</xsl:template>
<xsl:template match="errors/auth_newpassword_want_lower_latin">В пароле должна быть хотя бы одна латинская буква в нижнем регистре (a-z)</xsl:template>
<xsl:template match="errors/auth_newpassword_want_upper_latin">В пароле должна быть хотя бы одна латинская буква в верхнем регистре (A-Z)</xsl:template>
<xsl:template match="errors/auth_newpassword_want_digit">В пароле должна быть хотя бы одна цифра</xsl:template>
<xsl:template match="errors/auth_user_locked">Пользователь <xsl:value-of select="." disable-output-escaping="yes"/> заблокирован</xsl:template>
<xsl:template match="errors/auth_user_locked_permanent">Пользователь <xsl:value-of select="." disable-output-escaping="yes"/> заблокирован администратором</xsl:template>
<xsl:template match="errors/auth_user_locked_temporary">Пользователь <xsl:value-of select="." disable-output-escaping="yes"/> заблокирован за многократные попытки ввода неверного пароля</xsl:template>
<xsl:template match="errors/auth_password_expired">У пользователя <xsl:value-of select="." disable-output-escaping="yes"/> истек срок действия пароля</xsl:template>
<xsl:template match="errors/auth_attempt_delay">Перед следующей попыткой ввода пароля надо подождать несколько минут</xsl:template>



</xsl:stylesheet>
