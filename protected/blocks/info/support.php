<?
class support extends Template {

    public function block($P) {

		if(isset($P->status)) {

            $support = dataBase::DBadmin()->select('support',
                '*',
                "where status=".$P->status." and owner_id=0",'order by add_date desc','limit 30'
            );
            if(!empty($support)) {
                foreach($support as $sw) {
                    $sw['date'] = date('d.m.Y в H:i',$sw['add_date']);
                    $sw['who'] = $sw['author'] == 0 ? '-user' : '-support';
                    $sw['i'] = $sw['author'] == 0 ? $P->vars['L_here_mail'] : $P->vars['L_answer_mail'];
                    $sw['word'] = $sw['author'] == 0 ? $P->vars['L_send_in'] : $P->vars['L_send_from'];
                    $sw['link'] = $this->iterate_tmpl('info',__CLASS__,'link',array('id'=>$sw['id'],'email'=>$sw['email']));
                    $this->vars['html'] .= $this->iterate_tmpl('info',__CLASS__,'iterate',$sw);
                }
            }

		} else {

			$support = dataBase::DBadmin()->select('support',
				'*',
				"where id=".$P->id." or owner_id=0".$P->id,
                'order by add_date desc'
			);
            $this->vars['action'] = 'update_message';

			foreach($support as $sw) {
				$sw['date'] = date('d.m.Y в H:i',$sw['add_date']);
				$sw['who'] = $sw['author'] == 0 ? '-user' : '-support';
				$sw['i'] = $sw['author'] == 0 ? $P->vars['L_here_mail'] : $P->vars['L_answer_mail'];
				$sw['word'] = $sw['author'] == 0 ? $P->vars['L_send_in'] : $P->vars['L_send_from'];
				$this->vars['html'] .= $this->iterate_tmpl('info',__CLASS__,'iterate',$sw);
			}
			$this->vars['owner_id'] = $support[0]['id'];
			$this->vars['email'] = $support[0]['email'];
			$this->vars['indeficator'] = $support[0]['indeficator'];
		
			$this->vars['form'] = $this->iterate_tmpl('info',__CLASS__,'form',$this->vars);
		}


        

        return $this;
    }

    public function process($P) {
        $status = 0;

        switch ($P->action) {
            case 'update_message';
                //sValidate::isInt($P->owner_id);
                //sValidate::BodyMess($P->message);

                if(!sValidate::$code) {
					dataBase::DBadmin()->update('support',array('status'=>1),'where id='.$P->owner_id);
                    dataBase::DBadmin()->insert('support',array('message'=>$P->message,'add_date'=>time(),'owner_id'=>$P->owner_id,'author'=>1));

                    $message = 'Сообщение отправлено';

                    $mail = mailSender::init();
                    $mail->to = $P->email;
                    $mail->subject = '[WM-RB.net] Ответ на запрос '.$P->indeficator;
                    $mail->message = $this->iterate_tmpl('emails',Config::getLang(),'add_message_support',array(
                        'bottom_support' => $this->iterate_tmpl('emails',Config::getLang(),'bottom_support'),
                        'indeficator' => $P->indeficator,
                        'url' => Config::$base['STATIC_URL'].'/support/'.$P->indeficator.'/',
                    ));
                    $mail->smtpmail();

                } else {
                    $status = 1; $message = sValidate::$message;
                }
                break;
            case 'close';
				dataBase::DBadmin()->update('support',array('status'=>1),'where id='.$P->owner_id);
				$message = 'Тикет закрыт';
				
            break;
        }

//Browser::goReferer();

        echo json_encode(array('status'=>$status,'message'=>$message));
    }
}

?>