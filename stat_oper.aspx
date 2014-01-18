<?
require("customsql.inc.aspx");
//$db = new CustomSQL($DBName);
$db_exchange = new CustomSQL_exchange($DBName_exchange);
$db_admin = new CustomSQL_admin($DBName_admin);
$db_pay_desk = new CustomSQL_pay_desk($DBName_pay_desk);
/*
if(!empty($_POST['sel_mount'])) {
$mount = $_POST['year']."-".$_POST['mount']."-";
$data = date( "Y-m-d",mktime(0,0,0,$_POST['mount'],$_POST['day'],$_POST['year']) );
}
else {$mount = substr($date_pay,0,8); $data = date("Y-m-d");}
*/
$data = date("Y-m-d");
$data_mas = explode("-",$data);
?>
<html>
<head>
<title>Статистика заявок</title>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8">
<link rel="stylesheet" href="style/style.css" type="text/css">
<meta content="none" name="ROBOTS">
<SCRIPT language=javascript src="include/informer.js"></SCRIPT>
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
<td align="center">
<div style="float:left; width:40px;">
	<b></b>
</div>
<div>

<div align="left">
	<form action="stat_oper.aspx" method="post" style="display: inline;">
<b>Показать статистику с :</b>

			<select name="day_n">
<?
	if(!empty($_POST['day_n'])) $day_sel = $_POST['day_n'];
	else $day_sel = $data_mas[2];
	foreach($mass_day as $ar) {
		if($day_sel == $ar)echo "<option value=\"{$ar}\" selected=\"selected\">{$ar}</option>";
		else echo "<option value=\"{$ar}\">{$ar}</option>";
	}
?>
	</select></span>
	<select name="mount_n">
<?
	$c=1;
	if(!empty($_POST['mount_n'])) $mount_sel = $_POST['mount_n'];
	else $mount_sel = $data_mas[1];
	foreach($mass_mount as $ar) {
		if($mount_sel == $c) echo "<option value=\"{$c}\" selected=\"selected\">{$ar}</option>";
		else echo "<option value=\"{$c}\">{$ar}</option>";
	$c++;
	}
?>
	</select></span>
	<select name="year_n">
	<option value="2009">2009</option>
	<option value="2010">2010</option>
	<option value="2011">2011</option>
	<option value="2012">2012</option>
	<option value="2013">2013</option>
    <option value="2014" selected="selected">2014</option>
	</select>
<b>&nbsp;&nbsp;по :&nbsp;&nbsp;</b>
			<select name="day_k">
<?
	if(!empty($_POST['day_k'])) $day_sel = $_POST['day_k'];
	else $day_sel = $data_mas[2];
	foreach($mass_day as $ar) {
		if($day_sel == $ar)echo "<option value=\"{$ar}\" selected=\"selected\">{$ar}</option>";
		else echo "<option value=\"{$ar}\">{$ar}</option>";
	}
?>
	</select></span>
	<select name="mount_k">
<?
	$c=1;
	if(!empty($_POST['mount_k'])) $mount_sel = $_POST['mount_k'];
	else $mount_sel = $data_mas[1];
	foreach($mass_mount as $ar) {
		if($mount_sel == $c) echo "<option value=\"{$c}\" selected=\"selected\">{$ar}</option>";
		else echo "<option value=\"{$c}\">{$ar}</option>";
	$c++;
	}
?>
	</select></span>
	<select name="year_k">
	<option value="2009">2009</option>
	<option value="2010">2010</option>
	<option value="2011">2011</option>
	<option value="2012">2012</option>
	<option value="2013">2013</option>
    <option value="2014" selected="selected">2014</option>
	</select>
	<br /><br />
	<center><input type="submit" name="sel_mount" value="Показать" style="width:100px; "onmouseover="this.style.backgroundColor='#E8E8FF';" onmouseout="this.style.backgroundColor='#f3f7ff';" id="cursor">&nbsp;</center>
</form>
</div>

</div>
</td>
</tr>
	<tr bgcolor="#ffffff" align="center">
		<td>
<A onclick="set_informer(1);return false" href="http://atomly.net/?info=1" class="sait">Заявки на обмен</A> |&nbsp;
<A onclick="set_informer(2);return false" href="http://atomly.net/?info=2" class="sait">Заявки по услугам</A> |&nbsp;
<A onclick="set_informer(3);return false" href="http://atomly.net/?info=3" class="sait">Магазин</A> |&nbsp;
<A onclick="set_informer(4);return false" href="http://atomly.net/?info=4" class="sait">Заявки на пополнение</A> |&nbsp;
<A onclick="set_informer(5);return false" href="http://atomly.net/?info=5" class="sait">Заявки на вывод</A> |&nbsp;
		</td>
</tr>
	<tr bgcolor="#ffffff" align="center">
