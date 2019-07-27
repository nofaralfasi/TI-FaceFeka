<?php
$http_origin = $_SERVER["HTTP_ORIGIN"];
if (isset($http_origin)) {
    header("Access-Control-Allow-Origin: " . $http_origin);
}
header("Access-Control-Allow-Methods: GET,PUT,POST,DELETE,PATCH,OPTIONS");
// header("Access-Control-Allow-Headers: Origin,Accept, X-Requested-With, Content-Type, Access-Control-Request-Method, Access-Control-Request-Headers");
header("Access-Control-Allow-Headers: Origin, X-Requested-With, Content-Type, Accept, Authorization");

define('DB_SERVER', 'localhost');
define('DB_USERNAME', 'root');
define('DB_PASSWORD', '');
define('DB_DATABASE', 'facefeka');
$connection = @mysqli_connect(DB_SERVER, DB_USERNAME, DB_PASSWORD, DB_DATABASE) or diedie("<BR><BR><B>ERROR:</B> cannot connect to MySQL server.<BR>");

$request_body = file_get_contents('php://input');
$data = json_decode($request_body, true);
$hashFormat = "$7y$11$";
$salt = "avianofarmicafacefeka";
$hashNsalt = $hashFormat . $salt;

function checkCookis()
{
    global $data;
    global $connection;
    if (isset($_COOKIE["FaceFeka_Avia_Nofar"])) {
        return $RESPONSE[0] = "001"; // have a good cookie
    } else {
        return $RESPONSE[0] = "002"; // don't have a cookie
    }
}

function login()
{
    global $data;
    global $connection;
    global $hashNsalt;

    $userID = $data['usersID'];
    $pass = $data['usersPass'];
    $pass = crypt($pass, $hashNsalt);

    $query = "select * from users WHERE `usersID`='" . $userID . "' AND `usersPass`='" . $pass . "'";
    $select_q = $connection->query($query);
    $rep = $select_q->fetch_assoc();

    /*/ -----
    $query = "select posts.*, users.usersName from posts left join users on posts.usersID=users.usersID WHERE posts.usersID='" . $userID . "' OR (posts.usersID IN (" . implode(",", $fol) . ") and private=0) order by postsDateCreated DESC";
    $select_q = $connection->query($query);
    $res = $select_q->fetch_all(MYSQLI_ASSOC);
    if ($select_q != true || $select_q->num_rows < 1)
        return $RESPONSE = array("100");
    $RESPONSE = array("000");
    $RESPONSE[2] = $res;
    return $RESPONSE;
    ------- /*/ 

    $userName = $rep['usersName'];
    // $userPas = $rep['usersPass']; //n

    // echo "From login() on connect.php -> usersName: " . $userName;//n
    // echo "From login() on connect.php -> usersPass: " . $userPas;//n

    if ($select_q->num_rows == 1) {
        // successed!
        $RESPONSE[0] = "000";
        // $RESPONSE[4] = array('usersID' => $userID, 'usersName' => $userName, 'usersPass' => $userPas);//n
        $query = "select certificate from certificates WHERE usersID=" . $userID;
        $cert = $connection->query($query)->fetch_assoc();

        $RESPONSE = array("000");
        $RESPONSE[2] = array('usersID' => $userID, 'usersName' => $userName, 'certificate' => $cert['certificate']);
        // $row = $select_q->fetch_assoc();
        // $RESPONSE[2][$userID]=$row;
        return $RESPONSE;
    } 
    // on failure
    else
        return $RESPONSE[0] = "100";
}

function register()
{
    global $data;
    global $connection;
    global $hashNsalt;

    $userID = $data['usersID'];
    $userName = $data["usersName"];
    $pass = $data['usersPass'];
    // *** for preventing sql injection make text quotes, etc...
    // if (isset($userName))
    // $userName = msqli_real_escape_string($connection, $userName);
    if (isset($userID) && isset($pass)) {
        $pass = crypt($pass, $hashNsalt);

        // checks userID already exist
        $query = "select * from users WHERE usersID=" . $userID;
        $select_q = $connection->query($query);
        if ($select_q->num_rows == 1) {
            return $RESPONSE = array("101");
        }
        // put to users
        $query = "insert into users(usersID, usersName, usersPass)";
        $query .= "values ('$userID', '$userName', '$pass')";
        $select_q = $connection->query($query);
        if ($select_q != true)
            goto Done;
        // put to certificates
        $userIDHASH = crypt($userID, $hashNsalt);
        $query = "insert into certificates(usersID, certificate) ";
        $query .= "values ('$userID', '$userIDHASH')";
        $select_q2 = $connection->query($query);
        if ($select_q2 != true)
            goto Done;
        $RESPONSE = array("000");
        $RESPONSE[2] = array('usersID' => $userID, 'usersName' => $userName, 'cert' => $userIDHASH);
        return $RESPONSE;
    }
    Done:
    return $RESPONSE = array("100");
}

