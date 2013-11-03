<?
//������� ��������� ������� ��������(�������� ������� �� ������ � �������)
function shop_new($did,$in_val,$out_val,$output,$name_shop) {
	include("xml/conf.php");
	include("xml/wmxiparser.php");
	$parser = new WMXIParser();
	$db = new CustomSQL($DBName);
	$db_exchange = new CustomSQL_exchange($DBName_exchange);
	$db_pay_desk = new CustomSQL_pay_desk($DBName_pay_desk);
	$db_admin = new CustomSQL_admin($DBName_admin);
//����� ������ �� ������
	$demand_info = $db_pay_desk->demand_check($did);
//����� ������ ���������� �� ������ ������
	$sel_idpay = $db_admin->sel_idpay($did);
//���������� �������
	$exch_balance = $db_exchange->exch_balance($output);
	//$bal_in = $exch_balance[0]['balance'] + $in_val;
	$db_exchange->demand_update_bal($exch_balance[0]['balance'] + $in_val,$output);
//����� ���� �� ��������
	$sel_shop = $db->autoPay_shop($name_shop);
//����� ��������
	$sel_purse_out = $db_exchange->sel_purse_out('WMB');
//������ �� ������� ��������
	$sum_tranz = $out_val - $out_val * $sel_shop[0]['percent'];

///!!!!!!!!!!!!!!!�������� �������
$send_summ = explode('.',$demand_info[0]['out_val']);
$sig = md5("230113050722009:".$demand_info[0]['pole1'].":".$send_summ['0']);
$postfields = "n_order=".$demand_info[0]['pole1']."&out_val=".$send_summ['0']."&email=".$demand_info[0]['email']."&data_pay=".$demand_info[0]['data']."&time_pay=".$demand_info[0]['time']."&sig=".$sig;

$ch = curl_init();
curl_setopt($ch, CURLOPT_URL, $sel_shop[0]['refresh_url']);
curl_setopt($ch, CURLOPT_HEADER, 0);
curl_setopt($ch, CURLOPT_RETURNTRANSFER,1);
curl_setopt($ch, CURLOPT_POST,1);
curl_setopt($ch, CURLOPT_NOBODY, false);
curl_setopt($ch, CURLOPT_POSTFIELDS, $postfields);
$res = curl_exec($ch);

///!!!!!!!!!!!!!!!�������� �������
	$desc_pay = "������ �� ������ �".$demand_info[0]['pole1'].", ID".$did;
	if(preg_match("/OK+/i",$res)) {

	$response = $wmxi->X2(
			intval($sel_idpay[0]['id_pay']),    # ����� �������� � ������� ����� �����������; ����� ����� ����� ��� �����, ������ ���� ����������
			'B146213360627',          # ����� �������� � �������� ����������� ������� (�����������)
			$sel_shop[0]['purse'],         # ����� ��������, �� ������� ����������� ������� B144877377115 (����������)
			$sum_tranz,  # ����� � ��������� ������ ��� ���������� ��������
			'0',    # ����� �� 0 �� 255 ��������; 0 - ��� ���������
			'',       # ������������ ������ �� 0 �� 255 ��������; ������� � ������ ��� ����� �� �����������
			trim($desc_pay),        # ������������ ������ �� 0 �� 255 ��������; ������� � ������ ��� ����� �� �����������
			'0',    # ����� ����� > 0; ���� 0 - ������� �� �� �����
			'1'    # ���� 0 � ������� ����� ����������� ��� ����� ��������� �� ���������� �������; 1 � ������� ����� ����������� ������ ���� ���������� ��������� ������� (� ��������� ������ ��� �������� � 35)
		);
		$structure = $parser->Parse($response, DOC_ENCODING);
		$transformed = $parser->Reindex($structure, true);
		$kod_error = htmlspecialchars(@$transformed["w3s.response"]["retval"], ENT_QUOTES);
//echo "������ - ".$kod_error;

		if ($kod_error == "0") {$db_pay_desk->demand_edit('y',$did);}
		else {
			$db_pay_desk->demand_add_coment('�� ����������� �������. ERROR='.$kod_error,$did); $db_pay_desk->demand_edit('er',$did);}
 $oper_res = "Payment_successfully";
	}
	else {$db_pay_desk->demand_add_coment('�� ������� ����� �� �������.',$did); $db_pay_desk->demand_edit('er',$did);}
return $oper_res;
}

