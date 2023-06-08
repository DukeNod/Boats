<?php
function mb_wordwrap($str, $width = 75, $break = "\n", $cut = false)
{
	$lines = explode($break, $str);
	foreach ($lines as &$line)
	{
		$line = rtrim($line);
		if (mb_strlen($line, 'UTF-8') <= $width)
		{
			continue;
		}
		$words = explode(' ', $line);
		$line = '';
		$actual = '';
		foreach ($words as $word)
		{
			if (mb_strlen($actual.$word, 'UTF-8') <= $width)
			{
				$actual .= $word.' ';
			}
			else
			{
				if ($actual != '')
				{
					$line .= rtrim($actual).$break;
				}
				$actual = $word;
				if ($cut)
				{
					while (mb_strlen($actual, 'UTF-8') > $width)
					{
						$line .= mb_substr($actual, 0, $width, 'UTF-8').$break;
						$actual = mb_substr($actual, $width, mb_strlen($actual, 'UTF-8'), 'UTF-8');
					}
				}
				$actual .= ' ';
			}
		}
		$line .= trim($actual);
	}
	return implode($break, $lines);
}

class Push_Service
{

	public function __construct()
	{
		$this->server_url = 'https://fcm.googleapis.com/fcm/send';
		$this->auth_key = 'AAAAviy7l8E:APA91bF3KjaJ22SLR3LpQn6C9s1YmGr8gPpDiAG7ebt3mc9-Lcdvkg7kCkkR-dXi8MNMjw25EYj37yeOigcFf2wFoOIB3RXpc0PJpCkrxgvy2_xxag50SOHIRBXfm_ePWvskC9sIVgcz';
	}
	
	function SendOnePushAndroid($registatoin_ids, $message)
	{
		$ch = curl_init();

		curl_setopt($ch, CURLOPT_URL, $this->server_url);

		curl_setopt($ch, CURLOPT_POST, true);
		curl_setopt($ch, CURLOPT_HTTPHEADER, [ 'Authorization: key='.$this->auth_key, 'Content-Type: application/json' ]);
		curl_setopt($ch, CURLOPT_RETURNTRANSFER, true);
		curl_setopt($ch, CURLOPT_SSL_VERIFYPEER, false);
		#curl_setopt($ch, CURLOPT_POSTFIELDS, json_encode([ 'registration_ids' => $registatoin_ids, 'data' => $message ]));
//		debug($message);die;
		#curl_setopt($ch, CURLOPT_POSTFIELDS, json_encode([ 'to' => '/topics/akashkin', 'data' => $message ]));
		curl_setopt($ch, CURLOPT_POSTFIELDS, json_encode([ 'to' => '/topics/monitor.135', 'data' => $message ]));
		curl_setopt($ch, CURLOPT_HEADER, 1);
		
		$result = curl_exec($ch);

		curl_close($ch);
		return $result;
	}

	function SendPushAndroid($appid, $text, $custom_data = null, $deviceid = null)
	{
		$where = [ 'platform' => 'android' ];
		if ($deviceid)
		{
			$where["deviceid"] = $deviceid;
		}

		$total_count = DB::Count("push_devices_{$appid}", $where);
		$chunk_count = ceil($total_count / 1000);

		for ($i = 0; $i < $chunk_count; ++$i)
		{
			$offset = $i * 1000;

			$ids = DB::SelectArray("push_devices_{$appid}", "device_token", $where, null, 1000, $offset);

			SendOnePushAndroid($ids, [ 'message' => $text ]);
		}
	}

