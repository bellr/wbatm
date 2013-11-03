<?php

require("const.inc.aspx");
require("dbsql.inc.aspx");
function edit_balance($parm) {
$parm = trim(sprintf("%8.0f ",$parm));
$invers_balance = '';
$balance = '';
	$string_len = strlen($parm);
	$c=0;
	for($i=$string_len;$i>=0;$i--) {
		$invers_balance .= $parm[$i];
		if($c == 3) $invers_balance .= " ";
		if($c == 6) $invers_balance .= " ";
		$c++;
	}
	$string_len = strlen($invers_balance);
	for($i=$string_len;$i>=0;$i--) {
		$balance .= $invers_balance[$i];
	}
return $balance;
}
Class CustomSQL extends DBSQL
{
   // the constructor
   function CustomSQL($DBName = "")
   {
      $this->DBSQL($DBName);
   }

//��������� �������
   function addnews($title,$contents,$data)
   {
      $sql = "insert into news (title,contents,data) values ('$title','$contents','$data')";
      $result = $this->insert($sql);
      return $result;
   }
//������� ���� �������� �� ������
   function sel_partner($email)
   {
	$sql = "select * from partner where email='$email'";
	$result = $this->select($sql);
	return $result;
   }
//������� ���� �������� �� ������������
   function sel_partner_id($id)
   {
	$sql = "select * from partner where id='$id'";
	$result = $this->select($sql);
	return $result;
   }
//���������� ����
function update_partner($email,$username,$host,$balance,$percent,$st)
   {
      $sql = "update partner set username='$username', host='$host', balance='$balance', percent='$percent', status='$st' where email='$email'";
      $results = $this->update($sql);
      return $results;
   }
//������� ���� �� ��������
   function selall_partner($page,$record,$sort)
   {
	$start = $page*$record;
	$sql = "select id,email,host,balance,summa_bal,refer,count_oper,summ_oper,status from partner order by $sort DESC LIMIT $start,$record";
	$result = $this->select($sql);
	return $result;
   }
//������� ���� �� ��������
   function selall_partner_sort($page,$record,$sort)
   {
	$start = $page*$record;
	$sql = "select id,email,host,balance,summa_bal,refer,count_oper,summ_oper,status from partner where status='1' order by $sort DESC LIMIT $start,$record";
	$result = $this->select($sql);
	return $result;
   }
//������� ���������� �������������-���������
function count_partner()
{
    $sql = "select count(id) as stotal from partner";
	$result = $this->select($sql);
	return $result;
}
//�������� ��������
   function del_partner($email)
   {
      $sql = "DELETE FROM partner where email='$email'";
      $result = $this->delete($sql);
      return $result;
   }
//���� �� shop
   function sel_shop($name_shop)
   {
	$sql = "select refresh_url from terminal where name_shop='$name_shop'";
	$result = $this->select($sql);
	return $result;
   }
//������� ���������� ������������ ������(�������)
function count_cheque_n($st)
{
    $sql = "select count(did) as stotal from auto_pay where  status='$st' and (oplata='RBK Money' or oplata='YaDengi')";
	$result = $this->select($sql);
	return $result;
}
//������� ���������� ������������ ������(�������)
function count_cheque($st)
{
    $sql = "select count(did) as stotal from auto_pay where  status='$st'";
	$result = $this->select($sql);
	return $result;
}
//����� ������������ ������(�������)
   function unachieved_cheque($page,$record,$status)
   {
	  $start = $page*$record;
      $sql = "select * from auto_pay where status='$status' order by data ASC LIMIT $start,$record";
      $result = $this->select($sql);
      return $result;
   }
//����� ������������ ������(�������)
   function unachieved_cheque_n($page,$record,$status)
   {
	  $start = $page*$record;
      $sql = "select * from auto_pay where status='$status' and (output='RBK Money' or output='YaDengi') order by data ASC LIMIT $start,$record";
      $result = $this->select($sql);
      return $result;
   }
   //����� ��. �������
   function check_email($email)
   {
      $sql = "select id from email_base where email='$email'";
      $result = $this->select($sql);
      return $result;
   }
   //���������� ��. ������
   function add_email($email)
   {
      $sql = "insert into email_base (email) values ('$email')";
      $this->insert($sql);
   }
   //����� ��. �������
   function sel_email()
   {
      $sql = "select id,email from email_base where status='0' order by id asc";
      $result = $this->select($sql);
      return $result;
   }
   //������� ��. ������� �� ������
   function update_st_email($id)
   {
      $sql = "update email_base set status='1' where id='$id'";
      $this->update($sql);
   }
   //���������� ������
   function add_discount($indef,$amount,$size_d)
   {
      $sql = "insert into discount (indef,amount,size_d) values ('$indef','$amount','$size_d')";
      $this->insert($sql);
   }
//������� ������������ ������
   function sel_discount()
   {
      $sql = "select * from discount order by indef asc";
      $result = $this->select($sql);
      return $result;
   }
   //��������� � �������
   function edit_discount($id,$amount,$size_d,$status)
   {
      $sql = "update discount set amount='$amount',size_d='$size_d',status='$status' where id='$id'";
      $this->update($sql);
   }
//�������� ������
   function del_discount($id)
   {
      $sql = "DELETE FROM discount where id='$id'";
      $result = $this->delete($sql);
      return $result;
   }
}

