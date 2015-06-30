<?php

//cd /var/www/wmrb/data/www/billing87.wm-rb.net/nncron/ && /usr/bin/php -f return_pay.aspx >/dev/null 2>&1


class checkPaymentJob {

    // php job.php -j checkPayment -m easypay
    // cd /var/www/wmrb/data/www/billing87.wm-rb.net/ && /usr/bin/php job.php -j checkPayment -m easypay >/dev/null 2>&1

    public function easypay() {

        $old_demand = time() - 0.5 * 3600;
        $demands = dataBase::DBexchange()->select('demand','*','where ex_output="EasyPay" and status="n" and add_date > '.$old_demand);

        if(count($demands)) {

            $EP_purse = Model::Acount_easypay()->getPurseInput(1,'desc');

            $str = iconv( "windows-1251","UTF-8", Extension::Payments()->EasyPay()->getApi('getHistory',array(
                'login' => $EP_purse,
                'mode' => '4'
            )));

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

    // php job.php -j checkPayment -m wmt

    public function wmt() {

        $old_demand = time() - 0.5 * 3600;
        $date_start = date('Ymd H:i:s',$old_demand - 3600);
        $date_end = date('Ymd H:i:s',time() + 3600);
        $data_operations = array();
        $demands = dataBase::DBexchange()->select('demand','did,ex_output,ex_input,out_val,in_val,purse_in,purse_payment','where status="n" and ex_output in ("WMZ","WMR","WME","WMG","WMY","WMU","WMB") and add_date > '.$old_demand);

        if(!empty($demands)) {

            foreach($demands as $demand) {

                if(!isset($data_operations[$demand['ex_output']])) {

                    $data_operations[$demand['ex_output']] = Extension::Payments()->Webmoney()->x3(array(
                        'purse_type' => $demand['ex_output'],
                        'start_date' => $date_start,
                        'end_date' => $date_end,
                    ),'primary_wmid');

                }

                foreach($data_operations[$demand['ex_output']]->operations->operation as $operation) {

                    if(strpos($operation->desc,$demand['did']) !== false && $operation->amount >= $demand['out_val'] && $operation->opertype == '0') {

                        dataBase::DBexchange()->query('balance',"update balance set balance=balance+".$demand['out_val']." where name='".$demand['ex_output']."'");
                        dataBase::DBexchange()->update('demand',array(
                            'status' => 'yn',
                            'purse_out' => $operation->pursesrc,
                        ),'where did='.$demand['did']);

                    }
                }
            }
        }
    }

    public function executeTransactiontoEasypay() {

        $demands = dataBase::DBexchange()->select('demand','did,ex_output,ex_input,out_val,in_val,purse_in,purse_payment','where status="yn" and ex_input="EasyPay"');

        $PP = (array)Extension::Payments()->getParam('payments');
        $comission = $PP['com_EasyPay'];

        if(!empty($demands)) {

            foreach($demands as $demand) {

                $amount_output = $demand['in_val'] + $demand['in_val'] * $comission / 100;
                $purse = Model::Acount_easypay()->getPurseOutput($amount_output);

                if($purse) {
                    echo 'purse '.$purse;
                    $str_result = Extension::Payments()->EasyPay()->getApi('Translate',array(
                        'login' 	=> $purse,
                        'purse_in' 	=> $demand['purse_in'],
                        'in_val' 	=> trim(number_format($demand['in_val'], 0, '.', ' ')),
                        'did' 		=> $demand['did'],
                    ));
                    vsLog::add($str_result,'return_easypay');
                    if($str_result == 'ERROR_EXCESS_S') {
                        dataBase::DBexchange()->update('acount_easypay',array('output'=>$PP['easypay']['limits']['EP_mouth'],'st_output'=>0),'where acount='.$purse);
                        self::toEasyPay($ar);
                    } else {
                        $res = Extension::Payments()->EasyPay()->parseResEasypay($str_result);
                        dataBase::DBexchange()->update('demand',array('status'=>$res['status'],'coment'=>$res['message'],'purse_payment'=>$purse),"where did=".$ar['did']);

                        if($res['status'] == 'y') {
                            Model::Acount_easypay()->updateAcountRemoval($purse,$ar['in_val'],$amount_output);
                        }
                    }

                }

                d($str_result);
                exit;
            }

        }



    }

}