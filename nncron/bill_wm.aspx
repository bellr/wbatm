<?
//start repit from 5 minuts
define('PROJECT','ATM');
define('VS_DEBUG',true);
require_once("../../core/vs.php");

$res = dataBase::DBexchange()->select('demand','did,ex_output,ex_input,out_val,in_val,purse_in','where status="p"');

if(!empty($res)) {
		
	foreach($res as $ar) {
		$id_pay = dataBase::DBadmin()->select('id_payment','id_pay,more_idpay','where did='.$ar['did']);
		$ar['id_pay'] = $id_pay[0]['id_pay'];
		$ar['more_idpay'] = $id_pay[0]['more_idpay'];
		$ar['purse_type'] = $ar['ex_output'];
		$ar['desc_pay']= "Direction of the exchange: {$ar['ex_output']}->{$ar['ex_input']}, ID:{$ar['did']}";
		$ar['direct'] = $ar['ex_output'].'_'.$ar['ex_input'];
		$r = eWebmoney::x4($ar);
		
		vsLog::add('DID '.$ar['did'].' status '.$r->outinvoices->outinvoice->state,'check_bill');
		
		if($r->outinvoices->outinvoice->state == 2 || $r->outinvoices->outinvoice->state == 1) {

			dataBase::DBexchange()->query('balance',"update balance set balance=balance+".$ar['out_val']." where name='".$ar['ex_output']."'");
			dataBase::DBexchange()->update('demand',array('status'=>'yn'),"where did=".$ar['did']);

			$ar['type_oper'] = 'exchange';
			$ar['customerpurse'] = $r->outinvoices->outinvoice->customerpurse;
			$ar['type_object'] = 'demand';
			gcCheckPayment::resultCheckPayment($ar);
		} elseif($r->outinvoices->outinvoice->state == 3) {
			dataBase::DBexchange()->update('demand',array('status'=>'n'),"where did=".$ar['did']);
		}
	}
}
unset($res);

$res = dataBase::DBpaydesk()->select('demand_uslugi','did,output,name_uslugi,in_val,out_val,pole1,pole2','where status="p"');

if(!empty($res)) {

	foreach($res as $ar) {
		$id_pay = dataBase::DBadmin()->select('id_payment','id_pay,more_idpay','where did='.$ar['did']);
		$ar['id_pay'] = $id_pay[0]['id_pay'];
		$ar['more_idpay'] = $id_pay[0]['more_idpay'];
		$ar['purse_type'] = $ar['output'];
		$ar['desc_pay'] = "Payment facilities: {$ar[0]['name_uslugi']}, ID:{$ar[0]['did']}";
		$ar['direct'] = $ar['output'].'_uslugi';
		$r = eWebmoney::x4($ar);

		if($r->outinvoices->outinvoice->state == 2 || $r->outinvoices->outinvoice->state == 1 || $ar['did'] == '1371063811') {

			dataBase::DBexchange()->query('balance',"update balance set balance=balance+".$ar['out_val']." where name='".$ar['output']."_service'");
			dataBase::DBpaydesk()->update('demand_uslugi',array('status'=>'yn'),"where did=".$ar['did']);
			$ar['customerpurse'] = $r->outinvoices->outinvoice->customerpurse;

			gcCheckPayment::resultPayService($ar);
		} elseif($r->outinvoices->outinvoice->state == 3) {
			dataBase::DBpaydesk()->update('demand_uslugi',array('status'=>'n'),"where did=".$ar['did']);
		}
	}
}
unset($res);