function check_payment($ex_input,$purse_in,$in_val,$desc_pay,$did,$sel_idpay,$type_oper,$direct) {

//���� ��������
//include("xml/conf.php");
//include("xml/wmxiparser.php");
include("../const.inc.aspx");
//$db_exchange = new CustomSQL_exchange($DBName_exchange);
//$db_pay_desk = new CustomSQL_pay_desk($DBName_pay_desk);
$db_exchange = new CustomSQL_exchange($DBName_exchange);
if($type_oper == 'exchange') {
	$db_pay_desk = new CustomSQL_exchange($DBName_exchange);
	$name_func = "demand_edit";
	$name_func_kom = "demand_add_coment";}
if($type_oper == 'NAL') {
	$db_pay_desk = new CustomSQL_pay_desk($DBName_pay_desk);
	$name_func = "demand_edit_cash";
	$name_func_kom = "cash_add_coment";}
//$parser = new WMXIParser();

	if ($ex_input == "WMZ" || $ex_input == "WMR" || $ex_input == "WME" || $ex_input == "WMG" || $ex_input == "WMU" || $ex_input == "WMY" || $ex_input == "WMB") { $wmt_purse = $ex_input; $ex_input = "WMT";}
switch ($ex_input) :

	case ("WMT") :
$exch_balance = $db_exchange->exch_balance($wmt_purse);
$in_val_com = $in_val * 1.008;
			$db_exchange->demand_update_bal($exch_balance[0]["balance"] - $in_val_com,$wmt_purse);
if ($exch_balance[0]["balance"] >= $in_val_com) {
/*
	$response = $wmxi->X2(
			intval($sel_idpay),    # ����� �������� � ������� ����� �����������; ����� ����� ����� ��� �����, ������ ���� ����������
			$exch_balance[0]["purse"],          # ����� �������� � �������� ����������� ������� (�����������)
			$purse_in,         # ����� ��������, �� ������� ����������� ������� (����������)
			floatval($in_val),  # ����� � ��������� ������ ��� ���������� ��������
			'0',    # ����� �� 0 �� 255 ��������; 0 - ��� ���������
			'',       # ������������ ������ �� 0 �� 255 ��������; ������� � ������ ��� ����� �� �����������
			trim($desc_pay),        # ������������ ������ �� 0 �� 255 ��������; ������� � ������ ��� ����� �� �����������
			intval('0'),    # ����� ����� > 0; ���� 0 - ������� �� �� �����
			'1'    # ���� 0 � ������� ����� ����������� ��� ����� ��������� �� ���������� �������; 1 � ������� ����� ����������� ������ ���� ���������� ��������� ������� (� ��������� ������ ��� �������� � 35)
		);
		$structure = $parser->Parse($response, DOC_ENCODING);
		$transformed = $parser->Reindex($structure, true);
		$kod_error = htmlspecialchars(@$transformed["w3s.response"]["retval"], ENT_QUOTES);
*/
			//$ext = new eWebmoney('slave_wmid');
			$r = eWebmoney::x2(array('id_pay'=>$sel_idpay,'purse_in'=>$purse_in,'purse_type'=>$wmt_purse,'amount'=>floatval($in_val),'desc'=>$desc_pay,'direct'=>$direct));

		if ($r->retval == "0") {
			$db_pay_desk->$name_func('y',$did);
			echo "Payment_successfully";
		} else {
			$db_pay_desk->$name_func('er',$did);
			$db_pay_desk->$name_func_kom('�� ������������ ��������, ������ ��������� �� �����������. ������������� ���������. ERROR='.$r->retval,$did); exit();
		}
}
else {
	//$db_pay_desk->$name_func('er',$did);
	$db_pay_desk->$name_func_kom('������ ������������ ������ ���������� � �������� ������. �������� �������������.',$did);
	exit();
}
	break;
	case ("RBK Money") :
$exch_balance = $db_exchange->exch_balance($ex_input);
$in_val_com = $in_val * 1.005;
	$bal_in = $exch_balance[0]["balance"] - $in_val_com;
	$db_exchange->demand_update_bal($bal_in,$ex_input);
if ($exch_balance[0]["balance"] < $in_val_com) {
	//$db_pay_desk->$name_func('er',$did);
	$db_pay_desk->$name_func_kom('������ ������������ ������ ���������� � �������� ������. �������� �������������.',$did);
}
	break;
	case ("EasyPay") :

	
	
//if ($exch_balance[0]["balance"] >= $in_val_com) {
	$purse = $db_exchange->EP_purse_output($in_val*1.02);
	//$sql = "select acount from acount_easypay where status=1 and st_output=1 and balance>=$s_output and outputday+'$s_output'<{$limitday} and output+'$s_output'<{$limitmouth} order by id ASC LIMIT 1";
	//vsLog::add($purse);
	if(!empty($purse)) {
		$db_exchange->edit_bal_minus($in_val*1.02,$ex_input);
		$db_exchange->edit_bal_ep($purse[0]['acount'],$in_val*1.02);
		$db_exchange->upd_time_dayout($purse[0]['acount']);
		$db_exchange->edit_purse_input($did,$purse[0]['acount']);
		require($atm_dir."nncron/func_easypay.aspx");
			//����� � �������� �� ���. ����� ����������� ������� ��� ����������� ��� �������� �������
			//$purse = $db_exchange->sel_purse_out('EasyPay');
			$p = "EP".$purse[0]['acount'];
			$pp = "PP".$purse[0]['acount'];
		//$class_EasyPay = new EasyPay();
		$str_result = EasyPay::direct_translation($purse[0]['acount'],$$p,$$pp,$purse_in,trim(sprintf("%8.0f ",$in_val)),$did);
		if($str_result == "TRANSFER_OK") {$db_exchange->$name_func('y',$did);}
		elseif($str_result == "TRANSFER_ERROR") {$db_pay_desk->$name_func_kom('�������� ���� ��������� �����������. ������������� ��������� �� ������.',$did);}
		elseif($str_result == "ERROR_RECIPIENT") {$db_pay_desk->$name_func_kom('��� ���������� ���� �������� ��������� ����� ������� ������ �������� (������� ����������). ������������� ��������� �� ������.',$did);}
		elseif($str_result == "ERROR_PURSE") {$db_pay_desk->$name_func_kom('�������������� ������������� ������������ �������� EasyPay (������� ����������). ������������� ��������� �� ������.',$did);}
		elseif($str_result == "ERROR_EXCESS_S") {$db_pay_desk->$name_func_kom('��������� �������� ����������� �� ����� �������� (������� �����������). ������������� ��������� �� ������.',$did);}
		elseif($str_result == "ERROR_EXCESS_U") {$db_pay_desk->$name_func_kom('��������� �������� ����������� �� ����� �������� (������� ����������). ������������� ��������� �� ������.',$did);}
		elseif($str_result == "MAX_LIMIT_DAY") {$db_pay_desk->$name_func_kom('��������� ������� ����������� (������� �����������). ������������� ��������� �� ������.',$did);}
		elseif($str_result == "ERROR_BALANCE") {$db_pay_desk->$name_func_kom('������������� ������ ��� ���������� ��������. ������������� ��������� �� ������.',$did);}
		elseif($str_result == "ERROR_CONNECT_SERVER") {$db_pay_desk->$name_func_kom('������ ���������� � �������� EasyPay. ������������� ��������� �� ������.',$did);}
			
			}
			
			else {//$db_pay_desk->$name_func('er',$did);
		$db_pay_desk->$name_func_kom('������ ������������ ������ ���������� � �������� ������. ������������� ��������� �� ������.',$did);}
		
	break;
	case ("YaDengi") :
$exch_balance = $db_exchange->exch_balance($ex_input);
$balance_in = $exch_balance[0]["balance"];
	$bal_in = $balance_in - $in_val;
	$db_exchange->demand_update_bal($bal_in,$ex_input);
if ($balance_in < $in_val) {
	//$db_pay_desk->$name_func('er',$did);
	$db_pay_desk->$name_func_kom('������ ������������ ������ ���������� � �������� ������. �������� �������������.',$did);
}
	break;
	case ("Z-PAYMENT") :
$exch_balance = $db_exchange->exch_balance($ex_input);
$balance_in = $exch_balance[0]["balance"];
	$bal_in = $balance_in - $in_val;
	$db_exchange->demand_update_bal($bal_in,$ex_input);
if ($balance_in < $in_val) {
	//$db_pay_desk->$name_func('er',$did);
	$db_pay_desk->$name_func_kom('������ ������������ ������ ���������� � �������� ������. �������� �������������.',$did);
}
	break;
	default:
endswitch;
}

