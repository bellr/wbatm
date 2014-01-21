<?php

require("customsql.inc.aspx");
require("nncron/constructor_exch_auto.aspx");
$db = new CustomSQL($DBName);
$db_exchange = new CustomSQL_exchange($DBName_exchange);
$db_pay_desk = new CustomSQL_pay_desk($DBName_pay_desk);
$db_admin = new CustomSQL_admin($DBName_admin);
$error_did = true;

if (!empty($_POST['change_status'])) {

    dataBase::DBpaydesk()->update('demand_uslugi',array('status' => $_POST['status']),array(
        'did' => $_GET['did']
    ));
}
if (!empty($_POST['search_pay'])) {
    $did = $_POST['did'];
    $error_did = false;
}
if (!empty($_GET['did'])) {
    $did = $_GET['did'];
    $error_did = false;
}
/*
if(!empty($_POST['autopay'])){
	echo $mass_oper[$_POST['name_uslugi']];
$mass_oper = array(VELCOM => "velcom", MTC => "mts", LIFE => "best", Dialog => "belcel");
if(!empty($mass_oper[$_POST['name_uslugi']])) {
	//require($atm_dir."nncron/func_easypay.aspx");
	//$class_EasyPay = new EasyPay();
	//установить новый кошелек
	//$str_result = $class_EasyPay->pay_usluga($ep_service,$pass_serv,$pp_service,$pole1,trim(sprintf("%8.0f ",$_POST['in_val'])),$mass_oper[$_POST['name_uslugi']]);
	echo $ep_service.$pass_serv.$pp_service.$mass_oper[$_POST['name_uslugi']];
		if($str_result == "TRANSFER_OK") {$db_pay_desk->demand_edit('y',$did);
			$balance_in = $exch_balance[0]["balance"] - $in_val * 1.02;
			$db_pay_desk->update_bal_card($balance_in,'prior');}
		if($str_result == "TRANSFER_ERROR") {$db_pay_desk->demand_edit('er',$did); $db_pay_desk->demand_add_coment('Операция не выполнена. Администрация оповещена об ошибке.',$did);}
}
}
*/
if (!$error_did) $info = dataBase::DBpaydesk()->select('demand_uslugi','output,name_uslugi,purse_out,out_val,email,in_val,pole1,pole2,data,time,status,coment,purse_payment','where did ='.$did);

?>
<html>
<head>
<title>Заявки №<? echo $did; ?></title>
<meta http-equiv="Content-Type" content="text/html; charset=win-1251">
<link rel="stylesheet" href="style/style.css" type="text/css">
<meta content="none" name="ROBOTS">
</head>
<body topmargin="0" leftmargin="0" MARGINWIDTH="0" MARGINHEIGHT="0">
<table width="100%" border="0" cellspacing="1" cellpadding="0" align="center">
  <tr>

      <td class="menu" bgcolor="#FFFFFF" valign="top" width="100%" align="center">
      <?php
      include("include/top.aspx");
      ?>
      <hr width="90%" size="1">


<table width="100%" border="0" cellspacing="1" cellpadding="4">
	<form action="search_pay_d.aspx" method="POST">
<tr>
	<td width="100%" colspan="2" class="black" align="center">
	<h3>Поиск заявок на обмен э/в</h3>
	</td>
</tr>
<tr>
	<td width="50%" align="right">Введите номер заявки : </td>
	<td width="50%" align="left">
	<input type="text" name="did" value="<? echo $did; ?>">
	</td>
</tr>
<tr>
	<td colspan="2" align="center">
	<input type="submit" name="search_pay" value="Поиск"><br /><br />
	</td>
</tr>
	</form>
