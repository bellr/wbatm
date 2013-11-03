<?php
define('VS_DEBUG',true);
define('PROJECT','ATM');
require_once("../../core/vs.php");

$arr = array(
"WMZ_WMR" => "WMZ -> WMR",
"WMZ_WME" => "WMZ -> WME",
"WMZ_WMU" => "WMZ -> WMU",
"WMZ_EasyPay" => "WMZ -> ESP",
"WMR_WMZ" => "WMR -> WMZ",
"WMR_WME" => "WMR -> WME",
"WMR_WMU" => "WMR -> WMU",
"WMR_EasyPay" => "WMR -> ESP",
"WME_WMZ"=> "WME -> WMZ",
"WME_WMR" => "WME -> WMR",
"WME_WMU" => "WME -> WMU",
"WME_EasyPay" => "WME -> ESP",
"WMU_WMZ" => "WMU -> WMZ",
"WMU_WMR" => "WMU -> WMR",
"WMU_WME" => "WMU -> WME",
"WMU_EasyPay" => "WMU -> ESP",
"EasyPay_Z-PAYMENT" => "ESP -> Z-PAYMENT",
"EasyPay_WMU" => "ESP -> WMU",
"EasyPay_WME" => "ESP -> WME",
"EasyPay_WMR" => "ESP -> WMR",
"EasyPay_WMZ" => "ESP -> WMZ",
"Z-PAYMENT_EasyPay" => "Z-PAYMENT -> ESP",
);

$info_direct = dataBase::DBexchange()->select('kurs','direction,konvers','where status=1');
//$stmt_select = dataBase::DBexchange()->prepare('select konvers,direct from kurs where direction=?');

$info_balance = dataBase::DBexchange()->select('balance','name,balance','where st_exch=1');
foreach($info_balance as $ib) {
	$balance_array[$ib['name']] = $ib['balance'];
}

$estandart = Config::getConfig('estandart');
$text = '';

foreach($info_direct as $kar) {
	$mv = explode("_",$kar['direction']);
	
	/*$direction = $kar['direction'];
	$stmt_select->bind_param("s", $direction);
	$stmt_select->execute();
	$stmt_select->bind_result($konvers,$direct);
	$stmt_select->fetch();*/

	$balance = $balance_array[$mv[1]];
	$direction = $estandart[$mv[0]].' -> '.$estandart[$mv[1]];
	if($balance > 0) {
		if($direct == "n") {
			$text .= "{$direction}: rate={$kar['konvers']}, reserve={$balance}\n";
		}
		else {
			$rates = round(1/$kar['konvers'],5);
			$text .= "{$direction}: rate={$rates}, reserve={$balance}\n";
		}
	//dd($stmt_select->affected_rows);
							//d($stmt_select->fetch());
						
							/*while ($stmt_select->fetch()) {
							echo $direct;
						}*/
	}
}

$fd = fopen(Config::$base['HOME']['ROOT']."/out_rates_all.aspx","w+");
fputs($fd, $text);
fflush($fd);
fclose($fd);
