<?PHP
/*************************************************************************/
/* This class stores associative arrays in an xml formated string.       */
/* There's also a function thar retrieves them. If you try to use        */ 
/* xml2array with a general xml, it can fail, since there can be some    */
/* repeated indexes....                                                  */
/*************************************************************************/

/*************************************************************************/
/* Use:
/* 
<?PHP
include('assoc_array2xml.php');
$example_array=array('one'=>'23','two'=>array('subone'=>'22',subtwo=>'233'),'three'=>'2');
$converter= new assoc_array2xml;
$string=$converter->array2xml($example_array);
echo "******\n$string\n********\n";
$array=$converter->xml2array($string);
print_r($array);
?>
 
*/
class assoc_array2xml {
var $text;
var $arrays, $keys, $node_flag, $depth, $xml_parser;
/*Converts an array to an xml string*/
function array2xml($array) {
//global $text;
$this->text="<?xml version=\"1.0\" encoding=\"iso-8859-1\"?><array>";
$this->text.= $this->array_transform($array);
$this->text .="</array>";
return $this->text;
}

function array_transform($array){
//global $array_text;
foreach($array as $key => $value){
if(!is_array($value)){
 $value=str_replace(array('<','>'),array('&lt;','&gt;'),$value);
 $this->text .= "<$key>$value</$key>";
 } else {
 $this->text.="<$key>";
 $this->array_transform($value);
 $this->text.="</$key>";
 }
}
return $array_text;

}
/*Transform an XML string to associative array "XML Parser Functions"*/
function xml2array($xml){
$this->depth=-1;
$this->xml_parser = xml_parser_create('UTF-8');
xml_set_object($this->xml_parser, $this);
xml_parser_set_option ($this->xml_parser,XML_OPTION_CASE_FOLDING,0);//Don't put tags uppercase
xml_set_element_handler($this->xml_parser, "startElement", "endElement");
xml_set_character_data_handler($this->xml_parser,"characterData");
xml_parse($this->xml_parser,$xml,true);
xml_parser_free($this->xml_parser);
return $this->arrays[0];

}
function startElement($parser, $name, $attrs)
 {
   $this->keys[]=$name; //We add a key
   $this->node_flag=1;
   $this->depth++;
 }
function characterData($parser,$data)
 {
   $key=end($this->keys);
   $data=str_replace(array('&lt;','&gt;'),array('<','>'),$data);
   $this->arrays[$this->depth][$key].=$data;
   $this->node_flag=0; //So that we don't add as an array, but as an element
 }
function endElement($parser, $name)
 {
   $key=array_pop($this->keys);
   //If $node_flag==1 we add as an array, if not, as an element
   if($this->node_flag==1){
     $this->arrays[$this->depth][$key]=$this->arrays[$this->depth+1];
     unset($this->arrays[$this->depth+1]);
   }
   $this->node_flag=1;
   $this->depth--;
 }
}//End of the class
//-----------------------------------------------------------------------------
function xml_2_array($xml)
{
	$doc = new DOMDocument();
	$doc->formatOutput = true;
	$doc->preserveWhiteSpace = false;
	libxml_use_internal_errors(true);
	libxml_clear_errors();
	$doc->loadXML($xml);
	$xpath = new DOMXPath($doc);
	foreach( $xpath->query('namespace::*', $doc->documentElement) as $node)
	{
		$ns = $doc->documentElement->lookupPrefix($node->nodeValue);
		$doc->documentElement->removeAttributeNS($node->nodeValue, $ns);
	}
	$doc->loadXML($doc->saveXML($doc->documentElement));
	return Dom_2_Array($doc->documentElement);
}
//-----------------------------------------------------------------------------
function Dom_2_Array($root)
{
	$data = array();
	if($root->nodeType == XML_ELEMENT_NODE) //handle classic node
	{
		if($root->hasChildNodes())
		{
			$children = $root->childNodes;
			for($i = 0; $i < $children->length; $i++)
			{
				$child = Dom_2_Array($children->item($i));
				if(!empty($child)) //don't keep textnode with only spaces and newline
				{
					if(is_array($child))
					{
						reset($child);
						$node=key($child);
//						$data[$root->nodeName][$node][] = $child[$node];
						if(isset($data[$root->nodeName][$node]))
						{
							if(!is_array($data[$root->nodeName][$node]) || !isset($data[$root->nodeName][$node][0]))
							{
								$aux = $data[$root->nodeName][$node];
								unset($data[$root->nodeName][$node]);
								$data[$root->nodeName][$node][0] = $aux;
							}
							$data[$root->nodeName][$node][count($data[$root->nodeName][$node])] = $child[$node];
						}
						else $data[$root->nodeName][$node] = $child[$node];
					}
					else $data[$root->nodeName] = $child;
				}
			}

/*
			//list attributes
			if($root->hasAttributes())
			{
				foreach($root->attributes as $attribute) $atr[$attribute->name] = $attribute->value;
				$data[$root->nodeName]["---"] = $atr;
			}
*/
		}
	}
	elseif($root->nodeType == XML_TEXT_NODE || $root->nodeType == XML_CDATA_SECTION_NODE) //handle text node
	{
		if(!empty($root->nodeValue)) $data=$root->nodeValue;
	}
	return $data;
}
//-----------------------------------------------------------------------------
/*
* Recursive function to turn an array to a DOMDocument
* @param array       $array the array
* @param DOMDocument $doc   only used by recursion
*/
function Array_2_Dom($array, $doc = null)
{
	if($doc == null)
	{
		$doc = new DOMDocument();
		$doc->formatOutput = true;
		$currentNode = $doc;
	}
	else
	{
		if($array['_type'] == '_text') $currentNode = $doc->createTextNode($array['_content']);
		else $currentNode = $doc->createElement($array['_type']);
	}
	if($array['_type'] != '_text')
	{
		if(isset($array['_attributes'])) foreach ($array['_attributes'] as $name => $value) $currentNode->setAttribute($name, $value);
		if(isset($array['_children']))
		{
			foreach($array['_children'] as $child)
			{
				$childNode = Array2Dom($child, $doc);
				$childNode = $currentNode->appendChild($childNode);
			}
		}
	}
	return $currentNode;
}
//-----------------------------------------------------------------------------
?>
