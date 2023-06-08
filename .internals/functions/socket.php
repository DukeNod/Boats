<?php
global $agents;

$agents=array(
		array(
			'p'=>35,
			'user_agent'=>'Mozilla/4.0 (compatible; MSIE 7.0; Windows NT 5.1; MRA 5.1 (build 02243)'
		),
		array(
			'p'=>25,
			'user_agent'=>'Mozilla/4.0 (compatible; MSIE 6.0; Windows NT 5.1; MRA 5.1 (build 02243)'
		),
		array(
			'p'=>20,
			'user_agent'=>'Opera/9.51 (Windows NT 5.1; U; ru)'
		),
		array(
			'p'=>10,
			'user_agent'=>'Mozilla/5.0 (Windows; U; Windows NT 5.1; ru; rv:1.9.0.1) Gecko/2008070208 Firefox/3.0.1 '
		),
		array(
			'p'=>10,
			'user_agent'=>'Mozilla/5.0 (Windows; U; Windows NT 5.1; ru; rv:1.8.1.1) Gecko/20061204 Firefox/2.0.0.1'
		)
	);


function GetRandAgent(){
	global $agents;
	$a=rand(1,100);
	$tmp=0;
	foreach($agents as $v){
		$tmp+=$v['p'];
		if ($a<=$tmp) return $v['user_agent'];
	}
	return '';
}


function make_http_request($url, $header=0, $proxy_id = '') {
	
		$user_agent = GetRandAgent(); //"Mozilla/4.0+(compatible;+MSIE+5.5;+Windows+98)";
		$ch = curl_init();
		curl_setopt($ch, CURLOPT_URL, $url);
		curl_setopt($ch, CURLOPT_USERAGENT,  $user_agent);
		curl_setopt($ch, CURLOPT_COOKIEJAR,  "cookies/".$proxy_id."cookie.txt");
		curl_setopt($ch, CURLOPT_COOKIEFILE, "cookies/".$proxy_id."cookie.txt");
		curl_setopt($ch, CURLOPT_INTERFACE,  $_SERVER['SERVER_ADDR']);
		
		curl_setopt($ch, CURLOPT_RETURNTRANSFER, 1);
		curl_setopt($ch, CURLOPT_FOLLOWLOCATION, 1);
		curl_setopt($ch, CURLOPT_TIMEOUT, 15);
		if ($header) curl_setopt($ch, CURLOPT_HEADER, 1);
		$page = curl_exec($ch);

		return $page;
}

function make_https_post_request($url, $data, $add_headers = [], $header=0, $proxy_id = '') {
	
		$user_agent = GetRandAgent(); //"Mozilla/4.0+(compatible;+MSIE+5.5;+Windows+98)";
		$ch = curl_init();
		curl_setopt($ch, CURLOPT_URL, $url);
		curl_setopt($ch, CURLOPT_USERAGENT,  $user_agent);
		#curl_setopt($ch, CURLOPT_COOKIEJAR,  "cookies/".$proxy_id."cookie.txt");
		#curl_setopt($ch, CURLOPT_COOKIEFILE, "cookies/".$proxy_id."cookie.txt");
		curl_setopt($ch, CURLOPT_INTERFACE,  $_SERVER['SERVER_ADDR']);
		curl_setopt($ch, CURLOPT_POST, 1);
		
		curl_setopt($ch, CURLOPT_POSTFIELDS, $data);
		
		if ($add_headers)
			curl_setopt($ch, CURLOPT_HTTPHEADER, $add_headers);
		
		curl_setopt($ch, CURLOPT_RETURNTRANSFER, 1);
		curl_setopt($ch, CURLOPT_FOLLOWLOCATION, 1);
		curl_setopt($ch, CURLOPT_TIMEOUT, 15);
		curl_setopt($ch, CURLOPT_SSL_VERIFYPEER, 0);
		if ($header) curl_setopt($ch, CURLOPT_HEADER, 1);
		$page = curl_exec($ch);

		return $page;
}

