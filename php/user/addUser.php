<?php
$link = mysql_connect('localhost', 'root', 'bamkie072489');
if (!$link)
{
	die('Could not connect : ' . mysql_error());
}

// 값 가져오기
$id = $_GET['id'];
$name = $_GET['name'];
$score = $_GET['score'];

$rewarded = 0;
$utcNow = date("Y-m-d H:i:s");
$gmtNow = date("Y-m-d H:i:s", strtotime($utcNow . ' + 9 hours'));

// 유저 정보 가져오기
$result = mysql_query("SELECT * FROM HundredBlocksDB.User WHERE id = '$id'");
$user =  mysql_fetch_assoc($result);

if ($user)
{
	// 기존 유저인 경우
	// 출석 체크
	$max = 5;
	$latestPlay = $user['latestPlay'];
	$diff = intval((strtotime($gmtNow) - strtotime($latestPlay)) / 86400); 
	
	if ($diff == 0) // 오늘 재접속
	{
    	mysql_query(
			"UPDATE HundredBlocksDB.User
			SET name = '$name', latestPlay = '$gmtNow'
			WHERE id = '$id'");
	}
	else if ($diff == 1) // 어제 접속 -> 오늘 접속 (연속 출석)
	{
		$attendance = $user['attendance'];
		
		if ($attendance == $max) // 개근 후 보상 지급 받음 -> 출석 초기화
		{
			$attendance = 1;
		}
		else
		{
			$attendance = $attendance + 1;
		}
		
    	mysql_query(
			"UPDATE HundredBlocksDB.User
			SET name = '$name', attendance = '$attendance', rewarded = '$rewarded', latestPlay = '$gmtNow'
			WHERE id = '$id'");
	}
	else // 개근 X -> 출석 1일로 초기화
	{
		$attendance = 1;
		
    	mysql_query(
			"UPDATE HundredBlocksDB.User
			SET name = '$name', attendance = '$attendance', rewarded = '$rewarded', latestPlay = '$gmtNow'
			WHERE id = '$id'");
	}
	
	// 점수 갱신
	$result = mysql_query("SELECT score FROM HundredBlocksDB.User WHERE id = '$id'");
    $rankedScore = mysql_result($result, 0, 0);
	
	if ($rankedScore < $score)
    {
    	mysql_query(
			"UPDATE HundredBlocksDB.User SET score = '$score' WHERE id = '$id'");
    }
}
else
{
 	// 신규 유저인 경우
	// 유저 정보 등록
	$attendance = 1;
	
	mysql_query(
		"INSERT INTO HundredBlocksDB.User(id, name, score, attendance, rewarded, latestPlay)
		VALUES('$id', '$name', '$score', '$attendance', '$rewarded', '$gmtNow')");
}

// 업데이트 된 정보 리텅
$result = mysql_query("SELECT * FROM HundredBlocksDB.User WHERE id = '$id'");

$userInfo = array();
while ($row = mysql_fetch_array($result))
{
	array_push($userInfo, array(
		'id'=>$row[0],
		'name'=>$row[1],
		'score'=>$row[2],
		'numItem0'=>$row[3],
		'numItem1'=>$row[4],
		'attendance'=>$row[5],
		'rewarded'=>$row[6],
		'latestPlay'=>$row[7]));
}

echo json_encode($userInfo);

mysql_close($link);
?>