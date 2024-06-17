<?php require "./config.php"; ?>

<?php
// We need to use sessions, so you should always start sessions using the below code.
session_start();
// If the user is not logged in redirect to the login page...
if (!isset($_SESSION['loggedin'])) {
	header('Location: index.html');
	exit;
}
?>

<!DOCTYPE html>
<html>
	<head>
		<meta charset="utf-8">
		<title>FTWRP | WebPanel</title>
		<link rel="icon" type="image/png" href="https://shop.ftw.pt/image/catalog/ftwshop.png"/>
		<link rel="stylesheet" type="text/css" href="js/notify.css">
		<link rel="stylesheet" type="text/css" href="js/prettify.css">
		<link href="assets/css/style_home.css" rel="stylesheet" type="text/css">
		<link rel="stylesheet" href="https://use.fontawesome.com/releases/v5.7.1/css/all.css">
		<script src="https://ajax.googleapis.com/ajax/libs/jquery/3.2.1/jquery.min.js"></script>
		<script>
			$(document).ready(function() {
				var firstLoad = 1
				function loadLogs(){
				var bottom = $('#content').prop('scrollHeight')
				$.get({
					url: "<?php echo $log_file; ?>",
					cache: false
				}).then(function(data) {
					var heightAfter = $('#content').scrollTop() + $('#content').height()
					var split = data.replace(/\n/g, "<br />")
					$('#content').html(split);
					if (firstLoad || bottom === heightAfter){
					$("#content").animate({ scrollTop: $('#content').prop('scrollHeight') }, 0);
					firstLoad = 0
					}
					setTimeout(loadLogs, 1000);
				});
				}
				setTimeout(loadLogs, 10);
				$('#rcon').keyup(function(e) {
				if (e.keyCode === 13) {
					var command = $('#rcon').val()
					$('#rcon').val('')
					$.post("process.php", { data: command }, function(data) {})
				}
				})
			})
			function execute(e) {
				var command = $('#rcon').val()
				$('#rcon').val('')
				$.post("process.php", { data: command }, function(data) {})
			}
			function executeQuit(e) {
				var command = "quit"
				$('#rcon').val('')
				$.post("process.php", { data: command }, function(data) {})
			}
			var firstRun = true
			function executeStatus(e) {
				var command = "ensure rconlog"
				var command1 = "status"
				$('#rcon').val('')
				if (firstRun) {
					firstRun = false
					$.post("process.php", { data: command }, function(data) {})
				}
				$.post("process.php", { data: command1 }, function(data) {})
			}
		</script>
	</head>
	<body class="loggedin">
		<nav class="navtop">
			<div>
			<img src="https://shop.ftw.pt/image/catalog/ftwshop.png" width="70px" height="50px" style="margin-top: 4px; margin-right: 320px"></img>
				<h1>FTWRP | WebPanel</h1>
				<a href="profile.php"><i class="fas fa-user-circle"></i><?=$_SESSION['name']?></a>
				<a href="logout.php"><i class="fas fa-sign-out-alt"></i>Logout</a>
			</div>
		</nav>
		<div class="content">
			<h2 onclick="history.back()"><i class="fas fa-caret-left"></i> Index</h2>
			<p>Welcome back, <?=$_SESSION['name']?>!</p>
			<div style="text-align:center;">
				<p>Server Manager</p>
				<button onclick='window.location.href = "batch.php"; $.notify("Server Started", {type:"success"});'>START</button>
				<button onclick='executeQuit(); $.notify("Server Stopped", {type:"danger"});'>STOP</button>
			</div>
			<div style="text-align:center;">
				<p>Console</p>
				<console>
					<div id="content"></div>
				</console>
				<div id="input">
					<input id="rcon" type="text" placeholder="Execute... (eg. refresh)">
					<button onclick='execute(); $.notify("Command Executed", {type:"info"});'>Execute</button>
					<button onclick='executeStatus(); $.notify("Showing Players", {type:"info"});'>Show Players</button>
				</div>
			</div>
			<div style="text-align:center;">
				<p>Database Manager</p>
				<button onclick="window.location.href = 'infos/ban.php';">BAN LIST</button>
				<button onclick="window.location.href = 'infos/register.php';">CHARACTERS</button>
				<button onclick="window.location.href = 'infos/users.php';">USERS</button>
				<button onclick="window.location.href = 'register/register.html';">NEW USER</button>
			</div>
		</div>
	</body>
	<script src="js/notify.js" type="text/javascript"></script><script src="js/prettify.js" type="text/javascript"></script>
</html>