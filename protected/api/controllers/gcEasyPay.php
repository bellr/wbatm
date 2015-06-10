<?php
class easypayJob {

    // php job.php -j easypay -m checkPayments

    public function checkPayments() {

        $EP_purse = Model::Acount_easypay('HOME')->getPurseInput(1,'desc');
        /*dataBase::DBexchange()->update('demand',array('purse_payment'=>$EP_purse),array(
            'did' => $P->did,
            'status' => 'n'
        ));*/


        $str = iconv( "windows-1251","UTF-8", Extension::Payments()->EasyPay()->getApi('getHistory',array(
            'login' => Model::Acount_easypay('HOME')->getPurseInput(1,'desc'),
            'mode' => '4'
        )));

    }

}
