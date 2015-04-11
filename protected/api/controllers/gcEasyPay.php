<?
class gcEasyPay {

    /**
     * global call https://atm.wm-rb.net/api/EasyPay/webMoneyMerchant/
     * local call Vitalis::Controller('EasyPay','webMoneyMerchant',array(),'gc');
     * @params $P->login
     * @params $P->mode
     */

    public function getHistory($P) {

        echo Extension::Payments()->EasyPay()->connect_history_easypay($P->login,$P->mode);

    }

    public function Translate($P) {

        echo Extension::Payments()->EasyPay()->direct_translation($P->login,$P->purse_in,trim(sprintf("%8.0f ",$P->in_val)),$P->did);

    }
}