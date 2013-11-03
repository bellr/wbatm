<?
class wm_example extends Template {

    function __construct($action_method,$vars) {
        $this->vars = $vars;
        $this->$action_method();
    }


	
	
    private function block() {
		$P = inputData::init();

		foreach(Config::$wmBase['all_wmid'] as $k=>$ar) {
			$html .= '<option value="'.$k.'">'.$ar.'</option>';
		}
		$vars['interface'] = parent::iterate_tmpl('webmoney',__CLASS__,$P->interface,array(
		'start_date'=>date('Ymd H:i:s',time()),
		'end_date'=>date('Ymd H:i:s',time()),
		'option'=>$html,
		'interface'=>$P->interface));
		echo date('Ymd H:i:s', strtotime('+2 hour'));
        return $this->vars = $vars;
    }
	
	
	
	
	private function process() {
		$P = inputData::init();

		$name_interface = $P->interface;

		switch ($P->interface) {
		case 'x9':
			$res = eWebmoney::x9(null,$P->type_wmid);
			//$res = Extension::Webmoney()->x9(null,$P->type_wmid);
			foreach($res->purses->purse as $r) {
				echo $r->pursename.' - '.$r->amount.' '.$r->desc.'<br>';
			}

		break;
		case 'x1':
			$res = eWebmoney::x1((array)$P,$P->type_wmid);
			d($res);
		break;
		case 'x2':
			$res = eWebmoney::x2((array)$P,$P->type_wmid);
			if($res->retval == 0) {
				echo "Перевод выполнен успешно";
			} else {
				echo 'Ошибка №'.$res->retval.' описание '.$res->retdesc;
			}
			d($res);

		break;
		case 'x3':
			$res = eWebmoney::x3((array)$P,$P->type_wmid);
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
			}
			
			echo '</table>';
			
		break;
		case 'x4':
		$r = eWebmoney::x4((array)$P);
		d($r);
		break;
		}; 
		

	}
}

?>