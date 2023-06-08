<?php
//
// Чистка длительное время неактивированных подписок (запросов на подписку).
//
// Рекомендуется выполнять раз в неделю-месяц. Чаще просто нет нужды.
//

_main_::depend('subscribers//opers'); delete_subscribers_where_inactive(_config_::$timeout_of_subscriptions);

// В случае "тихого" режима не генериуем отчёт.
if (in_array('silent', $pathargs)) throw new exception_exit();

?>