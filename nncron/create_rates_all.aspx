<?php
define('VS_DEBUG',true);
define('PROJECT_ROOT',dirname(dirname(__FILE__)));
define('PROJECT','ATM');

require_once(dirname(PROJECT_ROOT)."/core/vs.php");

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
