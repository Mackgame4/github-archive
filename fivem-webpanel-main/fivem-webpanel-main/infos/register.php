<?php require "../config.php"; ?>
<?php
// We need to use sessions, so you should always start sessions using the below code.
session_start();
// If the user is not logged in redirect to the login page...
if (!isset($_SESSION['loggedin'])) {
	//header('Location: http://**[IP SERVEUR ou DOMAINE]/pannel/index.html');
	exit;
}
?>

<?php
try
{
 $bdd = new PDO('mysql:host='.$SDATABASE_HOST.';dbname='.$SDATABASE_NAME.';', $SDATABASE_USER, $SDATABASE_PASS);
}
catch (Exception $e){
 die('Erreur : ' . $e->getMessage());
}
?>
<title>FTWRP | Database</title>
<link rel="icon" type="image/png" href="https://shop.ftw.pt/image/catalog/ftwshop.png"/>
<center>
<nav class="navtop">
	<div>
	<img src="https://shop.ftw.pt/image/catalog/ftwshop.png" width="70px" height="50px" style="margin-top: 4px; margin-right: 320px"></img>
		<h1>FTWRP | Characters Database</h1>
		<a href="../home.php"><i class="fas fa-sign-out-alt"></i>Back</a>
	</div>
</nav>
<form method="post" class="modifyform" action="modify.php">
  <input type="hidden" name="table" value="characters">
  <input id="rowId" name="rowId" type="text" placeholder="User ID">
  <input id="rowName" name="rowName" type="text" placeholder="Label Name to Modify">
  <input id="newValue" name="newValue" type="text" placeholder="New Value">
  <input type="submit" name="modify" class="modify" value="Modify">
</form>
<table class="table table-hover">
<thead>
  <th>ID</th>
  <th>Firstname</th>
  <th>Lastname</th>
  <th>Steam</th>
  <th>Action</th>
</thead>
<?php
$reponse = $bdd->query('SELECT * FROM characters');
  while($donnees=$reponse->fetch())
  {
    echo
    '<tr>
    <td><center>' . $donnees['id'] .'</td><td><center>' . $donnees['firstname'] . '</td><td><center>' . $donnees['lastname'] . '</td><td><center>' . $donnees['identifier'] . '</td>
      <td>
      <form method="post" class="deleteform" action="delete.php">
      <input type="hidden" name="table" value="characters">
      <input type="hidden" name="id" value="'. $donnees['id'] . '">
      <input type="submit" name="supprimer" class="delete" value="Delete">
      </form>
      </td>
    </tr>';
  }
?>

<link rel="stylesheet" href="https://use.fontawesome.com/releases/v5.7.1/css/all.css">

<style>
@import url('https://rsms.me/inter/inter-ui.css');

* {
	box-sizing: border-box;
	font-family: 'Inter UI', sans-serif;
	font-size: 16px;
	-webkit-font-smoothing: antialiased;
	-moz-osx-font-smoothing: grayscale;
	outline: none;
}

body {
  margin: 0;
	height: 100%;
  background-color: #f3f4f7;
}

.modifyform {
  margin-top: 20px;
}

.navtop {
	height: 60px;
	width: 100%;
	background-color: rgba(0, 0, 0, 0.9);
	backdrop-filter: blur(4px);
	border-bottom: 1px solid black;
	color: white;
}
.navtop div {
	display: flex;
	margin: 0 auto;
	width: 1000px;
	height: 100%;
}
.navtop div h1, .navtop div a {
	display: inline-flex;
	align-items: center;
}
.navtop div h1 {
	flex: 1;
	font-size: 24px;
	padding: 0;
	margin: 0;
	color: #eaebed;
	font-weight: normal;
}
.navtop div a {
	padding: 0 20px;
	text-decoration: none;
	color: #c1c4c8;
	font-weight: bold;
}
.navtop div a i {
	padding: 2px 8px 0 0;
}
.navtop div a:hover {
	color: #eaebed;
}

table {
  font-family: arial, sans-serif;
  border-collapse: collapse;
  width: 90%;
  margin-top: 30px;
}

th {
  background-color: rgba(0, 0, 0, 0.8);
	backdrop-filter: blur(4px);
	border-top: 1px solid black;
	color: white;
}

td, th {
  border: 1px solid black;
  text-align: left;
  padding: 8px;
}

tr:nth-child(even) {
  background-color: #dddddd;
}

button {
  background-color: rgb(170, 0, 0);
  border: none;
  color: white;
  padding: 15px 32px;
  text-align: center;
  text-decoration: none;
  display: inline-block;
	font-size: 16px;
	cursor: pointer;
}

button:hover {
  background-color: rgb(130, 0, 0);
	transition: background-color 0.2s;
}

input {
  background-color: rgb(170, 0, 0);
  border: none;
  color: white;
  padding: 15px 32px;
  text-align: center;
  text-decoration: none;
  display: inline-block;
  font-size: 16px;
}

input:hover {
  background-color: rgb(130, 0, 0);
  transition: background-color 0.2s;
  cursor: pointer;
}
</style>