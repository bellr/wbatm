<?php

$DBHost = Config::$dbBase['DBmain']['host'];
$DBName = Config::$dbBase['DBmain']['db'];
$DBUser = Config::$dbBase['DBmain']['user'];
$DBPassword = Config::$dbBase['DBmain']['pass'];

$DBName_exchange = Config::$dbBase['DBexchange']['db'];
$DBUser_exchange = Config::$dbBase['DBexchange']['user'];
$DBPassword_exchange = Config::$dbBase['DBexchange']['pass'];

$DBName_admin = Config::$dbBase['DBadmin']['db'];
$DBUser_admin = Config::$dbBase['DBadmin']['user'];
$DBPassword_admin = Config::$dbBase['DBadmin']['pass'];

$DBName_pay_desk = Config::$dbBase['DBpaydesk']['db'];
$DBUser_pay_desk = Config::$dbBase['DBpaydesk']['user'];
$DBPassword_pay_desk = Config::$dbBase['DBpaydesk']['pass'];

//����� ��� ������ � ������� �����
Class DBSQL
{

   function DBSQL($DBName)
   {
      global $DBHost,$DBUser,$DBPassword;
      $conn=mysqli_connect($DBHost,$DBUser,$DBPassword,$DBName);
	  mysqli_query("SET CHARACTER SET CP1251",$conn);
	  $this->CONN = $conn;
      return true;
   }

   function select($sql="")
   {
      if (empty($sql)) return false;
      if (empty($this->CONN)) return false;
      $conn = $this->CONN;
      $results = mysqli_query($conn,$sql);
      if ((!$results) or (empty($results)))
      {
         return false;
      }
      $count = 0;
      $data = array();
      while ($row = mysqli_fetch_array($results)) {
         $data[$count] = $row;
         $count++;
      }
      mysqli_free_result($results);
      return $data;
   }


   function insert($sql="")
   {
      if (empty($sql)) return false;
      if (empty($this->CONN)) return false;

      $conn = $this->CONN;
      $results = mysqli_query($conn,$sql);
      if (!$results) return false;
      $results = mysqli_insert_id($conn);
      return $results;
   }


   function update($sql="")
   {
      if(empty($sql)) return false;
      if(empty($this->CONN)) return false;

      $conn = $this->CONN;
      $result = mysqli_query($conn,$sql);
      return $result;
   }


   function delete($sql="")
   {
      if(empty($sql)) return false;
      if(empty($this->CONN)) return false;

      $conn = $this->CONN;
      $result = mysqli_query($conn,$sql);
      return $result;
   }

   function createtable($sql="")
   {
      if(empty($sql)) return false;
      if(empty($this->CONN)) return false;

      $conn = $this->CONN;
      $result = mysqli_query($conn,$sql);
      return $result;
   }

   function droptable($sql="")
   {
      if(empty($sql)) return false;
      if(empty($this->CONN)) return false;

      $conn = $this->CONN;
      $result = mysqli_query($conn,$sql);
      return $result;
   }

   function createindex($sql="")
   {
      if(empty($sql)) return false;
      if(empty($this->CONN)) return false;

      $conn = $this->CONN;
      $result = mysqli_query($conn,$sql);
      return $result;
   }

   function dropindex($sql="")
   {
      if(empty($sql)) return false;
      if(empty($this->CONN)) return false;

      $conn = $this->CONN;
      $result = mysqli_query($conn,$sql);
      return $result;
   }

}

//����� ��� ������ � ����� EXCHENGE
Class DBSQL_exchange
{

   function DBSQL_exchange($DBName_exchange)
   {
      global $DBHost,$DBUser_exchange,$DBPassword_exchange;
      $conn=mysqli_connect($DBHost,$DBUser_exchange,$DBPassword_exchange,$DBName_exchange);
	  mysqli_query("SET CHARACTER SET CP1251",$conn);
	  $this->CONN = $conn;
      return true;
   }


   function select($sql="")
   {
      if (empty($sql)) return false;
      if (empty($this->CONN)) return false;
      $conn = $this->CONN;
      $results = mysqli_query($conn,$sql);
      if ((!$results) or (empty($results)))
      {
         return false;
      }
      $count = 0;
      $data = array();
      while ($row = mysqli_fetch_array($results)) {
         $data[$count] = $row;
         $count++;
      }
      mysqli_free_result($results);
      return $data;
   }


   function insert($sql="")
   {
      if (empty($sql)) return false;
      if (empty($this->CONN)) return false;

      $conn = $this->CONN;
      $results = mysqli_query($conn,$sql);
      if (!$results) return false;
      $results = mysqli_insert_id();
      return $results;
   }


   function update($sql="")
   {
      if(empty($sql)) return false;
      if(empty($this->CONN)) return false;

      $conn = $this->CONN;
      $result = mysqli_query($conn,$sql);
      return $result;
   }


   function delete($sql="")
   {
      if(empty($sql)) return false;
      if(empty($this->CONN)) return false;

      $conn = $this->CONN;
      $result = mysqli_query($conn,$sql);
      return $result;
   }

   function createtable($sql="")
   {
      if(empty($sql)) return false;
      if(empty($this->CONN)) return false;

      $conn = $this->CONN;
      $result = mysqli_query($conn,$sql);
      return $result;
   }

   function droptable($sql="")
   {
      if(empty($sql)) return false;
      if(empty($this->CONN)) return false;

      $conn = $this->CONN;
      $result = mysqli_query($conn,$sql);
      return $result;
   }

   function createindex($sql="")
   {
      if(empty($sql)) return false;
      if(empty($this->CONN)) return false;

      $conn = $this->CONN;
      $result = mysqli_query($conn,$sql);
      return $result;
   }

   function dropindex($sql="")
   {
      if(empty($sql)) return false;
      if(empty($this->CONN)) return false;

      $conn = $this->CONN;
      $result = mysqli_query($conn,$sql);
      return $result;
   }

}