//����� ��� ������ � ����� EXCHENGE
Class CustomSQL_exchange extends DBSQL_exchange
{
   // the constructor
   function CustomSQL_exchange($DBName_exchange = "")
   {
      $this->DBSQL_exchange($DBName_exchange);
   }
   //������� ��. ������� �� ������
   function sel_email()
   {
      $sql = "select email from demand";
      $result = $this->select($sql);
      return $result;
   }
   //����� ������ ����� ��� ������������� ������ �����
   function EP_purse_out_service($s_output)
   {
      $sql = "select acount from acount_easypay where st_output='0' and balance>='$s_output' order by id ASC LIMIT 1";
      $result = $this->select($sql);
      return $result;
   }
//����� ������ �������� ��������� ������
   function sel_purse_out($output)
   {
      $sql = "select purse from balance where name ='$output'";
      $results = $this->select($sql);
      return $results;
   }
//���� �������� �/�
   function exch_bal_sel()
   {
	$sql = "select id,name,balance,st_exch,st_pay,st_cash,st_out_nal,st_eshop,purse from balance order by id ASC";
	$result = $this->select($sql);
	return $result;
   }
function exch_bal_edit($id,$balance,$st_exch,$st_pay,$st_cash,$st_out_nal,$st_eshop,$purse)
   {
      $sql = "update balance set balance='$balance',st_exch='$st_exch',st_pay='$st_pay',st_cash='$st_cash',st_out_nal='$st_out_nal',st_eshop='$st_eshop',purse='$purse' where id='$id'";
      $results = $this->update($sql);
      return $results;
   }
//���� �������� � ������� EasyPay
   function bal_ep()
   {
	$sql = "select * from acount_easypay order by id ASC";
	$result = $this->select($sql);
	return $result;
   }
function bal_edit_ep($id,$balance,$input,$output,$st_input,$st_output,$status)
   {
      $sql = "update acount_easypay set balance='$balance',input='$input',st_input='$st_input',output='$output',st_output='$st_output',status='$status' where id='$id'";
      $results = $this->update($sql);
      return $results;
   }
   /*
//����� ������ �������� �� ������ �� ������� ����� ������������� ������
   function epay_from_dem($did)
   {
	$sql = "select purse_payment from demand where did='$did'";
	$result = $this->select($sql);
	return $result;
   }
   */
//�������������� ���� �� ������
function exch_kurs_edit($id,$konvers,$commission,$direct,$upd,$status)
   {
      $sql = "update kurs set konvers='$konvers', commission='$commission', direct='$direct', upd='$upd', status='$status' where id='$id'";
      $results = $this->update($sql);
      return $results;
   }
   //����� ������ �����
   function kurs_sel($main)
   {
	$sql = "select id,direction,konvers,commission,indefined,direct,upd,status,edit_date from kurs where main='$main' order by id ASC";
	$result = $this->select($sql);
	return $result;
   }
//����� ������������ ������ �� ����� �/�
   function unachieved_demand($page,$record,$status)
   {
	  $start = $page*$record;
      $sql = "select did,ex_output,ex_input,purse_out,purse_in,out_val,in_val,data,time from demand where status='$status' order by data ASC LIMIT $start,$record";
      $result = $this->select($sql);
      return $result;
   }
//����� ������ � ������� �� ����� �/�
   function sel_exchange_demand($did)
   {
      $sql = "select * from demand where did='$did'";
      $result = $this->select($sql);
      return $result;
   }
//����� ������������ ������������ ������ �� ����� �/�
   function unachieved_demand_n($page,$record,$status)
   {
	  $start = $page*$record;
      $sql = "select did,ex_output,ex_input,purse_out,purse_in,out_val,in_val,data,time from demand where status='$status' and (ex_output='RBK Money' or ex_output='EasyPay' or ex_output='YaDengi')  order by data ASC LIMIT $start,$record";
      $result = $this->select($sql);
      return $result;
   }
//����� ���������� ������������ ������������ ������ �� �����
function count_exch_dem_n($st)
{
    $sql = "select count(did) as stotal from demand where (ex_output='RBK Money' or ex_output='EasyPay' or ex_output='YaDengi') and status='$st'";
	$result = $this->select($sql);
	return $result;
}
//������� ���������� ������������ ������ �� �����
function count_exch_dem($st)
{
    $sql = "select count(did) as stotal from demand where status='$st'";
	$result = $this->select($sql);
	return $result;
}
//����� ������� ������
	function demand_edit($status,$did)
	{
	$sql = "update demand set status='$status' where did='$did'";
	$results = $this->update($sql);
	return $results;
	}
//�������� ������
   function del_dem($did)
   {
      $sql = "DELETE FROM demand where did='$did'";
      $result = $this->delete($sql);
      return $result;
   }
//����� ������ ��������
   function sel_dem_part($id)
   {
	$sql = "select did,ex_output,ex_input,out_val,in_val,data,time from demand where partner_id='$id' and status='y' order by data desc";
	$result = $this->select($sql);
	return $result;
   }
//������� �������� ����� �� ����������� ������
   function baserate($direct)
   {
	$sql = "select rate,procentbankrate from baserate where direct='$direct'";
	$result = $this->select($sql);
	return $result;
   }
//��������������
	function edit_kurs($konvers,$id)
	{
	$sql = "update kurs set konvers='$konvers' where id='$id'";
	$this->update($sql);
	}
//����� ������ � ������� �� ����� �/� ����������
   function stat_exch_dem($data_n,$data_k)
   {
      $sql = "select did,ex_output,ex_input,out_val,in_val,data,time,status,partner_id from demand where data >= '$data_n' and data <= '$data_k' order by data asc, time asc";
      $result = $this->select($sql);
      return $result;
   }
//����� ����� �� ���� ������ �� WM
   function sel_wmrate($direct)
   {
	$sql = "select rate from wmrate where direction='$direct'";
	$result = $this->select($sql);
	return $result;
   }
}



