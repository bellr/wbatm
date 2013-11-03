<?
require("customsql.inc.aspx");
//$db = new CustomSQL($DBName);
$db_admin = new CustomSQL_admin($DBName_admin);
if(!empty($_POST['sel_mount'])) {
$mount = $_POST['year']."-".$_POST['mount']."-";
}
else {$mount = substr($date_pay,0,8);}
?>
<html>
<head>
<title>Статистика балансов э/в</title>
<meta http-equiv="Content-Type" content="text/html; charset=win-1251">
<link rel="stylesheet" href="style/style.css" type="text/css">
<meta content="none" name="ROBOTS">
<script language="JavaScript">
<!--
var oldgridSelectedColor;
function setMouseOverColor(element) {
    oldgridSelectedColor = element.style.backgroundColor;
    element.style.backgroundColor = '#F5F5DC';
}
function setMouseOutColor(element) {
    element.style.backgroundColor = oldgridSelectedColor;
}
function nc(url) {
    document.location.href = url;
}
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


<table width="95%" border="0" cellspacing="1" cellpadding="3" bgcolor="#CCCCCC">
<tr bgcolor="#ffffff">
<td colspan="11" align="center">
<form action="stat_bal.aspx" method="post" style="display: inline;">
	<span class="text">Месяц :&nbsp;</span>
	<select name="mount">
	<option value="01">Январь</option>
	<option value="02">Февраль</option>
	<option value="03">Март</option>
	<option value="04">Апрель</option>
	<option value="05">Май</option>
	<option value="06">Июнь</option>
	<option value="07">Июль</option>
	<option value="08">Август</option>
	<option value="09">Сентябрь</option>
	<option value="10">Октябрь</option>
	<option value="11">Ноябрь</option>
	<option value="12">Декабрь</option>
	</select>
	<span class="text">Год :&nbsp;</span>
	<select name="year">
	<option value="2009">2009</option>
	</select>
	<input type="submit" name="sel_mount" value="Показать" style="width:100px; "onmouseover="this.style.backgroundColor='#E8E8FF';" onmouseout="this.style.backgroundColor='#f3f7ff';" id="cursor">&nbsp;
</form></td>
</tr>
	<tr bgcolor="#F2F2F2" align="center">
	<td width="20">Дата</td>
	<td>WMZ</td>
	<td>WMR</td>
	<td>WME</td>
	<td>WMG</td>
	<td>WMU</td>
	<td>WMY</td>
	<td>WMB</td>
	<td>RBK_Money</td>
	<td>EasyPay</td>
	<td>YaDengi</td>
	</tr>
