<?
class return_pay extends Template {

    function __construct($action_method,$vars) {
        $this->vars = $vars;
        $this->$action_method();
    }


	
	
    private function block() {
		$P = inputData::init();
		foreach(Config::$wmBase['all_wmid'] as $ar) {
			$html .= '<option>'.$ar.'</option>';
		}
		$vars['interface'] = parent::iterate_tmpl('webmoney',__CLASS__,$P->interface,array('option'=>$html,'interface'=>$P->interface));
	
        return $this->vars = $vars;
    }
	
	
	
	
	private function process() {
		$P = inputData::init();

		if($P->comission == 1) {
			$get_com = dataBase::DBexchange()->select('balance','com_seti','where name="'.$P->purse_type.'"');
			$amount = $P->amount - $P->amount * $get_com[0]['com_seti'];
		} else {
			$amount = $P->amount;
		}

			$desc_pay = "Возврат по заявке №".$P->did;
			$direct = explode('_',$P->direct);
			$direct = $direct[1].'_'.$direct[0];
			$r = eWebmoney::x2(array('id_pay'=>$P->id_pay,'purse_in'=>$P->p_output,'purse_type'=>$P->purse_type,'amount'=>$amount,'desc'=>$desc_pay,'direct'=>$direct));

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