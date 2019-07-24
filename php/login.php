<?php

/* Database stuct for `login_logs` :
 * int id;
 * varchar(100) username;	--unique index 
 * varchar(400) password;
 * varchar(100) userIP;
 * text browserInfo;
 * smallint status;	//1-good , 2-no username , 3- wrong-password, 4-fail auth google
 * datetime createDate; default - CURRENT_TIME
 */

/*
 * Database stuct for 'login_users'
 * int id ; -- Auto inc ;
 * varchar(100) username;	--unique index 
 * varchar(400) password;	
 * varchar(400) recoveryEmail;
 * int	accountType;	--user define for each project. must mention in DB !
 * bool enable;
 * datetime createDate; default - CURRENT_TIME
 * datetime lastModified ; default - CURRENT_TIME
 */

class login
{

  private $username;
  private $recaptchaSecret;
  private $isLoginSuccess = FALSE;
  private $numberOfLoginTrys;

  private $sessonName;
  public $blocked = false;

  private $DB;
  private $sessionTime;
  private $usersTable;
  private $usersLogTable;
  private $maxNumberOfTrys;

  private $secure = true;
  private $httponly = true;


  public function __construct($DB, $usersTable, $usersLogTable, $connectUser = 0, $username = 0, $password = 0, $recaptcha = 0, $sessionTime = 3600, $maxNumberOfTrys = 5, $sessionName = 0)
  {
    $this->recaptchaSecret = $GLOBALS['recaptchaSecret'];
    $this->DB = $DB;
    $this->usersTable = $usersTable;
    $this->usersLogTable = $usersLogTable;
    $this->maxNumberOfTrys = $maxNumberOfTrys;
    $this->sessionTime = $sessionTime;//default one hour

    if (ini_set('session.use_only_cookies', 1) === FALSE)  //coockies only!!
      throw new Exception("Could not initiate a safe session (ini_set)");
    $cookieParams = session_get_cookie_params();

    session_set_cookie_params(0, "/", ".bankerim.co.il", $this->secure, $this->httponly);

    session_name("$sessionName");
    $this->sessonName = $sessionName;

    error_reporting(0);
    //session_name('smwebsites_login');
    session_start();
    error_reporting(E_ALL);
    //session_regenerate_id(true);    // regenerated the session, delete the old one.
    $this->numberOfLoginTrys = $this->getNumberOfLogin();
    if (($this->numberOfLoginTrys >= $this->maxNumberOfTrys)) {
      $this->blocked = true;
      return $this;
    }

    if ($connectUser == "1" && $username != "0" && $password != "0") {
      $this->username = $username;
      $this->isLoginSuccess == $this->loginUser($password, $recaptcha);
    } else if ($connectUser == "0" && !($this->getConnected()) && isset($_COOKIE['_uti_' . $this->sessonName])) {
      $this->connectUserWithToken($_COOKIE['_uti_' . $this->sessonName]);
    }
  }

  public function getIsLoginSuccess()
  {
    return $this->isLoginSuccess;
  }

  /*
     * this function returen boolean with true if the user is still connected otherwise false
     */
  public function getConnected()
  {
    if (isset($_SESSION['SLT']) && (time() - $_SESSION['TTL'] <= $_SESSION['SLT'])) {
      $_SESSION['TTL'] = time();
      return TRUE;
    } else {
      return FALSE;
    }

  }

  /*
     * this function delete the session.
     */
  public function logout()
  {
    if (isset($_COOKIE['_uti_' . $this->sessonName])) {
      $this->DB->query("UPDATE `login_logs_web` SET `tokenTime`='" . date("Y-m-d H:i:s", strtotime("-1 days")) . "' WHERE `token`='" . $_COOKIE['_uti_' . $this->sessonName] . "'");

    }
    echo("<script>localStorage.removeItem(\"info\");</script>");
    $_SESSION = array();
    session_unset();
    session_destroy();
    setcookie('_uti_' . $this->sessonName, '', strtotime("-1 days"), "/", parse_url($GLOBALS['websitePath'], PHP_URL_HOST), $this->secure, $this->httponly);
    $_SESSION['TTL'] = 0;
  }

  /*
     * this function login the user , return true if login success
     */

