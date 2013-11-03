<?
require("customsql.inc.aspx");
$db = new CustomSQL($DBName);
$db_exchange = new CustomSQL_exchange($DBName_exchange);
$db_pay_desk = new CustomSQL_pay_desk($DBName_pay_desk);
$db_admin = new CustomSQL_admin($DBName_admin);

$data_start = time() - 86400;
$data_end = time();

//расчет партнерской программы за вчерашний день по заявкам обмена валют
$partner_dem = $db_exchange->partner_dem($data_start,$data_end);
if (!empty($partner_dem)) {
    foreach($partner_dem as $arr) {
        $sel_info_partner = $db->sel_info_partner($arr['2']);
        if($arr['ex_output'] == "WMZ") {
            $res_comiss = $arr['out_val'] * $sel_info_partner[0]["percent"] / 100;

            $res_summ_oper = $sel_info_partner[0]["summ_oper"] + $arr['out_val'];
            $res_balance = $sel_info_partner[0]["balance"] + $res_comiss + 0.01;
            $res_summa_bal = $sel_info_partner[0]["summa_bal"] + $res_comiss;

            $update_bal_partner = $db->update_bal_partner($res_balance,$res_summa_bal,$res_count_oper,$res_summ_oper,$arr['partner_id']);
        }
        else {
            $sel_kurs = $db_exchange->sel_kurs($arr['0']."_WMZ");
            if($sel_kurs[0]["direct"] == "y") $summa_wmz = $sel_kurs[0]["konvers"] * $arr['out_val'];
            if($sel_kurs[0]["direct"] == "n") $summa_wmz = $arr['out_val'] / $sel_kurs[0]["konvers"];
            $res_comiss = $summa_wmz * $sel_info_partner[0]["percent"] / 100;

            $res_summ_oper = $sel_info_partner[0]["summ_oper"] + $summa_wmz;
            $res_balance = $sel_info_partner[0]["balance"] + $res_comiss;
            $res_summa_bal = $sel_info_partner[0]["summa_bal"] + $res_comiss;
            $res_count_oper = ++$sel_info_partner[0]["count_oper"];
            $update_bal_partner = $db->update_bal_partner($res_balance,$res_summa_bal,$res_count_oper,$res_summ_oper,$arr['2']);
        }
    }
}

//расчет партнерской программы за вчерашний день по заявкам оплату услуг
$partner_dem_pay = $db_pay_desk->partner_dem($data_start,$data_end);
if (!empty($partner_dem_pay)) {
    foreach($partner_dem_pay as $arr) {
        $sel_info_partner = $db->sel_info_partner($arr['2']);
        if($arr['0'] == "WMZ") {
            $res_comiss = $arr['1'] * $sel_info_partner[0]["percent"] / 100;

            $res_summ_oper = $sel_info_partner[0]["summ_oper"] + $arr['1'];
            $res_balance = $sel_info_partner[0]["balance"] + $res_comiss;
            $res_summa_bal = $sel_info_partner[0]["summa_bal"] + $res_comiss;
            $res_count_oper = ++$sel_info_partner[0]["count_oper"];
            $update_bal_partner = $db->update_bal_partner($res_balance,$res_summa_bal,$res_count_oper,$res_summ_oper,$arr['2']);
        }
        else {
            $sel_kurs = $db_exchange->sel_kurs($arr['0']."_WMZ");
            if($sel_kurs[0]["direct"] == "y") $summa_wmz = $sel_kurs[0]["konvers"] * $arr['1'];
            if($sel_kurs[0]["direct"] == "n") $summa_wmz = $arr['1'] / $sel_kurs[0]["konvers"];
            $res_comiss = $summa_wmz * $sel_info_partner[0]["percent"] / 100;

            $res_summ_oper = $sel_info_partner[0]["summ_oper"] + $summa_wmz;
            $res_balance = $sel_info_partner[0]["balance"] + $res_comiss;
            $res_summa_bal = $sel_info_partner[0]["summa_bal"] + $res_comiss;
            $res_count_oper = ++$sel_info_partner[0]["count_oper"];
            $update_bal_partner = $db->update_bal_partner($res_balance,$res_summa_bal,$res_count_oper,$res_summ_oper,$arr['2']);
        }
    }
}
//расчет партнерской программы за вчерашний день по заявкам на пополнение счетов
$partner_dem_nal = $db_pay_desk->partner_dem_nal($data_start,$data_end);
if (!empty($partner_dem_nal)) {
    foreach($partner_dem_nal as $arr) {
        $sel_info_partner = $db->sel_info_partner($arr['2']);

        $sel_kurs = $db_exchange->sel_kurs("WMB_WMZ");
        $summa_wmz = $arr['1'] / $sel_kurs[0]["konvers"];
        $res_comiss = $summa_wmz * $sel_info_partner[0]["percent"] / 100;

        $res_summ_oper = $sel_info_partner[0]["summ_oper"] + $summa_wmz;
        $res_balance = $sel_info_partner[0]["balance"] + $res_comiss;
        $res_summa_bal = $sel_info_partner[0]["summa_bal"] + $res_comiss;
        $res_count_oper = ++$sel_info_partner[0]["count_oper"];
        $update_bal_partner = $db->update_bal_partner($res_balance,$res_summa_bal,$res_count_oper,$res_summ_oper,$arr['2']);

    }
}

//расчет партнерской программы за вчерашний день по заявкам на вывод на карту
/*$partner_dem_nal_out = $db_pay_desk->partner_dem_nal_out($data);
if (!empty($partner_dem_nal_out)) {
    foreach($partner_dem_nal_out as $arr) {
        $sel_info_partner = $db->sel_info_partner($arr['2']);

        $sel_kurs = $db_exchange->sel_kurs("WMB_WMZ");
        $summa_wmz = $arr['1'] / $sel_kurs[0]["konvers"];
        $res_comiss = $summa_wmz * $sel_info_partner[0]["percent"] / 100;

        $res_summ_oper = $sel_info_partner[0]["summ_oper"] + $summa_wmz;
        $res_balance = $sel_info_partner[0]["balance"] + $res_comiss;
        $res_summa_bal = $sel_info_partner[0]["summa_bal"] + $res_comiss;
        $res_count_oper = ++$sel_info_partner[0]["count_oper"];
        $update_bal_partner = $db->update_bal_partner($res_balance,$res_summa_bal,$res_count_oper,$res_summ_oper,$arr['2']);
    }
}*/

//чистка базы с АЙ-ПИ адресами рефералов
$delip_partner_refer = $db->delip_partner_refer();
/*
//статистика балансов
$db_admin->add_cash_str($data);
$sel_cash_bal = $db_exchange->sel_cash_bal();
if (!empty($sel_cash_bal)) {

	foreach($sel_cash_bal as $arr) {

		if ($arr['0'] == "RBK Money") $arr['0'] = "RBK_Money";
		$db_admin->add_cash_bal($arr['0'],$arr['1'],$data);
		//echo $arr['0']."<br>";
	}
}
*/
?>