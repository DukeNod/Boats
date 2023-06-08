<?php

class FFMpeg
{
	function __construct()
	{
	}
	
	public function get_file_info (&$errors, $videoFile){
		if (!file_exists($videoFile)){
			validate_add_error($errors, "FFMpeg", "video_file_not_exists"); return;
		}
		
		$output = [];
		$a = exec('ffmpeg -i '.$videoFile.' 2>&1', $output, $retval);
		
		$result = '';
		foreach ($output as $str){
			$result .= $str;
		}
		//      С аудио стримом
		//$pattern = '/Duration:\s(\d\d:\d\d:\d\d\.\d+),.+Video:\s(.+)\s.+\s((\d{1,5})x(\d{1,5}))\s.+\s((\d{1,5})\s\D{2,5}),.+(\d{1,3})\sfps.+Audio:\s(.+)\s.+\s((\d{1,5})\s\D{2,5}\/s)\s/isU';
		
		//		Без аудио
		#$pattern = '/Duration:\s(\d\d):(\d\d):(\d\d\.\d+),.+Video:\s(.+)\s.+\s((\d{1,5})x(\d{1,5}))\s.+\s((\d{1,5})\s\D{2,5}),.+([\d|\.]{1,})\sfps/isU';
		$pattern = '/Duration:\s(\d\d):(\d\d):(\d\d\.\d+),.+Video:\s(.+)\s.+\s(([1-9]\d{1,5})x(\d{1,5}))[,\s].*\s((\d{1,5})\s\D{2,5}),.+([\d|\.]{1,})\sfps/isU';
		
		preg_match($pattern, $result, $matches);
		
		if (empty($matches)){
			validate_add_error($errors, "FFMpeg", "parse_error"); return;
		}
		
		$infoArr = [
				'duration' 				=> (3600*$matches[1]+60*$matches[2]+$matches[3])
			,	'videCodec' 			=> $matches[4] 
			,	'resolution' 			=> $matches[5] 
			,	'videoWith' 			=> $matches[6] 
			,	'videoHeight' 			=> $matches[7] 
			,	'bitrateVideo' 			=> $matches[8] 
			,	'bitrateVideoValue' 	=> $matches[9] 
			,	'fps' 					=> $matches[10] 
			//,	'audioCodec' 			=> $matches[11]
			//,	'bitrateAudio' 			=> $matches[12] 
			//,	'bitrateAudioValue' 	=> $matches[13]
		];
		
		return $infoArr;
	}
}