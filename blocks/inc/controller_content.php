<?
class controller_content extends Template {
    function __construct($action_method,$vars) {
        $this->$action_method();
    }

    private function block() {
		$P = inputData::init();
		//$P->getAllParams();
        $this->vars['content'] = Vitalis::tmpl()->load_tmpl_block($P->block,(array)$P);

        return $this->vars;
    }
	


}

?>