  private function loginUser($password, $recaptcha = 0)
  {
    if ($this->numberOfLoginTrys >= 5) {
      return FALSE;
    }
    if ($recaptcha != "0") {

      $dataArray = array("secret" => $this->recaptchaSecret, "response" => $recaptcha);
      $serverAns = utils::getHTMLrequest($dataArray, "https://www.google.com/recaptcha/api/siteverify");
      $serverAns[0] = json_decode($serverAns[0], TRUE);
      if ($serverAns[0]['success'] != "1") {
        $this->logLoginTrys("4", $password);
        return FALSE;
      }

    }
    $result = $this->DB->query("SELECT `password`,`accountType`,`id` FROM `" . $this->usersTable . "` WHERE `username`='" . $this->username . "' AND `enable`='1' LIMIT 1");
    if ($result && $result->num_rows > 0) {
      $data = $result->fetch_array(MYSQLI_ASSOC);
      if ($data['password'] == $password) {
        $_SESSION['username'] = $this->username;
        $_SESSION['login_id'] = $data['id'];
        $_SESSION['accountType'] = $data['accountType'];
        $_SESSION['SLT'] = $this->sessionTime;
        $_SESSION['TTL'] = time();
        $this->logLoginTrys("1", $password);
        return TRUE;
      } else {
        $this->logLoginTrys("3", $password);
        $_SESSION = array();
        session_unset();
        session_destroy();
        $_SESSION['TTL'] = 0;
        return FALSE;
      }
    }

    $this->logLoginTrys("2", $password);
    $_SESSION = array();
    session_unset();
    session_destroy();
    $_SESSION['TTL'] = 0;
    return FALSE;
  }


  private function connectUserWithToken($token)
  {
    $ip = $_SERVER['REMOTE_ADDR'];
    $browserData = $_SERVER['HTTP_USER_AGENT'];
    $date = date("Y-m-d H:i:s");

    $result = $this->DB->query("SELECT `username`,`password` FROM `" . $this->usersLogTable . "` WHERE `token`='$token' AND `browserInfo`='$browserData' AND `tokenTime`>='$date' ");
    if ($result && $result->num_rows > 0) {
      $data = $result->fetch_assoc();
      $this->username = $data['username'];
      $this->sessionTime = 36000;
      $this->loginUser($data['password'], 0);
    } else {
      $this->logout();
    }


  }

  /*
     * this function log all the login tries . save the time,ip,borwser and login info . this data will be used for dectect attacks
     */
  private function logLoginTrys($status, $password)
  {
    $ip = $_SERVER['REMOTE_ADDR'];
    $browserData = $_SERVER['HTTP_USER_AGENT'];
    $date = date("Y-m-d H:i:s");
    $token = "";
    $tokenTime = "";
    if ($status == "1" && $this->sessionTime > 43200) {
      //create token
      $this->cleanLoginTrys();
      $token = bin2hex(openssl_random_pseudo_bytes(24));
      $tokenTime = date("Y-m-d H:i:s", strtotime("+120 days"));
      setcookie('_uti_' . $this->sessonName, $token, strtotime($tokenTime), "/", parse_url($GLOBALS['websitePath'], PHP_URL_HOST), $this->secure, $this->httponly);
    }
    $this->DB->query("INSERT INTO `" . $this->usersLogTable . "`(`username`, `password`, `userIP`, `browserInfo`, `status`,`createDate`,`token`,`tokenTime`) VALUES ('" . $this->username . "','" . $password . "','$ip','$browserData','$status','$date','$token','$tokenTime')");
  }

  /*
  *   this function remove old logs
  */
  private function cleanLoginTrys()
  {
    $this->DB->query("DELETE FROM `" . $this->usersLogTable . "` WHERE `createDate` < '" . date("Y-m-d H:i:d", strtotime("-180 days")) . "' AND `tokenTime` < '" . date("Y-m-d H:i:d") . "'");
  }

  /*
     * this function get number of login tries in 5mins .
     */
  public function getNumberOfLogin()
  {
    /*$ip = $_SERVER['REMOTE_ADDR'];
        $browserData = $_SERVER['HTTP_USER_AGENT'];
        $date=date("Y-m-d H:i:s",strtotime("-5 minute"));
        $result=$this->DB->query("SELECT `id` FROM `".$this->usersLogTable."` WHERE `status`<>'1' AND `userIP`='$ip' AND `browserInfo`='$browserData' AND `createDate`>='$date' AND `status`<>'1'");
        return $result->num_rows;*/
    return 0;
  }

