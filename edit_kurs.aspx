<?php

require("customsql.inc.aspx");
require("direction.aspx");
include("usercheck.aspx");

//$db = new CustomSQL($DBName);
$db_exchange = new CustomSQL_exchange($DBName_exchange);
if (!empty($_POST['exch_kurs_edit'])) {
if($_POST['up_date']) $up_date = 1;
else $up_date = 0;
if($_POST['status']) $status = 1;
else $status = 0;
$db_exchange->exch_kurs_edit($_POST['id'],$_POST['konvers'],$_POST['commission'],$_POST['direct'],$up_date,$status);
}
if (!empty($_POST['update_kurs_edit'])) {
//header("Location: nncron/update_kurs.aspx?main=".$_GET['main']);
}
if(!empty($_POST['update_kurs'])) {
	/*
$sel_rate = $db_exchange->baserate($_POST['indefined']);
$d = explode('_',$_POST['direction']);
*/

$select_rate = select_rate($_POST['direction'],$_POST['indefined'],$db_exchange);
$kurs = $select_rate + $select_rate * $_POST['commission']/100;
$db_exchange->edit_kurs($kurs,$_POST['id']);
}
?>
<html>
<head>
<title>Редактирование курсов э/в</title>
<meta http-equiv="Content-Type" content="text/html; charset=win-1251">
<link rel="stylesheet" href="style/style.css" type="text/css">
<meta content="none" name="ROBOTS">
</head>
<body topmargin="0" leftmargin="0" MARGINWIDTH="0" MARGINHEIGHT="0">
<table width="100%" border="0" cellspacing="1" cellpadding="0" align="center">
  <tr>
      <td class="menu" bgcolor="#FFFFFF" valign="top" width="100%" align="left">
	  <select name="owner_id" onchange="document.location.href = 'edit_kurs.aspx?main='+this.options[this.selectedIndex].value">
		<option value="">Выбор курсов для редактирование</option>
		<option value="WMZ">WebMoney Z</option>
		<option value="WMR">WebMoney R</option>
		<option value="WME">WebMoney E</option>
		<option value="WMU">WebMoney U</option>
		<option value="WMB">WebMoney B</option>
		<option value="EasyPay">EasyPay</option>
		<option value="NAL">Наличные в ....</option>
		
    </select>
<tr>

<table width="100%" border="0" cellspacing="1" cellpadding="4"  bgcolor="#CCCCCC">

	<tr bgcolor="#F2F2F2">
<td align="center">Направление</td>
<td align="center">Курс</td>
<td align="center">Update</td>
<td align="center">Статус</td>
<td align="center">Прямой</td>
<td align="center">Комиссия</td>
<td align="center">&nbsp;</td>
<td align="center">Время обновление</td>
</tr>

<?
		$kurs_main = dataBase::DBexchange()->select('kurs',
		'id,direction,konvers,commission,indefined,direct,upd,status,edit_date',
		'where main="'.$_GET['main'].'"',
		'order by id ASC');

		foreach((array)$kurs_main as $arr)
		{
	        $id = $arr['id'];
			$direction = $arr['direction'];
			$konvers = $arr['konvers'];
			$commission = $arr['commission'];
			$indefined = $arr['indefined'];
			$direct = $arr['direct'];
			$up_date = $arr['upd'];
			$status = $arr['status'];
			$edit_date = $arr['edit_date'];
			$direction_n = explode('_',$direction);

		echo "<form action=\"edit_kurs.aspx?main=".$_GET['main']."\" method=\"POST\">
		<tr  bgcolor=\"#ffffff\">
		<td align=\"left\">$direction</td>
				<td align=\"center\">";
		if($direct == "y") echo "1 {$direction_n[0]} = <input type=\"text\" name=\"konvers\" size='8' value=$konvers /> {$direction_n[1]}";
		if($direct == "n") echo "<input type=\"text\" name=\"konvers\" size='8' value=$konvers /> {$direction_n[0]} = 1 {$direction_n[1]}";
		echo "</td>
		<td align=\"center\"><input type=\"checkbox\" name=\"up_date\""; if($up_date == 1) echo " checked=1";
		echo "></td>
		<td align=\"center\"><input type=\"checkbox\" name=\"status\""; if($status == 1) echo " checked=1";
		echo "></td>
		<td align=\"center\"><select name=\"direct\">
			<option value=y ";
			if($direct == "y") echo "selected=selected"; echo ">Прямой</option>
			<option value=n ";
			if($direct == "n") echo "selected=selected"; echo ">Обратный</option>";
			echo "</select>
		</td>
		<td align=\"center\"><input type=\"text\" name=\"commission\" size='5' value=$commission></td>
		<input type=\"hidden\" name=\"id\" value=$id>
		<input type=\"hidden\" name=\"indefined\" value=\"{$indefined}\">
		<input type=\"hidden\" name=\"direction\" value=\"{$direction}\">
		</td>
		<td align=\"center\"><div>
			<div style=\"float:left;\"><input type=\"submit\" name=\"exch_kurs_edit\" value=\"Изменить\"></div>
			
		<div style=\"float:right;\"><input type=\"submit\" name=\"update_kurs\" value=\"Обновить\"></div>
		</div></td>
		<td align=\"center\">{$edit_date}</td>
		</tr></form>\n";

		}
?>
		</table>

      </td>
  </tr>
</table>
