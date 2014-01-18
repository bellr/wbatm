<?php

define('PROJECT','ATM');
define('VS_DEBUG',true);
require_once("../../core/vs.php");
$PP = Extension::Payments()->getParam('payments','webmoney');

$P = inputData::init();
echo $PP->secret_key_merchant;
vsLog::add((array)$P);
vsLog::add($_POST['LMI_SECRET_KEY']);
echo $PPsecret_key_merchant;
if($P->LMI_SECRET_KEY == $PP->secret_key_merchant) {
	
	$P->did = '1375383710';
	$demand_info = dataBase::DBexchange()->select('demand','ex_output,ex_input,out_val,in_val,purse_out,purse_in,email','where did="'.$P->did.'" and status="n"');
	d($demand_info);
	$ex_output = $ar['purse_type'] = $demand_info[0]["ex_output"];
	$ex_input = $ar['ex_input'] = $demand_info[0]["ex_input"];
	$out_val = $demand_info[0]["out_val"];
	$in_val = $ar['in_val'] = $demand_info[0]["in_val"];
	$purse_out = $demand_info[0]["purse_out"];
	$purse_in = $ar['purse_in'] = $demand_info[0]["purse_in"];
	$email = $demand_info[0]["email"];

	$wmBase = $PP;
	$work_wmid_wmid = $wmBase[$PP->default_wmid];
	$sel_purse_out = $wmBase[$work_wmid_wmid][$demand_info[0]['ex_output']];
	
//	echo Config::$wmBase[$demand_info[0]['ex_output']]
	
	//Config::$wmBase[eWebmoney::$workWMID][$params['purse_type']]
	$md5_demand = md5($ex_output.$ex_input.$out_val.$in_val.$sel_purse_out.$purse_in);
	$md5_merchant = md5($P->ex_output.$P->ex_input.$P->LMI_PAYMENT_AMOUNT.$P->inval.$P->LMI_PAYEE_PURSE.$P->in_purse);

	
	//$db_exchange->update_purse_out($_POST['did'],$_POST['LMI_PAYER_PURSE']);
	dataBase::DBexchange()->update('demand',array('purse_out' => $P->LMI_PAYER_PURSE, 'status' =>'yn'),array(
        'did' => $P->did
    ));
	//$sql = "update demand set purse_out='$purse' where did='$did'";
	
	$id_pay = dataBase::DBadmin()->update('id_payment',array('more_idpay' => $P->LMI_SYS_TRANS_NO),array(
        'id_pay' => $P->LMI_PAYMENT_NO
    ));
	$ar['id_pay'] = $id_pay[0]['id_pay'];
	$ar['more_idpay'] = $P->LMI_SYS_TRANS_NO;
	$ar['direct'] = $ex_output.'_'.$ar['ex_input'];
	$ar['type_object'] = 'demand';
	
	//$db_admin->add_more_idpay($_POST['LMI_SYS_TRANS_NO'],$_POST['LMI_PAYMENT_NO']);
	//$sql = "update id_payment set more_idpay='$more_idpay' where id_pay='$id_pay'";
	
	//$exch_balance = dataBase::DBexchange()->select('balance','balance,purse','where name="'.$ex_output.'"');
	//$exch_balance = $db_exchange->exch_balance($ex_output);
	//$sql = "select balance,purse from balance where name ='$output'";
	//$balance_out = $exch_balance[0]["balance"] + $out_val;

	dataBase::DBexchange()->query('balance',"update balance set balance=balance+{$out_val} where name='{$ex_output}'");
		//$db_exchange->demand_update_bal($balance_out,$ex_output);
		//$sql = "update balance set balance='$balance_out' where name='$ex_output'";
		
		//$db_exchange->demand_edit('yn',$_POST['did']);
		//$sql = "update demand set status='$st' where did='$did'";
		
		$ar['desc_pay'] = "Direction of the exchange: {$ex_output}->{$ex_input}, ID:{$P->did}";

		gcCheckPayment::resultCheckPayment($ar);
		//check_payment($_POST['ex_input'],$purse_in,$in_val,$desc_pay,$_POST['did'],$_POST['LMI_PAYMENT_NO'],'exchange',$ex_output.'_'.$ex_input);
		
		
	} else {
		dataBase::DBexchange()->update('demand',array('coment' => '� �������� ������ ���� �������� ��������� ������. �������� ������������� ��������� ������, ����� ����� ��������� � ������ ������ ����� ��������', 'status' =>'er'),'where did='.$P->did);
	
		//$db_exchange->demand_add_coment('� �������� ������ ���� �������� ��������� ������. �������� ������������� ��������� ������, ����� ����� ��������� � ������ ������ ����� ��������',$_POST['did']);
		//$sql = "update demand set coment='$coment' where did='$did'";
		
		//$db_exchange->demand_edit('er',$_POST['did']);
		//$sql = "update demand set status='$st' where did='$did'";
	}



