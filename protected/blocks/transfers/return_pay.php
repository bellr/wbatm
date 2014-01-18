<?
class return_pay extends Template {

    public function block($P) {

        $PP = Extension::Payments()->getParam('payments','webmoney');

		foreach($PP->all_wmid as $ar) {
			$html .= '<option>'.$ar.'</option>';
		}
        $this->vars['interface'] = parent::iterate_tmpl('webmoney',__CLASS__,$P->interface,array('option'=>$html,'interface'=>$P->interface));
	
        return $this;
    }

	public function process($P) {

		if($P->comission == 1) {
			$get_com = dataBase::DBexchange()->select('balance','com_seti','where name="'.$P->purse_type.'"');
			$amount = $P->amount - $P->amount * $get_com[0]['com_seti'];
		} else {
			$amount = $P->amount;
		}

			$desc_pay = "Возврат по заявке №".$P->did;
			$direct = explode('_',$P->direct);
			$direct = $direct[1].'_'.$direct[0];
			$r = Extension::Payments()->Webmoney()->x2(array('id_pay'=>$P->id_pay,'purse_in'=>$P->p_output,'purse_type'=>$P->purse_type,'amount'=>$amount,'desc'=>$desc_pay,'direct'=>$direct));

		if($r->retval == 0) {
			dataBase::DBexchange()->update('demand',array('status'=>'n'),"where did=".$P->did);
		} else {
			d($r);
			exit('Ошибка возврата');
		}

		header("Location: ".$_SERVER['HTTP_REFERER']);
	}
}

?>