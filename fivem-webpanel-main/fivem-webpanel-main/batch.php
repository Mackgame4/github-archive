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

<?php
    //exec($cmd);
    $handle = popen ('start /B '.$cmd.' > .\logs.txt 2>&1', 'r');
    pclose ($handle);
    header('Location: home.php');
?>