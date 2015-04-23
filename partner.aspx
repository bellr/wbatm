<?php

require("customsql.inc.aspx");

$db = new CustomSQL($DBName);
//$db_exchange = new CustomSQL_exchange($DBName_exchange);
if(!empty($_POST['search_partner'])) $sel_partner = $db->sel_partner($_POST['email']);
if(!empty($_GET['email'])) $sel_partner = $db->sel_partner($_GET['email']);
if(!empty($_GET['id'])) $sel_partner = $db->sel_partner_id($_GET['id']);
if(!empty($_POST['update_partner'])) {
	if($_POST['st']) $st = 0;
	else $st = 1;
$db->update_partner($_POST['email'],$_POST['username'],$_POST['host'],$_POST['balance'],$_POST['percent'],$st);
}
if(!empty($_POST['del_partner'])) $db->del_partner($_POST['email']);
?>
<html>
<head>
<title>Редактирование балансов э/в</title>
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
          <td><a href="/partner_list.aspx" target="mainFrame" class="en_b">Список всех партнеров</a></td>
          <td><a href="/partner.aspx" target="mainFrame" class="en_b">Поиск партнера</a></td>
        </tr>
    </table>
      <hr width="90%" size="1" noshade>


<table width="100%" border="0" cellspacing="1" cellpadding="4">
	<form action="partner.aspx" method="POST">
<tr>
	<td width="100%" colspan="2" class="black" align="center">
	<h3>Форма для поиска пользователя</h3>
	</td>
</tr>
<tr>
	<td width="50%" align="right">Введите E-Mail пользователя : </td>
	<td width="50%" align="left">
	<input type="text" name="email" value="<? echo $_POST['email']; ?>">
	</td>
</tr>
<tr>
	<td colspan="2" align="center">
	<input type="submit" name="search_partner" value="Поиск"><br /><br />
	</td>
</tr>
	</form>
</table>
<?
if(!empty($sel_partner)) {
?>
<center>Смотреть заявки привлеченные партнером:
	<a href="partner_dem.aspx?oper=exch&id=<? echo $sel_partner[0]["id"]; ?>">Обмен</a>
	<a href="partner_dem.aspx?oper=pay&id=<? echo $sel_partner[0]["id"]; ?>">Платежи</a>
	<a href="partner_dem.aspx?oper=cash&id=<? echo $sel_partner[0]["id"]; ?>">Пополнение</a><br /></center>
<table width="40%" border="0" cellspacing="1" cellpadding="3"  bgcolor="#CCCCCC">
<form action="partner.aspx" method="POST">
	<tr bgcolor="#ffffff">
		<td width="30%">ID :</td>
		<td width="10%"><? echo $sel_partner[0]["id"]; ?></td>
	</tr>
	<tr bgcolor="#ffffff">
		<td width="30%">E-Mail :</td>
		<td width="10%"><? echo $sel_partner[0]["email"]; ?><input type="hidden" name="email" value="<? echo $sel_partner[0]["email"]; ?>"></td>
	</tr>
	<tr bgcolor="#ffffff">
		<td width="30%">Имя :</td>
		<td width="10%"><input type="text" name="username" value="<? echo $sel_partner[0]["username"]; ?>"></td>
	</tr>
	<tr bgcolor="#ffffff">
		<td width="30%">Сайт :</td>
		<td width="10%"><input type="text" name="host" value="<? echo $sel_partner[0]["host"]; ?>"></td>
	</tr>
	<tr bgcolor="#ffffff">
		<td width="30%">Текущий баланс :</td>
		<td width="10%"><input type="text" name="balance" value="<? echo $sel_partner[0]["balance"]; ?>"> $</td>
	</tr>
	<tr bgcolor="#ffffff">
		<td width="30%">Накопленные средства :</td>
		<td width="10%"><? echo $sel_partner[0]["summa_bal"]; ?>$</td>
	</tr>
	<tr bgcolor="#ffffff">
		<td width="30%">Сумма поступивших средств через программу :</td>
		<td width="10%"><? echo $sel_partner[0]["summ_oper"]; ?>$</td>
	</tr>
	<tr bgcolor="#ffffff">
		<td width="30%">Процент вознаграждения :</td>
		<td width="10%"><input type="text" name="percent" value="<? echo $sel_partner[0]["percent"]; ?>"></td>
	</tr>
	<tr bgcolor="#ffffff">
		<td width="30%">Количество переходов с сайта :</td>
		<td width="10%"><? echo $sel_partner[0]["refer"]; ?></td>
	</tr>
	<tr bgcolor="#ffffff">
		<td width="30%">Количество завершенных операций :</td>
		<td width="10%"><? echo $sel_partner[0]["count_oper"]; ?></td>
	</tr>
	<tr bgcolor="#ffffff">
		<td width="30%" align="right">ЗАБЛОКИРОВАН :</td>
		<td width="10%"><? echo "<input type=\"checkbox\" name=\"st\""; if($sel_partner[0]["status"] == 0) echo " checked=1>"; ?></td>
	</tr>
<tr bgcolor="#ffffff" align="center">
	<td>
	<input type="submit" name="update_partner" value="Обновить"><br />
	</td>
	<td>
	<input type="submit" name="del_partner" value="УДАЛИТЬ"><br />
	</td>
</tr>
	</form>
</table>
<? }
	?>
      </td>
  </tr>
</table>
