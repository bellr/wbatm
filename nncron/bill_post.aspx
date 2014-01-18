<?
define('PROJECT','ATM');
define('PROJECT_ROOT',dirname(dirname(__FILE__)));
define('VS_DEBUG',true);

require_once(dirname(PROJECT_ROOT)."/core/vs.php");

Config::getSysMessages();
$PP = Extension::Payments()->getParam('payments','webmoney');
$old_demand = time() - $PP->demand_deadlines + 24 * 3600;

/* echo strtotime('2013-06-18 12:49')."<br>";
//echo date('Y-m-d H:i:s',strtotime('2013-06-18 12:49'));
echo date('Y-m-d H:i:s','1371551101');

exit; */
//$info = dataBase::DBpaydesk()->select('demand_cash','did,output,input,purse_in,out_val,in_val,purse_payment','where output="pochta" and status="yn" and add_date<'.$old_demand);
$info = dataBase::DBpaydesk()->select('demand_cash','did,output,input,purse_in,out_val,in_val,purse_payment','where output="pochta" and status="yn"');

if(!empty($info)) {

	foreach($info as $ar) {

		$str = Extension::Payments()->EasyPay()->connect_history_easypay($ar['purse_payment'],'1');
		$date_pay = strtotime(Extension::Payments()->EasyPay()->parserSumRefill(number_format(round($ar['out_val']), 0, '.', ' '),$str));
		
$log = 'DID '.$ar['did'].', date from easypay '.Extension::Payments()->EasyPay()->parserSumRefill(number_format(round($ar['out_val']), 0, '.', ' '),$str).', real data '.date('Y-m-d H:i',$date_pay).', unix time '.$date_pay;
vsLog::add($log,'bill_post');

		if($date_pay) {
			$check_pay = dataBase::DBpaydesk()->select('demand_cash','did','where pay_date='.$date_pay);
			if(empty($check_pay)) {
			
				dataBase::DBpaydesk()->update('demand_cash',array('pay_date'=>$date_pay),array(
                    'did' => $ar['did']
                ));
				Model::Acount_easypay()->updateAcountRefill($ar['purse_payment'],$ar['out_val']);
				
				$ip = dataBase::DBadmin()->select('id_payment','id_pay','where did='.$ar['did']);
				$params['ex_input'] = $ar['input'];
				$params['in_val'] = $ar['in_val'];
				$params['id_pay'] = $ip[0]['id_pay'];
				$params['purse_in'] = $ar['purse_in'];
				$params['type_object'] = 'demand_cash';
				$params['direct'] = $ar['output'].'_'.$ar['input'];
				$params['desc_pay'] = "Refill the electronic count: ".$ar['input'].", DID".$ar['did'].", bill merchant : ".$ip[0]['id_pay'];
				$params['did'] = $ar['did'];

				$status = gcCheckPayment::resultCheckPayment($params);

			} else {
				$value['status'] = 'er';
				$value['coment'] = Config::$sysMessage['L_repit_error'].' '.Config::$sysMessage['L_contect_support'];
				Model::Demand()->update($ar['did'],'demand_cash',$value);
			}

		} else {
			dataBase::DBpaydesk()->query('demand_cash','update demand_cash set status="n" where did='.$ar['did']);
		}
	}
}

exit;

//print_r($info);
if(!empty($info)) {

	foreach($info as $ar) {
		$p = "EP".$ar['purse_payment'];
	$class_EasyPay = new EasyPay();
	$str = $class_EasyPay->connect_history_easypay($ar['purse_payment'],$$p,'1');

	echo $class_EasyPay->parser_sum_NAL(edit_balance(truncation_amount($ar[out_val])),$str);
		if($class_EasyPay->parser_sum_NAL(edit_balance(truncation_amount($ar[out_val])),$str)) {
			$exch_balance = $db_exchange->exch_balance($ar['input']);
			if ($exch_balance[0]["balance"]*0.998 >= $ar['in_val']) {
				$db_exchange->edit_bal_ep_in($ar['purse_payment'],truncation_amount($ar['out_val']));
				$id_pay = $db_admin->sel_idpay($ar['did']);
				$desc_pay = "Renewing the electronic count: ".$wmt_purse.", DID".$ar['did'].", bill merchant : ".$id_pay[0]['id_pay'];
				$result = check_payment($ar['input'],$ar['purse_in'],$ar['in_val'],$desc_pay,$ar['did'],$id_pay[0]['id_pay'],'NAL');
			}
			else {
				$db_pay_desk->cash_add_coment('������ ������������ ������ ���������� � �������� ������. ������������� ��������� �� ������.',$ar['did']); exit();
			}
		}
	}
}
?>