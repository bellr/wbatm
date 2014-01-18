<?

define('PROJECT','ATM');
define('PROJECT_ROOT',dirname(__FILE__));
define('VS_DEBUG',true);

require_once(dirname(PROJECT_ROOT)."/core/vs.php");

$P = inputData::init();
if(isset($P->process)) {
    Vitalis::tmpl()->load_tmpl_block($P->process,array(),'process');
}
elseif(isset($P->gcontrol)) {
    Vitalis::gController($P->gcontrol);
}
else {
    echo Vitalis::tmpl()->get_page();

}
