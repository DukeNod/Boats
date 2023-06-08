<?php // Должен быть в юникоде

class APEC
{
	public static $APEC_signature = 'APEC Business Travel Card';
	public static $APEC_regex = '/([0-9]+).*([0-9]{2}\.[0-9]{2}\.[0-9]{4})/';
	public static $APEC_regex_full = '/^APEC Business Travel Card, номер ([0-9]+), действительна до ([0-9]{2}\.[0-9]{2}\.[0-9]{4})/';
	public static $APEC_regex_date = '/([0-9]{4})-([0-9]{2})-([0-9]{2})/';
	public static $APEC_splitter = '||';

	public static function apec_is_present($comments)
	{
		return strstr($comments,self::$APEC_signature) ? 1 : 0;
	}

	public static function apec_number($comments)
	{
		if (preg_match(self::$APEC_regex_full,$comments,$match))
		{
			return $match[1];
		}
		else
		{
			return '';
		}
	}

	public static function apec_expire_date($comments)
	{
		if (preg_match(self::$APEC_regex_full,$comments,$match))
		{
			return $match[2];
		}
		else
		{
			return '';
		}
	}

	public static function apec_manual_comment($comments)
	{
		if (empty($comments))
		{
			return $comments;
		}
	
		$parts = explode(self::$APEC_splitter,$comments);

		if (count($parts) > 0)
		{
			if (preg_match(self::$APEC_regex_full,$parts[0],$match))
			{
				return $parts[1];
		    }
			else
			{
				return $comments;
			}
		}
		else
		{
			return $comments;
		}
	}

	public static function apec_make_comments($number,$expire_date,$comments)
	{
		//print 'number = '.$number.'<br />';
		//print 'expire_date = '.$expire_date.'<br />';
		//print 'comments = '.$comments.'<br />';
		//die();

		$comments_xml = '';
		if (!empty($number) && !empty($expire_date))
		{
			$rus_date = '';
			if (preg_match(self::$APEC_regex_date,$expire_date,$match))
			{
				$rus_date = $match[3].'.'.$match[2].'.'.$match[1];
				$comments_xml = self::$APEC_signature.', номер '.$number.', действительна до '.$rus_date;
			}
		}

		$comments = str_replace(self::$APEC_splitter,'',$comments);
		if ($comments)
		{
			if (strlen($comments_xml) > 0)
			{
				$comments_xml = $comments_xml.self::$APEC_splitter.$comments;
			}
			else
			{
				$comments_xml = $comments;
			}
		}

		return $comments_xml;
	}

}

?>