//����� ��� ������ � ����� ADMIN
Class CustomSQL_admin extends DBSQL_admin
{

   // the constructor
   function CustomSQL_admin($DBName_admin = "")
   {
      $this->DBSQL_admin($DBName_admin);
   }

   //������� ���������� ������ �� �����
   function count_out()
   {
    $sql = "select count(did) as stotal from out_log";
	$result = $this->select($sql);
	return $result;
   }
//����� ������������� ���������
   function support_mess($st)
   {
	$sql = "select id,email,message,date,time from support where status='$st' order by id DESC LIMIT 20";
	$result = $this->select($sql);
	return $result;
   }
//����� �� ������������� ���������
   function get_info_mess($id,$st)
   {
	$sql = "select id,ip,email,message from support where id='$id' and status='$st' order by id";
	$result = $this->select($sql);
	return $result;
   }
//�������� ����������� ���������
   function support_del($id)
   {
      $sql = "DELETE FROM support where id='$id'";
      $result = $this->delete($sql);
      return $result;
   }
//������� ���������� ������������� ���������
function support_count()
{
    $sql = "select count(id) as stotal from support where status='n'";
	$result = $this->select($sql);
	return $result;
}
//���������� ���� � �������� � WM
   function add_stat_fin($did)
   {
      $sql = "insert into demand (did) values ('$did')";
      $result = $this->insert($sql);
      return $result;
   }
//����� ID ��� ��������
function stat_fin_id($did)
{
	$sql = "select id from stat_out where did='$did'";
	$result = $this->select($sql);
	return $result;
}
//�������� ������������ �������� �� �������� N
 function del_idpay($did)
   {
      $sql = "delete from id_payment where did='$did'";
      $result = $this->insert($sql);
   }
//����� IP �������
   function sel_ip($did)
   {
      $sql = "select id_pay,addr_remote,proxy from id_payment where did='$did'";
      $result = $this->select($sql);
      return $result;
   }
}



