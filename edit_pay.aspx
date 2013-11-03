<?php

require("customsql.inc.aspx");

//$db = new CustomSQL($DBName);
$db_exchange = new CustomSQL_exchange($DBName_exchange);
$db_pay_desk = new CustomSQL_pay_desk($DBName_pay_desk);
if (!empty($_POST['pay_edit'])) {
if($_POST['status']) $status = 1;
else $status = 0;
$db_pay_desk->edit_pay($_POST['id'],$_POST['commission'],$_POST['bankpay'],$status);
}
if(!empty($_POST['pay_add'])) {
$db_pay_desk->add_pay($_POST['name_cat'],$_POST['desc_uslugi'],$_POST['name'],$_POST['desc_val'],$_POST['bankpay']);
echo "<u><b>Услуга добавлена</b></u>";
}
?>
<html>
<head>
<title>Редактирование\добавление платежей</title>
<meta http-equiv="Content-Type" content="text/html; charset=win-1251">
<link rel="stylesheet" href="style/style.css" type="text/css">
<meta content="none" name="ROBOTS">
<script language="JavaScript">
<!--
function MM_reloadPage(init) {  //reloads the window if Nav4 resized
  if (init==true) with (navigator) {if ((appName=="Netscape")&&(parseInt(appVersion)==4)) {
    document.MM_pgW=innerWidth; document.MM_pgH=innerHeight; onresize=MM_reloadPage; }}
  else if (innerWidth!=document.MM_pgW || innerHeight!=document.MM_pgH) address.reload();
}
MM_reloadPage(true);
// -->
</script>
</head>
<body topmargin="0" leftmargin="0" MARGINWIDTH="0" MARGINHEIGHT="0">
<table width="100%" border="0" cellspacing="1" cellpadding="0" align="center">
  <tr>
      <td class="menu" bgcolor="#FFFFFF" valign="top" width="100%" align="center">
      <?php
      include("include/top.aspx");
      ?>
      <hr width="90%" size="1" noshade>
<div align="left"><b>Выбор категории платежа для редактирование</b></div><br/>
<div align="left"><a href="edit_pay.aspx?name_cat=Internet" class="en_b">Интернет-операторы</a></div>
<div align="left"><a href="edit_pay.aspx?name_cat=InternetBF" class="en_b">Интернет-операторы(ByFly)</a></div>
<div align="left"><a href="edit_pay.aspx?name_cat=Mobile" class="en_b">Мобильные операторы</a></div>
<div align="left"><a href="edit_pay.aspx?name_cat=MobileTEL" class="en_b">Мобильные операторы(Beltelecom)</a></div>
<div align="left"><a href="edit_pay.aspx?name_cat=TV" class="en_b">Телевидение</a></div>
<div align="left"><a href="edit_pay.aspx?name_cat=Komunal" class="en_b">Комунальные</a></div>
<div align="left"><a href="edit_pay.aspx?name_cat=Gaz" class="en_b">Газ</a></div>
<div align="left"><a href="edit_pay.aspx?name_cat=Voda" class="en_b">Вода</a></div>
<div align="left"><a href="edit_pay.aspx?name_cat=Elektro" class="en_b">Электроенергия</a></div>
<br /><br />
<tr>
<td align="center">
<br />
<div><a href="edit_pay.aspx?oper=add" class="en_b">Добавить услугу в систему</a></div><br /><br />
<?
if($_GET['oper'] == "add") {
?>
<form action="edit_pay.aspx" method="POST">
<table>
	<tr>
		<td>Раздел (Internet)</td>
		<td><input type="text" name="name_cat" size="80"></td>
	</tr>
	<tr>
		<td>Описание услуги (WWW.TELECOM.BY)</td>
		<td><input type="text" name="desc_uslugi" size="80"></td>
	</tr>
	<tr>
		<td>Обозначение услуги в системе (AtlantTelecom)</td>
		<td><input type="text" name="name" size="80"></td>
	</tr>
	<tr>
		<td>Название услуги (Атлант Телеком)</td>
		<td><input type="text" name="desc_val" size="80"></td>
	</tr>
	<tr>
		<td>Банк принимающий платеж</td>
		<td><input type="text" name="bankpay" size="80"></td>
	</tr>
	<tr>
		<td colspan="2" align="center"><input type="submit" name="pay_add" value="Изменить"></td>
	</tr>
</table>

<? }
?>
</td>
</tr>
<?
		$pay_main = $db_pay_desk->info_pay($_GET['name_cat']);
if (!empty($pay_main)) {
	?>
<table width="100%" border="0" cellspacing="1" cellpadding="4"  bgcolor="#CCCCCC">

	<tr bgcolor="#F2F2F2">
	<td align="center">Услуга</td>
<td align="center">Описание услуги</td>
<td align="center">Банк</td>


<td align="center">Комиссия</td>
<td align="center">Статус</td>
<td align="center">&nbsp;</td>
</tr>

<?
		foreach($pay_main as $arr)
		{
	        $id = $arr['0'];
			$desc_uslugi = $arr['2'];
			$desc_val = $arr['4'];
			$bankpay = $arr['5'];
			$commission = $arr['6'];
			$status = $arr['7'];

		echo "<form action=\"edit_pay.aspx?name_cat=".$_GET['name_cat']."\" method=\"POST\">
		<tr  bgcolor=\"#ffffff\">
		<td align=\"left\">$desc_val</td>
		<td align=\"left\">$desc_uslugi</td>
		<td align=\"center\"><input type=\"text\" name=\"bankpay\" size='8' value=$bankpay></td>
		<td align=\"center\"><input type=\"text\" name=\"commission\" size='8' value=$commission></td>
		<td align=\"center\"><input type=\"checkbox\" name=\"status\""; if($status == 1) echo " checked=1";
		echo "></td>
				<input type=\"hidden\" name=\"id\" value=$id></td>
		<td align=\"center\"><input type=\"submit\" name=\"pay_edit\" value=\"Изменить\"></td>
		</tr></form>\n";
					}
}
?>

		</table>


      </td>
  </tr>
</table>