//������� ���������� ������� ����� ������ �� �������
function check_pay_uslugi($did,$output,$name_uslugi,$in_val,$out_val,$pole1,$pole2) {
include("../const.inc.aspx");

	//$db = new CustomSQL($DBName);
	$db_exchange = new CustomSQL_exchange($DBName_exchange);
	$db_pay_desk = new CustomSQL_pay_desk($DBName_pay_desk);
//���������� �������
	$db_pay_desk->demand_edit('yn',$did);
	//$exch_balance = $db_exchange->exch_balance_service($output);
	//$bal_in = $exch_balance[0]['balance'] + $out_val;
	//$db_exchange->demand_update_bal_service($bal_in,$output);

$mass_oper = array(VELCOM => "velcom", MTS => "mts", LIFE => "best", Dialog => "belcel",
BF => "10131", BF17 => "10161", BF15 => "10155", BF16 => "10142", BF21 => "10213", BF22 => "10206", BF23 => "10234",
TEL => "10111", TEL17 => "10141", TEL15 => "10145", TEL16 => "10092", TEL21 => "10193", TEL22 => "10016", TEL022 => "10216", TEL23 => "10214", KTV => "cosmostv", AchinaPlus => "13431", ATLANT => "atlant", SOLO => "solo", ZKH => "10011", ZKH16 => "10032", ZKH21 => "10063", ZKH22 => "10026");
if($name_uslugi == 'BF' && preg_match("/1760[0-9]*/i",$pole1) || preg_match("/1705[0-9]*/i",$pole1) || preg_match("/1706[0-9]*/i",$pole1) || preg_match("/1704[0-9]*/i",$pole1) || preg_match("/1703[0-9]*/i",$pole1) || preg_match("/1701[0-9]*/i",$pole1) || preg_match("/1700[0-9]*/i",$pole1)) {$mass_oper[$name_uslugi] = '14521';}
if(!empty($mass_oper[$name_uslugi])) {
	//����� ����� � �������� ����� ������������� �������
	$purse = $db_exchange->EP_purse_out_service($in_val);
	$db_pay_desk->edit_purse_input($did,$purse[0]['acount'],'demand_uslugi');
	$p = "EP".$purse[0]['acount'];
	$pp = "PP".$purse[0]['acount'];
	if (!empty($purse[0]['acount'])) {
	require($atm_dir."nncron/func_easypay.aspx");
	$class_EasyPay = new EasyPay();
//	$ak = $pole2.$pole1;
	$str_result = $class_EasyPay->pay_usluga($purse[0]['acount'],$$p,$$pp,$pole2.$pole1,trim(sprintf("%8.0f ",$in_val)),$mass_oper[$name_uslugi]);
		if($str_result == "TRANSFER_OK") {$db_pay_desk->demand_edit('y',$did);
			$db_exchange->edit_bal_ep_service($purse[0]['acount'],$in_val);
			echo "Payment_successfully";
			}
		if($str_result == "TRANSFER_ERROR") {$db_pay_desk->demand_edit('er',$did); $db_pay_desk->demand_add_coment('�������� �� ���������. ������������� ��������� �� ������.',$did);}
		if($str_result == "ERROR_BALANCE") {$db_pay_desk->demand_edit('er',$did); $db_pay_desk->demand_add_coment('������������� ������ ��� ���������� ��������. ������������� ��������� �� ������.',$did);}
		if($str_result == "ERROR_CONNECT_SERVER") {$db_pay_desk->demand_edit('er',$did); $db_pay_desk->demand_add_coment('������ ���������� � ��������� ��������. ������������� ��������� �� ������.',$did);}

}
else {$db_pay_desk->demand_add_coment('�� ������ ���� ��� ������. ���� ������ ����� ��������� � ��������� ����� ����� ��������� .',$did); $db_pay_desk->demand_edit('er',$did);}
}
}

