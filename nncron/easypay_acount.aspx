<?
require("/var/www/wmrb/data/www/billing87.wm-rb.net/nncron/customsql.inc.aspx");
$db_exchange = new CustomSQL_exchange($DBName_exchange);
$hour = date("H");
$min = date("i");
$days = date("d");
$mon = date("m");
$yaer = date("Y");

$data_tom = date( "Y-m-d",mktime(0,0,0,$mon-1,$days-2,$yaer) );
$data_old = date("Y-m-d",mktime(0,0,0,$mon-1,$days,$yaer) );
$time = date("H:i");

$db_exchange->zeroiz_st_input();
$db_exchange->zeroiz_st_output();
//$db_exchange->on_st_output();

$db_exchange->update_month_input();
$db_exchange->update_month_output();

$db_exchange->update_day_input();
$db_exchange->update_day_output();


$bal="0";
$ar_purse = $db_exchange->update_EP_purse($bal);
//print_r($ar_purse); echo "<br />";
foreach($ar_purse as $ar) {

	if($ar[balance]<$limitday-$ar[outputday]) {

if($limitmouth-$ar[output] > $ar[balance]) {
$balsel=$ar[balance];

} else {
$balsel=$limitmouth-$ar[output];
}


} else {
$balsel = $limitday-$ar[outputday];
}

	if($balsel>$bal) {
$bal = $balsel;
}

}
//echo $bal;

$db_exchange->edit_EP_balance($bal*0.98);

//$bal='0';
///добавить, возобновление переводов со счета сервиса, при возврате денег на счет пользователя, т.е. возврат статуса ST_OUTPUT= 1
//будет проверка на объем суммы, если исход сумма меньше 3 100 000, то включаем
/*
foreach($ar_purse as $ar){
if($bal <= $ar['balance']) {$bal = $ar['balance']; $ak = $ar['acount'];}
	}

	*/

?>