function checkCertificate()
{
    global $data;
    global $connection;
    $userID = $data['usersID'];
    $cert = $data['certificate'];

    $query = "select * from certificates WHERE usersID=" . $cert;
    $select_q = $connection->query($query);
    $rep = $select_q->fetch_assoc();
    if ($select_q->num_rows == 1) {
        $RESPONSE[0] = "000";
        $RESPONSE[2] = $rep;
        return $RESPONSE;
    } else
        // 300 = no certificate
        return $RESPONSE[0] = "300";
}

function insertPost()
{
    global $data;
    global $connection;
    $data = $data['data'];
    $userID = $data['usersID'];
    $postsContent = $data['postsContent'];
    $postsPic = $data['postsPic'];
    $private = $data['private'];
    $query = "insert into posts(usersID, postsContent, postsPic, private) ";
    $query .= "values ('$userID', '$postsContent', '$postsPic', '$private')";
    $select_q = $connection->query($query);
    if ($select_q != true)
        goto Done;
    $RESPONSE = array("000");
    $RESPONSE[2] = $select_q;
    return $RESPONSE;
    Done:
    return $RESPONSE = array("100");
}

// GETS followed users ID
// @param userID = users ID

function getFollowed()
{
    global $data;
    $dat = $data["data"];
    global $connection;
    $userID = $dat["usersID"];
    $query = "select followedID from follow WHERE followerID=" . $userID;
    $select_q = $connection->query($query);
    $res = $select_q->fetch_all(MYSQLI_ASSOC);
    // if current user has any followers
    if ($select_q->num_rows > 0) {
        $RESPONSE[0] = "000";
        $RESPONSE[2] = $res; // saves here query's result 
        return $RESPONSE;
    }
     // else -> if current user doesn't have any followers
    return $RESPONSE[0] = "300";
}

// GETS posts and followed posts
// @param userID = users ID
// @param followers = followers ID

function getPost($followers = false)
{
    global $data;
    global $connection;
    $dat = $data["data"];
    $followers = $followers[2];
    $userID = $dat['usersID'];
    if ($userID && $followers) {
        $fol = array();
        for ($i = 0; $i < count($followers); $i++) {
            $fol[] = $followers[$i]['followedID'];
        }
        // need impolode explode array of followers first !!!

        // important! -> gets entire posts table, plus current user's name from users table using join!
        $query = "select posts.*, users.usersName from posts left join users on posts.usersID=users.usersID WHERE posts.usersID='" . $userID . "' OR (posts.usersID IN (" . implode(",", $fol) . ") and private=0) order by postsDateCreated DESC";
        $select_q = $connection->query($query);
        $res = $select_q->fetch_all(MYSQLI_ASSOC);
        if ($select_q != true || $select_q->num_rows < 1)
            goto Done;
        $RESPONSE = array("000");
        $RESPONSE[2] = $res;
        return $RESPONSE;
    }
    Done:
    return $RESPONSE = array("100");
}

function insertReply()
{
    global $data;
    global $connection;
    $data = $data['data'];
    $userID = $data['usersID'];
    $postsID = $data['postsID'];
    $replyContent = $data['replyContent'];
    $query = "insert into reply(postsID, usersID, replyContent) ";
    $query .= "values ('$postsID', '$userID', '$replyContent')";
    $select_q = $connection->query($query);
    if ($select_q != true)
        goto Done;
    $RESPONSE = array("000");
    $RESPONSE[2] = $select_q;
    return $RESPONSE;
    Done:
    return $RESPONSE = array("100");
}

