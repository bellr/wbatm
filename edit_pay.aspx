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
echo "<u><b>������ ���������</b></u>";
}
?>
<html>
<head>
<title>��������������\���������� ��������</title>
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
<div align="left"><b>����� ��������� ������� ��� ��������������</b></div><br/>
<div align="left"><a href="edit_pay.aspx?name_cat=Internet" class="en_b">��������-���������</a></div>
<div align="left"><a href="edit_pay.aspx?name_cat=InternetBF" class="en_b">��������-���������(ByFly)</a></div>
<div align="left"><a href="edit_pay.aspx?name_cat=Mobile" class="en_b">��������� ���������</a></div>
<div align="left"><a href="edit_pay.aspx?name_cat=MobileTEL" class="en_b">��������� ���������(Beltelecom)</a></div>
<div align="left"><a href="edit_pay.aspx?name_cat=TV" class="en_b">�����������</a></div>
<div align="left"><a href="edit_pay.aspx?name_cat=Komunal" class="en_b">�����������</a></div>
<div align="left"><a href="edit_pay.aspx?name_cat=Gaz" class="en_b">���</a></div>
<div align="left"><a href="edit_pay.aspx?name_cat=Voda" class="en_b">����</a></div>
<div align="left"><a href="edit_pay.aspx?name_cat=Elektro" class="en_b">��������������</a></div>
<br /><br />
<tr>
<td align="center">
<br />
<div><a href="edit_pay.aspx?oper=add" class="en_b">�������� ������ � �������</a></div><br /><br />
<?
if($_GET['oper'] == "add") {
?>
<form action="edit_pay.aspx" method="POST">
<table>
	<tr>
		<td>������ (Internet)</td>
		<td><input type="text" name="name_cat" size="80"></td>
	</tr>
	<tr>
		<td>�������� ������ (WWW.TELECOM.BY)</td>
		<td><input type="text" name="desc_uslugi" size="80"></td>
	</tr>
	<tr>
		<td>����������� ������ � ������� (AtlantTelecom)</td>
		<td><input type="text" name="name" size="80"></td>
	</tr>
	<tr>
		<td>�������� ������ (������ �������)</td>
		<td><input type="text" name="desc_val" size="80"></td>
	</tr>
	<tr>
		<td>���� ����������� ������</td>
		<td><input type="text" name="bankpay" size="80"></td>
	</tr>
	<tr>
		<td colspan="2" align="center"><input type="submit" name="pay_add" value="��������"></td>
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
	<td align="center">������</td>
<td align="center">�������� ������</td>
<td align="center">����</td>


<td align="center">��������</td>
<td align="center">������</td>
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
		<td align=\"center\"><input type=\"submit\" name=\"pay_edit\" value=\"��������\"></td>
		</tr></form>\n";
					}
}
?>

		</table>


      </td>
  </tr>
</table>