function getSocketRequest($query_str, $proxy_id = '', $attempt = 0)
{
	return make_http_request($query_str, 0, $proxy_id);

	$res=false;
	$request=parse_url($query_str);
	if ($request['path'] == '') $request['path'] = '/';

	$service_port = getservbyname ('www', 'tcp');

	#$address = gethostbyname ('localhost');
	$address = gethostbyname ($request['host']);
	$socket = socket_create (AF_INET, SOCK_STREAM, 0);
	if ($socket < 0) {
	    return "socket_create() failed: reason: " . socket_strerror ($socket) . "\n";
	}

	if (!socket_bind($socket, $_SERVER['SERVER_ADDR'])) {
	    return "socket_bind() failed: reason: " . socket_strerror ($socket) . "\n";
	}

	$result = @socket_connect ($socket, $address, $service_port);

	if ((!$result) || ($result < 0)) {
		#return false;
		return "socket_connect() failed.\nReason: ($result) " . socket_strerror($result) . "\n";
	}

	$in = "GET ".$request['path'].(isset($request['query']) ? "?".$request['query'] : "")." HTTP/1.1\r\nHost: {$request['host']}\r\n";
	$in .= "User-Agent: ".GetRandAgent()."\r\n";
	$in .= "Connection: Close\r\n\r\n";
	$out = '';

	socket_write ($socket, $in, strlen ($in));

	$chunked=false;

	if ($out = socket_read ($socket, 2048))
	{
		$p=strpos($out,"\r\n\r\n");
		$header=substr($out,0,$p);
		$tmp=explode("\r\n",$header);
		foreach ($tmp as $v)
		{
			if ($p1=strpos($v,":"))
			{
				$f=substr($v,0,$p1);
				$headers[$f]=trim(substr($v,$p1+1));
			}
			elseif (preg_match("/HTTP\/1\.1 (\d+)/",$v,$rr))
			{
				$headers['response']=$rr[1];				
			}
		}	

		if ($headers['response']=='302')
		{
		        #return $request['path'].(isset($request['query']) ? "?".$request['query'] : "")."\n\n".$headers['Location'];
		        if ($attempt < 10)
		        {
			        $url = ($headers['Location'][0]=='/') 
			        	? 'http://'.$request['host'].$headers['Location']
			        	: $headers['Location'];			        
				return getSocketRequest($url, $proxy_id, $attempt+1);
		        }else
		        {
			        return "More when 10 redirects (http: 302)";
		        }
		}

		if ($headers['response']!='200')
		{
		        $res = $out;
			while ($tmp = socket_read ($socket, 2048)) $res.=$tmp;
			return "Headers errors:\n".$out;
		}

		$out = substr($out,$p+4);

		if ($headers['Transfer-Encoding']=="chunked")
		{
			$p2=strpos($out,"\n");
			#$length=intval(trim(substr($out,0,$p2)),16);
			$out = substr($out,$p2+1);
		
		}
		elseif(isset($headers['Content-Length']))
		{
			$length=intval($headers['Content-Length']);
		}

		$res=$out;
		$size=strlen($out);
		while (($out = socket_read ($socket, 2048))&&((!isset($length) || ($size<$length))))
		{
			$size+=strlen($out);
			$res.=$out;
		}

		if ($headers['Transfer-Encoding']=="chunked")
		{
			if (substr($res,-5)=="0\r\n\r\n") $res=substr($res,0,-5);
		}

	}

	return $res;
}

