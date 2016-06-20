<?php
$link = mysql_connect('localhost', 'root', 'bamkie072489');
if (!$link)
{
	die('Could not connect : ' . mysql_error());
}

$rank = $_GET['rank'];
$numResult = $_GET['numResult'];
$currUserId = $_GET['currUserId'];

// 데이터를 점수 기준 내림차순 정렬하여 가져옴
$result = mysql_query("SELECT * FROM HundredBlocksDB.User WHERE score > 0 ORDER BY score DESC");

// Rank 유효성 검사
$count = mysql_num_rows($result);
if ($rank <= 0 || $rank > $count)
{
	echo "0";
}
else
{
	if ($currUserId != "null")
	{
		$userResult = mysql_query("SELECT * FROM HundredBlocksDB.User WHERE id = '$currUserId'");
		$user = mysql_fetch_array($userResult);	
		
		if ($user)
		{
			$userOrder = (int)($numResult / 2) + 1;
			$userScore = $user['score'];
			$userInfo = array();
			$counter = 0;
			
			// 상위 랭커
			mysql_data_seek($result, $rank - 1);
			while ($row = mysql_fetch_array($result))
			{
				array_push($userInfo, array('id'=>$row[0], 'name'=>$row[1], 'score'=>$row[2]));
				
				$counter++;
				if ($counter == $userOrder - 1)
				{
					break;		
				}
			}
			$counter = 0;
			
			// 유저
			array_push($userInfo, array('id'=>$user[0], 'name'=>$user[1], 'score'=>$user[2]));
			
			// 하위 랭커
			$result = mysql_query("
				SELECT * FROM HundredBlocksDB.User 
				WHERE NOT id = '$currUserId' and score <= $userScore
				ORDER BY score DESC");
			
			while ($row = mysql_fetch_array($result))
			{
				array_push($userInfo, array('id'=>$row[0], 'name'=>$row[1], 'score'=>$row[2]));
				
				$counter++;
				if ($counter == $userOrder - 1)
				{
					break;		
				}
			}
		
			// 리턴
			echo json_encode($userInfo);
		}
		else
		{
			echo "0";
		}
	}
	else
	{
		// 해당 Rank 데이터 특정
		mysql_data_seek($result, $rank - 1);
		
		// 데이터 저장
		$userInfo = array();
		while ($row = mysql_fetch_array($result))
		{
			array_push($userInfo, array('id'=>$row[0], 'name'=>$row[1], 'score'=>$row[2]));
			
			$numResult = $numResult - 1;
			if ($numResult <= 0)
			{
				break;		
			}
		}
			
		// 리턴
		echo json_encode($userInfo);
	}
}

mysql_close($link);
?>