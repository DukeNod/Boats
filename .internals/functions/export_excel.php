<?php
class ExportExcel
{	
	private $settings = array(
		'row'		=> 0,
		'max_row' 	=> 1000000
	);
	
	private $iteration = 0;
	private $xls_files = array();
	private $fp = false;
	
	function __construct($puth = "") {
       $this->settings['dir'] 		= $puth;
	   $this->settings['zipfile'] 	= (new DateTime)->format('Y-m-d-H-i-s')."_". uniqid().".zip";
	}
	
	public function __get($property)
    {
		if ($property == "getZip") return $this->getZip();
        elseif (isset($this->settings[$property]))
			return $this->settings[$property];
		else 
			return false;
    }
	
	public function __set($property, $value)
    {
        switch ($property)
        {
			case 'set':
				if (is_array($value)) foreach ($value as $key => $val)
					$this->settings[$key] = $val;
				break;
			case 'writeRow':
				$this->process($value);
				break;
        }
	}
	
	private function getZip(){
		include_once('pclzip.lib.php');
		$archive = new PclZip($this->settings['dir'].$this->settings['zipfile']);
		foreach ($this->xls_files as $vfiles){
			$archive->add($this->settings['dir'].$vfiles, PCLZIP_OPT_REMOVE_PATH, $this->settings['dir']);
			if (file_exists($this->settings['dir'].$vfiles)) unlink($this->settings['dir'].$vfiles);
		}
		return $this->settings['dir'].$this->settings['zipfile'];
	}
	
	private function setXlsFile() {
		$this->xls_files[count($this->xls_files)] = (new DateTime)->format('Y-m-d-H-i-s')."_". uniqid().".xls";
		$this->fp = fopen($this->settings['dir'].$this->getXlsFile(), 'a');
	}
	
	private function getXlsFile(){
		return $this->xls_files[count($this->xls_files)-1];
	}

	private function process($row){
		if ($this->settings['row']!=0){
			if (!$this->fp) {
				$this->setXlsFile();
				$this->writeExcelHeader();
			}
			
			$this->writeRows($row);
	
			if ($this->settings['row']==0 || $this->iteration==$this->settings['max_row']){
				$this->writeExcelFootter();
				fclose($this->fp);
				$this->fp = false;
				$this->iteration=0;
			}
		}
	}
	
	private function writeRows ($row) {
		if ($this->settings['row']>0){
			$data = '<Row>'."\r\n";
			foreach ($this->settings['excelTitle'] as $key => $title){
				$data .= '<Cell><Data ss:Type="String">'.(isset($row[$key])?$row[$key]:"").'</Data></Cell>'."\r\n";
			}
			$data .= '</Row>'."\r\n";
			fwrite($this->fp, $data);
			$this->settings['row']--; 
			$this->iteration++;	
		}
	}
	
	
	
	private function writeExcelHeader () {
		$count_column = count($this->settings['excelTitle']);
		$count_rows = ($this->settings['row'] <= $this->settings['max_row']) ? $this->settings['row']+1 : $this->settings['max_row']+1;
		$_shapka = '
			<?xml version="1.0"?>
			<?mso-application progid="Excel.Sheet"?>
			<Workbook xmlns="urn:schemas-microsoft-com:office:spreadsheet"
			xmlns:o="urn:schemas-microsoft-com:office:office"
			xmlns:x="urn:schemas-microsoft-com:office:excel"
			xmlns:ss="urn:schemas-microsoft-com:office:spreadsheet"
			xmlns:html="http://www.w3.org/TR/REC-html40">
			<DocumentProperties xmlns="urn:schemas-microsoft-com:office:office">
			<Author>TSV</Author>
			<LastAuthor>TSV</LastAuthor>
			<Created>2018-08-14T04:13:57Z</Created>
			<Company>HOME</Company>
			<Version>16.00</Version>
			</DocumentProperties>
			<OfficeDocumentSettings xmlns="urn:schemas-microsoft-com:office:office">
			<AllowPNG/>
			</OfficeDocumentSettings>
			<ExcelWorkbook xmlns="urn:schemas-microsoft-com:office:excel">
			<WindowHeight>7980</WindowHeight>
			<WindowWidth>21570</WindowWidth>
			<WindowTopX>32767</WindowTopX>
			<WindowTopY>32767</WindowTopY>
			<ProtectStructure>False</ProtectStructure>
			<ProtectWindows>False</ProtectWindows>
			</ExcelWorkbook>
			<Styles>
			<Style ss:ID="Default" ss:Name="Normal">
			<Alignment ss:Vertical="Bottom"/>
			<Borders/>
			<Font ss:FontName="Arial Cyr" x:CharSet="204"/>
			<Interior/>
			<NumberFormat/>
			<Protection/>
			</Style>
			</Styles>
			<Worksheet ss:Name="work">
			<Table ss:ExpandedColumnCount="'.$count_column.'" ss:ExpandedRowCount="'.$count_rows.'" x:FullColumns="1"
			x:FullRows="1">
		';
		fwrite($this->fp, $_shapka);

		$data = '<Row>'."\r\n";
		foreach ($this->settings['excelTitle'] as $title){
			$data .= '<Cell><Data ss:Type="String">'.$title.'</Data></Cell>'."\r\n";
		}
		$data .= '</Row>'."\r\n";
		fwrite($this->fp, $data);
	}
	
	private function writeExcelFootter () {
		$_footer = '
			</Table>
			<WorksheetOptions xmlns="urn:schemas-microsoft-com:office:excel">
			<PageSetup>
				<PageMargins x:Bottom="0.984251969" x:Left="0.78740157499999996"
				x:Right="0.78740157499999996" x:Top="0.984251969"/>
			</PageSetup>
			<Print>
				<ValidPrinterInfo/>
				<PaperSizeIndex>9</PaperSizeIndex>
				<HorizontalResolution>600</HorizontalResolution>
				<VerticalResolution>600</VerticalResolution>
			</Print>
			<Selected/>
			<Panes>
				<Pane>
				<Number>3</Number>
				<ActiveRow>10</ActiveRow>
				<ActiveCol>3</ActiveCol>
				</Pane>
			</Panes>
			<ProtectObjects>False</ProtectObjects>
			<ProtectScenarios>False</ProtectScenarios>
			</WorksheetOptions>
			</Worksheet>
			</Workbook>
		';
		fwrite($this->fp, $_footer);
	}
	
}

?>