  public static function getCount($DB, $table = 'login_users_web')
  {
    $result = $DB->query("SELECT count(`id`) FROM `$table` WHERE `enable`='1'");
    if ($result)
      return $result->fetch_row()[0];
    else
      return 0;
  }

  public function getTokenKey()
  {
    return $_COOKIE['_uti_' . $this->sessonName];
  }

  public function setTokenCookieAndLogin($token, $tokenTime)
  {
    setcookie('_uti_' . $this->sessonName, $token, strtotime($tokenTime), "/", parse_url($GLOBALS['websitePath'], PHP_URL_HOST), $this->secure, $this->httponly);
    $this->connectUserWithToken($token);
  }

}

class loginManager extends login
{
  private $DB;
  private $usersTable;

  public function __construct($DB, $usersTable, $usersLogTable, $connectUser = 0, $username = 0, $password = 0, $recaptcha = 0, $sessionTime = 3600, $maxNumberOfTrys = 5)
  {
    parent::__construct($DB, $usersTable, $usersLogTable, $connectUser, $username, $password, $recaptcha, $sessionTime, $maxNumberOfTrys);
    $this->DB = $DB;
    $this->usersTable = $usersTable;
  }

  public function printLastLogins()
  {
    $allUsersArray = array();

    $result = $this->DB->query("SELECT  `username`, `status`, `createDate` FROM `login_logs_web` WHERE 1  ORDER BY `createDate` DESC LIMIT 10");
    if ($result) {
      $allUsersArray = $result->fetch_all(MYSQLI_ASSOC);
    }

    foreach ($allUsersArray as $user) {
      if ($user['status'] == 1)
        $status = "����� ������";
      else if ($user['status'] == 2)
        $status = "�� ����� �� ����";
      else if ($user['status'] == 3)
        $status = "����� �� �����";
      else if ($user['status'] == 4)
        $status = "���� ����� ������";

      echo("
            <tr>
                <td>" . $user['username'] . "</td>
                <td>" . $status . "</td>
                <td>" . $user['createDate'] . "</td>     
            </tr>
            ");

    }
  }

  public function updatePassword($username, $newPass)
  {
    if ($newPass == "" && $username == "") {
      echo("3");
      return 3;
    }

    $result = $this->DB->query("UPDATE `" . $this->usersTable . "` SET `password`='$newPass' WHERE `username`='$username'");
    if ($result)
      echo("1");
    else {
      print_r($this->DB);
    }

  }

  public static function ajaxUpdate($db, $table, $id, $username = 0, $password, $enable = 1)
  {
    if ($password == "" || $id == "") {
      return 3;
    }

    $userNameUpdateString = "";

    if ($username !== "" && $username !== 0 && $username !== "0") {
      $username = trim($username);
      $userNameUpdateString = " `username`='$username' ,";
    }

    $password = trim($password);

    $result = $db->query("UPDATE `" . $table . "` SET $userNameUpdateString `password`='$password' , `enable`='$enable' WHERE `id`='$id'");
    if ($result)
      return "1";
    else {
      print_r($db);
    }

  }

  public static function ajaxInsert($DB, $table, $username, $password, $email, $enable = 1)
  {
    if ($username == "" || $password == "" || $email == "" || $table == "") {

      return 0;

    }
    $now = date("Y-m-d H:i:s");
    $result = $DB->query("INSERT INTO `$table` (`username`, `password`, `recoveryEmail`, `accountType`, `enable`, `createDate`, `lastModified`) VALUES ('$username','$password','$email','1','$enable','$now','$now')");
    if ($result && $DB->insert_id != 0) {
      return $DB->insert_id;
    } else {
      print_r($DB);
      return 0;
    }


  }

  public static function ajaxDelete($DB, $table, $id)
  {
    $result = $DB->query(/** @lang text */ "DELETE FROM `" . $table . "`  WHERE `id`='$id'");
  }

  public static function checkIfUsernameInUse($db, $table, $username)
  {
    $result = $db->query("select `id` from `$table` WHERE `username`='$username' ");
    if ($result && $result->num_rows > 0) {
      return 1;
    } else
      return 0;
  }

}

?>
