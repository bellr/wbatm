<?php

require("customsql.inc.aspx");
require("nncron/constructor_exch_auto.aspx");
$db = new CustomSQL($DBName);
$db_exchange = new CustomSQL_exchange($DBName_exchange);
$db_pay_desk = new CustomSQL_pay_desk($DBName_pay_desk);
$db_admin = new CustomSQL_admin($DBName_admin);
$error_did = true;

if (!empty($_POST['change_status'])) {
$db_pay_desk->demand_edit_eshop($_POST['status'],$_GET['did']);
}
if (!empty($_POST['search_eshop'])) {$did = $_POST['did']; $error_did = false;}
if (!empty($_GET['did'])) {$did = $_GET['did']; $error_did = false;}

if (!$error_did) {$info = $db_pay_desk->sel_eshop_demand($did);
$goods_info = $db_pay_desk->goods_info($info[0]['id_goods']);
}

?>
<html>
<head>
<title>Редактирование заявки №<? echo $did; ?></title>
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
	<form action="search_eshop_d.aspx" method="POST">
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
	<input type="submit" name="search_eshop" value="Поиск"><br /><br />
	</td>
</tr>
	</form>
<?
if (!empty($info)) {
	$ip = $db_admin->sel_ip($did);
echo "
<tr>
	<td width=\"50%\" colspan=2><b>IP : </b> {$ip[0]["addr_remote"]}&nbsp;&nbsp;&nbsp;&nbsp; <b>PROXY : </b> {$ip[0]["proxy"]}</td>
</tr>
<tr>
	<td width=\"50%\" align=\"right\"><b>Товар : </b></td>
	<td width=\"50%\" align=\"left\">{$goods_info[0]['name_card']}</td>
</tr>
<tr>
	<td width=\"50%\" align=\"right\"><b>Сумма оплаты : </b></td>
	<td width=\"50%\" align=\"left\">{$info[0]["amount"]} {$info[0]["output"]}</td>
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
	<form method=\"post\" action=\"search_eshop_d.aspx?did=$did\">";
	if ($info[0]["status"] == "n") {echo "Не оплачена";} if ($info[0]["status"] == "yn") {echo "Оплачена";} if ($info[0]["status"] == "y") {echo "Выполнена";} if ($info[0]["status"] == "er") {echo "Ошибка";}echo "
	<select name=\"status\">
		<option value=\"none\" selected=\"selected\">Выбрать</option>
		<option value=\"n\">Не оплачена</option>
		<option value=\"yn\">Оплачена</option>
		<option value=\"y\">Выполнена</option>
		<option value=\"er\">Ошибка</option>
	</select>
	<input type=\"submit\" name=\"change_status\" value=\"Изменить\"/><br /><br /></form>
	<form method=\"post\" action=\"nncron/constructor_inpay.aspx?did=$did\">
	<input type=\"hidden\" name=\"output\" value=\"{$info[0]["output"]}\">
	<input type=\"hidden\" name=\"did\" value=\"{$did}\">
		<input type=\"hidden\" name=\"out_val\" value=\"{$info[0]["out_val"]}\">
	<input type=\"hidden\" name=\"in_val\" value=\"{$info[0]["in_val"]}\">
<tr>
	<td width=\"100%\" align=\"center\" colspan=2><input type=\"submit\" name=\"run_pay\" value=\"Выполнить\"/></td>
</tr>
</form>

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
