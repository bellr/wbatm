<?
require("customsql.inc.aspx");
require("constructor_exch_auto.aspx");
$db_exchange = new CustomSQL_exchange($DBName_exchange);
$db_admin = new CustomSQL_admin($DBName_admin);

//$data_tom = date( "Y-m-d",mktime(0,0,0,date("m"),date("d")-1,date("Y")) );
//$time = date("Y-m-d|H:i",mktime(date("H")-10,date("i")) );

$data = date("Y-m-d H:i",mktime(date("H")-10,date("i")) );

$d = explode(' ',$data);

echo $d[0]." ".$d[1];

$res = $db_exchange->sel_return($d[0],$d[1]);
print_r($res);
if(!empty($res)) {
	foreach($res as $ar) {
		$sel_idpay = $db_admin->sel_more_idpay($ar['did']);
return_pay($ar['did'],$ar['ex_output'],$ar['ex_input'],$ar['purse_payment'],$ar['purse_out'],$ar['out_val'],$ar['in_val'],$sel_idpay[0]['more_idpay']);
	}
}
?>