<td>

<DIV id="exch">
<table width="100%" border="0" cellspacing="1" cellpadding="4" bgcolor="#F2F2F2">
<?

$data_n = strtotime($_POST['year_n']."-".$_POST['mount_n']."-".$_POST['day_n']);
$data_k = mktime(23,59,59,$_POST['mount_k'],$_POST['day_k'],$_POST['year_k']);
if(empty($_POST['year_n'])) {
	$data_n = strtotime($data);
	$data_k = mktime(23,59,59,date('m'),date('d'),date('Y'));
}
	
$WMZ_in = "0"; $WMZ_out = "0";
$WMR_in = "0"; $WMR_out = "0";
$WME_in = "0"; $WME_out = "0";
$WMU_in = "0"; $WMU_out = "0";
$WMB_in = "0"; $WMB_out = "0";
$EasyPay_in = "0"; $EasyPay_out = "0";
$YaDengi_in = "0"; $YaDengi_out = "0";

$unachieved_demand = dataBase::DBexchange()->select('demand','did,ex_output,ex_input,out_val,in_val,add_date,status,partner_id','where add_date BETWEEN '.$data_n.' and '.$data_k,'order by add_date desc');
if(!empty($unachieved_demand)) {$cdem=0;
echo "
             <tr bgcolor=\"#CCCCCC\" align=\"center\">
				<td>№ заявки</td>
                <td>Направление</td>
                <td>Отправляемая сумма</td>
				<td>Получаемая сумма</td>
                <td>Дата</td>
				<td>Статус</td>
				<td>Партнер</td>
              </tr>
";
		foreach($unachieved_demand as $arr) {
            //Model::Demand('HOME')->get
            //sFormatData::formatStatus
		$status_name = swDemand::$status_name[$arr['status']];
        $status_class = swDemand::$status_class[$arr['status']];

	if($arr['status'] == 'y') {
	$cdem++;
switch ($arr['ex_output']) :
	case ("WMZ") : $WMZ_in = $WMZ_in + $arr['out_val']; break;
	case ("WMR") : $WMR_in = $WMR_in + $arr['out_val']; break;
	case ("WME") : $WME_in = $WME_in + $arr['out_val']; break;
	case ("WMU") : $WMU_in = $WMU_in + $arr['out_val']; break;
	case ("WMB") : $WMB_in = $WMB_in + $arr['out_val']; break;
	case ("EasyPay") : $EasyPay_in = $EasyPay_in + $arr['out_val']; break;
	case ("YaDengi") : $YaDengi_in = $YaDengi_in + $arr['out_val']; break;
endswitch;
switch ($arr['ex_input']) :
	case ("WMZ") : $WMZ_out = $WMZ_out + $arr['in_val']; break;
	case ("WMR") : $WMR_out = $WMR_out + $arr['in_val']; break;
	case ("WME") : $WME_out = $WME_out + $arr['in_val']; break;
	case ("WMU") : $WMU_out = $WMU_out + $arr['in_val']; break;
	case ("WMB") : $WMB_out = $WMB_out + $arr['in_val']; break;
	case ("EasyPay") : $EasyPay_out = $EasyPay_out + $arr['in_val']; break;
	case ("YaDengi") : $YaDengi_out = $YaDengi_out + $arr['in_val']; break;
endswitch;
	}
	echo "<tr bgcolor=\"#FFFFFF\" align=center>
		<td><a href=\"search_exch_d.aspx?did={$arr['did']}\">{$arr['did']}</a></td>
		<td>{$arr['ex_output']}->{$arr['ex_input']}</td>
		<td>{$arr['out_val']} {$arr['ex_output']}</td>
		<td>{$arr['in_val']} {$arr['ex_input']}</td>
		<td>".date('d.m.Y H:i:s',$arr['add_date'])."</td>
		<td><b class=\"{$status_class}\">{$status_name}</b></td>
		<td><a href=\"http://atm.wm-rb.net/partner.aspx?id={$arr['partner_id']}\">{$arr['partner_id']}</a></td>
	</tr>";
		}
echo "
<div style=\"float:left; margin-left:10px;\">Входящие</div><div>Исходящие</div>
<div style=\"float:left;\">WMZ - ".number_format($WMZ_in, 0, '.', ' ')."</div><div>WMZ - ".number_format($WMZ_out, 0, '.', ' ')."</div>
<div style=\"float:left;\">WMR - ".number_format($WMR_in, 0, '.', ' ')."</div><div>WMR - ".number_format($WMR_out, 0, '.', ' ')."</div>
<div style=\"float:left;\">WME - ".number_format($WME_in, 0, '.', ' ')."</div><div>WME - ".number_format($WME_out, 0, '.', ' ')."</div>
<div style=\"float:left;\">WMU - ".number_format($WMU_in, 0, '.', ' ')."</div><div>WMU - ".number_format($WMU_out, 0, '.', ' ')."</div>
<div style=\"float:left;\">WMB - ".number_format($WMB_in, 0, '.', ' ')."</div><div>WMB - ".number_format($WMB_out, 0, '.', ' ')."</div>
<div style=\"float:left;\">EasyPay - ".number_format($EasyPay_in, 0, '.', ' ')."</div><div>EasyPay - ".number_format($EasyPay_out, 0, '.', ' ')."</div>
<!-- <div style=\"float:left;\">YaDengi - {$YaDengi_in}</div><div>YaDengi - {$YaDengi_out}</div> -->
<div style=\"float:left;\"><b>Всего выполненных операций :{$cdem}</b></div>
";
}
else echo "<b>По указанной дате заявок нет</b>";
?>
</table>
</DIV>
<DIV id="pay" style="DISPLAY: none">
<table width="100%" border="0" cellspacing="1" cellpadding="4" bgcolor="#F2F2F2">
<?