//������� ���������� ������� ����� ������ ���������� ����
function output_NAL($did,$output,$out_val,$name_card,$card,$id_pay,$period) {
	include("../const.inc.aspx");
	$db_exchange = new CustomSQL_exchange($DBName_exchange);
	$db_pay_desk = new CustomSQL_pay_desk($DBName_pay_desk);
switch ($name_card) :

	case ("CARDUSD") :
		require($atm_dir."nncron/liqpay.aspx");
 		$class_LiqPAY = new LiqPAY();
		$answer = $class_LiqPAY->API_LiqPAY($did,$id_pay,$card,$out_val,'USD','card');
		if($answer == 'success') {$db_pay_desk->dem_edit_output('y',$did);}
		else {$db_pay_desk->dem_coment_output($answer,$did); $db_pay_desk->dem_edit_output('er',$did);}

		$fd = fopen("123.log","w");
		fputs($fd, $answer."\n");
                fflush($fd);
		fclose($fd);
	break;
	case ("P24USD") :

	break;
	case ("P24UAH") :

	break;
	case ("belbank") :
	require($home_dir."mailer/smtp-func.aspx");

	smtpmail("1176044@sms.velcom.by","atomly","{$card}/{$period}|{$out_val}","atomly");

	break;
	case ("bpsb") :

	break;
	default:
endswitch;

}


