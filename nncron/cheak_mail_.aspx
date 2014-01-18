<?
$part_time = explode(' ',microtime());
$begin_time = $part_time[1].substr($part_time[0],1);

require("customsql.inc.aspx");
include("constructor_exch_auto.aspx");
$db_exchange = new CustomSQL_exchange($DBName_exchange);
$db_pay_desk = new CustomSQL_pay_desk($DBName_pay_desk);
$db_admin = new CustomSQL_admin($DBName_admin);

function utf8_win ($s){
$out="";
$c1="";
$byte2=false;
for ($c=0;$c<strlen($s);$c++){
$i=ord($s[$c]);
if ($i<=127) $out.=$s[$c];
if ($byte2){
$new_c2=($c1&3)*64+($i&63);
$new_c1=($c1>>2)&5;
$new_i=$new_c1*256+$new_c2;
if ($new_i==1025){
$out_i=168;
}else{
if ($new_i==1105){
$out_i=184;
}else {
$out_i=$new_i-848;
}
}
$out.=chr($out_i);
$byte2=false;
}
if (($i>>5)==6) {
$c1=$i;
$byte2=true;
}
}
return $out;
}
$filename = "rbkmail/rbk_mail.txt";
//$filename = "virtuser_1007";
//если файл пустой ничего не делать
if (filesize($filename) != 0) {
//место хранение файла с сообщениями
$c =0;
$fd = fopen($filename,'r');
$bf = fread($fd, filesize($filename));
fclose($fd);
//очистка файла входящих сообшений, ПРОСМОТРЕТЬ ВАРИАНТ ВСТАВКИ ЭТОГО КОДА ПОСЛЕИЗВЛЕЧЕНИЯ ИНФЫ В НАЧАЛО ВСЕГО КОДА
$fd_cl = fopen($filename,'w');
flock($fd_cl, LOCK_EX);
fwrite($fd_cl, '');
flock($fd_cl, LOCK_UN);
fclose($fd_cl);

$lines = explode('From noreply@rbkmoney.ru',$bf);

//перебираем письма и находим от RBK по адресу
foreach ($lines as $line) {
	$c++;

	$count = 0;
	$ss = explode(' ',$line);
	foreach ($ss as $ssi) $count++;

		if(preg_match("/FILETIME=\[/", $ss[$count-1], $utf_arr)) {

$utf_ok = substr($ss[$count-1], 30);
		}
		else $utf_ok = $ss[$count-1];
//echo $utf_ok."<br>";

	$line_base64_decode = base64_decode($utf_ok);
	$utf8_win = utf8_win($line_base64_decode);

//echo $utf8_win."<br><br />";
	if(preg_match("/[0-9]{2}[.][0-9]{2}[.][0-9]{4}/", $utf8_win, $arr)) {
		$data_pr = explode(".",$arr[0]);
		$data_de = date("Y-m-d",mktime(0,0,0,$data_pr[1],$data_pr[0]-1,$data_pr[2]));
		$data_nach = date("Y-m-d",mktime(0,0,0,$data_pr[1],$data_pr[0],$data_pr[2]));
	}

	if(preg_match("/[a-zA-Z0-9\.\_\-]+@[a-zA-Z0-9_^\.\-]+\.[a-zA-Z]{2,3}/i", $utf8_win, $email_arr)) {
		$email_merch = strtolower($email_arr[0]); }

	if(preg_match("/Сумма получения: [\d,.]+ руб\./", $utf8_win, $summ_arr)) {
		$summa_merch = explode(' ',$summ_arr[0]);}

//echo $email_merch."<br>";
//echo $summa_merch[2]."<br>";
//echo $data_nach."<br>";
//echo $data_de."<br><br /><br />";
			$sel_demand_cheak = $db_exchange->sel_demand_cheak($email_merch,$summa_merch[2],$data_nach,$data_de);

				if(!empty($sel_demand_cheak)) {
//echo "<br>Платеж совершен<br />";
//echo $sel_demand_cheak[0]['did']."<br>";
//echo $sel_demand_cheak[0]['ex_output']."<br>";
//echo $sel_demand_cheak[0]['out_val']."<br>";
//echo $sel_demand_cheak[0]['purse_out']."<br>";
//echo $sel_demand_cheak[0]['purse_in']."<br>";
//echo $sel_demand_cheak[0]['data']."<br>";
					$db_exchange->demand_edit('yn',$sel_demand_cheak[0]['did']);
					$exch_balance = $db_exchange->exch_balance($sel_demand_cheak[0]['ex_output']);
					$bal_in = $exch_balance[0]["balance"] + $sel_demand_cheak[0]['out_val'];
					$db_exchange->demand_update_bal($bal_in,$sel_demand_cheak[0]['ex_output']);
					$desc_pay = "Direction of the exchange: {$sel_demand_cheak[0]['ex_output']}->{$sel_demand_cheak[0]['ex_input']}, ID:{$sel_demand_cheak[0]['did']}";

					$sel_idpay = $db_admin->sel_idpay($sel_demand_cheak[0]['did']);
					check_payment($sel_demand_cheak[0]['ex_input'],$sel_demand_cheak[0]['purse_in'],$sel_demand_cheak[0]['in_val'],$desc_pay,$sel_demand_cheak[0]['did'],$sel_idpay[0]['id_pay']);
				}
				else {
					$sel_demand_pay = $db_pay_desk->sel_demand_pay($email_merch,$summa_merch[2],$data_nach,$data_de);
						if(!empty($sel_demand_pay)) {
//echo "Обработка платежа<br />";
//echo $sel_demand_pay[0]['did']."<br>";
check_pay_uslugi($sel_demand_pay[0]['did'],$sel_demand_pay[0]['output'],$sel_demand_pay[0]['in_val'],$sel_demand_pay[0]['out_val']);
						}
				}



}
clearstatcache();
}

$part_time = explode(' ',microtime());
$end_time = $part_time[1].substr($part_time[0],1);
$result_time = $end_time - $begin_time;

		//echo "<div class=text align=center>Время загрузки: ".$result_time." сек.<br />";
?>