//$unachieved_demand = $db_pay_desk->stat_pay_dem($data_n,$data_k);
$unachieved_demand = dataBase::DBpaydesk()->select('demand_uslugi','did,output,name_uslugi,out_val,in_val,add_date,status,partner_id','where add_date >= '.$data_n.' and add_date <= '.$data_k,'order by add_date asc');
if(!empty($unachieved_demand)) {
echo "
             <tr bgcolor=\"#CCCCCC\" align=\"center\">
				<td>№ заявки</td>
                <td>Название услуги</td>
                <td>Отправляемая сумма</td>
				<td>Получаемая сумма</td>
                <td>Дата</td>
				<td>Статус</td>
				<td>Партнер</td>
              </tr>
";
		foreach($unachieved_demand as $arr) {

            $status_name = swDemand::$status_name[$arr['status']];
            $status_class = swDemand::$status_class[$arr['status']];

	if($arr['status'] == 'y') {
		if($arr['name_uslugi'] == 'Megashare') {$Megashare = $Megashare + $arr['in_val'];}
		else {$p = $p + $arr['in_val'];}
	}
	echo "<tr bgcolor=\"#FFFFFF\" align=center>
		<td><a href=\"search_pay_d.aspx?did={$arr['did']}\">{$arr['did']}</a></td>
		<td>{$arr['name_uslugi']}</td>
		<td>{$arr['out_val']} {$arr['output']}</td>
		<td>{$arr['in_val']} BLR</td>
		<td>".date('d.m.Y H:i:s',$arr['add_date'])."</td>
		<td><b class=\"{$status_class}\">{$status_name}</b></td>
		<td><a href=\"http://atm.wm-rb.net/partner.aspx?id={$arr['partner_id']}\">{$arr['partner_id']}</a></td>
	</tr>";
		}
echo "
<div class=text align=left>Статистика :</div>
<div align=left>
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;Сумма по Megashare - {$Megashare} <b>BLR</b><br />
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;Сумма по платежам - {$p} <b>BLR</b><br />
</div>
";
}
else echo "<b>По указанной дате заявок нет</b>";
?>
</table>
</DIV>
<DIV id="eshop" style="DISPLAY: none">
<table width="100%" border="0" cellspacing="1" cellpadding="4" bgcolor="#F2F2F2">
<?
$vkontakte = 0;
$unachieved_demand = dataBase::DBpaydesk()->select('demand_eshop','did,output,id_goods,amount,data,time,status,partner_id','where add_date >= '.$data_n.' and add_date <= '.$data_k,'order by add_date asc');
//$unachieved_demand = $db_pay_desk->stat_eshop_dem($data_n,$data_k);
//$sql = "select did,output,id_goods,amount,data,time,status,partner_id from demand_eshop where data >= '$data_n' and data <= '$data_k' order by data asc, time asc";
if(!empty($unachieved_demand)) {

echo "
             <tr bgcolor=\"#CCCCCC\" align=\"center\">
				<td>№ заявки</td>
                <td>Название услуги</td>
                <td>Отправляемая сумма</td>
                <td>Дата</td>
				<td>Статус</td>
				<td>Партнер</td>
              </tr>
";
		foreach($unachieved_demand as $arr) {
			$goods_info = $db_pay_desk->goods_info($arr['id_goods']);

            $status_name = swDemand::$status_name[$arr['status']];
            $status_class = swDemand::$status_class[$arr['status']];

	echo "<tr bgcolor=\"#FFFFFF\" align=center>
		<td><a href=\"search_eshop_d.aspx?did={$arr['0']}\">{$arr['0']}</a></td>
		<td>{$goods_info[0]['name_card']}</td>
		<td>{$arr['amount']} {$arr['output']}</td>
		<td>{$arr['data']} {$arr['time']}</td>
		<td><b class=\"{$status_class}\">{$status_name}</b></td>
		<td><a href=\"http://atm.wm-rb.net/partner.aspx?id={$arr['partner_id']}\">{$arr['partner_id']}</a></td>
	</tr>";
		}
echo "
<div class=text align=left>Статистика :</div>
<div align=left>
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;Количество товара - {$vkontakte} <b>шт.</b><br />
</div>
";

}
else echo "<b>По указанной дате заявок нет</b>";
?>
</table>
</DIV>
<DIV id="cash" style="DISPLAY: none">
<table width="100%" border="0" cellspacing="1" cellpadding="4" bgcolor="#F2F2F2">
<?
$unachieved_demand = dataBase::DBpaydesk()->select('demand_cash','did,output,input,out_val,in_val,add_date,status,partner_id','where add_date >= '.$data_n.' and add_date <= '.$data_k,'order by add_date asc');
//$unachieved_demand = $db_pay_desk->stat_pay_dem_cash($data_n,$data_k);
if(!empty($unachieved_demand)) {
echo "
             <tr bgcolor=\"#CCCCCC\" align=\"center\">
				<td>№ заявки</td>
                <td>Банк</td>
                <td>Отправляемая сумма</td>
				<td>Получаемая сумма</td>
                <td>Дата</td>
				<td>Статус</td>
				<td>Партнер</td>
              </tr>
";
		foreach($unachieved_demand as $arr) {

            $status_name = swDemand::$status_name[$arr['status']];
            $status_class = swDemand::$status_class[$arr['status']];

	echo "<tr bgcolor=\"#FFFFFF\" align=center>
		<td><a href=\"search_cash_d.aspx?did={$arr['did']}\">{$arr['did']}</a></td>
		<td>{$arr['output']}</td>
		<td>{$arr['out_val']} BLR</td>
		<td>{$arr['in_val']} {$arr['input']}</td>
		<td>".date('d.m.Y H:i:s',$arr['add_date'])."</td>
		<td><b class=\"{$status_class}\">{$status_name}</b></td>
		<td><a href=\"http://atm.wm-rb.net/partner.aspx?id={$arr['partner_id']}\">{$arr['partner_id']}</a></td>
	</tr>";
		}
}
else echo "<b>По указанной дате заявок нет</b>";
?>
</table>