//������� ��� ������ � ����������
function shop($did,$output,$out_val,$in_val,$name_card) {

	//$db = new CustomSQL($DBName);
	$db_exchange = new CustomSQL_exchange($DBName_exchange);
	$db_pay_desk = new CustomSQL_pay_desk($DBName_pay_desk);
//���������� �������
	$db_pay_desk->dem_edit_output('yn',$did);
	$exch_balance = $db_exchange->exch_balance($output);
	$bal_in = $exch_balance[0]['balance'] + $in_val;
	$db_exchange->demand_update_bal($bal_in,$output);
//��������� ������� ������ ������� ���������� ������
	$exch_bal_card = $db_pay_desk->sel_card_bal($name_card);

if ($exch_bal_card[0]['balance'] >= $in_val) {
	$balance_in = $exch_bal_card[0]['balance'] - $out_val * (1 + $exch_bal_card[0]['com_card']);
	$db_pay_desk->update_bal_card($balance_in,$name_card);
}
else {
	$db_pay_desk->dem_coment_output('������ ������������ ������ ���������� � �������� ������. ������������� ���������.',$did);
	$error = true;
}
return  $error;
}

///////////////////////////////////////////////////////////////////////////������� �� ���������� �������� �� ������������� ������
/*function repet_pay($did,$ex_output,$ex_input,$purse_in,$out_val,$in_val,$id_pay,$purse_payment) {
include("../const.inc.aspx");
$db_exchange = new CustomSQL_exchange($DBName_exchange);

	if ($ex_input == "WMZ" || $ex_input == "WMR" || $ex_input == "WME" || $ex_input == "WMG" || $ex_input == "WMU" || $ex_input == "WMY" || $ex_input == "WMB") { $wmt_purse = $ex_input; $ex_input = "WMT";}
switch ($ex_input) :

	case ("WMT") :

		$desc_pay = "Direction of the exchange(AUTOREPIT): {$ex_output} ({$out_val})->{$wmt_purse} ({$in_val}), ID:{$did}";
		$r = eWebmoney::x2(array('id_pay'=>$id_pay,'purse_in'=>$purse_in,'purse_type'=>$wmt_purse,'amount'=>floatval($in_val),'desc'=>$desc_pay,'direct'=>$direct));

		if($r->retval == 0) {
			$value['status'] = 'y';
		} else {
			$value['status'] = 'er';
			$value['coment'] = 'Error #'.$r->retval;
		}		
		
		dataBase::DBexchange()->update('demand',$value,'where did='.$did);	

	break;

	case ("EasyPay") :


	if(!empty($purse_payment)) {
		require_once($atm_dir."nncron/func_easypay.aspx");
		//����� � �������� �� ���. ����� ����������� ������� ��� ����������� ��� �������� �������
		$p = "EP".$purse_payment;
		$pp = "PP".$purse_payment;
		$class_EasyPay = new EasyPay();
		$str_result = $class_EasyPay->direct_translation($purse_payment,$$p,$$pp,$purse_in,trim(sprintf("%8.0f ",$in_val)),$did);

		if($str_result == "TRANSFER_OK") {
			dataBase::DBexchange()->update('demand',array('status'=>'y','coment'=>''),"where did=".$did);
			//$db_exchange->return_data_ep($purse[0][purse_payment],$in_val);
			//$db_exchange->edit_bal_ep($purse_payment,$in_val*1.02);
			//update acount_easypay set balance=balance-'$summa',output=output+'$summa',outputday=outputday+'$summa',time_payout=".time()."	where acount='$acount'";
			//$db_exchange->upd_time_dayout($purse_payment);$db_exchange->demand_add_coment('',$did); $db_exchange->demand_edit('y',$did);
		}
	} else{
		$db_exchange->demand_add_coment('�� ������ ���� ��� ������. ������������� ���������',$did);
	}
	break;
	default:
endswitch;
}*/