function getSocketPostRequest($query_str, $data, $add_headers = [], $proxy_id = '', $attempt = 0)
{
	$res=false;
	$request=parse_url($query_str);
	if ($request['path'] == '') $request['path'] = '/';

	$data_str = '';
	foreach($data as $f=>$v)
	{
		$data_str .= urlencode($f) . '=' . urlencode($v) . '&';
	}
	$data_str = substr($data_str, 0, -1);

	$service_port = getservbyname ('www', 'tcp');

	#$address = gethostbyname ('localhost');
	$address = gethostbyname ($request['host']);
	$socket = socket_create (AF_INET, SOCK_STREAM, 0);
	if ($socket < 0) {
	    return "socket_create() failed: reason: " . socket_strerror ($socket) . "\n";
	}

	if (!socket_bind($socket, $_SERVER['SERVER_ADDR'])) {
	    return "socket_bind() failed: reason: " . socket_strerror ($socket) . "\n";
	}

	$result = @socket_connect ($socket, $address, $service_port);

	if ((!$result) || ($result < 0)) {
		#return false;
		return "socket_connect() failed.\nReason: ($result) " . socket_strerror($result) . "\n";
	}

	$in = "POST ".$request['path'].(isset($request['query']) ? "?".$request['query'] : "")." HTTP/1.1\r\nHost: {$request['host']}\r\n";
	$in .= "User-Agent: ".GetRandAgent()."\r\n";
	$in .= "Content-type: application/x-www-form-urlencoded\r\n";
	$in .= "Content-length: ".strlen($data_str)."\r\n";
	$in .= "Connection: Close\r\n\r\n";
	$in .= $data_str."\r\n\r\n";
	$out = '';

	socket_write ($socket, $in, strlen ($in));

	$chunked=false;

	if ($out = socket_read ($socket, 2048))
	{
		$p=strpos($out,"\r\n\r\n");
		$header=substr($out,0,$p);
		$tmp=explode("\r\n",$header);
		foreach ($tmp as $v)
		{
			if ($p1=strpos($v,":"))
			{
				$f=substr($v,0,$p1);
				$headers[$f]=trim(substr($v,$p1+1));
			}
			elseif (preg_match("/HTTP\/1\.1 (\d+)/",$v,$rr))
			{
				$headers['response']=$rr[1];				
			}
		}	

		if ($headers['response']=='302')
		{
		        #return $request['path'].(isset($request['query']) ? "?".$request['query'] : "")."\n\n".$headers['Location'];
		        if ($attempt < 10)
		        {
			        $url = ($headers['Location'][0]=='/') 
			        	? 'http://'.$request['host'].$headers['Location']
			        	: $headers['Location'];			        
				return getSocketRequest($url, $data, $proxy_id, $attempt+1);
		        }else
		        {
			        return "More when 10 redirects (http: 302)";
		        }
		}

		if ($headers['response']!='200')
		{
		        $res = $out;
			while ($tmp = socket_read ($socket, 2048)) $res.=$tmp;
			return "Headers errors:\n".$res;
		}

		$out = substr($out,$p+4);

		/*
		if ($headers['Transfer-Encoding']=="chunked")
		{
			$p2=strpos($out,"\n");
			$length=intval(trim(substr($out,0,$p2)),16);
			$out = substr($out,$p2+1);
		}
		*/

		if(isset($headers['Content-Length']))
		{
			$length=intval($headers['Content-Length']);
		}

		$res=$out;
		$size=strlen($out);
		while (($out = socket_read ($socket, 2048))&&((!isset($length) || ($size<$length))))
		{
			$size+=strlen($out);
			$res.=$out;
		}

		if (isset($headers['Transfer-Encoding']) && $headers['Transfer-Encoding']=="chunked")
		{
		        $res = http_chunked_decode($res);
			#if (substr($res,-5)=="0\r\n\r\n") $res=substr($res,0,-5);
		}

	}

	return $res;
}

if (!function_exists('http-chunked-decode')) { 
    /** 
     * dechunk an http 'transfer-encoding: chunked' message 
     * 
     * @param string $chunk the encoded message 
     * @return string the decoded message.  If $chunk wasn't encoded properly it will be returned unmodified. 
     */ 
    function http_chunked_decode($chunk) { 
        $pos = 0; 
        $len = strlen($chunk); 
        $dechunk = null; 

        while(($pos < $len) 
            && ($chunkLenHex = substr($chunk,$pos, ($newlineAt = strpos($chunk,"\n",$pos+1))-$pos))) 
        { 
            if (! is_hex($chunkLenHex)) { 
                trigger_error('Value is not properly chunk encoded', E_USER_WARNING); 
                return $chunk; 
            } 

            $pos = $newlineAt + 1; 
            $chunkLen = hexdec(rtrim($chunkLenHex,"\r\n")); 
            $dechunk .= substr($chunk, $pos, $chunkLen); 
            $pos = strpos($chunk, "\n", $pos + $chunkLen) + 1; 
        } 
        return $dechunk; 
    } 
} 

    /** 
     * determine if a string can represent a number in hexadecimal 
     * 
     * @param string $hex 
     * @return boolean true if the string is a hex, otherwise false 
     */ 
    function is_hex($hex) { 
        // regex is for weenies 
        $hex = strtolower(trim(ltrim($hex,"0"))); 
        if (empty($hex)) { $hex = 0; }; 
        $dec = hexdec($hex); 
        return ($hex == dechex($dec)); 
    }
?>