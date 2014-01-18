<?
class wm_example extends Template {

    public function block($P) {

        $PP = Extension::Payments()->getParam('payments','webmoney');

		foreach($PP->all_wmid as $k=>$ar) {
			$html .= '<option value="'.$k.'">'.$ar.'</option>';
		}

		$this->vars['interface'] = $this->iterate_tmpl('webmoney',__CLASS__,$P->interface,array(
            'start_date'=>date('Ymd H:i:s',time()),
            'end_date'=>date('Ymd H:i:s',time()),
            'option'=>$html,
            'interface'=>$P->interface
        ));

		echo date('Ymd H:i:s', strtotime('+2 hour'));

        return $this;
    }

	public function process($P) {

		switch ($P->interface) {
		case 'x9':
			$res = Extension::Payments()->Webmoney()->x9(null,$P->type_wmid);
			//$res = Extension::Webmoney()->x9(null,$P->type_wmid);
			foreach($res->purses->purse as $r) {
				echo $r->pursename.' - '.$r->amount.' '.$r->desc.'<br>';
			}

		break;
		case 'x1':
			$res = Extension::Payments()->Webmoney()->x1((array)$P,$P->type_wmid);
			d($res);
		break;
		case 'x2':
			$res = Extension::Payments()->Webmoney()->x2((array)$P,$P->type_wmid);
			if($res->retval == 0) {
				echo "Перевод выполнен успешно";
			} else {
				echo 'Ошибка №'.$res->retval.' описание '.$res->retdesc;
			}
			d($res);

		break;
		case 'x3':
			$res = Extension::Payments()->Webmoney()->x3((array)$P,$P->type_wmid);
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
		$r = Extension::Payments()->Webmoney()->x4((array)$P);
		d($r);
		break;
		}; 
		

	}
}

?>