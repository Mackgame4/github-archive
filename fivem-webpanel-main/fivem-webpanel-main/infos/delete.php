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
   if(isset($_POST['supprimer']))
        {
    $table = $_POST['table'];
    $identifier = $_POST['id'];
 $bdd->query("DELETE FROM $table WHERE id=" .$identifier); 
 //header('Location: users.php');
 header('Location: '.$_SERVER['HTTP_REFERER'].'');
}
?>