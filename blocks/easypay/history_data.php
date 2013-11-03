<?
class history_data extends Template {

    function __construct($action_method,$vars) {
        $this->$action_method();
    }

    private function block() {
		$P = inputData::init();

		$data = date("Y-m-d");
		$data_mas = explode("-",$data);

		$acount = dataBase::DBexchange()->select('acount_easypay','acount,balance','order by id ASC');
		foreach($acount as $ac) {
			$this->vars['option_acount'] .= $this->iterate_tmpl('easypay',__CLASS__,'option_acount',$ac);
		}
		
		$this->vars['days'] = sFormatData::getDaysList();
		$this->vars['months'] = sFormatData::getMonthsList();
		$this->vars['year'] = sFormatData::getYearList('2009');
		
        return $this->vars;
    }

	private function process() {

		$P = inputData::init();

		$str = iconv( "windows-1251","UTF-8", eEasyPay::connectHistoryEasypayDate($P->purse,$P->type,'',''));

		$s = "/<div class=\"balance_value\" id=\"balance_value\">([0-9\ ]+) руб.<\/div>+/i";
		preg_match($s,$str,$b);
		
		$res = '<b>Полученный баланс</b> - '.$b[1].'<br />';
		$res .= $str;

		echo json_encode(array('status'=>0,'message'=>'Готово','html'=>$res));
	}
}

?>