exit;
require("customsql.inc.aspx");
require("constructor_exch_auto.aspx");
$db = new CustomSQL($DBName);
$db_exchange = new CustomSQL_exchange($DBName_exchange);
$db_admin = new CustomSQL_admin($DBName_admin);
$db_pay_desk = new CustomSQL_pay_desk($DBName_pay_desk);
//Dbnfkbq_1986 - Z-Payment

if($_POST['LMI_SECRET_KEY'] == "Dbnfkbq1986") {
	if(!empty($_POST['ex_wm'])) {
//��������� ������ �����
//����� ���� �� ������
	$demand_info = $db_exchange->demand_check($_POST['did'],'n');
	$ex_output = $demand_info[0]["ex_output"];
	$ex_input = $demand_info[0]["ex_input"];
	$out_val = $demand_info[0]["out_val"];
	$in_val = $demand_info[0]["in_val"];
	$purse_out = $demand_info[0]["purse_out"];
	$purse_in = $demand_info[0]["purse_in"];
	$email = $demand_info[0]["email"];

//����� ��������
$sel_purse_out = $db_exchange->sel_purse_out($ex_output);

	$md5_demand = md5($ex_output.$ex_input.$out_val.$in_val.$sel_purse_out[0]['purse'].$purse_in);
	$md5_merchant = md5($_POST['ex_output'].$_POST['ex_input'].$_POST['LMI_PAYMENT_AMOUNT'].$_POST['inval'].$_POST['LMI_PAYEE_PURSE'].$_POST['in_purse']);

	if ($md5_demand == $md5_merchant) {

		$db_exchange->update_purse_out($_POST['did'],$_POST['LMI_PAYER_PURSE']);
		$db_admin->add_more_idpay($_POST['LMI_SYS_TRANS_NO'],$_POST['LMI_PAYMENT_NO']);
		$exch_balance = $db_exchange->exch_balance($ex_output);
		$balance_out = $exch_balance[0]["balance"] + $out_val;

		$db_exchange->demand_update_bal($balance_out,$ex_output);
		$db_exchange->demand_edit('yn',$_POST['did']);
		$desc_pay = "Direction of the exchange: {$ex_output}->{$ex_input}, ID:{$_POST['did']}";

		check_payment($_POST['ex_input'],$purse_in,$in_val,$desc_pay,$_POST['did'],$_POST['LMI_PAYMENT_NO'],'exchange',$ex_output.'_'.$ex_input);
	}
	else {$db_exchange->demand_add_coment('� �������� ������ ���� �������� ��������� ������. �������� ������������� ��������� ������, ����� ����� ��������� � ������ ������ ����� ��������',$_POST['did']);
	$db_exchange->demand_edit('er',$_POST['did']); }
	}

	
	
	
	
	
	
//��������� �������� �� ������
	elseif(!empty($_POST['usluga_wm'])) {
//��������� ������ �����
$sel_idpay_did = $db_admin->sel_idpay_did($_POST['LMI_PAYMENT_NO']);
$db_admin->add_more_idpay($_POST['LMI_SYS_TRANS_NO'],$_POST['LMI_PAYMENT_NO']);
//����� ���� �� ������
	$demand_info = $db_pay_desk->demand_check($sel_idpay_did[0]['did']);
	$output = $demand_info[0]["output"];
	$out_val = $demand_info[0]["out_val"];
	$in_val = $demand_info[0]["in_val"];
		if(!empty($demand_info)) {
//����� ��������
$sel_purse_out = $db_exchange->sel_purse_out_service($output);
	if (!empty($_POST['LMI_HASH'])) {
		$md5_demand = md5($output.$out_val.$in_val.$sel_purse_out[0]['purse']);
		$md5_merchant = md5($_POST['output'].$_POST['LMI_PAYMENT_AMOUNT'].$_POST['in_val'].$_POST['LMI_PAYEE_PURSE']);
			if ($md5_demand == $md5_merchant) {

//foreach($_POST as $ar) {
//$str .= $ar."\n";
//}
/*
$str = $sel_idpay_did[0]['did']." ".$_POST['output']." ".$demand_info[0]['name_uslugi']." ".$in_val." ".$out_val." ".$demand_info[0]['pole1']." ".$demand_info[0]['pole2'];
		$fd = fopen("123.log","a");
		fputs($fd, $str."\n");
                fflush($fd);
		fclose($fd);
*/
		check_pay_uslugi($sel_idpay_did[0]['did'],$_POST['output'],$demand_info[0]['name_uslugi'],$in_val,$out_val,$demand_info[0]['pole1'],$demand_info[0]['pole2']);
	}
	else { $db_pay_desk->demand_add_coment('� �������� ������ ���� �������� ��������� ������. �������� ������������� ��������� ������, ����� ����� ��������� � ������ ������ ����� ��������',$sel_idpay_did[0]['did']);
	$db_pay_desk->demand_edit('er',$sel_idpay_did[0]['did']);}
	}
	else { $db_pay_desk->demand_add_coment('�� ������ �������� � ����������� �������',$sel_idpay_did[0]['did']);
	$db_pay_desk->demand_edit('er',$sel_idpay_did[0]['did']);}
		}
	}

/////////////////////////////////////////////////////////////////��������� ���������� �����
	elseif(!empty($_POST['output_NAL'])) {
//����� ���� �� ������
	$sel_idpay_did = $db_admin->sel_idpay_did($_POST['LMI_PAYMENT_NO']);
	$demand_info = $db_pay_desk->demand_check_out($sel_idpay_did[0]['did'],'n');
	$db_admin->add_more_idpay($_POST['LMI_SYS_TRANS_NO'],$_POST['LMI_PAYMENT_NO']);
	$db_pay_desk->dem_edit_output('yn',$sel_idpay_did[0]['did']);
	//���������� �������
	$db_exchange->increase_bal($demand_info[0]["in_val"],$_POST['output']);
//����� ��������
$sel_purse_out = $db_exchange->sel_purse_out($demand_info[0]["output"]);
	$md5_demand = md5($demand_info[0]["output"].$demand_info[0]["in_val"].$demand_info[0]["out_val"].$sel_purse_out[0]['purse']);
	$md5_merchant = md5($_POST['output'].$_POST['LMI_PAYMENT_AMOUNT'].$_POST['in_val'].$_POST['LMI_PAYEE_PURSE']);
			if ($md5_demand == $md5_merchant) {
				$exch_bal_card = $db_pay_desk->sel_card_bal($demand_info[0]['name_card']);
				if($exch_bal_card[0]['balance'] >= $demand_info[0]["out_val"]) {
					$db_pay_desk->update_bal_card($exch_bal_card[0]['balance'] - $demand_info[0]["out_val"] * (1 + $exch_bal_card[0]['com_card']),$demand_info[0]['name_card']);

output_NAL($sel_idpay_did[0]['did'],$_POST['output'],$demand_info[0]["out_val"],$demand_info[0]['name_card'],$demand_info[0]['card'],$_POST['LMI_PAYMENT_NO'],$demand_info[0]["period"]);
exit();
					}
					else {$db_pay_desk->dem_coment_output('������ ������������ ������ ���������� � �������� ������. �������� �������������.',$sel_idpay_did[0]['did']); $db_pay_desk->dem_edit_output('er',$sel_idpay_did[0]['did']);}
	}
	else { $db_pay_desk->dem_coment_output('� �������� ������ ���� �������� ��������� ������. �������� ������������� ��������� ������, ����� ����� ��������� � ������ ������ ����� ��������',$sel_idpay_did[0]['did']);
	$db_pay_desk->dem_edit_output('er',$sel_idpay_did[0]['did']);}
	}

elseif(!empty($_POST['pay_shop'])) {
	include("xml/conf.php");
	include("xml/wmxiparser.php");
	$parser = new WMXIParser();

//��������� ������ �����
$sel_idpay_did = $db_admin->sel_idpay_did($_POST['LMI_PAYMENT_NO']);
//����� ���� �� ������
	$demand_info = $db_pay_desk->demand_check($sel_idpay_did[0]['did']);
	$output = $demand_info[0]["output"];
	$name_shop = $demand_info[0]["name_uslugi"];
	$out_val = $demand_info[0]["out_val"];
	$in_val = $demand_info[0]["in_val"];

if($demand_info[0]["status"] != "y") {
	if (!empty($_POST['LMI_HASH'])) {
$db_pay_desk->demand_edit('yn',$sel_idpay_did[0]['did']);

//����� ���� �� shop�
$sel_shop = $db->sel_shop($name_shop);
//���������� �������
	$exch_balance = $db_exchange->exch_balance_service($output);
	$bal_in = $exch_balance[0]['balance'] + $out_val;
	$db_exchange->demand_update_bal_service($bal_in,$output);

//������ �� ������� ��������
//$exch_balance = $db_exchange->exch_balance('WMB');
$sum_tranz = $in_val - $in_val * $sel_shop[0]['percent'];

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
curl_exec($ch);
///!!!!!!!!!!!!!!!�������� �������

$desc_pay = "������ �� ������ �".$demand_info[0]['pole1'].", ID".$sel_idpay_did[0]['did'];

	$response = $wmxi->X2(
			$_POST['LMI_PAYMENT_NO'],    # ����� �������� � ������� ����� �����������; ����� ����� ����� ��� �����, ������ ���� ����������
			'B146213360627',          # ����� �������� � �������� ����������� ������� (�����������)
			$sel_shop[0]['purse'],         # ����� ��������, �� ������� ����������� ������� B144877377115 (����������)
			$sum_tranz,  # ����� � ��������� ������ ��� ���������� ��������
			'0',    # ����� �� 0 �� 255 ��������; 0 - ��� ���������
			'',       # ������������ ������ �� 0 �� 255 ��������; ������� � ������ ��� ����� �� �����������
			trim($desc_pay),        # ������������ ������ �� 0 �� 255 ��������; ������� � ������ ��� ����� �� �����������
			'0',    # ����� ����� > 0; ���� 0 - ������� �� �� �����
			intval('0')    # ���� 0 � ������� ����� ����������� ��� ����� ��������� �� ���������� �������; 1 � ������� ����� ����������� ������ ���� ���������� ��������� ������� (� ��������� ������ ��� �������� � 35)
		);
		$structure = $parser->Parse($response, DOC_ENCODING);
		$transformed = $parser->Reindex($structure, true);
		$kod_error = htmlspecialchars(@$transformed["w3s.response"]["retval"], ENT_QUOTES);
//echo "������ - ".$kod_error;


		if ($kod_error == "0") {

$db_pay_desk->demand_edit('y',$sel_idpay_did[0]['did']);
		}
		else {
			$db_pay_desk->demand_add_coment('� ����� � ������������ �����������, ������ ���� ��������� �����������. �������� �������������. ERROR='.$kod_error,$sel_idpay_did[0]['did']);}

	}
	else { $db_pay_desk->dem_coment_output('�� ������ �������� � ����������� �������',$sel_idpay_did[0]['did']);
	$db_pay_desk->demand_edit('er',$sel_idpay_did[0]['did']);}
}

}
/*

///////////////////////////��������� ������� �� ������� �������������� ������
if(!empty($_POST['auto_processing'])) {
//��������� ������ �����
$sel_idpay_did = $db_admin->sel_idpay_did($_POST['LMI_PAYMENT_NO']);
//����� ���� �� ������
	$demand_info = $db->demand_check($sel_idpay_did[0]['did']);
//����� ��������
$sel_purse_out = $db_exchange->sel_purse_out_service($demand_info[0]["oplata"]);
	if (!empty($_POST['LMI_HASH'])) {
		$md5_demand = md5($demand_info[0]["oplata"].$demand_info[0]["summa_pay"].$sel_purse_out[0]['purse']);
		$md5_merchant = md5($_POST['output'].$_POST['LMI_PAYMENT_AMOUNT'].$_POST['LMI_PAYEE_PURSE']);
			if ($md5_demand == $md5_merchant) {
				$remainder = $db->autoPay_shop($demand_info[0]["terminal"]);
				$add_amount = $remainder[0]['remainder'] + $demand_info[0]["summa"];
				$db->remainder_null($demand_info[0]["terminal"]);
				$db->upd_summa($add_amount,$sel_idpay_did[0]['did']);
				//���������� �������
				$exch_balance = $db_exchange->exch_balance_service($demand_info[0]["oplata"]);
				$bal_in = $exch_balance[0]['balance'] + $demand_info[0]["summa_pay"];
				$db_exchange->demand_update_bal_service($bal_in,$demand_info[0]["oplata"]);
				$db->st_edit('yn',$sel_idpay_did[0]['did']);
//������ ������ B ��������
	include("xml/conf.php");
	include("xml/wmxiparser.php");
	$parser = new WMXIParser();
	$response = $wmxi->X9('871652566746');
	$xmlres = simplexml_load_string($response);

	for ($i=0; $i<=20; $i++) {
		if ($xmlres->purses->purse[$i]->pursename == 'B580416608371') {$balance_in = $xmlres->purses->purse[$i]->amount - $xmlres->purses->purse[$i]->amount*0.008; break;}
	}
//������ ������ B ��������
	}
	else { $db->add_comment('� �������� ������ ���� �������� ��������� ������. �������� ������������� ��������� ������, ����� ����� ��������� � ������ ������ ����� ��������',$sel_idpay_did[0]['did']);
	$db->st_edit('er',$sel_idpay_did[0]['did']);}
		}
	else { $db->add_comment('�� ������ �������� � ����������� �������',$sel_idpay_did[0]['did']);
	$db->st_edit('er',$sel_idpay_did[0]['did']);}
}
*/
elseif(!empty($_POST['shop_pay'])) {
//��������� ������ �����
$sel_idpay_did = $db_admin->sel_idpay_did($_POST['LMI_PAYMENT_NO']);
//����� ���� �� ������
	$demand_info = $db_pay_desk->demand_check_eshop($sel_idpay_did[0]['did']);
	$purse = $db_exchange->sel_purse_shop($demand_info[0]["output"]);
	$hesh = md5("keyok16201Dbnfkbq1987x986dbnfkbq19864-_=&^%$#@".$_POST['LMI_PAYMENT_NO'].$_POST['LMI_PAYMENT_AMOUNT'].$purse[0]['purse'].$demand_info[0]["output"]."keyok16201Dbnfkbq1987x986dbnfkbq19864-_=&^%$#@");
		if($hesh == $_POST['hesh']) {
			$info_goods = $db_pay_desk->sel_goods_price($demand_info[0]["id_goods"]);
$s = e_shop($sel_idpay_did[0]["did"],$demand_info[0]["email"],$info_goods[0]["name_card"],$demand_info[0]["amount"],$demand_info[0]["output"],$demand_info[0]["id_goods"],$demand_info[0]["type_goods"],$demand_info[0]["data"],$demand_info[0]["time"]);

if($s == "ERROR_SELGOODS") {$db_pay_desk->add_coment_eshop('�� ������ ����� �� ���� ������. ������������� ��������� �� ������.',$sel_idpay_did[0]['did']);	$db_pay_desk->demand_edit_eshop('er',$sel_idpay_did[0]['did']);}
else {$db_pay_desk->demand_edit_eshop('y',$sel_idpay_did[0]['did']);
	if(!empty($demand_info[0]["diskont_id"])) {
		$sel_diskont = $db_pay_desk->search_diskont($demand_info[0]["diskont_id"]);	$db_pay_desk->upd_diskont($demand_info[0]["diskont_id"],$info_goods[0]["price"]-$info_goods[0]["price"]*$sel_diskont[0]['procent']/100);
	}
}
		}
		else {$db_pay_desk->add_coment_eshop('�������� �������. ������������� ��������� �� ������.',$sel_idpay_did[0]['did']);
		$db_pay_desk->demand_edit_eshop('er',$sel_idpay_did[0]['did']);
		}
}
}




?>