<?
		$result = $db_admin->stat_bal_sel($mount);

		foreach($result as $arr)
		{
		echo "
		<tr bgcolor=\"#ffffff\" align=\"right\" onmouseover=\"javascript:setMouseOverColor(this);\" onmouseout=\"javascript:setMouseOutColor(this);\">
		<td>&nbsp;{$arr['1']}</td>
		<td>{$arr['2']}<br />"; if($arr[2] != $wmz) { if($arr[2] > $wmz) {$res=($arr[2]-$wmz)*100/$arr[2]; echo "&nbsp;<span class=\"blue\">"; printf('%7.2f',$res); echo "%";} else {$res=($wmz -$arr[2])*100/$wmz; echo "<span class=\"red\">"; printf('%7.2f',$res); echo "%";} } echo "</span></td>
		<td>{$arr['3']}<br />"; if($arr[3] != $wmr) { if($arr[3] > $wmr) {$res=($arr[3]-$wmr)*100/$arr[3]; echo "&nbsp;<span class=\"blue\">"; printf('%7.2f',$res); echo "%";} else {$res=($wmr -$arr[3])*100/$wmr; echo "<span class=\"red\">"; printf('%7.2f',$res); echo "%";} } echo "</span></td>
		<td>{$arr['4']}<br />"; if($arr[4] != $wme) { if($arr[4] > $wme) {$res=($arr[4]-$wme)*100/$arr[4]; echo "&nbsp;<span class=\"blue\">"; printf('%7.2f',$res); echo "%";} else {$res=($wme -$arr[4])*100/$wme; echo "<span class=\"red\">"; printf('%7.2f',$res); echo "%";} } echo "</span></td>
		<td>{$arr['5']}<br />"; if($arr[5] != $wmg) { if($arr[5] > $wmg) {$res=($arr[5]-$wmg)*100/$arr[5]; echo "&nbsp;<span class=\"blue\">"; printf('%7.2f',$res); echo "%";} else {$res=($wmg -$arr[5])*100/$wmg; echo "<span class=\"red\">"; printf('%7.2f',$res); echo "%";} } echo "</span></td>
		<td>{$arr['6']}<br />"; if($arr[6] != $wmu) { if($arr[6] > $wmu) {$res=($arr[6]-$wmu)*100/$arr[6]; echo "&nbsp;<span class=\"blue\">"; printf('%7.2f',$res); echo "%";} else {$res=($wmu -$arr[6])*100/$wmu; echo "<span class=\"red\">"; printf('%7.2f',$res); echo "%";} } echo "</span></td>
		<td>{$arr['7']}<br />"; if($arr[7] != $wmy) { if($arr[7] > $wmy) {$res=($arr[7]-$wmy)*100/$arr[7]; echo "&nbsp;<span class=\"blue\">"; printf('%7.2f',$res); echo "%";} else {$res=($wmy -$arr[7])*100/$wmy; echo "<span class=\"red\">"; printf('%7.2f',$res); echo "%";} } echo "</span></td>
		<td>{$arr['8']}<br />"; if($arr[8] != $wmb) { if($arr[8] > $wmb) {$res=($arr[8]-$wmb)*100/$arr[8]; echo "&nbsp;<span class=\"blue\">"; printf('%7.2f',$res); echo "%";} else {$res=($wmb -$arr[8])*100/$wmb; echo "<span class=\"red\">"; printf('%7.2f',$res); echo "%";} } echo "</span></td>
		<td>{$arr['9']}<br />"; if($arr[9] != $RBK_Money) { if($arr[9] > $RBK_Money) {$res=($arr[9]-$RBK_Money)*100/$arr[9]; echo "&nbsp;<span class=\"blue\">"; printf('%7.2f',$res); echo "%";} else {$res=($RBK_Money -$arr[9])*100/$RBK_Money; echo "<span class=\"red\">"; printf('%7.2f',$res); echo "%";} } echo "</span></td>
		<td>{$arr['10']}<br />"; if($arr[10] != $EasyPay) { if($arr[10] > $EasyPay) {$res=($arr[10]-$EasyPay)*100/$arr[10]; echo "&nbsp;<span class=\"blue\">"; printf('%7.2f',$res); echo "%";} else {$res=($EasyPay -$arr[10])*100/$EasyPay; echo "<span class=\"red\">"; printf('%7.2f',$res); echo "%";} } echo "</span></td>
		<td>{$arr['11']}<br />"; if($arr[11] != $YaDengi) { if($arr[11] > $YaDengi) {$res=($arr[11]-$YaDengi)*100/$arr[11]; echo "&nbsp;<span class=\"blue\">"; printf('%7.2f',$res); echo "%";} else {$res=($YaDengi -$arr[11])*100/$YaDengi; echo "<span class=\"red\">"; printf('%7.2f',$res); echo "%";} } echo "</span></td>
		</tr>";
$wmz = $arr['2'];
$wmr = $arr['3'];
$wme = $arr['4'];
$wmg = $arr['5'];
$wmu = $arr['6'];
$wmy = $arr['7'];
$wmb = $arr['8'];
$RBK_Money = $arr['9'];
$EasyPay = $arr['10'];
$YaDengi = $arr['11'];

		}
?>
		</table>

      </td>
  </tr>
</table>
