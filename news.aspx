<?php

require("customsql.inc.aspx");

$db = new CustomSQL($DBName);

if (!empty($_POST['add_news'])) {
$P = inputData::init();

$data['title'] = $P->title;
$data['contents'] = $P->contents;
$data['data'] = $P->data;
$ok = dataBase::DBmain()->insert('news',$data);

}
?>
<html>
<head>
<title>Курсы валют</title>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8">
<link rel="stylesheet" href="style/style.css" type="text/css">
</head>
<body topmargin="0" leftmargin="0" MARGINWIDTH="0" MARGINHEIGHT="0">
<table width="100%" border="0" cellspacing="1" cellpadding="0" align="center">
  <tr>

      <td class="menu" bgcolor="#FFFFFF" valign="top" width="100%">
      <?php
      include("include/top.aspx");
      ?>
      <hr width="90%" size="1" noshade>
     <table border="0" cellspacing="0" cellpadding="4" width="100%">
        <tr>
          <td>
<?
 if (!empty($ok)) echo "Новость добавлена"; ?>
         <form action="news.aspx" method="post">
	<table width="100%" border="0" cellspacing="1" cellpadding="4">
	<tr>
	<td align="center"><TEXTAREA style="WIDTH: 400px" name="title" rows="3">ЗАГЛАВИЕ</TEXTAREA></td>
	</tr>
	<tr>
	<td align="center"><TEXTAREA style="WIDTH: 400px" name="contents" rows="10">НОВОСТЬ</TEXTAREA></td>
	</tr>
	<tr>
	<td align="center"><input type="hidden" name="data" value="<? echo date("d.m.Y"); ?>">
			<input type="submit" name="add_news" value="Добавить">
	</td>
	</tr>

		</table>
		</form>
      </td>
  </tr>
</table>
