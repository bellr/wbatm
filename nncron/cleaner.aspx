<?

//clear old deman and  not payid demands start repit from 5 minuts
define('PROJECT','ATM');
define('VS_DEBUG',true);
require_once("../../core/vs.php");

function parse($ids) {
	foreach($ids as $id) {
		$id_str[] = $id['did'];
	}
	return implode(',',$id_str);
}

$check_date = time() - Config::$wmBase['payment_deadlines_P'];
//$check_date = time() - 20 * 60;
$old_demand = time() - 2 * 24 * 3600;

//delete demand on exchange
dataBase::DBexchange()->update('demand',array('status'=>'n'),'where status="p" and add_date<'.$check_date);
$ids = dataBase::DBexchange()->select('demand','did','where status="n" and add_date<'.$old_demand);
if(!empty($ids)) {
	$str_ids = parse($ids);
	dataBase::DBexchange()->delete('demand','where did in('.$str_ids.')');
	dataBase::DBadmin()->delete('id_payment','where did in('.$str_ids.')');
}

//delete demand on services
dataBase::DBpaydesk()->update('demand_uslugi',array('status'=>'n'),'where status="p" and add_date<'.$check_date);
$ids = dataBase::DBpaydesk()->select('demand_uslugi','did','where status="n" and add_date<'.$old_demand);
if(!empty($ids)) {
	$str_ids = parse($ids);
	dataBase::DBpaydesk()->delete('demand_uslugi','where did in('.$str_ids.')');
	dataBase::DBadmin()->delete('id_payment','where did in('.$str_ids.')');	
}