///////////////////////////////////////////////////////////////////////////������� �������� �������
function return_pay($did,$ex_output,$ex_input,$purse_payment,$purse_out,$out_val,$in_val,$id_pay) {
//���� ��������
include("../const.inc.aspx");
//$db = new CustomSQL($DBName);
$db_exchange = new CustomSQL_exchange($DBName_exchange);
//$db_pay_desk = new CustomSQL_pay_desk($DBName_pay_desk);

	if ($ex_output == "WMZ" || $ex_output == "WMR" || $ex_output == "WME" || $ex_output == "WMG" || $ex_output == "WMU" || $ex_output == "WMY" || $ex_output == "WMB") { $wmt_purse = $ex_output; $ex_output = "WMT";}
switch ($ex_output) :

	case ("WMT") :
require_once($atm_dir."nncron/func_wm.aspx");
	$class_WebMoney = new WebMoney();
	$desc_pay = "Return of the exchange: {ex_output} ({$out_val})->{$ex_input} ({$in_val}), ID:{$did}";

	$exch_balance = $db_exchange->exch_balance($wmt_purse);
	if($exch_balance[0]["balance"] >= $out_val){

		$trans_result = $class_WebMoney->return_translation_X14($id_pay,$out_val);
		if($trans_result == "0") {
			$db_exchange->demand_edit('n',$did);
			$db_exchange->demand_update_bal($exch_balance[0]["balance"] - $out_val,$wmt_purse);
			$db_exchange->edit_bal_plus($in_val*(1+$$ex_input),$ex_input);
			if($ex_input == 'EasyPay') {$db_exchange->edit_ep_return($purse_payment,$in_val*1.02);}
		}
		else {$db_exchange->demand_add_coment($kod_error,$did);}
	}
	break;

	case ("EasyPay") :
		$summa = $out_val - $out_val*0.02;
	$purse = $db_exchange->EP_purse_output($summa);
	if(!empty($purse)) {
		require_once($atm_dir."nncron/func_easypay.aspx");
			//����� � �������� �� ���. ����� ����������� ������� ��� ����������� ��� �������� �������
			$p = "EP".$purse[0]['acount'];
			$pp = "PP".$purse[0]['acount'];
		$class_EasyPay = new EasyPay();
		$str_result = $class_EasyPay->direct_translation($purse[0]['acount'],$$p,$$pp,$purse_out,trim(sprintf("%8.0f ",$summa)),$did);
		if($str_result == "TRANSFER_OK") {
			$db_exchange->demand_edit('n',$did);
			$db_exchange->edit_bal_minus($summa,$ex_output);
			$db_exchange->edit_bal_plus($in_val*(1+$$ex_input),$ex_input);
			$db_exchange->edit_ep_return_input($purse[0]['acount'],$summa);
			$db_exchange->upd_time_dayout($purse[0]['acount']);
			}
			else {$db_exchange->demand_add_coment($str_result,$did);}
	}
	break;
	default:
endswitch;
}