//����� ��� ������ � ����� PAY-DESK
Class CustomSQL_pay_desk extends DBSQL_pay_desk
{

   // the constructor
   function CustomSQL_pay_desk($DBName_pay_desk = "")
   {
      $this->DBSQL_pay_desk($DBName_pay_desk);
   }
   function selpas()
   {
    $sql = "SELECT @password:='dbnfkbq1986'";
	$result = $this->select($sql);
	return $result;
   }
//������� ���� �� ��������
   function show_goods($id_goods,$page,$record,$st)
   {
	$p = $this->selpas();
	$start = $page*$record;
	$sql = "select id,AES_DECRYPT(info_goods,'$p[0][0]') from goods where id_goods='$id_goods' and status='$st' order by id DESC LIMIT $start,$record";
	$result = $this->select($sql);
	return $result;
   }
//������� ���������� �������
function count_goods($id_goods,$st)
{
    $sql = "select count(id) as stotal from goods where id_goods='$id_goods' and status='$st'";
	$result = $this->select($sql);
	return $result;
}
//�������� ������
   function del_goods($id)
   {
      $sql = "DELETE FROM goods where id='$id'";
      $this->delete($sql);
   }
//���������� ���������� ����(��� �������� ������)
function update_count_goods($id_goods)
   {
      $sql = "update info_goods set count=count-1 where id='$id_goods'";
		$this->update($sql);
   }
//������� ���������� ��������
function count_eshop_dem($st)
{
    $sql = "select count(did) as stotal from demand_eshop where status='$st'";
	$result = $this->select($sql);
	return $result;
}
//������� ���������� �� ������ �����
function count_pay_dem($st)
{
    $sql = "select count(did) as stotal from demand_uslugi where status='$st'";
	$result = $this->select($sql);
	return $result;
}

//������� ���������� ������������ ������������ �� ������ �����
function count_pay_dem_n($st)
{
    $sql = "select count(did) as stotal from demand_uslugi where status='$st' and (output='RBK Money' or output='EasyPay' or output='YaDengi')";
	$result = $this->select($sql);
	return $result;
}
//������� ���������� ������������ ������������ ������ ��������
function count_eshop_dem_n($st)
{
    $sql = "select count(did) as stotal from demand_eshop where status='$st' and (output='RBK Money' or output='EasyPay' or output='YaDengi')";
	$result = $this->select($sql);
	return $result;
}
//����� ������ �� ������ ������ �����
   function sel_pay_demand($did)
   {
      $sql = "select output,name_uslugi,purse_out,out_val,email,in_val,pole1,pole2,data,time,status,coment,purse_payment from demand_uslugi where did='$did'";
      $result = $this->select($sql);
      return $result;
   }
//���������� ���������� � ��������� ������
	function goods_info($id)
   {
	$sql = "select name_card from info_goods where id='$id'";
	$result = $this->select($sql);
	return $result;
   }
//����� ������ �� ������ ��������
   function sel_eshop_demand($did)
   {
      $sql = "select did,output,id_goods,amount,email,data,time,status,coment,purse_payment from demand_eshop where did='$did'";
      $result = $this->select($sql);
      return $result;
   }
//����� ������������ ������
   function unachieved_demand($page,$record,$status)
   {
	  $start = $page*$record;
      $sql = "select did,output,name_uslugi,out_val,in_val,data,time from demand_uslugi where status='$status' order by data ASC LIMIT $start,$record";
      $result = $this->select($sql);
      return $result;
   }
//����� ������������ ������������ ������
   function unachieved_demand_n($page,$record,$status)
   {
	  $start = $page*$record;
      $sql = "select did,output,name_uslugi,out_val,in_val,data,time from demand_uslugi where status='$status' and (output='RBK Money' or output='EasyPay' or output='YaDengi') order by data ASC LIMIT $start,$record";
      $result = $this->select($sql);
      return $result;
   }
//����� ���� �� ������������� ������� ��������
   function unachieved_demand_eshop($page,$record,$status)
   {
	  $start = $page*$record;
      $sql = "select did,output,id_goods,amount,data,time from demand_eshop where status='$status' order by data ASC LIMIT $start,$record";
      $result = $this->select($sql);
      return $result;
   }
//����� ���� ��������������� ������������ ������� ��������
   function unachieved_demand_n_eshop($page,$record,$status)
   {
	  $start = $page*$record;
      $sql = "select did,output,id_goods,amount,data,time from demand_eshop where status='$status' and (output='RBK Money' or output='EasyPay' or output='YaDengi') order by data ASC LIMIT $start,$record";
      $result = $this->select($sql);
      return $result;
   }
//������� ���������� ������������ ������(���������� �����)
function count_cash_dem($st)
{
    $sql = "select count(did) as stotal from demand_cash where status='$st'";
	$result = $this->select($sql);
	return $result;
}
//������� ���������� ������������ ������(����� �� �����)
function count_cash_dem_out($st)
{
    $sql = "select count(did) as stotal from demand_nal_out where  status='$st'";
	$result = $this->select($sql);
	return $result;
}
//������� ���������� ������������ ������(����� �� �����)
function count_cash_dem_out_n($st)
{
    $sql = "select count(did) as stotal from demand_nal_out where  status='$st' and (output='RBK Money' or output='EasyPay' or output='YaDengi')";
	$result = $this->select($sql);
	return $result;
}
//����� ������������ ������(���������� �����)
   function unachieved_demand_cash($page,$record,$status)
   {
	  $start = $page*$record;
      $sql = "select did,output,input,in_val,out_val,data,time from demand_cash where status='$status' order by data ASC LIMIT $start,$record";
      $result = $this->select($sql);
      return $result;
   }
//����� ������������ ������(����� �� �����)
   function unachieved_demand_cash_out($page,$record,$status)
   {
	  $start = $page*$record;
      $sql = "select did,output,in_val,out_val,name_card,data,time from demand_nal_out where status='$status' order by data ASC LIMIT $start,$record";
      $result = $this->select($sql);
      return $result;
   }
//����� ������������ ������(����� �� �����)
   function unachieved_demand_cash_out_n($page,$record,$status)
   {
	  $start = $page*$record;
      $sql = "select did,output,in_val,out_val,name_card,data,time from demand_nal_out where status='$status' and (output='RBK Money' or output='EasyPay' or output='YaDengi') order by data ASC LIMIT $start,$record";
      $result = $this->select($sql);
      return $result;
   }
//����� ������� ������ � ������ �� ������ �����
	function demand_edit($status,$did)
	{
	$sql = "update demand_uslugi set status='$status' where did='$did'";
	$results = $this->update($sql);
	return $results;
	}
//����� ������� ������ �� �������� ��������
	function demand_edit_eshop($status,$did)
	{
	$sql = "update demand_eshop set status='$status' where did='$did'";
	$results = $this->update($sql);
	return $results;
	}
//����� ������� ������(���������� �����)
	function demand_edit_cash($status,$did)
	{
	$sql = "update demand_cash set status='$status' where did='$did'";
	$results = $this->update($sql);
	return $results;
	}
//����� ������� ������(����� �� �����)
	function demand_edit_cash_out($status,$did)
	{
	$sql = "update demand_nal_out set status='$status' where did='$did'";
	$results = $this->update($sql);
	return $results;
	}
//����� ������ � �������(���������� �����)
   function sel_cash_demand($did)
   {
      $sql = "select output,input,card,period,purse_in,in_val,out_val,email,data,time,status,coment,purse_payment from demand_cash where did='$did'";
      $result = $this->select($sql);
      return $result;
   }
//����� ������ � �������(����� �� �����)
   function sel_cash_out_dem($did)
   {
      $sql = "select output,card,period,in_val,out_val,purse_out,name_card,email,data,time,status,coment,wmid,user_surname,user_name,name_bank,purse_payment from demand_nal_out where did='$did'";
      $result = $this->select($sql);
      return $result;
   }
   //����� �������
   function info_pay($name_cat)
   {
	$sql = "select * from uslugi where name_cat='$name_cat' order by id ASC";
	$result = $this->select($sql);
	return $result;
   }
//�������������� ���� �� ��������
function edit_pay($id,$commission,$bankpay,$status)
   {
      $sql = "update uslugi set commission='$commission', bankpay='$bankpay', status='$status' where id='$id'";
      $results = $this->update($sql);
   }
//���������� ������� �� �������
   function add_pay($name_cat,$desc_uslugi,$name,$desc_val,$bankpay)
   {
      $sql = "insert into uslugi (name_cat,desc_uslugi,name,desc_val,bankpay) values ('$name_cat','$desc_uslugi','$name','$desc_val','$bankpay')";
      $result = $this->insert($sql);
      return $result;
   }
//�������� ������(������)
   function del_dem($did)
   {
      $sql = "DELETE FROM demand_uslugi where did='$did'";
      $result = $this->delete($sql);
      return $result;
   }
//�������� ������(�������)
   function del_dem_shop($did)
   {
      $sql = "DELETE FROM demand_eshop where did='$did'";
      $result = $this->delete($sql);
      return $result;
   }
//�������� ������(���������� �����)
   function del_dem_nal($did)
   {
      $sql = "DELETE FROM demand_cash where did='$did'";
      $result = $this->delete($sql);
      return $result;
   }
//�������� ������(����� �� �����)
   function del_dem_nal_out($did)
   {
      $sql = "DELETE FROM demand_nal_out where did='$did'";
      $result = $this->delete($sql);
      return $result;
   }
//����� ������ �������� �� ��������
   function sel_dempay_part($id)
   {
	$sql = "select did,output,name_uslugi,out_val,in_val,data,time from demand_uslugi where partner_id='$id' and status='y' order by data desc";
	$result = $this->select($sql);
	return $result;
   }
//����� ������ �������� �� ����������
   function sel_demcash_part($id)
   {
	$sql = "select did,output,in_val,out_val,data,time from demand_cash where partner_id='$id' and status='y' order by data desc";
	$result = $this->select($sql);
	return $result;
   }
//���� �������� ����
   function card_bal_sel()
   {
	$sql = "select id,desc_val,balance,status,bonus from name_card order by id ASC";
	$result = $this->select($sql);
	return $result;
   }
//�������������� ������ � ������
function card_bal_edit($id,$balance,$status,$bonus)
   {
      $sql = "update name_card set balance='$balance',status='$status',bonus='$bonus' where id='$id'";
      $results = $this->update($sql);
      return $results;
   }
//���� �������� �������
   function goods_bal_sel()
   {
	$sql = "select * from reserv_goods order by id ASC";
	$result = $this->select($sql);
	return $result;
   }
//�������������� ������ � �������
function goods_bal_edit($id,$balance,$status)
   {
      $sql = "update reserv_goods set balance='$balance',status='$status' where id='$id'";
      $results = $this->update($sql);
      return $results;
   }
//��� ������ ���������� �� ���������(������)
   function stat_pay_dem($data_n,$data_k)
   {
      $sql = "select did,output,name_uslugi,out_val,in_val,data,time,status,partner_id from demand_uslugi where data >= '$data_n' and data <= '$data_k' order by data asc, time asc";
      $result = $this->select($sql);
      return $result;
   }
//��� ������ ���������� �� ���������(������)
   function stat_eshop_dem($data_n,$data_k)
   {
      $sql = "select did,output,id_goods,amount,data,time,status,partner_id from demand_eshop where data >= '$data_n' and data <= '$data_k' order by data asc, time asc";
      $result = $this->select($sql);
      return $result;
   }
//��� ������ ���������� �� ���������(����������)
   function stat_pay_dem_cash($data_n,$data_k)
   {
      $sql = "select did,output,input,out_val,in_val,data,time,status,partner_id from demand_cash where data >= '$data_n' and data <= '$data_k' order by data asc, time asc";
      $result = $this->select($sql);
      return $result;
   }
//��� ������ ���������� �� ���������(�����)
   function stat_pay_dem_cash_out($data_n,$data_k)
   {
      $sql = "select did,output,out_val,in_val,name_card,data,time,status,partner_id from demand_nal_out where data >= '$data_n' and data <= '$data_k' order by data asc, time asc";
      $result = $this->select($sql);
      return $result;
   }
//����� ������ �������������, ������� �������� ����� �� �����
   function list_card($page,$record)
   {
	  $start = $page*$record;
      $sql = "select * from list_card order by id ASC LIMIT $start,$record";
      $result = $this->select($sql);
      return $result;
   }
//������� ���������� �������������, ������� �������� ����� �� �����
function count_list_card()
{
    $sql = "select count(id) as stotal from list_card";
	$result = $this->select($sql);
	return $result;
}
//���������� ������������ � �������
   function add_card($card,$period)
   {
      $sql = "insert into list_card (card,period) values ('$card','$period')";
      $result = $this->insert($sql);
      return $result;
   }
//�������� �����
   function del_card($id)
   {
      $sql = "DELETE FROM list_card where id='$id'";
      $result = $this->delete($sql);
      return $result;
   }
//�������� ������� ����� � ����
   function search_card($number_card,$period)
   {
      $sql = "select id from list_card where card='$number_card' and period='$period'";
      $result = $this->select($sql);
      return $result;
   }
//���������� ������������ � �������
   function add_company($main_cat,$side_cat,$company,$desc_company)
   {
      $sql = "insert into goods_company (main_cat,side_cat,company,desc_company) values ('$main_cat','$side_cat','$company','$desc_company')";
      $this->insert($sql);
   }
//����� ���� ��������
   function sel_company()
   {
      $sql = "select company,desc_company from goods_company";
      $result = $this->select($sql);
      return $result;
   }
//���������� ������ ������ � �������
   function add_goods($name_company,$id_company,$name_goods,$desc,$price,$type_goods)
   {
      $sql = "insert into info_goods (name_company,card,name_card,name_desc,price,type_goods) values ('$name_company','$id_company','$name_goods','$desc','$price','$type_goods')";
      $this->insert($sql);
   }
//���������� ���-����
   function add_goods_text($id_goods,$info_goods)
   {
	  $p = $this->selpas();
      $sql = "insert into goods (id_goods,info_goods) values ('$id_goods',AES_ENCRYPT('$info_goods','$p[0][0]'))";
      $this->insert($sql);
   }

//����� ����� ������� �� �������� ��������
   function sel_goods_company($company)
   {
      $sql = "select id,card,name_card,name_desc,price,count,sale from info_goods where name_company='$company'";
      $result = $this->select($sql);
      return $result;
   }
//���������� ���������� ����
function update_count($id_goods,$c)
   {
      $sql = "update info_goods set count=count+{$c} where id='$id_goods'";
		$this->update($sql);
   }
//����� ������� ������ � ������ �� ������ �����
	function edit_info_goods($name_goods,$name_desc,$price,$id)
	{
	$sql = "update info_goods set name_card='$name_goods',name_desc='$name_desc',price='$price' where id='$id'";
	$results = $this->update($sql);
	return $results;
	}
}
?>