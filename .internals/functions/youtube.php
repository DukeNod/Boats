<?php
// Функции работы с API Youtube

function get_youtube_video_info($video_id)
{

/*
$xml = file_get_contents("http://gdata.youtube.com/feeds/api/videos/$video_id");

if (!$xml) throw new exception_bl('Can\'t get info page from Youtube');
$mydoc = new DOMDocument();

$loaded = $mydoc->loadXML($xml);
if (!$loaded) throw new exception_bl('Can\'t parce xml info');

die($mydoc->saveXML());
*/

$entry = simplexml_load_file("http://gdata.youtube.com/feeds/api/videos/$video_id");
if (!$entry) throw new exception_bl('Can\'t get info page from Youtube');

      // get nodes in media: namespace for media information
      $media = $entry->children('http://search.yahoo.com/mrss/');
      
      // get video player URL
      $attrs = $media->group->player->attributes();
      $watch = (string) $attrs['url']; 
      
      // get video thumbnail
      foreach($media->group->thumbnail as $p)
      {
	      $attrs = $p->attributes();
	      $w = (int) $attrs['width'];
              if ($w < 130)
              {
              	$thumbnail = (string) $attrs['url']; 
              	break;
              }
      }
            
      // get <yt:duration> node for video length
      $yt = $media->children('http://gdata.youtube.com/schemas/2007');
      $attrs = $yt->duration->attributes();
      $length = (string) $attrs['seconds']; 
      
      /*
      // get <yt:stats> node for viewer statistics
      $yt = $entry->children('http://gdata.youtube.com/schemas/2007');
      $attrs = $yt->statistics->attributes();
      $viewCount = $attrs['viewCount']; 
      
      // get <gd:rating> node for video ratings
      $gd = $entry->children('http://schemas.google.com/g/2005'); 
      if ($gd->rating) {
        $attrs = $gd->rating->attributes();
        $rating = $attrs['average']; 
      } else {
        $rating = 0; 
      } 
      */

      $return = array(
      	'name' => (string) $entry->title
      ,	'seconds' => $length
      ,	'time' => date('i:s', $length)
      ,	'preview' => $thumbnail
      ,	'player_code' => $watch
      );

	return $return;
}
?>