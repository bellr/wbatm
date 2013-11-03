<?
define('VS_DEBUG',true);
define('PROJECT','ATM');
require_once("../../core/vs.php");

set_time_limit(0);
ignore_user_abort(1);

//$mas_ind = array("1","23","7","6","5","20","12","4","19","11","3","18","10","2","17","9","24","8");
$mas_ind = array('1','2','3','4','5','6','7','8','9','10','11','12','17','18','19','20','23','24');


foreach($mas_ind as $ar) {

	$filename = "https://wm.exchanger.ru/asp/XMLWMList.asp?exchtype=".$ar;
	$ch = curl_init();
	curl_setopt($ch, CURLOPT_USERAGENT, "Mozilla/4.0 (compatible; MSIE 8.0; Windows NT 6.1)");
	curl_setopt($ch, CURLOPT_URL, $filename);
	curl_setopt($ch, CURLOPT_HEADER, 0);
	curl_setopt($ch, CURLOPT_RETURNTRANSFER,1);
	curl_setopt($ch, CURLOPT_VERBOSE,0);
	$fd = curl_exec($ch);
	if($fd){
		$xmlres = simplexml_load_string($fd);
		$d = $xmlres->WMExchnagerQuerys['amountin']."_". $xmlres->WMExchnagerQuerys['amountout'];
echo $d."<br>";

		$sel_infodir = dataBase::DBexchange()->select('kurs','commission,direct','where direction="'.$d.'" and upd=1');
		if(!empty($sel_infodir)) {
			if($sel_infodir[0]['direct'] == "y") $rate = str_replace(',','.',trim($xmlres->WMExchnagerQuerys->query[0]['outinrate']));
			if($sel_infodir[0]['direct'] == "n") $rate = str_replace(',','.',trim($xmlres->WMExchnagerQuerys->query[0]['inoutrate']));

			$kurs = $rate + $rate * $sel_infodir[0]['commission']/100;
			dataBase::DBexchange()->update('kurs',array('konvers'=>$kurs),"where direction='{$d}'");
			dataBase::DBexchange()->update('wmrate',array('rate'=>$rate),"where direction='{$d}'");
		}
		else {

			$sel_infodir = dataBase::DBexchange()->select('kurs','commission,direct','where direction="'.$d.'" and upd=1');
			//if($sel_infodir[0]['direct'] == "y") $rate = str_replace(',','.',trim($xmlres->WMExchnagerQuerys->query[0]['outinrate']));
			if($sel_infodir[0]['direct'] == "n") $rate = str_replace(',','.',trim($xmlres->WMExchnagerQuerys->query[0]['inoutrate']));
			dataBase::DBexchange()->update('kurs',array('konvers'=>$rate),"where direction='{$d}'");
		}

		//echo $xmlres->WMExchnagerQuerys->query[0]['outinrate']."<br>";
		//echo date("H:i:s")."  ".$d." -  ".$kurs."\n";
	}
	sleep(1);

}

?>