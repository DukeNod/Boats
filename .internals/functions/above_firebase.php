<?php
/**
 * Created by PhpStorm.
 * User: vadim
 * Date: 24.04.19
 * Time: 17:01
 */

class Above_FireBase
{
    function __construct()
    {
        $this->url = 'https://nebo-digital-app.firebaseio.com/';
        $this->token = 'eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJhZG1pbiI6ZmFsc2UsImRlYnVnIjpmYWxzZSwiZXhwIjoxNjA5MzYyMDAwLCJkIjp7InVpZCI6Im1vbml0b3JzIn0sInYiOjAsImlhdCI6MTU1MzE2NzQyNX0.9qSKpE_dhH-yEWVWV44OxOqFS7-TFeTsWBXu-wlsp_M';
        $this->firebase = new \Firebase\FirebaseLib($this->url, $this->token);
    }

    // ”ниверсальна€ отправка пушей
    public function send_push(&$errors, $path, $options)
    {
        $this->firebase->push($path, $options);
    }
}