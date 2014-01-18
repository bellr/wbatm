<?php

require("customsql.inc.aspx");
require("nncron/constructor_exch_auto.aspx");
$db = new CustomSQL($DBName);
$db_exchange = new CustomSQL_exchange($DBName_exchange);
$db_pay_desk = new CustomSQL_pay_desk($DBName_pay_desk);
$db_admin = new CustomSQL_admin($DBName_admin);

$error_did = true;

if (!empty($_POST['change_status'])) {
$db_pay_desk->demand_edit_cash($_POST['status'],$_GET['did']);
}
if (!empty($_POST['search_pay'])) {$did = $_POST['did']; $error_did = false;}
if (!empty($_GET['did'])) {$did = $_GET['did']; $error_did = false;}

if (!$error_did) $info = dataBase::DBpaydesk()->select('demand_cash','output,input,card,period,purse_in,in_val,out_val,email,add_date,status,coment,purse_payment','where did ='.$did);

?>
<html>
<head>
<title>Редактирование заявки №<? echo $did; ?></title>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8">
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
	<form action="search_cash_d.aspx" method="POST">
<tr>
	<td width="100%" colspan="2" class="black" align="center">
	<h3>Поиск заявок на пополнение э/в</h3>
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
	$ip = $db_admin->sel_ip($did);
echo "
<tr>
	<td width=\"50%\" colspan=2><b>IP : </b> {$ip[0]["addr_remote"]}&nbsp;&nbsp;&nbsp;&nbsp; <b>PROXY : </b> {$ip[0]["proxy"]}</td>
</tr>
<tr>
	<td width=\"50%\" align=\"right\"><b>Номер заявки : </b></td>
	<td width=\"50%\" align=\"left\">$did</td>
</tr>
<tr>
	<td width=\"50%\" align=\"right\"><b>СЧЕТ ДЛЯ ОПЛАТЫ : </b></td>
	<td width=\"50%\" align=\"left\">{$info[0]["purse_payment"]}</td>
</tr>
<tr>
	<td width=\"50%\" align=\"right\"><b>Валюта пополнения : </b></td>
	<td width=\"50%\" align=\"left\">{$info[0]["input"]}</td>
</tr>
<tr>
	<td width=\"50%\" align=\"right\"><b>Счет пополнения : </b></td>
	<td width=\"50%\" align=\"left\"><u>{$info[0]["purse_in"]}</u></td>
</tr>
<tr>
	<td width=\"50%\" align=\"right\"><b>Отправленная сумма : </b></td>
	<td width=\"50%\" align=\"left\">{$info[0]["out_val"]} BLR</td>
</tr>
<tr>
	<td width=\"50%\" align=\"right\"><b>Полученная сумма : </b></td>
	<td width=\"50%\" align=\"left\">{$info[0]["in_val"]} {$info[0]["input"]}</td>
</tr>
<tr>
	<td width=\"50%\" align=\"right\"><b>Отправитель : </b></td>
	<td width=\"50%\" align=\"left\"><u>{$info[0]["output"]}</u></td>
</tr>
<!-- <tr>
	<td width=\"50%\" align=\"right\"><b>Номер карты : </b></td>
	<td width=\"50%\" align=\"left\">{$info[0]["card"]}</td>
</tr>
<tr>
	<td width=\"50%\" align=\"right\"><b>Срок действия : </b></td>
	<td width=\"50%\" align=\"left\">{$info[0]["period"]}</td>
</tr> -->
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
	<form method=\"post\" action=\"search_cash_d.aspx?did=$did\">";
	echo "<select name=\"status\">";
		echo swDemand::getStatusList($info[0]["status"]);
	echo "</select>
	<input type=\"submit\" name=\"change_status\" value=\"Изменить\"/><br /><br /></form>
	<form method=\"post\" action=\"nncron/constructor_inpay.aspx?did=$did\">
	<input type=\"hidden\" name=\"output\" value=\"{$info[0]["output"]}\">
	<input type=\"hidden\" name=\"input\" value=\"{$info[0]["input"]}\">
	<input type=\"hidden\" name=\"purse_in\" value=\"{$info[0]["purse_in"]}\">
	<input type=\"hidden\" name=\"out_val\" value=\"{$info[0]["out_val"]}\">
	<input type=\"hidden\" name=\"in_val\" value=\"{$info[0]["in_val"]}\">
<tr>
	<td width=\"100%\" align=\"center\" colspan=2><input type=\"submit\" name=\"run_cash\" value=\"Выполнить\"/></td>
</tr>";

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
