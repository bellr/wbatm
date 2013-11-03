<?
//удаление всех заявок со статусом "n", только при условии если проверка происходит каждый день
require("customsql.inc.aspx");
$db = new CustomSQL($DBName);
$db_exchange = new CustomSQL_exchange($DBName_exchange);
$db_pay_desk = new CustomSQL_pay_desk($DBName_pay_desk);
$db_admin = new CustomSQL_admin($DBName_admin);
$days = date("d");
$mon = date("m");
$yaer = date("Y");

//$check_date = 30 * 60 - time();

//$d = $demand_info = dataBase::DBexchange()->select('demand','id,status','where status='p' and add_date<'.$check_date);
//d(d);
$data_1 = date( "Y-m-d",mktime(0,0,0,$mon,$days-2,$yaer) );
$data_2 = date( "Y-m-d",mktime(0,0,0,$mon,$days-3,$yaer) );

//удаление вчерашних и позавчерашних заявок на обмен эл. валютой
/*$sel_del_dem = $db_exchange->sel_del_dem($data_1,$data_2);
if (!empty($sel_del_dem)) {
	foreach($sel_del_dem as $arr) {
		$db_exchange->del_demand($arr['0']);
		//удаление номера в системе отправителя
		$db_admin->del_idpay($arr['0']);
		}
}

//удаление просроченных заявок на оплату платежей
$sel_del_dem_pay = $db_pay_desk->sel_del_dem($data_1,$data_2);
if (!empty($sel_del_dem_pay)) {
	foreach($sel_del_dem_pay as $arr) {
		$db_pay_desk->del_demand($arr['0']);
		$db_admin->del_idpay($arr['0']);
		}
}
*/
//удаление просроченных заявок на пополнение
$sel_del_dem_nal = $db_pay_desk->sel_del_dem_nal($data_1,$data_2);
if (!empty($sel_del_dem_nal)) {
	foreach($sel_del_dem_nal as $arr) {
		$db_pay_desk->del_demand_nal($arr['0']);
		//удаление номера в системе отправителя
		$db_admin->del_idpay($arr['0']);
		}
}
$sel_del_dem_out = $db_pay_desk->sel_del_dem_out($data_1,$data_2);
if (!empty($sel_del_dem_out)) {
	foreach($sel_del_dem_out as $arr) {
		$db_pay_desk->del_demand_out($arr['0']);
		//удаление номера в системе отправителя
		$db_admin->del_idpay($arr['0']);
		}
}

//удаление просроченных заявок в магазине
$sel_del_dem_pay = $db_pay_desk->del_dem_eshop($data_1,$data_2);
if (!empty($sel_del_dem_pay)) {
	foreach($sel_del_dem_pay as $arr) {
		$db_pay_desk->del_demand_eshop($arr['0']);
		$db_admin->del_idpay($arr['0']);
		}
}
?>