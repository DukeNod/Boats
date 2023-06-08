<?xml version="1.0" encoding="cp1251" ?>
<!DOCTYPE xsl:stylesheet [
	<!ENTITY % HTMLlat1    PUBLIC "-//W3C//ENTITIES Latin 1 for XHTML//EN" "../../dtds/xhtml-lat1.ent"   > %HTMLlat1;
	<!ENTITY % HTMLspecial PUBLIC "-//W3C//ENTITIES Special for XHTML//EN" "../../dtds/xhtml-special.ent"> %HTMLspecial;
	<!ENTITY % HTMLsymbol  PUBLIC "-//W3C//ENTITIES Symbols for XHTML//EN" "../../dtds/xhtml-symbol.ent" > %HTMLsymbol;
]>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:php="http://php.net/xsl">
<xsl:include href="form.xslt"/>
<xsl:include href="../../xslts/public.xslt"/>
<xsl:include href="../../xslts/registration/errors.xslt"/>
<xsl:include href="../../xslts/_common_/quick_form.xslt"/>

<xsl:template  match="/" mode="overrideable_head">
	<xsl:text>Авторизация</xsl:text>
</xsl:template>

<xsl:template match="/" mode="overrideable_keywords">
	<xsl:text>Авторизация</xsl:text>
</xsl:template>

<xsl:template match="/" mode="overrideable_description">
	<xsl:text>Авторизация.</xsl:text>
</xsl:template>

<xsl:template match="/" mode="overrideable_measurer">
	<xsl:text>Авторизация</xsl:text>
</xsl:template>


<xsl:template match="/" mode="overrideable_content">
	<xsl:variable name="form" select="/*/form | /*/done"/>

	<xsl:choose>
	<xsl:when test="/*/done">
		<div class="para">
		<p>
		Авторизация прошла успешно.		
		<!--xsl:apply-templates select="/*/inlines/inline[label='login:ok']"/-->
		</p>
		</div>
	</xsl:when>
	<xsl:otherwise>
		<xsl:apply-templates select="/*/inlines/inline[label='login:intro']"/>

            <div class="authform">
                <form class="new_user" id="new_user" action="" accept-charset="UTF-8" method="post"> <!-- {/*/system/info/pub_root}login/ -->
                    <h3>Форма входа</h3>
                    
					<xsl:if test="$form/errors/*">
						<xsl:apply-templates select="$form/errors/*" mode="div"/>
					</xsl:if>

					<div class="form-group">
		              <xsl:apply-templates select="/*/fields/TextField[name='email']"	mode="quick_form">
		              	<xsl:with-param name="class" select="'form-control'"/>
		              </xsl:apply-templates>
					</div>
					
					<div class="form-group">
		              <xsl:apply-templates select="/*/fields/TextField[name='password']"	mode="quick_form_password">
		              	<xsl:with-param name="class" select="'form-control'"/>
		              </xsl:apply-templates>
					</div>

					<!-- новый пароль и подтверждение нового пароля -->
					<!-- при выдаче ошибок проверки новых паролей всегда добавляем к ним auth_expired -->
					<xsl:choose>
						<xsl:when test="$form/errors/auth_expired">
							<div class="form-group">
								<xsl:apply-templates select="/*/fields/TextField[name='newpassword1']"	mode="quick_form_password">
									<xsl:with-param name="class" select="'form-control'"/>
								</xsl:apply-templates>
							</div>

							<div class="form-group">
								<xsl:apply-templates select="/*/fields/TextField[name='newpassword2']"	mode="quick_form_password">
									<xsl:with-param name="class" select="'form-control'"/>
								</xsl:apply-templates>
							</div>

							<span class="text">
							Минимум <xsl:value-of select="/*/auth_extended_policy/min_password_length"/> символов, только большие и маленькие латинские буквы и цифры<xsl:if test="/*/auth_extended_policy/want_lower_latin = '1'">, хотя бы одна маленькая латинская</xsl:if><xsl:if test="/*/auth_extended_policy/want_upper_latin = '1'">, хотя бы одна большая латинская</xsl:if><xsl:if test="/*/auth_extended_policy/want_digit = '1'">, хотя бы одна цифра</xsl:if>
							<br />
							</span>
						</xsl:when>
						<xsl:otherwise>
						</xsl:otherwise>
					</xsl:choose>
		              
                    <!--div class="form-group">
                        <label for="user_email">Email</label>
                        <input autofocus="autofocus" class="form-control" type="email" value="" name="user[email]" id="user_email"/>
                    </div>
                    <div class="form-group">
                        <a class="right" href="/users/password/new">Забыли пароль?</a>
                        <label for="user_password">Пароль</label>
                        <input class="form-control" type="password" name="user[password]" id="user_password"/>
                    </div-->
                    <input type="submit" name="login_submit" value="Войти" class="button right" data-disable-with="Войти"/>
                </form>
            </div>

	</xsl:otherwise>
	</xsl:choose>
</xsl:template>

<xsl:template match="/" mode="overrideable_body">
        <main role="main">
            <!--div class="alert alert-dismissible alert-danger">
                <button aria-hidden="true" class="close" data-dismiss="alert" type="button">x</button>
                <div id="flash_alert">Вам необходимо войти в систему или зарегистрироваться.</div>
            </div-->
			<xsl:apply-templates select="/" mode="overrideable_content"/>
        </main>
</xsl:template>

</xsl:stylesheet>
