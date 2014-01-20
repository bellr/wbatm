<?

define('PROJECT','ATM');
define('PROJECT_ROOT',dirname(dirname(__FILE__)));
define('VS_DEBUG',true);

require_once(dirname(PROJECT_ROOT)."/core/vs.php");

$res = dataBase::DBexchange()->select('demand','did,ex_output,ex_input,out_val,in_val,purse_in,purse_payment','where status="yn" and ex_input in ("WMZ","WMR","WME","WMG","WMY","WMU","WMB","EasyPay")');

if(!empty($res)) {
	
	$curl = Extension::Rest(Config::$base['HOME_URL'].'/api/CheckPayment/RepetPayment/');

	foreach($res as $ar) {
	
		$sel_idpay = dataBase::DBadmin()->select('id_payment','id_pay','where did='.$ar['did']);
		$ar['id_pay'] = $sel_idpay[0]['id_pay'];
		$ar['direct'] = $ar['ex_output'].'_'.$ar['ex_input'];
		$ar['desc_pay'] = "Direction of the exchange: {$ar['ex_output']}->{$ar['ex_input']}, ID:{$ar['did']}";
		$ar['type_object'] = 'demand';
		
		$curl->post($ar);
		$curl->execute();

	}
}
?>