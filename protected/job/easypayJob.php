<?php
class easypayJob {

    // php job.php -j easypay -m checkPayments

    public function checkPayments() {

        $old_demand = time() - 30 * 3600;
        $demands = dataBase::DBexchange()->select('demand','*','where ex_output="EasyPay" and status="n" and add_date > '.$old_demand);

        if(count($demands)) {

            $EP_purse = Model::Acount_easypay()->getPurseInput(1,'desc');
d($EP_purse);
            $str = iconv( "windows-1251","UTF-8", Extension::Payments()->EasyPay()->getApi('getHistory',array(
                'login' => $EP_purse,
                'mode' => '4'
            )));
vsLog::add($str);
            if(preg_match("/200 OK/i",$str)) {

                foreach($demands as $demand) {

                    $check_out_val = trim(number_format($demand['out_val'], 0, '.', ' '));
                    $check_summe = Extension::Payments()->EasyPay()->parserHistorySum($check_out_val,$demand['did'],$str);

                    if($check_summe == "AMOUNT_CORRESPONDS") {

                        dataBase::DBexchange()->query('balance',"update balance set balance=balance+".$demand['out_val']." where name='".$demand['ex_output']."'");
                        Model::Acount_easypay()->updateAcountRefill($demand['purse_payment'],$demand['out_val']);
                        dataBase::DBexchange()->update('demand',array('status'=>'yn'),'where did='.$demand['did']);

                    }
                }
            }
        }
    }

}