<?
if (!empty($info)) {
	//вывод инфы по shopу
	$sel_shop = $db->sel_shop($info[0]['name_uslugi']);
	$ip = $db_admin->sel_ip($did);
echo "
<tr>
	<td width=\"50%\" colspan=2><b>IP : </b> {$ip[0]["addr_remote"]}&nbsp;&nbsp;&nbsp;&nbsp; <b>PROXY : </b> {$ip[0]["proxy"]}</td>
</tr>";

	if(!empty($sel_shop)) {
echo"
<tr>
	<td width=\"50%\" align=\"right\"><b>Номер заявки : </b></td>
	<td width=\"50%\" align=\"left\">$did</td>
</tr>
<tr>
	<td width=\"50%\" align=\"right\"><b>Магазин : </b></td>
	<td width=\"50%\" align=\"left\">{$info[0]["name_uslugi"]}</td>
</tr>
<tr>
	<td width=\"50%\" align=\"right\"><b>Номер заказа : </b></td>
	<td width=\"50%\" align=\"left\">{$info[0]["pole1"]}</td>
</tr>
<tr>
	<td width=\"50%\" align=\"right\"><b>Доп. поле №2 : </b></td>
	<td width=\"50%\" align=\"left\">{$info[0]["pole2"]}</td>
</tr>
<tr>
	<td width=\"50%\" align=\"right\"><b>СЧЕТ ДЛЯ ОПЛАТЫ : </b></td>
	<td width=\"50%\" align=\"left\"><i>{$info[0]["purse_payment"]}</i></td>
</tr>
<tr>
	<td width=\"50%\" align=\"right\"><b>Счет отправителя  : </b></td>
	<td width=\"50%\" align=\"left\">{$info[0]["purse_out"]}</td>
</tr>
<tr>
	<td width=\"50%\" align=\"right\"><b>Отдаете  : </b></td>
	<td width=\"50%\" align=\"left\">{$info[0]["out_val"]} {$info[0]["output"]}</td>
</tr>
<tr>
	<td width=\"50%\" align=\"right\"><b>Стоимость : </b></td>
	<td width=\"50%\" align=\"left\">{$info[0]["in_val"]} BLR</td>
</tr>
<tr>
	<td width=\"50%\" align=\"right\"><b>E-Mail : </b></td>
	<td width=\"50%\" align=\"left\">{$info[0]["email"]}</td>
</tr>
<tr>
	<td width=\"50%\" align=\"right\"><b>Время оформления заявки : </b></td>
	<td width=\"50%\" align=\"left\">".date('d.m.Y H:i:s',$info[0]['add_date'])."</td>
</tr>
<tr>
	<td width=\"50%\" align=\"right\"><b>Комментарий : </b></td>
	<td width=\"50%\" align=\"left\">{$info[0]["coment"]}</td>
</tr>
<tr>
	<td width=\"50%\" align=\"right\"><b>Статус</b></td>
	<td width=\"50%\" align=\"left\" valign=middle>
	<form method=\"post\" action=\"search_pay_d.aspx?did=$did\">";
	echo "<select name=\"status\">";
		echo sFormatData::getStatusList($info[0]["status"]);
	echo "</select>
	<input type=\"submit\" name=\"change_status\" value=\"Изменить\"/><br /><br /></form>
<form method=\"post\" action=\"nncron/constructor_inpay.aspx?did=$did\">
	<input type=\"hidden\" name=\"output\" value=\"{$info[0]["output"]}\">
	<input type=\"hidden\" name=\"did\" value=\"{$did}\">
	<input type=\"hidden\" name=\"name_shop\" value=\"{$info[0]["name_uslugi"]}\">
		<input type=\"hidden\" name=\"out_val\" value=\"{$info[0]["out_val"]}\">
	<input type=\"hidden\" name=\"in_val\" value=\"{$info[0]["in_val"]}\">

<tr>
	<td width=\"100%\" align=\"center\" colspan=2><input type=\"submit\" name=\"run_shop\" value=\"Выполнить\"/></td>
</tr>";

}
else {
echo"
<tr>
	<td width=\"50%\" align=\"right\"><b>Номер заявки : </b></td>
	<td width=\"50%\" align=\"left\">$did</td>
</tr>
<tr>
	<td width=\"50%\" align=\"right\"><b>Услуга : </b></td>
	<td width=\"50%\" align=\"left\">{$info[0]["name_uslugi"]}</td>
</tr>
<tr>
	<td width=\"50%\" align=\"right\"><b>Доп. поле №1 : </b></td>
	<td width=\"50%\" align=\"left\">{$info[0]["pole1"]}</td>
</tr>
<tr>
	<td width=\"50%\" align=\"right\"><b>Доп. поле №2 : </b></td>
	<td width=\"50%\" align=\"left\">{$info[0]["pole2"]}</td>
</tr>
<tr>
	<td width=\"50%\" align=\"right\"><b>СЧЕТ ДЛЯ ОПЛАТЫ : </b></td>
	<td width=\"50%\" align=\"left\"><i>{$info[0]["purse_payment"]}</i></td>
</tr>
<tr>
	<td width=\"50%\" align=\"right\"><b>Счет отправителя : </b></td>
	<td width=\"50%\" align=\"left\">{$info[0]["purse_out"]}</td>
</tr>
<tr>
	<td width=\"50%\" align=\"right\"><b>Отправленная сумма : </b></td>
	<td width=\"50%\" align=\"left\">{$info[0]["out_val"]} {$info[0]["output"]}</td>
</tr>
<tr>
	<td width=\"50%\" align=\"right\"><b>Полученная сумма : </b></td>
	<td width=\"50%\" align=\"left\">{$info[0]["in_val"]} BLR</td>
</tr>
<tr>
	<td width=\"50%\" align=\"right\"><b>E-Mail : </b></td>
	<td width=\"50%\" align=\"left\">{$info[0]["email"]}</td>
</tr>
<tr>
	<td width=\"50%\" align=\"right\"><b>Время оформления заявки : </b></td>
	<td width=\"50%\" align=\"left\">{$info[0]["data"]} {$info[0]["time"]}</td>
</tr>
<tr>
	<td width=\"50%\" align=\"right\"><b>Комментарий : </b></td>
	<td width=\"50%\" align=\"left\">{$info[0]["coment"]}</td>
</tr>
<tr>
	<td width=\"50%\" align=\"right\"><b>Статус</b></td>
	<td width=\"50%\" align=\"left\" valign=middle>
	<form method=\"post\" action=\"search_pay_d.aspx?did=$did\">";
	echo "<select name=\"status\">";
		echo swDemand::getStatusList($info[0]["status"]);
	echo "</select>
	<input type=\"submit\" name=\"change_status\" value=\"Изменить\"/><br /><br /></form>
	<form method=\"post\" action=\"nncron/constructor_inpay.aspx?did=$did\">
	<input type=\"hidden\" name=\"output\" value=\"{$info[0]["output"]}\">
	<input type=\"hidden\" name=\"did\" value=\"{$did}\">
	<input type=\"hidden\" name=\"pole1\" value=\"{$info[0]["pole1"]}\">
	<input type=\"hidden\" name=\"pole2\" value=\"{$info[0]["pole2"]}\">
	<input type=\"hidden\" name=\"name_uslugi\" value=\"{$info[0]["name_uslugi"]}\">
		<input type=\"hidden\" name=\"out_val\" value=\"{$info[0]["out_val"]}\">
	<input type=\"hidden\" name=\"in_val\" value=\"{$info[0]["in_val"]}\">
<tr>
	<td width=\"100%\" align=\"center\" colspan=2><input type=\"submit\" name=\"run_pay\" value=\"Завершить операцию\"/>&nbsp;&nbsp;&nbsp;&nbsp;
	<input type=\"submit\" name=\"autopay\" value=\"Оплатить через сервер EasyPay\"/></td>
</tr>";
}
	echo "</form>

</td>
</tr>
";
}
else { echo "<tr><td colspan=\"2\" align=\"center\"><b>Заявки с таким номером не существует</b></td></tr>"; }
?>
</table>

      </td>
  </tr>
</table>
