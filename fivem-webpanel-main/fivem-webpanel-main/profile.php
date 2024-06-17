<?php require "./config.php"; ?>
<?php
// We need to use sessions, so you should always start sessions using the below code.
session_start();
// If the user is not logged in redirect to the login page...
if (!isset($_SESSION['loggedin'])) {
	header('Location: index.html');
	exit;
}

$con = mysqli_connect($DATABASE_HOST, $DATABASE_USER, $DATABASE_PASS, $DATABASE_NAME);
if (mysqli_connect_errno()) {
	exit('Failed to connect to MySQL: ' . mysqli_connect_error());
}
// We don't have the password or email info stored in sessions so instead we can get the results from the database.
$stmt = $con->prepare('SELECT password, email FROM accounts WHERE id = ?');
// In this case we can use the account ID to get the account info.
$stmt->bind_param('i', $_SESSION['id']);
$stmt->execute();
$stmt->bind_result($password, $email);
$stmt->fetch();
$stmt->close();
?>

<!DOCTYPE html>
<html>
	<head>
		<meta charset="utf-8">
		<title>FTWRP | Profile</title>
		<link href="assets/css/style_home.css" rel="stylesheet" type="text/css">
		<link type="text/css" rel="stylesheet" href="http://fonts.googleapis.com/css?family=Noto+Sans">
		<link rel="stylesheet" type="text/css" href="js/notify.css">
		<link rel="stylesheet" type="text/css" href="js/prettify.css">
		<link rel="stylesheet" href="https://use.fontawesome.com/releases/v5.7.1/css/all.css">
	</head>
	<body class="loggedin">
		<nav class="navtop">
			<div>
			<img src="https://shop.ftw.pt/image/catalog/ftwshop.png" width="70px" height="50px" style="margin-top: 4px; margin-right: 320px"></img>
				<h1>FTWRP | Information</h1>
				<a href="profile.php"><i class="fas fa-user-circle"></i><?=$_SESSION['name']?></a>
				<a href="logout.php"><i class="fas fa-sign-out-alt"></i>Logout</a>
			</div>
		</nav>
		<div class="content">
			<h2 onclick="history.back()"><i class="fas fa-caret-left"></i> Home</h2>
			<div>
				<p>Your account details:</p>
				<table>
					<tr>
						<td>Username:</td>
						<td><?=$_SESSION['name']?></td>
					</tr>
					<tr>
						<td>Email:</td>
						<td><?=$email?></td>
					</tr>
					<tr>
						<td>Password:</td>
						<td>•••••••••••••</td>
					</tr>
				</table>
				<input type="submit" name="changeEmail" value="Change Email" onclick='$.notify("Coming Soon", {type:"info"});'></input>
				<input type="submit" name="changePass" value="Change Password" onclick='$.notify("Coming Soon", {type:"info"});'></input>
			</div>
		</div>
	</body>
	<script src="https://ajax.googleapis.com/ajax/libs/jquery/3.2.1/jquery.min.js"></script>
	<script src="js/notify.js" type="text/javascript"></script><script src="js/prettify.js" type="text/javascript"></script>
</html>