//����� ��� ������ � ����� ADMIN
Class DBSQL_admin
{

   function DBSQL_admin($DBName_admin)
   {
      global $DBHost,$DBUser_admin,$DBPassword_admin;
      $conn=mysqli_connect($DBHost,$DBUser_admin,$DBPassword_admin,$DBName_admin);
	  mysqli_query("SET CHARACTER SET CP1251",$conn);
	  $this->CONN = $conn;
      return true;
   }

   function select($sql="")
   {
      if (empty($sql)) return false;
      if (empty($this->CONN)) return false;
      $conn = $this->CONN;
      $results = mysqli_query($conn,$sql);
      if ((!$results) or (empty($results)))
      {
         return false;
      }
      $count = 0;
      $data = array();
      while ($row = mysqli_fetch_array($results)) {
         $data[$count] = $row;
         $count++;
      }
      mysqli_free_result($results);
      return $data;
   }


   function insert($sql="")
   {
      if (empty($sql)) return false;
      if (empty($this->CONN)) return false;

      $conn = $this->CONN;
      $results = mysqli_query($conn,$sql);
      if (!$results) return false;
      $results = mysqli_insert_id($conn);
      return $results;
   }


   function update($sql="")
   {
      if(empty($sql)) return false;
      if(empty($this->CONN)) return false;

      $conn = $this->CONN;
      $result = mysqli_query($conn,$sql);
      return $result;
   }


   function delete($sql="")
   {
      if(empty($sql)) return false;
      if(empty($this->CONN)) return false;

      $conn = $this->CONN;
      $result = mysqli_query($conn,$sql);
      return $result;
   }

   function createtable($sql="")
   {
      if(empty($sql)) return false;
      if(empty($this->CONN)) return false;

      $conn = $this->CONN;
      $result = mysqli_query($conn,$sql);
      return $result;
   }

   function droptable($sql="")
   {
      if(empty($sql)) return false;
      if(empty($this->CONN)) return false;

      $conn = $this->CONN;
      $result = mysqli_query($conn,$sql);
      return $result;
   }

   function createindex($sql="")
   {
      if(empty($sql)) return false;
      if(empty($this->CONN)) return false;

      $conn = $this->CONN;
      $result = mysqli_query($conn,$sql);
      return $result;
   }

   function dropindex($sql="")
   {
      if(empty($sql)) return false;
      if(empty($this->CONN)) return false;

      $conn = $this->CONN;
      $result = mysqli_query($conn,$sql);
      return $result;
   }

}
//����� ��� ������ � ����� PAY-DESK
Class DBSQL_pay_desk
{

   function DBSQL_pay_desk($DBName_pay_desk)
   {
      global $DBHost,$DBUser_pay_desk,$DBPassword_pay_desk;
      $conn=mysqli_connect($DBHost,$DBUser_pay_desk,$DBPassword_pay_desk,$DBName_pay_desk);
	  mysqli_query("SET CHARACTER SET CP1251",$conn);
	  $this->CONN = $conn;
      return true;
   }

   function select($sql="")
   {
      if (empty($sql)) return false;
      if (empty($this->CONN)) return false;
      $conn = $this->CONN;
      $results = mysqli_query($conn,$sql);
      if ((!$results) or (empty($results)))
      {
         return false;
      }
      $count = 0;
      $data = array();
      while ($row = mysqli_fetch_array($results)) {
         $data[$count] = $row;
         $count++;
      }
      mysqli_free_result($results);
      return $data;
   }


   function insert($sql="")
   {
      if (empty($sql)) return false;
      if (empty($this->CONN)) return false;

      $conn = $this->CONN;
      $results = mysqli_query($conn,$sql);
      if (!$results) return false;
      $results = mysqli_insert_id($conn);
      return $results;
   }


   function update($sql="")
   {
      if(empty($sql)) return false;
      if(empty($this->CONN)) return false;

      $conn = $this->CONN;
      $result = mysqli_query($conn,$sql);
      return $result;
   }


   function delete($sql="")
   {
      if(empty($sql)) return false;
      if(empty($this->CONN)) return false;

      $conn = $this->CONN;
      $result = mysqli_query($conn,$sql);
      return $result;
   }

   function createtable($sql="")
   {
      if(empty($sql)) return false;
      if(empty($this->CONN)) return false;

      $conn = $this->CONN;
      $result = mysqli_query($conn,$sql);
      return $result;
   }

   function droptable($sql="")
   {
      if(empty($sql)) return false;
      if(empty($this->CONN)) return false;

      $conn = $this->CONN;
      $result = mysqli_query($conn,$sql);
      return $result;
   }

   function createindex($sql="")
   {
      if(empty($sql)) return false;
      if(empty($this->CONN)) return false;

      $conn = $this->CONN;
      $result = mysqli_query($conn,$sql);
      return $result;
   }

   function dropindex($sql="")
   {
      if(empty($sql)) return false;
      if(empty($this->CONN)) return false;

      $conn = $this->CONN;
      $result = mysqli_query($conn,$sql);
      return $result;
   }

}
?>