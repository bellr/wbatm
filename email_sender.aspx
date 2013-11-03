<?
require("customsql.inc.aspx");

$db = new CustomSQL($DBName);
$db_exchange = new CustomSQL_exchange($DBName_exchange);
$db_pay_desk = new CustomSQL_pay_desk($DBName_pay_desk);

$mail = $db_exchange->sel_email();
$c = 0;
foreach($mail as $ar) {
	$check_mail = $db->check_email($ar['email']);
	if(empty($check_mail)) {
		$db->add_email($ar['email']);
		$c++;
	}
}

$mail = $db_pay_desk->sel_email('demand_cash');
foreach($mail as $ar) {
	$check_mail = $db->check_email($ar['email']);
	if(empty($check_mail)) {
		$db->add_email($ar['email']);
		$c++;
		}
}
$mail = $db_pay_desk->sel_email('demand_nal_out');
foreach($mail as $ar) {
	$check_mail = $db->check_email($ar['email']);
	if(empty($check_mail)) {
		$db->add_email($ar['email']);
		$c++;
		}
}
$mail = $db_pay_desk->sel_email('demand_uslugi');
foreach($mail as $ar) {
	$check_mail = $db->check_email($ar['email']);
	if(empty($check_mail)) {
		$db->add_email($ar['email']);
		$c++;
		}
}

echo "<br />Добавлено".$c;

?>