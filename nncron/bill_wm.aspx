<?
//start repit from 5 minuts
define('PROJECT','ATM');
define('VS_DEBUG',true);
require_once("../../core/vs.php");

$res = dataBase::DBexchange()->select('demand','did,ex_output,ex_input,out_val,in_val,purse_in','where status="p"');


if(!empty($res)) {
		
	$curl = Extension::Rest(Config::$base['HOME_URL'].'/api/CheckPayment/resultCheckPayment/');
		
	foreach($res as $ar) {
		$id_pay = dataBase::DBadmin()->select('id_payment','id_pay,more_idpay','where did='.$ar['did']);
		$ar['id_pay'] = $id_pay[0]['id_pay'];
		$ar['more_idpay'] = $id_pay[0]['more_idpay'];
		$ar['purse_type'] = $ar['ex_output'];
		$ar['desc_pay']= "Direction of the exchange: {$ar['ex_output']}->{$ar['ex_input']}, ID:{$ar['did']}";
		$ar['direct'] = $ar['ex_output'].'_'.$ar['ex_input'];
		$r = Extension::Payments()->Webmoney()->x4($ar);

		if($r->outinvoices->outinvoice->state == 2 || $r->outinvoices->outinvoice->state == 1) {

			dataBase::DBexchange()->query('balance',"update balance set balance=balance+".$ar['out_val']." where name='".$ar['ex_output']."'");
			dataBase::DBexchange()->update('demand',array('status'=>'yn','purse_out' => $r->outinvoices->outinvoice->customerpurse),array(
                'did' => $ar['did']
            ));

			$ar['type_oper'] = 'exchange';
			$ar['type_object'] = 'demand';
			
	        $curl->post($ar);
	        $curl->execute();

		} elseif($r->outinvoices->outinvoice->state == 3) {
		
			dataBase::DBexchange()->update('demand',array('status'=>'n'),array(
                'did' => $ar['did']
            ));
			
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
		$r = Extension::Payments()->Webmoney()->x4($ar);

		if($r->outinvoices->outinvoice->state == 2 || $r->outinvoices->outinvoice->state == 1 || $ar['did'] == '1371063811') {

			dataBase::DBexchange()->query('balance',"update balance set balance=balance+".$ar['out_val']." where name='".$ar['output']."_service'");
			dataBase::DBpaydesk()->update('demand_uslugi',array('status'=>'yn'),array(
                'did' => $ar['did']
            ));
			$ar['customerpurse'] = $r->outinvoices->outinvoice->customerpurse;

			gcCheckPayment::resultPayService($ar);
		} elseif($r->outinvoices->outinvoice->state == 3) {
			dataBase::DBpaydesk()->update('demand_uslugi',array('status'=>'n'),array(
                'did' => $ar['did']
            ));
		}
	}
}
unset($res);
