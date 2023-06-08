<?php

function libxml_display_error($error)
{
    $return = "";
    switch ($error->level) {
        case LIBXML_ERR_WARNING:
            $return .= "Warning $error->code: ";
            break;
        case LIBXML_ERR_ERROR:
            $return .= "Error $error->code: ";
            break;
        case LIBXML_ERR_FATAL:
            $return .= "Fatal Error $error->code: ";
            break;
    }
    $return .= trim($error->message);
    $return .= " on line $error->line\n";

    return $return;
}

function libxml_display_errors()
{
	$ret = [];
    $errors = libxml_get_errors();
    foreach ($errors as $i => $error) {
        $ret['error:'.$i] = libxml_display_error($error);
    }
    libxml_clear_errors();
    
    return $ret;
}

if ($pathargs)
{
	$id = array_shift($pathargs);
	
	$doc = new DOMDocument();
	$doc->formatOutput = true;
	$doc->preserveWhiteSpace = false;
	$xmlerrors = libxml_use_internal_errors(true);
	libxml_clear_errors();

	$xsd = '../../.internals/files/schema/hotel/';
	
	if (isset($_POST['xml']) && $_POST['xml'] != '')
	{
		if (preg_match('/form5\:|ns9\:|ns1\:|f5\:/', $_POST['xml']))
		{
			$xsd .= 'hotel-form5.xsd';
		}
		elseif (preg_match('/ns4\:|ns5\:|ns7\:|rmsr\:/', $_POST['xml']))
		{
			$xsd .= 'migration-staying.xsd';
		}
		elseif (preg_match('/rmsu\:/', $_POST['xml']))
		{
			$xsd .= 'migration-staying-unreg.xsd';
		}
		
		$load = $doc->loadXML($_POST['xml']);

		$is_err = false;
		
		if ($load)
		{
			$xml = $doc->saveXML($doc->documentElement);
			$doc->loadXML($xml);
			
			if ($doc->schemaValidate($xsd))
			{
				_main_::put2dom('success', "Документ является действительным!");
				
				_main_::query(null, "
					update	xml_files
					set	content_body = {2}
					where	id = {1}
				", $id, $xml);

				$files = _main_::query(null, "
					select	request_id
					from	xml_files
					where	id = {1}
				", $id);
				$file = array_shift($files);
				
				_main_::query(null, "
					update	requests
					set	error_msg = ''
					,	is_valid = 1
					,	response_state = null
					,	sig = 0
					where	id = {1}
				", $file['request_id']);
			}
			else
			{
				$is_err = true;
				#$xmlerror = libxml_get_last_error();
				#libxml_use_internal_errors($xmlerrors);
				#_main_::put2dom('errors', $xmlerror->message);
				$err = libxml_display_errors();
				_main_::put2dom('errors', $err);
			}
		}
		else
		{
			$xml = $_POST['xml'];
			$is_err = true;
		}

		if ($is_err)	
		{
			$err = libxml_display_errors();
			_main_::put2dom('errors', $err);
			
		}
		
		_main_::put2dom('xml', $xml);
		_main_::put2dom('id', $id);
	}
	else
	{
		$files = _main_::query(null, "
			select	content_body
			from	xml_files
			where	id = {1}
		", $id);

		$file = array_shift($files);
				
		$xml = $file['content_body'];
		$load = $doc->loadXML($xml);
		
		if ($load)
		{
			$xml = $doc->saveXML($doc->documentElement);
		}
			
		_main_::put2dom('xml', $xml);
		_main_::put2dom('id', $id);
	}
}
?>