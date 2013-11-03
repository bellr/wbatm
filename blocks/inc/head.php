<?
class head extends Template {
    function __construct($action_method,$vars='') {
        $this->$action_method();
    }

    private function block() {

        $this->vars['dinamic_hesh'] = Config::$staticSetting['dinamic_hesh'];

        return $this->vars;
    }
}

?>