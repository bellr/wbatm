<?php

//cd /var/www/wmrb/data/www/billing87.wm-rb.net/nncron/ && /usr/bin/php -f return_pay.aspx >/dev/null 2>&1


class checkPaymentJob {

    // php job.php -j checkPayment -m easypay
    // cd /var/www/wmrb/data/www/billing87.wm-rb.net/ && /usr/bin/php job.php -j checkPayment -m easypay >/dev/null 2>&1

    public function easypay() {

        $old_demand = time() - 30 * 3600;
        $demands = dataBase::DBexchange()->select('demand','*','where ex_output="EasyPay" and status="n" and add_date > '.$old_demand);

        if(count($demands)) {
vsLog::add($demands);
            $EP_purse = Model::Acount_easypay()->getPurseInput(1,'desc');

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

    // php job.php -j checkPayment -m wmt

    public function wmt() {

        $old_demand = time() - 30 * 3600;
        $date_start = date('Ymd H:i:s',$old_demand);
        $date_end = date('Ymd H:i:s');
        $data_operations = array();
        $demands = dataBase::DBexchange()->select('demand','did,ex_output,ex_input,out_val,in_val,purse_in,purse_payment','where status="n" and ex_output in ("WMZ","WMR","WME","WMG","WMY","WMU","WMB") and add_date > '.$old_demand);

        if(!empty($demands)) {

            foreach($demands as $demand) {

                if(!isset($data_operations[$demand['ex_output']])) {

                    $data_operations[$demand['ex_output']] = Extension::Payments()->Webmoney()->x3(array(
                        'purse_type' => $demand['ex_output'],
                        'start_date' => $date_start,
                        'date_end' => $date_end,
                    ),'primary_wmid');

                }

                foreach($data_operations[$demand['ex_output']] as $operation) {

                    if($operation->operations->operation->desc == $demand['did'] && $operation->operations->operation->amount == $demand['out_val']) {

                        dataBase::DBexchange()->query('balance',"update balance set balance=balance+".$demand['out_val']." where name='".$demand['ex_output']."'");
                        dataBase::DBexchange()->update('demand',array('status'=>'yn'),'where did='.$demand['did']);

                    }

                }

            }

            vsLog::add($data_operations);
        }

    /*    $res = Extension::Payments()->Webmoney()->x3((array)$P,$P->type_wmid);
        echo "<table border=1>
			<tr>
			<td>Id счета</td>
			<td>From</td>
			<td>To</td>
			<td>amount</td>
			<td>Описание</td>
			<td>Дата</td>
			</tr>";
        foreach($res->operations->operation as $r) {
            echo '<tr>
			<td>'.$r->orderid.'</td>
			<td>'.$r->pursesrc.'</td>
			<td>'.$r->pursedest.'</td>
			<td>'.$r->amount.'</td>
			<td>'.$r->desc.'</td>
			<td>'.$r->dateupd.'</td>
			</tr>';
        }*/

    }


}
