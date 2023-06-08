<?php
setlocale( LC_TIME, 'ru_RU.UTF-8', 'russian' );
list($month, $year) = explode('.', '10.2021');
#echo iconv('utf-8', 'cp1251', strftime('%B', strtotime($year.'-'.$month.'-01')).' '.strftime('%Y', strtotime($year.'-'.$month.'-01')));
#echo iconv('koi8r', 'utf8', strftime('%B', strtotime($year.'-'.$month.'-01')).' '.strftime('%Y', strtotime($year.'-'.$month.'-01')));
echo strftime('%B', strtotime($year.'-'.$month.'-01')).' '.strftime('%Y', strtotime($year.'-'.$month.'-01'));

die;
#echo preg_replace('/\D/', '', '-1000');
$file = '../../upload/phones.csv';

$dat = _main_::query(null, "
	select c.id, c.phone, c.client, c.contract_date
	from	payment c
	inner	join pays p on (p.payment = c.id)
	inner	join `_models4payment_` m4p on (m4p.payment = c.id)
	inner	join `models` m on (m4p.model = m.id)
	where	p.status = 'yes' and m.type in (1, 2) and c.phone is not null
	group	by c.id
	order	by c.contract_date
");

$str = '';
foreach($dat as $data)
{
	$str .= $data['phone'].';'.($data['contract_date']?date('d.m.Y', strtotime($data['contract_date'])):'').';'.$data['client']."\n";
}

file_put_contents($file, iconv('utf-8', 'cp1251', $str));

die("OK");

$u = _main_::fetchModule('users');
die($u->pwd_hash('1w3q6Z'));


$blocks = [
    'block:120' => Array
        (
            '@time' => '05:05:00'
        ),

    'block:121' => Array
        (
            '@time' => '05:15:00'
        )
 ];

        $data_document = new DOMDocument();
        $data_document->formatOutput = true;
        $data_document->encoding     = 'utf-8';
        $data_document->appendChild(_main_::dom($data_document, 'blocks', $blocks));
        $xml = $data_document->saveXML($data_document->documentElement);

 die($xml); 
$u = _main_::fetchModule('users');
#$u->set_dev_user('admin');
#$u->access();
$u->check(['advertiser']);
die("OK");
require_once __DIR__.'/../functions/_external_/vendor/autoload.php';
use \Firebase\JWT\JWT;

$token = JWT::decode('eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJhZHZlcnRpc2VySWQiOiI3ODA1MTU3Zi02MzdhLTQxNzctOGNkNi0wMWQ2NjYwYTA2ZjIiLCJpYXQiOjE1NTIzMTA5NzAsImV4cCI6MTcyNTExMDk3MH0.EP6853rKYCtui1Z5gTU8Yq7KKWt0csvmIIcbxsrLRQQ', _config_::$secretKey, array('HS256'));

debug($token);
die;
/*
require_once __DIR__.'/../functions/_external_/token/vendor/autoload.php';

use Firebase\Token\TokenException;
use Firebase\Token\TokenGenerator;

try {
    $generator = new TokenGenerator('yLQF5jJLyEZlQmdeL5bQv3CCzCVoKnR9ZbmYbW1Q');
    $token = $generator
	    ->setOption('expires', date_create('2020-12-31'))
        ->setData(array('uid' => 'monitors'))
        ->create();
} catch (TokenException $e) {
    echo "Error: ".$e->getMessage();
}

echo $token;

die;
*/

#require_once __DIR__.'/../functions/_external_/vendor/autoload.php';
/*
const DEFAULT_URL = 'https://nebo-digital-app.firebaseio.com/';
const DEFAULT_TOKEN = 'eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJhZG1pbiI6ZmFsc2UsImRlYnVnIjpmYWxzZSwiZXhwIjoxNjA5MzYyMDAwLCJkIjp7InVpZCI6Im1vbml0b3JzIn0sInYiOjAsImlhdCI6MTU1MzE2NzQyNX0.9qSKpE_dhH-yEWVWV44OxOqFS7-TFeTsWBXu-wlsp_M';
//'AIzaSyBRsp1fau6IehBVZECUHiX30US2wfZss6Y'; 
//'AIzaSyA8MG6UwunyKkX2BzKuFbWf9AmVhSB1ojI';
//'MqL0c8tKCtheLSYcygYNtGhU8Z2hULOFs9OKPdEp';
const DEFAULT_PATH = '/monitors';

$firebase = new \Firebase\FirebaseLib(DEFAULT_URL, DEFAULT_TOKEN);

$r = $firebase->delete(DEFAULT_PATH . '/136/commands');
#$r = $firebase->set(DEFAULT_PATH . '/135', [ 'commands' => [ 'command' => 'none', 'time' => time() ] ]);
#$r = $firebase->push(DEFAULT_PATH . '/135/commands', [ 'command' => 'reload_playlist', 'time' => time() ]);
#$r = $firebase->get(DEFAULT_PATH . '/135');
#$r = $firebase->set(DEFAULT_PATH . '/136/commands', [ [ 'command' => 'none', 'time' => time() ] ] );
debug($r); die;
*/
_main_::depend('evrika/common');

$errors = [];
$data = Evrika::get_time_window($errors);

debug($data);die;


$result = "  Duration: 00:00:05.00, start: 0.000000, bitrate: 1163 kb/s    Stream #0:0(eng): Video: h264 (Main) (avc1 / 0x31637661), yuv420p(tv, smpte170m), 1280x512, 1159 kb/s, 25 fps";
#$result = "Video: h264 (Main) (avc1 / 0x31637661), yuv420p(tv, smpte170m), 1280x512, 1159 kb/s";

#$pattern = '/Video:\s(.+)\s.+\s(([1-9]\d{1,5})x(\d{1,5}))[,\s].*\s((\d{1,5})\s\D{2,5})/isU';
		$pattern = '/Duration:\s(\d\d):(\d\d):(\d\d\.\d+),.+Video:\s(.+)\s.+\s(([1-9]\d{1,5})x(\d{1,5}))[,\s].*\s((\d{1,5})\s\D{2,5}),.+([\d|\.]{1,})\sfps/isU';


preg_match($pattern, $result, $matches);

debug($matches);

#$u = _main_::fetchModule('users');
#$u->set_dev_user('admin');
#$u->check(['advertiser']);

#debug(_identify_::$info);
#die;

die("OK");

?>