	/* Про IOS подумаем потом.
	function SendPushIOS($appid, $text, $is_dev = APPLE_DEV, $custom_data = null, $deviceid = null)
	{
		$cert = DB::Select("push_certs", "*", [ "appid" => $appid, "type" => ($is_dev ? "dev" : "ent") ]);

		if (count($cert) <= 0)
		{
			if ($is_dev == APPLE_DEV)
			{
				echo("Certificate is missed\n");
				return;
			}
			else
			{
				$cert = file_get_contents('./InHousePushCert.pem');
			}
		}
		else
		{
			$cert = $cert[0]['cert'];
		}
		
		$apnsCert = tempnam('/tmp', 'cert');
		file_put_contents($apnsCert, $cert);

		$where = [ 'platform' => 'ios' ];
		if ($deviceid)
		{
			$where["deviceid"] = $deviceid;
		}

		$total_count = DB::Count("push_devices_{$appid}", $where);
		$chunk_count = ceil($total_count / DEVICE_CHUNCK_SIZE);

		$need_remove = [];

		for ($i = 0; $i < $chunk_count; ++$i)
		{
			$offset = $i * DEVICE_CHUNCK_SIZE;

			$ids = DB::SelectArray("push_devices_{$appid}", "device_token", $where, null, DEVICE_CHUNCK_SIZE, $offset);

			$apnsHost = 'gateway.push.apple.com';
			$apnsPort = 2195;

			$streamContext = stream_context_create();
			stream_context_set_option($streamContext, 'ssl', 'local_cert', $apnsCert);
			stream_context_set_option($streamContext, 'ssl', 'cafile', 'entrust_ssl_ca.cer');

			$apns = stream_socket_client('tls://' . $apnsHost . ':' . $apnsPort, $error, $errorString, 60, STREAM_CLIENT_CONNECT, $streamContext);

			foreach ($ids as $key => $value)
			{
				$deviceToken = hex2bin($value);

				$payload = [];
				$payload['aps'] = [ 'alert' => $text ]; //, 'badge' => 0, 'sound' => 'default'
				if (!is_null($custom_data))
				{
					$payload['d'] = json_encode($custom_data);
				}
				$payload = json_encode($payload, JSON_UNESCAPED_UNICODE);

				$apnsMessage = chr(0) . chr(0) . chr(32) . $deviceToken . chr(0) . chr(strlen($payload)) . $payload;

				fwrite($apns, $apnsMessage);
			}

			fclose($apns);

			$ids = FeedbackPushIOS($appid, $apnsCert);
			if ($ids)
			{
				$need_remove = array_merge($need_remove, $ids);
			}
		}

		unlink($apnsCert);

		if ($need_remove)
		{
			echo "Remove from DB: ".count($need_remove)."\n";

			$offset = 0;
			$chunk = array_slice($need_remove, 0, 1000);
			do
			{
				$chunk = array_slice($need_remove, $offset, 1000);
				$offset += 1000;

				DB::Delete('push_devices_'.$appid, [ 'device_token' => $chunk ]);
			}
			while($chunk);
		}
	}

	function FeedbackPushIOS($appid, $apnsCert)
	{
		$apnsHost = 'feedback.push.apple.com';
		$apnsPort = 2196;

		$streamContext = stream_context_create();
		stream_context_set_option($streamContext, 'ssl', 'local_cert', $apnsCert);
		stream_context_set_option($streamContext, 'ssl', 'cafile', 'entrust_ssl_ca.cer');

		$apns = stream_socket_client('tls://' . $apnsHost . ':' . $apnsPort, $error, $errorString, 60, STREAM_CLIENT_CONNECT, $streamContext);

		if (!is_resource($apns))
		{
			return [];
		}
		
		stream_set_blocking($apns, 0);
		$need_remove = [];
		while (!feof($apns))
		{
			$buffer = fread($apns, 8192);

			for ($i = 0, $size = strlen($buffer); $i < $size; $i += 38)
			{
				$tmp = substr($buffer, $i, 38);
				$need_remove[] = unpack('Ntimestamp/ntokenLength/H*deviceToken', $tmp);
			}
		}

		fclose($apns);

		$ids = [];
		foreach ($need_remove as $key => $value)
		{
			$ids[] = $value['deviceToken'];
		}

		return $ids;
	}
	*/
}
?>