<?php

require("customsql.inc.aspx");
require("nncron/constructor_exch_auto.aspx");
$db_admin = new CustomSQL_admin($DBName_admin);
//$db_exchange = new CustomSQL_exchange($DBName_exchange);
$db_pay_desk = new CustomSQL_pay_desk($DBName_pay_desk);
echo $_POST['main_cat'];
if(!empty($_POST['add_company'])) {
	$db_pay_desk->add_company($_POST['main_cat'],$_POST['side_cat'],$_POST['company'],$_POST['desc_company']);}
if(!empty($_POST['add_goods'])) {
$db_pay_desk->add_goods($_POST['side_cat'],$_POST['id_goods'],$_POST['name_goods'],$_POST['desc'],$_POST['price'],$_POST['type_goods']);}
?>
<html>
<head>
<title>Добаление компании или товара</title>
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


<table width="90%" border="0" cellspacing="1" cellpadding="4">
	<tr>
	<td><b>Добавление компании</b></td>
	<td><b>Добавление товара</b></td>
	</tr>

	<tr>
	<td><form method="post" action="goods_add.aspx">
Главная категория <select name="main_cat">
	<option value="pinkod" selected="selected">PIN-коды</option>
</select><br /><br />
Категория <select name="side_cat">
	<option value="internet" selected="selected">Интернет провайдеры</option>
	<option value="mobile">Мобильные операторы</option>
	<option value="diskont">Дисконтные карты</option>

</select><br /><br />
Name компании <input type="text" name="company" /><br /><br />
Название компании <input type="text" name="desc_company" /><br /><br />
<input type="submit" name="add_company" value="Добавить" />
</form></td>

	<td><form method="post" action="goods_add.aspx">
Главная категория <select name="main_cat">
	<option value="pinkod" selected="selected">PIN-коды</option>
</select>
Категория <select name="side_cat">
<?
$company = $db_pay_desk->sel_company();
foreach($company as $ar) {
echo "<option value=\"{$ar[company]}\">{$ar[desc_company]}</option>";
}
?></select><br /><br />
<select name="type_goods">
	<option value="pinkod" selected="selected">PIN-код(Уникальный товар)</option>
	<option value="pin_un" selected="selected">PIN-код(Не уникальный)</option>
	<option value="file" selected="selected">Файлы</option>
</select><br /><br />
Индетификатор <input type="text" name="id_goods" /><br /><br />
Название <input type="text" size="85" name="name_goods" /><br /><br />
Описание <textarea name="desc" cols="100" rows="10">
Текстовое поле шириной в 11 символов и в семь строк </textarea><br /><br />
Цена <input type="text" size="5" name="price" />$<br /><br />

<input type="submit" name="add_goods" value="Добавить" />
</form></td>

	</tr>



</table>

      </td>
  </tr>
</table>