</DIV>

<DIV id="cash_out" style="DISPLAY: none">

<table width="100%" border="0" cellspacing="1" cellpadding="4" bgcolor="#F2F2F2">
<?

$unachieved_demand = $db_pay_desk->stat_pay_dem_cash_out($data_n,$data_k);
if(!empty($unachieved_demand)) {
echo "
             <tr bgcolor=\"#CCCCCC\" align=\"center\">
				<td>№ заявки</td>
                <td>Карта пополнения</td>
                <td>Отправляемая сумма</td>
				<td>Получаемая сумма</td>
                <td>Дата</td>
				<td>Статус</td>
				<td>Партнер</td>
              </tr>
";
$summa_belbank = 0;
$summa_bpsb = 0;
		foreach($unachieved_demand as $arr) {

            $status_name = swDemand::$status_name[$arr['status']];
            $status_class = swDemand::$status_class[$arr['status']];

	if($arr['7'] == 'y') {
		if($arr['4'] == 'belbank') $summa_belbank = $summa_belbank + $arr['2'];
		if($arr['4'] == 'bpsb') $summa_bpsb = $summa_bpsb + $arr['2'];
	}
	echo "<tr bgcolor=\"#FFFFFF\" align=center>
		<td><a href=\"search_cash_out_d.aspx?did={$arr['0']}\">{$arr['0']}</a></td>
		<td>{$arr['4']}</td>
		<td>{$arr['3']} {$arr['1']}</td>
		<td>{$arr['2']} BLR</td>
		<td>{$arr['5']} {$arr['6']}</td>
		<td><b class=\"{$status_class}\">{$status_name}</b></td>
		<td><a href=\"http://atm.wm-rb.net/partner.aspx?id={$arr['8']}\">{$arr['8']}</a></td>
	</tr>
	<tr>";
		}
}
else echo "<b>По указанной дате заявок нет</b>";
?>
</table>
<?
$summa_belbank = edit_balance($summa_belbank);
$summa_bpsb = edit_balance($summa_bpsb);
echo "
<div class=text align=left>Статистика :</div>
<div align=left>
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;Сумма операций по карте <b>БеларусБанка</b> - {$summa_belbank} <b>BLR</b><br />
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;Сумма операций по карте <b>БПС-Банка</b> - {$summa_bpsb} <b>BLR</b>
</div>
";
?>
</DIV>


</td>





	</tr>
<tr>

		</table>

      </td>
  </tr>
</table>
