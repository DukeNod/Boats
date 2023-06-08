<?php

function send_multipart_mail ($from, $to, $subject, $html, $files)
{
	_main_::depend('_external_/phpmailer/class.phpmailer');
	_main_::depend('_external_/phpmailer/class.smtp');
	
	$login = 'noreply@appbeauty.me';
	$passwd = 'ekXsEmFVZp';
	
	$subject = ($subject === null) && preg_match("|<title>(.*?)</title>|six", $html, $matches) ? $matches[1] : $subject;

		$mail = new PHPMailer();
		$mail->IsSMTP();
		// $mail->SMTPDebug = 1;
		$mail->SMTPAuth = true;
		$mail->SMTPSecure = 'ssl';
		$mail->Host = 'smtp.yandex.ru';
		$mail->Port = 465;
		$mail->IsHTML(true);
		$mail->CharSet = 'UTF-8';
		$mail->Username = $login;
		$mail->SetFrom($login);
		$mail->Password = $passwd;
		$mail->Subject = $subject;
		$mail->Body = $html;

		// http://www.ietf.org/rfc/rfc2369
		// $mail->addCustomHeader('List-Unsubscribe','<admin@keepity.com>, <http://keepity.com/?email='.$address.'>');

		/*
		if ($images)
		{
			foreach ($images as $key => $value)
			{
				$mail->addStringEmbeddedImage($value['content'], $key, $value['name']);
			}			
		}
		*/

		if (strstr($to, ';'))
		{
			// Несколько адресов, разделенных ;
			$mto = explode(';',$to);
			foreach ($mto as $k => $sto)
			{
				$mail->AddAddress(trim($sto));
			}
		}
		else
		{
			// Один адрес
			$mail->AddAddress($to);
		}

		if (!$mail->Send())
		{
			return $mail->ErrorInfo;
		}

		return true;
}

/*
//todo: сделать чтобы была plain-text часть
function send_multipart_mail ($from, $to, $subject, $html, $files)
{
        global $content_img, $boundary;

	$content_img = '';
        $boundary = md5(uniqid(rand()));

//???	$text = strip_tags($html);

	$subject = ($subject === null) && preg_match("|<title>(.*?)</title>|six", $html, $matches) ? $matches[1] : $subject;
	$subject = "=?UTF-8?B?" . base64_encode($subject) . "?=";
	$message = '';
	$headers = '';

	$headers .= "From: $from"."\r\n";
	$headers .= "Reply-To: $from"."\r\n";
//	$headers .= "To: $to"."\r\n";// NB: duplicated in mail() below.
//	$headers .= "Subject: $subject"."\r\n";// NB: duplicated in mail() below.
	$headers .= "Mime-Version: 1.0"."\r\n";
	$headers .= "Content-Type: multipart/related; boundary=\"{$boundary}\""."\r\n";

	{
		$content  = preg_replace("/^\\.\$/m", "..", $html);
		
		$content  = preg_replace_callback("/<img.+?src=[\"\'](.+?)[\"\'].*?>/", 'multipart_replace_img', $content);

		$message .= "--{$boundary}"."\n";
		$message .= "Content-Type: text/html; charset=utf-8"."\n";
		$message .= "Content-Length: ".strlen($content)."\n";
		$message .= "Content-Transfer-Encoding: 8bit"."\n";
		$message .= "\n";
		$message .= $content;
		$message .= "\n";
		$message .= "\n";
	}

	if ($content_img != '')
		$message .= $content_img;

	if (is_array($files))
	foreach ($files as $name => $data)
	{
		$name = "=?UTF-8?B?" . base64_encode($name) . "?=";
		$content  = chunk_split(base64_encode($data), 70, "\n");
		$message .= "--".$boundary."\n"; 
		$message .= "Content-Type: application/octet-stream; name=\"" . $name . "\""."\n";
		$message .= "Content-Length: ".strlen($content)."\n";
		$message .= "Content-Disposition: attachment; filename=\"" . $name . "\""."\n";
		$message .= "Content-Transfer-Encoding: base64"."\n";
		$message .= "\n";
		$message .= $content;
		$message .= "\n";
		$message .= "\n";
	}

	return mail($to, $subject, $message, $headers);
}
*/

function multipart_replace_img($input)
{
        global $content_img, $boundary;

	$cid = md5(uniqid(rand()));
	$img_file = (substr($input[1],0,5) == 'http:') ? $input[1] : "../..".$input[1];

	$content  = chunk_split(base64_encode(file_get_contents($img_file)), 70, "\n");
	$message  = "--".$boundary."\n"; 
	$message .= "Content-Type: image/jpeg\n";
	$message .= "Content-ID: <" . $cid . ">\n";
	$message .= "Content-Disposition: inline\n";
	$message .= "Content-Transfer-Encoding: base64\n";
	$message .= "\n";
	$message .= $content;
	$message .= "\n";
	$message .= "\n";
	
	$content_img .= $message;

	return str_replace($input[1], "cid:".$cid, $input[0]);
}

?>