function getReply()
{
    global $data;
    global $connection;
    $postsID = $data['postsID'];
    $query = "select reply.*, users.usersName from reply left join users on reply.usersID=users.usersID WHERE postsID=" . $postsID . " order by replyCreated DESC";
    $select_q = $connection->query($query);
    $res = $select_q->fetch_all(MYSQLI_ASSOC);
    if ($select_q != true || $select_q->num_rows < 1)
        goto Done;
    $RESPONSE = array("000");
    $RESPONSE[2] = $res;
    return $RESPONSE;
    Done:
    return $RESPONSE = array("100");
}

function friendsAutoComplete()
{
    global $data;
    global $connection;
    $ac = $data['data'];
    if (!isset($ac))
        goto Done;
    if ($ac = '*') {
        $query = "select * FROM `users`";
    } else {
        //$query = "select * FROM `users` WHERE LOWER(`usersName`) LIKE LOWER('%{$ac}%') OR `usersID` LIKE LOWER('%{$ac}%')";
        $query = "select * from users WHERE `usersName` like '" . $ac . "%' ORDER BY `usersName`";
    }
    $select_q = $connection->query($query);
    $res = $select_q->fetch_all(MYSQLI_ASSOC);
    if ($select_q != true || $select_q->num_rows < 1)
        goto Done;
    $arr = array();
    for ($i = 0; $i < count($res); $i++) {
        $arr[] = array('usersID' => $res[$i]['usersID'], 'usersName' => $res[$i]['usersName']);
    }
    $RESPONSE = array("000");
    $RESPONSE[2] = $arr;
    return $RESPONSE;
    Done:
    return $RESPONSE = array("100");
}

function insertFriend()
{
    global $data;
    global $connection;
    $data = $data['data'];
    $followedID = $data['followedID'];
    $followerID = $data['followerID']['usersID'];
    $query = "insert into follow(followedID, followerID)";
    $query .= "values ('$followedID', '$followerID')";
    $select_q = $connection->query($query);
    if ($select_q != true)
        goto Done;
    $RESPONSE = array("000");
    $RESPONSE[2] = $select_q;
    return $RESPONSE;
    Done:
    return $RESPONSE = array("100");
}

/***************************************  START  ************************************/
// $returnData = array("users"=>array());
$RESPONSE = array("000");
switch ($data["task"]) {
    case "login":
        $ans = login(); // from line 33 above
        if ($ans[0] != "000") {
            $RESPONSE = $ans;
            goto Done;
        }
        $RESPONSE = $ans;
        goto Done;
        break;
    case "register":
        $ans = register();
        $RESPONSE = $ans;
        break;
    case "getPosts":
        $followers = getFollowed();
        // if current user doesn't have any followers
        if ($followers[0] != "000") {
            $RESPONSE = $followers[0];
            goto Done;
        }
        // else -> if current user has any followers
        $ans = getPost($followers);
        if ($ans[0] != "000") {
            $RESPONSE = $ans[0];
            goto Done;
        }
        $RESPONSE = $ans;
        goto Done;
        break;
    case "getReply":
        $rep = getReply();
        if ($rep[0] != "000") {
            $RESPONSE = $rep[0];
            goto Done;
        }
        $RESPONSE = $rep;
        goto Done;
        break;
    case "insertReply":
        $rep = insertReply();
        if ($rep[0] != "000") {
            $RESPONSE = $rep[0];
            goto Done;
        }
        $RESPONSE = $rep;
        goto Done;
        break;
    case "insertPost":
        $rep = insertPost();
        if ($rep[0] != "000") {
            $RESPONSE = $rep[0];
            goto Done;
        }
        $RESPONSE = $rep;
        goto Done;
        break;
    case "friendsAutoComplete":
        $rep = friendsAutoComplete();
        if ($rep[0] != "000") {
            $RESPONSE = $rep[0];
            goto Done;
        }
        $RESPONSE = $rep;
        goto Done;
        break;
    case "insertFriend":
        $rep = insertFriend();
        if ($rep[0] != "000") {
            $RESPONSE = $rep[0];
            goto Done;
        }
        $RESPONSE = $rep;
        goto Done;
        break;
    default:
        $ans = "000";
        $RESPONSE = $ans;
        goto Done;
        break;
}
Done:
echo(json_encode($RESPONSE));
// return;
?>