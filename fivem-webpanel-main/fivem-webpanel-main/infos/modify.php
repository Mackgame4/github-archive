<?php require "../config.php"; ?>
<?php
ini_set('display_errors', 1);
try
{
 $bdd = new PDO('mysql:host='.$SDATABASE_HOST.';dbname='.$SDATABASE_NAME.';', $SDATABASE_USER, $SDATABASE_PASS);
}
catch (Exception $e){
 die('Erreur : ' . $e->getMessage());
} 
   if(isset($_POST['modify']))
        {
    $table = $_POST['table'];
    $identifier = $_POST['rowId'];
    $name = $_POST['rowName'];
    $newvalue = $_POST['newValue'];
    if ($name != "") {
 $bdd->query("UPDATE $table SET $name = '$newvalue' WHERE id=" .$identifier); }
 //header('Location: users.php');
 header('Location: '.$_SERVER['HTTP_REFERER'].'');
}
?>