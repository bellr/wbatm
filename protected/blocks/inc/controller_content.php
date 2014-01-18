<?
class controller_content extends Template {

    public function block($P) {

        $this->vars['content'] = Vitalis::tmpl()->load_tmpl_block($P->block,(array)$P);

        return $this;
    }
	


}

?>