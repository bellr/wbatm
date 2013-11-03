<?php

require("customsql.inc.aspx");

$db = new CustomSQL($DBName);
$db_pay_desk = new CustomSQL_pay_desk($DBName_pay_desk);
if(!empty($_POST['im_goods_f'])) {
    $fp = fopen($_FILES['in_file']['tmp_name'],"r");
    $content = fread($fp, filesize($_FILES['in_file']['tmp_name']));
    fclose($fp);
	if($_POST['type_goods'] == "text") {
		$con = explode('||',trim($content));
		$c= 0;
		foreach($con as $ar) {
			if(!empty($ar)) {
			$db_pay_desk->add_goods_text($_POST['id_goods'],$ar);
			$c++;
			}
		}
		$db_pay_desk->update_count($_POST['id_goods'],$c);
	}
}
if(!empty($_GET['id_goods'])) {
$db_pay_desk->edit_info_goods($_POST['name_goods'],$_POST['name_desc'],$_POST['price'],$_GET['id_goods']);
header("Location: http://atm.wm-rb.net/select_goods.aspx?company=".$_GET['company']);
}
?>
<html>
<head>
<title>Описание товаров</title>
<meta http-equiv="Content-Type" content="text/html; charset=win-1251">
<link rel="stylesheet" href="style/style.css" type="text/css">
<script language="JavaScript">
<!--
function show_hide(d,name_card){
var id=document.getElementById(d);
if(id) id.style.display=id.style.display=='none'?'block':'none';
document.formEddGoods.id_goods.value = name_card;
}

// -->
</script>
</head>
<body topmargin="0" leftmargin="0" MARGINWIDTH="0" MARGINHEIGHT="0">
<div style="POSITION: absolute; display: none; padding: 5px; right:0px;BORDER: black 1px solid; BACKGROUND: white;" id="add_card">
<form name="formEddGoods" enctype="multipart/form-data" method="post" action="select_goods.aspx?company=<?echo $_GET['company'];?>">
Что добавляем? <select name="type_goods">
	<option value="text" selected="selected">Текст. информация</option>
	<option value="file">Файл</option>
</select>
<br />
<br />
<input type="hidden" name="MAX_FILE_SIZE" value="30000">
Имя импортируемого файла<input type="file" name="in_file" size=50 />
<input type="submit" name="im_goods_f" value="Импорт" /><br />

<input type="hidden" name="id_goods"/>
</form></div>
<table width="100%" border="0" cellspacing="1" cellpadding="0" align="center">
  <tr>

      <td class="menu" bgcolor="#FFFFFF" valign="top" width="100%">
      <?php
      include("include/top.aspx");
      ?>
      <hr width="90%" size="1" noshade>
     <table border="0" cellspacing="0" cellpadding="4" width="100%">
<? if(empty($_GET['company'])) {?>
        <tr>
          <td>
Интернет провайдеры
<ul style="padding-left: 10px;">
<li><a href="select_goods.aspx?company=byfly"><b>›</b> ByFly Белтелеком</a></li>
<li><a href="select_goods.aspx?company=byfly_wifi"><b>›</b> Wi-Fi Белтелеком</a></li>
<li><a href="select_goods.aspx?company=niks"><b>›</b> Никс</a></li>

<!-- <li><a href="http://pinshop.by/select_goods.aspx?cat=internet&company=aichina"><b>›</b> Айчына Плюс</a></li>
<li><a href="http://pinshop.by/select_goods.aspx?cat=internet&company=ip_telcom"><b>›</b> Ip Telcom</a></li>
<li><a href="http://pinshop.by/select_goods.aspx?cat=internet&company=solo"><b>›</b> Соло</a></li>
<li><a href="http://pinshop.by/select_goods.aspx?cat=internet&company=niks"><b>›</b> Никс</a></li> -->
</ul>
Мобильные операторы
<ul style="padding-left: 10px;">
<li><a href="select_goods.aspx?company=life"><b>›</b> life:)</a></li>
<li><a href="select_goods.aspx?company=velcom"><b>›</b> Velcom</a></li>
<li><a href="select_goods.aspx?company=velcom_privet"><b>›</b> Velcom PRIVET</a></li>

</ul>
Дисконтные карты
<ul style="padding-left: 10px;">
<li><a href="select_goods.aspx?company=wmrb"><b>›</b> WM-RB.net</a></li>
<li><a href="select_goods.aspx?company=savechange"><b>›</b> SaveChange.ru</a></li>
</ul>

      </td>
  </tr>
  <?}
	else {
$goods = $db_pay_desk->sel_goods_company($_GET['company']);
//print_r($goods);
foreach($goods as $ar) {
echo "
<form method=\"post\" action=\"select_goods.aspx?id_goods={$ar['id']}&company={$_GET['company']}\" name=\"infoGoods\">
<div style=\"margin-bottom: 15px;\">
<b><span class=\"text\">Название карты</span></b>&nbsp;&nbsp;&nbsp;
<input type=\"text\" size=100 name=\"name_goods\" value='{$ar['name_card']}' /><br />
<b><span class=\"text\">Описание</span></b> <br />

<textarea name=\"name_desc\" rows=\"7\" cols=\"100\">{$ar['name_desc']}</textarea><br />
<b>В наличии :</b> <a href=\"show_goods.aspx?id_goods={$ar['id']}&status=1\">{$ar['count']}</a>
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<b>Продано :</b> <a href=\"show_goods.aspx?id_goods={$ar['id']}&status=0\">{$ar['sale']}</a>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
Цена : <input type=\"text\" size=5 name=\"price\" value=\"{$ar['price']}\" /> $
<br />
<br />
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<input type=\"submit\" name=\"edit\" value=\"Изменить\" />&nbsp;&nbsp;&nbsp;
<a href=\"javascript:show_hide('add_card','{$ar['id']}')\">Добавить пин-код</a>
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
</div>
</form>
";

}
	}


?>
</table>
