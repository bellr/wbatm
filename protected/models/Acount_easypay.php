<?php
class Acount_easypay extends Model {

    public $prop;

    protected function getInfoModel($obj) {}

    public static function getPurseInput($amount,$sort_type='asc') {

        $PP = Extension::Payments()->getParam('payments','easypay');

		$purse = dataBase::DBexchange()->select('acount_easypay',
		 'acount',
		 'where st_input=1 and status=1 and inputday+'.$amount.'<'.$PP->limits['EP_day'].' and input+'.$amount.'<'.$PP->limits['EP_mouth'],
		 'order by balance '.$sort_type,
		 'limit 1');

		return $purse[0]['acount'];
    }

	public static function getPurseInputUnlimit($amount,$sort_type='desc') {

        $PP = Extension::Payments()->getParam('payments','easypay');

		$purse = dataBase::DBexchange()->select('acount_easypay',
		 'acount',
		 'where st_input=1 and status=1 and input+'.$amount.'<'.$PP->limits['EP_mouth'],
		 'order by id '.$sort_type,
		 'LIMIT 1');

		return $purse = $purse[0]['acount'];
    }
	
    public static function getPurseOutput($amount) {

        $PP = Extension::Payments()->getParam('payments','easypay');

		$purse = dataBase::DBexchange()->select('acount_easypay',
			'acount',
			'where status=1 and st_output=1 and balance>='.$amount.' and outputday+'.$amount.'<'.$PP->limits['EP_day'].' and output+'.$amount.'<'.$PP->limits['EP_mouth'],
			'order by balance asc',
			'LIMIT 1');

		return $purse = $purse[0]['acount'];
    }
	
    public static function updateAcountRemoval($acount,$amount,$summa) {
		dataBase::DBexchange()->query('acount_easypay',"update acount_easypay set balance=balance-{$summa},output=output+{$amount},outputday=outputday+{$amount}, time_payout=".time().", firstpayout=".time()." where acount='$acount'");
		//dataBase::DBexchange()->update('acount_easypay',array('firstpayout'=>time()),"where acount='{$acount}' and firstpayout=0");
    }
	
	public static function updateAcountRefill($acount,$amount) {
		dataBase::DBexchange()->query('acount_easypay',"update acount_easypay set balance=balance+{$amount},input=input+{$amount},inputday=inputday+{$amount}, time_payin=".time().", firstpayin=".time()." where acount='$acount'");
		//dataBase::DBexchange()->update('acount_easypay',array('firstpayin'=>time()),"where acount='{$acount}' and firstpayin=0");
    }
	
	public static function updateAcountService($acount,$amount) {
		dataBase::DBexchange()->query('acount_easypay',"update acount_easypay set balance=balance-".$amount." where acount=".$acount);
    }

    public static function resetDataAcount($acount) {
        dataBase::DBexchange()->query('acount_easypay',"update acount_easypay set balance=0 where acount=".$acount);
    }

	public static function getPurseService($amount) {
		$purse = dataBase::DBexchange()->select('acount_easypay',
			'acount',
			'where st_output=0 and balance>='.$amount,
			'order by id ASC',
			'LIMIT 1');
		return $purse[0]['acount'];
    }
	
	public $codeStr = array(1 => 'Оплата услуг. Недостаточно баланса.', 2 => '');

}