//������� ���������� ������� ����� ������ �� �������
function check_pay_eshop($did,$name_goods,$amount,$amount_goods) {

	//$db = new CustomSQL($DBName);
	//$db_exchange = new CustomSQL_exchange($DBName_exchange);
	$db_pay_desk = new CustomSQL_pay_desk($DBName_pay_desk);
//��������� ���������� ������
	$amount_good = $db_pay_desk->sel_amount_good($name_goods);
	$bal_upd = $amount_good[0]['balance'] - $amount_goods;
	$db_pay_desk->upd_amount_good($name_goods,$bal_upd);
return  "Payment_successfully";
}

function e_shop($did,$email,$name_goods,$pay_price,$pay_curr,$id_goods,$type_goods,$data,$time) {
	include("../const.inc.aspx");
	require("send_mail.aspx");
	require($home_dir."mailer/smtp-func.aspx");
	$db_pay_desk = new CustomSQL_pay_desk($DBName_pay_desk);
switch ($type_goods) :

	case ("pinkod") :
$g = $db_pay_desk->select_goods($id_goods);
	if(!empty($g)) {
	$db_pay_desk->edit_st_goods($g[0]['id']);
	$db_pay_desk->edit_count($id_goods);
	$db_pay_desk->add_goods_dem($did,$g[0]['id']);
	}
	else {return "|ERROR_SELGOODS"; exit();}
	break;
	case ("pin_un") :
$g = $db_pay_desk->select_goods($id_goods);
	if(!empty($g)) {
	$db_pay_desk->edit_st_goods($g[0]['id']);
	$db_pay_desk->edit_count_un($id_goods);
	$db_pay_desk->add_goods_dem($did,$g[0]['id']);
	}
	else {return "|ERROR_SELGOODS"; exit();}
	break;
	default:
endswitch;
	$body = badyMail($did,$type_goods,$name_goods,$pay_price,$pay_curr,$g[0][1],$data,$time,$icq,$support);
	smtpmail($email,"������� ������ � ��������-�������� Shop.wm-rb.net",$body,"��������-������� Shop.wm-rb.net");
return  "Payment_successfully";
}
?>