<?php

require("customsql.inc.aspx");

//$db = new CustomSQL($DBName);
$db_exchange = new CustomSQL_exchange($DBName_exchange);
$db_pay_desk = new CustomSQL_pay_desk($DBName_pay_desk);

if($_GET['oper'] == "exch") $result = $db_exchange->sel_dem_part($_GET['id']);
if($_GET['oper'] == "pay") $result = $db_pay_desk->sel_dempay_part($_GET['id']);
if($_GET['oper'] == "cash") $result = $db_pay_desk->sel_demcash_part($_GET['id']);

?>
<html>
<head>
<title>Список заявок совершившие привлеченные пользователи</title>
<meta http-equiv="Content-Type" content="text/html; charset=win-1251">
<link rel="stylesheet" href="style/style.css" type="text/css">
<meta content="none" name="ROBOTS">
</head>
<body topmargin="0" leftmargin="0" MARGINWIDTH="0" MARGINHEIGHT="0">
<table width="100%" border="0" cellspacing="1" cellpadding="0" align="center">
  <tr>

      <td class="menu" bgcolor="#FFFFFF" valign="top" width="100%" align="center">
    <table width="90%" border="0" cellspacing="1" cellpadding="4" bgcolor="#FFFFFF">
        <tr align="center" bgcolor="#F2F2F2">
          <td><a href="admin_index.aspx" target="mainFrame" class="en_b">adminindex</a></td>
          <td><a href="http://atm.wm-rb.net/partner_list.aspx" target="mainFrame" class="en_b">Список всех партнеров</a></td>
          <td><a href="http://atm.wm-rb.net/partner.aspx" target="mainFrame" class="en_b">Поиск партнера</a></td>
        </tr>
    </table>
      <hr width="90%" size="1" noshade>


<table width="100%" border="0" cellspacing="1" cellpadding="4" bgcolor="#F2F2F2">
	<tr>
	<td bgcolor="#FFFFFF" colspan="5" class="black" align="center">
<h3>Список заявок совершившие привлеченные пользователи</h3>	</td>
	</tr>
		<tr align="center">
	<td>Номер заявки</td>
	<td>Направление</td>
	<td>Отправленная сумма</td>
	<td>Полученная сумма</td>
	<td>Время оформления заявки</td>
	</tr>
<?
if($_GET['oper'] == "exch") {
	foreach($result as $arr)
		{
	        $did = $arr['0'];
	        $ex_output = $arr['1'];
	        $ex_input = $arr['2'];
			$out_val = $arr['3'];
			$in_val = $arr['4'];
			$data = $arr['5'];
			$time = $arr['6'];

		echo "
		<tr bgcolor=\"#FFFFFF\" align=\"center\">
		<td><a href=\"search_exch_d.aspx?did=$did\">$did</a></td>
		<td>{$ex_output} ››› {$ex_input}</td>
		<td>$out_val $ex_output</td>
		<td>$in_val $ex_input</td>
		<td>$data $time</td>
		</tr>";
		}
}
if($_GET['oper'] == "pay") {
	foreach($result as $arr)
		{
	        $did = $arr['0'];
	        $ex_output = $arr['1'];
	        $ex_input = $arr['2'];
			$out_val = $arr['3'];
			$in_val = $arr['4'];
			$data = $arr['5'];
			$time = $arr['6'];

		echo "
		<tr bgcolor=\"#FFFFFF\" align=\"center\">
		<td><a href=\"search_pay_d.aspx?did=$did\">$did</a></td>
		<td>{$ex_output} ››› {$ex_input}</td>
		<td>$out_val $ex_output</td>
		<td>$in_val $ex_input</td>
		<td>$data $time</td>
		</tr>";
		}
}
if($_GET['oper'] == "cash") {
	foreach($result as $arr)
		{
	        $did = $arr['0'];
	        $output = $arr['1'];
			$out_val = $arr['2'];
			$in_val = $arr['3'];
			$data = $arr['4'];
			$time = $arr['5'];

		echo "
		<tr bgcolor=\"#FFFFFF\" align=\"center\">
		<td><a href=\"search_cash_d.aspx?did=$did\">$did</a></td>
		<td>NAL ››› {$output}</td>
		<td>$out_val BLR</td>
		<td>$in_val $output</td>
		<td>$data $time</td>
		</tr>";
		}
}
?>
		</table>

      </td>
  </tr>
</table>
