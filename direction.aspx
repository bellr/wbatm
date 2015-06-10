<?

function select_rate($direction,$indefined,$db_exchange) {

switch ($direction) :
	case ("WMZ_WMR") :
		$sel_rate = $db_exchange->sel_wmrate($direction);
	break;
	case ("WMZ_WME") :
		$sel_rate = $db_exchange->sel_wmrate($direction);
	break;
	case ("WMZ_WMU") :
		$sel_rate = $db_exchange->sel_wmrate($direction);
	break;
	case ("WMZ_WMB") :
		$sel_rate = $db_exchange->sel_wmrate($direction);
	break;
	case ("WMZ_EasyPay") :
		$sel_rate = $db_exchange->baserate($indefined);
	break;
	case ("WMZ_YaDengi") :
		$sel_rate = $db_exchange->baserate($indefined);
	break;
	case ("WMR_WMZ") :
		$sel_rate = $db_exchange->sel_wmrate($direction);
	break;
	case ("WMR_WME") :
		$sel_rate = $db_exchange->sel_wmrate($direction);
	break;
	case ("WMR_WMU") :
		$sel_rate = $db_exchange->sel_wmrate($direction);
	break;
	case ("WMR_WMB") :
		$sel_rate = $db_exchange->sel_wmrate($direction);
	break;
	case ("WMR_EasyPay") :
		$sel_rate = $db_exchange->baserate($indefined);
	break;
	case ("WME_WMZ") :
		$sel_rate = $db_exchange->sel_wmrate($direction);
	break;
	case ("WME_WMR") :
		$sel_rate = $db_exchange->sel_wmrate($direction);
	break;
	case ("WME_WMU") :
		$sel_rate = $db_exchange->sel_wmrate($direction);
	break;
	case ("WME_WMB") :
		$sel_rate = $db_exchange->sel_wmrate($direction);
	break;
	case ("WME_EasyPay") :
		$sel_rate = $db_exchange->baserate($indefined);
	break;
	case ("WME_YaDengi") :
		$sel_rate = $db_exchange->baserate($indefined);
	break;
	case ("WMU_WMZ") :
		$sel_rate = $db_exchange->sel_wmrate($direction);
	break;
	case ("WMU_WMR") :
		$sel_rate = $db_exchange->sel_wmrate($direction);
	break;
	case ("WMU_WME") :
		$sel_rate = $db_exchange->sel_wmrate($direction);
	break;
	case ("WMU_WMB") :
		$sel_rate = $db_exchange->sel_wmrate($direction);
	break;
	case ("WMU_EasyPay") :
		$sel_rate = $db_exchange->baserate($indefined);
	break;
	case ("WMU_YaDengi") :
		$sel_rate = $db_exchange->baserate($indefined);
	break;
	case ("WMB_WMZ") :
		$sel_rate = $db_exchange->sel_wmrate($direction);
	break;
	case ("WMB_WMR") :
		$sel_rate = $db_exchange->sel_wmrate($direction);
	break;
	case ("WMB_WME") :
		$sel_rate = $db_exchange->sel_wmrate($direction);
	break;
	case ("WMB_WMU") :
		$sel_rate = $db_exchange->sel_wmrate($direction);
	break;
	case ("WMB_YaDengi") :
		$sel_rate = $db_exchange->baserate($indefined);
	break;
	case ("EasyPay_WMU") :
		$sel_rate = $db_exchange->baserate($indefined);
	break;
	case ("EasyPay_WME") :
		$sel_rate = $db_exchange->baserate($indefined);
	break;
	case ("EasyPay_WMR") :
		$sel_rate = $db_exchange->baserate($indefined);
	break;
	case ("EasyPay_WMZ") :
		$sel_rate = $db_exchange->baserate($indefined);
	break;
	case ("YaDengi_EasyPay") :
		$sel_rate = $db_exchange->baserate($indefined);
	break;
	case ("YaDengi_WMB") :
		$sel_rate = $db_exchange->baserate($indefined);
	break;
	case ("YaDengi_WMU") :
		$sel_rate = $db_exchange->baserate($indefined);
	break;
	case ("YaDengi_WME") :
		$sel_rate = $db_exchange->baserate($indefined);
	break;
	case ("YaDengi_WMZ") :
		$sel_rate = $db_exchange->baserate($indefined);
	break;
	case ("EasyPay_YaDengi") :
		$sel_rate = $db_exchange->baserate($indefined);
	break;
	case ("YaDengi_usluga") :
		$sel_rate = $db_exchange->baserate($indefined);
	break;
	case ("WMZ_usluga") :
		$d = explode('_',$direction);
		$sel_rate = $db_exchange->sel_wmrate($d[0]."_WMB");
	break;
	case ("WMU_usluga") :
		$d = explode('_',$direction);
		$sel_rate = $db_exchange->baserate($indefined);
	break;
	case ("WMR_usluga") :
		$d = explode('_',$direction);
		$sel_rate = $db_exchange->sel_wmrate($d[0]."_WMB");
	break;
	case ("WME_usluga") :
		$d = explode('_',$direction);
		$sel_rate = $db_exchange->sel_wmrate($d[0]."_WMB");
	break;
	case ("NAL_WMZ") :
		$sel_rate = $db_exchange->baserate($indefined);
	break;
	case ("NAL_WMR") :
		$sel_rate = $db_exchange->baserate($indefined);
	break;
	case ("NAL_WME") :
		$sel_rate = $db_exchange->baserate($indefined);
	break;
	case ("NAL_WMU") :
		$sel_rate = $db_exchange->baserate($indefined);
	break;
	case ("NAL_YaDengi") :
		$sel_rate = $db_exchange->baserate($indefined);
	break;
	case ("WMZ_NAL") :
		$sel_rate = $db_exchange->baserate($indefined);
	break;
	case ("WMR_NAL") :
		$sel_rate = $db_exchange->baserate($indefined);
	break;
	case ("WME_NAL") :
		$sel_rate = $db_exchange->baserate($indefined);
	break;
	case ("WMU_NAL") :
		$sel_rate = $db_exchange->baserate($indefined);
	break;
	case ("YaDengi_NAL") :
		$sel_rate = $db_exchange->baserate($indefined);
	break;
	case ("WMZ_merch") :
		$d = explode('_',$direction);
		$sel_rate = $db_exchange->sel_wmrate($d[0]."_WMB");
	break;
	case ("WMR_merch") :
		$d = explode('_',$direction);
		$sel_rate = $db_exchange->sel_wmrate($d[0]."_WMB");
	break;
	case ("WME_merch") :
		$d = explode('_',$direction);
		$sel_rate = $db_exchange->sel_wmrate($d[0]."_WMB");
	break;
	case ("WMU_merch") :
		$d = explode('_',$direction);
		$sel_rate = $db_exchange->sel_wmrate($d[0]."_WMB");
	break;
	case ("YaDengi_merch") :
		$sel_rate = $db_exchange->baserate($indefined);
	break;
	case ("Z-PAYMENT_WMZ") :
		$sel_rate = $db_exchange->baserate($indefined);
	break;
	case ("Z-PAYMENT_WMR") :
		$sel_rate = $db_exchange->baserate($indefined);
	break;
	case ("Z-PAYMENT_WME") :
		$sel_rate = $db_exchange->baserate($indefined);
	break;
	case ("Z-PAYMENT_WMU") :
		$sel_rate = $db_exchange->baserate($indefined);
	break;
	case ("Z-PAYMENT_WMB") :
		$sel_rate = $db_exchange->baserate($indefined);
	break;
	case ("Z-PAYMENT_EasyPay") :
		$sel_rate = $db_exchange->baserate($indefined);
	break;
	case ("Z-PAYMENT_merch") :
		$sel_rate = $db_exchange->baserate($indefined);
	break;
	case ("Z-PAYMENT_NAL") :
		$sel_rate = $db_exchange->baserate($indefined);
	break;
	case ("Z-PAYMENT_usluga") :
		$sel_rate = $db_exchange->baserate($indefined);
	break;
	case ("NAL_Z-PAYMENT") :
		$sel_rate = $db_exchange->baserate($indefined);
	break;
	case ("WMZ_Z-PAYMENT") :
		$sel_rate = $db_exchange->baserate($indefined);
	break;
	case ("WME_Z-PAYMENT") :
		$sel_rate = $db_exchange->baserate($indefined);
	break;
	case ("WMU_Z-PAYMENT") :
		$sel_rate = $db_exchange->baserate($indefined);
	break;
	case ("WMB_Z-PAYMENT") :
		$sel_rate = $db_exchange->baserate($indefined);
	break;
	case ("EasyPay_Z-PAYMENT") :
		$sel_rate = $db_exchange->baserate($indefined);
	break;
	case ("WMZ_shop") :
		$d = explode('_',$direction);
		$sel_rate = $db_exchange->sel_wmrate($d[0]."_WMZ");
	break;
	case ("WMR_shop") :
		$d = explode('_',$direction);
		$sel_rate = $db_exchange->sel_wmrate($d[0]."_WMZ");
	break;
	case ("WME_shop") :
		$d = explode('_',$direction);
		$sel_rate = $db_exchange->sel_wmrate($d[0]."_WMZ");
	break;
	case ("WMU_shop") :
		$d = explode('_',$direction);
		$sel_rate = $db_exchange->sel_wmrate($d[0]."_WMZ");
	break;
	case ("EasyPay_shop") :
		$sel_rate = $db_exchange->baserate($indefined);
	break;
	case ("ZPRUB_shop") :
		$sel_rate = $db_exchange->baserate($indefined);
	break;
	case ("WMZ_belbank") :
		$sel_rate = $db_exchange->baserate($indefined);
	break;
	case ("WMZ_deltabank") :
		$sel_rate = $db_exchange->baserate($indefined);
	break;
	case ("WMZ_bpsb") :
		$sel_rate = $db_exchange->baserate($indefined);
	break;
	case ("WMR_belbank") :
		$sel_rate = $db_exchange->baserate($indefined);
	break;
	case ("WMR_deltabank") :
		$sel_rate = $db_exchange->baserate($indefined);
	break;
	case ("WMR_bpsb") :
		$sel_rate = $db_exchange->baserate($indefined);
	break;
	case ("WME_belbank") :
		$sel_rate = $db_exchange->baserate($indefined);
	break;
	case ("WME_deltabank") :
		$sel_rate = $db_exchange->baserate($indefined);
	break;
	case ("WME_bpsb") :
		$sel_rate = $db_exchange->baserate($indefined);
	break;
	case ("WMU_belbank") :
		$sel_rate = $db_exchange->baserate($indefined);
	break;
	case ("WMU_deltabank") :
		$sel_rate = $db_exchange->baserate($indefined);
	break;
	case ("WMU_bpsb") :
		$sel_rate = $db_exchange->baserate($indefined);
	break;
	case ("EasyPay_belbank") :
		$sel_rate = $db_exchange->baserate($indefined);
	break;
	case ("EasyPay_deltabank") :
		$sel_rate = $db_exchange->baserate($indefined);
	break;
	case ("EasyPay_bpsb") :
		$sel_rate = $db_exchange->baserate($indefined);
	break;
	case ("Z-PAYMENT_belbank") :
		$sel_rate = $db_exchange->baserate($indefined);
	break;
	case ("Z-PAYMENT_bpsb") :
		$sel_rate = $db_exchange->baserate($indefined);
	break;
	case ("Moneybookers_belbank") :
		$sel_rate = $db_exchange->baserate($indefined);
	break;
	case ("Moneybookers_bpsb") :
		$sel_rate = $db_exchange->baserate($indefined);
	break;
endswitch;

return $sel_rate[0]['rate'];
}
?>