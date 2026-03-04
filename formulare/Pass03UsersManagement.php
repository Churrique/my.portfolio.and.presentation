<?php
//* ********************************
//* Estilo por Procedimiento
//* Valido para PHP version >= 7.x
//* ********************************

include_once '../scripts/php/setting.php';
include_once '../scripts/php/proc.connection.php';
include_once '../scripts/php/proc.consulting.php';
include_once '../scripts/php/proc.insertion.php';

if (isset($_POST['btnOItem'])) {
  //! Se presume que se ejecuta DESPUES de la primera vez.
  //? It is presumed to be executed AFTER the first time.
  //* Předpokládá se, že bude provedena PO prvním použití.

  $IdUsuario = $_POST['txtIdUsuario'];
  $Usuario = $_POST['txtUsuario'];
  $Nombre = $_POST['txtNombre'];

  $idUserApp = $_POST['txtIdModulo'];
  $DetalleApp = $_POST['txtModulo'];

  $unicalinea = "Nombre: ".$Nombre."<br>Usuario: ".$Usuario."<br>";         //| Para Uso Informativo
  $quickmessage = $_POST['txtQuickmessage']."<br>";

  $ItemMenu = $_POST['txtItemMenu'];
  $OrderL = $_POST['numOrderL'];

  $connection = Connection();

  if ( is_object($connection) ) {

    if ( mysqli_query($connection, "CALL SP_CREATE_UMODULO('$idUserApp', '$ItemMenu', '$OrderL', @pds_insertado, @pds_identificador);") ) {

      $StoreProcedure = mysqli_query($connection, "SELECT @pds_insertado AS Record_Inserted, @pds_identificador AS Unique_Identifier;");

      while ( $FirstRow = mysqli_fetch_assoc($StoreProcedure) ) {
        $InsertedInTable = (($FirstRow["Record_Inserted"] == '1') ? true : false);
        $IdModuleUser = $FirstRow["Unique_Identifier"];
      }

      $quickmessage .= ($InsertedInTable ? "Se insertó con éxito...!" : "Hubieron problemas...!")."<br>";
      $quickmessage .= "Identificador Único: $IdModuleUser<br>";

    }else {

      $quickmessage .= "El SP tiene problemas...!<br>" . mysqli_errno($connection) . "<br>" . mysqli_error($connection);

    }

    mysqli_close($connection);

  }else {

    $quickmessage .= "No hay conección...!";

  }
} else {
  if(isset($_POST['btnO4User'])) {

    //! Viene de la Cuarta Pantalla
    //# Comes from the Fourth Screen
    //| Přichází ze čtvrté obrazovky

    $IdUsuario = $_POST['txtIdUser'];
    $Usuario = $_POST['txtUser'];
    $Nombre = $_POST['txtName'];
    $idUserApp = $_POST['txtIdMod'];
    $DetalleApp = $_POST['txtMENU'];

    $quickmessage = $_POST['txtQuickMe'];
    $unicalinea = $_POST['txtFirL'];

  } else {

    //! Viene de la Segunda Pantalla
    //# Comes from the Second Screen
    //| Z druhé obrazovky

    //! Se presume que se ejecuta la primera vez.
    //# It is presumed to be executed the first time.
    //| Předpokládá se, že bude provedena poprvé.

    $IdUsuario = $_POST['txtIdUser'];
    $Usuario = $_POST['txtUser'];
    $Nombre = $_POST['txtName'];

    $idUserApp = $_GET['id'];
    $DetalleApp = $_GET['modulo'];

    $unicalinea = "Nombre: ".$Nombre."<br>Usuario: ".$Usuario."<br>";         //| Para Uso Informativo
    $quickmessage = "";

  }
}
?>
<!DOCTYPE html>
<html lang="en">
<head>
  <meta charset="UTF-8">
  <meta http-equiv="X-UA-Compatible" content="IE=edge">
  <meta http-equiv="content-type" content="text/html; charset=ANSI">
  <meta name="language" content="es-ES" />
  <meta name="viewport" content="width=max-device-width, initial-scale=1, maximum-scale=1" />
  <meta name="author" content="Jesús Acosta" />
  <meta name="copyright" content="Jesús Acosta" />
  <meta name="keywords" content="html, css, académico, identificación, contabilidad, contable, diseño web, utilidades, crear páginas, curriculum vitae, foro" />
  <meta name="description" content="Página principal del sitio Web" />
  <meta name="revisit-after" content="1 month" />
  <meta name="robots" content="index, follow" />
  <meta name="REPLY-TO" content="kontakt@jesusacosta.cz">
  <meta name="Resource-type" content="Document">
  <meta name="DateCreated" content="Tue, 31 March 2020 14:00:00 GMT+1">
  <meta http-equiv="expires" content="86400" /> <!-- Equivalente a 24 horas -->
  <meta http-equiv="Cache-Control" content="no-store" />
  <title>&laquo;&nbsp;jesusacosta.cz&copy;&nbsp;&raquo;&nbsp;&nbsp;&laquo;&nbsp;Administración de Usuarios para los Projectos en Ejecución&nbsp;&raquo;&nbsp;</title>
  <link rev="made" href="mailto:kontakt@jesusacosta.cz">
  <link rel="StyleSheet" href="../css/_normalizar.css" type="text/css" />
  <link rel="StyleSheet" href="../css/UsersManagement.css" type="text/css" />
  <link rel="StyleSheet" href="../css/tooltip_der_blue.css" type="text/css" />
  <link rel="StyleSheet" href="../css/tabla_azul.css" type="text/css" />
  <link rel="shortcut icon" href="../img/_logo_nube.ico" type="image/x-icon" />
  <link rel="StyleSheet" href="../css/elemento_select.css" type="text/css" />
  <script src="../scripts/js/elemento_select.js"></script>
  <script src="../scripts/js/titulo.js"></script>
  <script src="../scripts/js/cuenta_caracteres.js"></script>
  <script src="https://kit.fontawesome.com/82f9d2a72c.js" crossorigin="anonymous"></script>
  <script src="../scripts/js/send_and_close.js"></script>
</head>
<body>
  <!--
  //  ? ---------------------
  //  ! Menú Horizontal
  // # Horizontal Menu
  // | Horizontální nabídka
  //  ? ---------------------
  -->
  <div id="div-padre">
    <form id="TheForm" name="frmAdmUsuarios" method="post" autocomplete="off" >
      <h1 id="alcentro">Administración Principal de Usuarios</h1>
      <h3 id="alcentro">Elementos del Menú (en Horizontal)</h3>
      <div id="capatres">
        <div><span>Referencia:</span></div>
        <div><span id="nota"><?php echo $unicalinea ?></span></div>
        <?php
          //! Para hacer seguimiento
          //# echo '<div><span id="nota">'.$quickmessage.'</span></div>';
        ?>
        <div><span id="notagruesa">Módulo/Aplicación/Área: <?php echo $DetalleApp ?></span></div>
        <?php
          echo '<input type="hidden" name="txtIdUsuario" value="'.$IdUsuario.'">';
          echo '<input type="hidden" name="txtUsuario" value="'.$Usuario.'">';
          echo '<input type="hidden" name="txtNombre" value="'.$Nombre.'">';
          echo '<input type="hidden" name="txtIdModulo" value="'.$idUserApp.'">';
          echo '<input type="hidden" name="txtModulo" value="'.$DetalleApp.'">';
          echo '<input type="hidden" name="txtQuickmessage" value="'.$quickmessage.'">';
        ?>
      </div>
      <div id="capados">
        <div><label for="txtItemMenu">Descripción del Item:</labe></div>
        <div><input type="text" name="txtItemMenu" id="txtItemMenu" value="" placeholder="Descripción del Item" maxlength="15" onkeyup="cItemMenu(this);"></div>
        <div id="aladerecha" class="lineadegradada margenderecho">
          <span id="chItemMenu" style="margin: 0em -.1875em;">
            <script>
              document.getElementById("chItemMenu").innerHTML = document.getElementById("txtItemMenu").maxLength.toString().trim();
            </script>
          </span>
          <span>/</span><span id="strItemMenu">
            <script>
              document.getElementById("strItemMenu").innerHTML = document.getElementById("txtItemMenu").maxLength;
            </script>
          </span>
        </div>
      </div>
      <div id="capados">
        <div><label for="numOrderL">Orden/Posición:</labe></div>
        <div><input type="number" name="numOrderL" id="numOrderL" value="" placeholder="Posición del Item" maxlength="2" onkeyup="cOrderL(this);"></div>
        <div id="aladerecha" class="lineadegradada margenderecho">
          <span id="chOrderL" style="margin: 0em -.1875em;">
            <script>
              document.getElementById("chOrderL").innerHTML = document.getElementById("numOrderL").maxLength.toString().trim();
            </script>
          </span>
          <span>/</span><span id="strOrderL">
            <script>
              document.getElementById("strOrderL").innerHTML = document.getElementById("numOrderL").maxLength;
            </script>
          </span>
        </div>
      </div>
      <!--
        //! ****************************************************
        //?  Colocar la Tabla con los Items del Menú Horizontal
        //#  Place the Table with Horizontal Menu Items
        //|  Umístění tabulky s položkami vodorovného menu
        //! ****************************************************
      -->
      <?php
        $TheCondition = "WHERE `usuario` = '$Usuario'";
        $theconnect = Connection();
        $FirstRecorset = Consulting( $theconnect, "*", "vw_consult_usuario_menuh", $TheCondition);
        if (is_object($FirstRecorset)) {
          $TotalItems = mysqli_num_rows($FirstRecorset);
          if ( $TotalItems > 0 ){
            echo '
                  <table>
                  <caption>Módulo/Área/Aplicación {'.$DetalleApp.'}</caption>
                  <thead>
                    <tr>
                      <th colspan="2">Elementos del Menú</th>
                    </tr>
                  </thead>
                  <tbody>
            ';
            mysqli_data_seek($FirstRecorset, 0);
            while ( $row = mysqli_fetch_assoc($FirstRecorset) ){
              echo '
                    <tr>
                      <td style="width:80%" >'.$row["menu"].'</td>
                      <td style="width:20%" >
                        <button style="padding: 0%;" type="submit" formaction="../formulare/Pass04UsersManagement.php?id='.$row["IdMenu"].'&menu='.$row["menu"].'&modulo='.$DetalleApp.'">
                          <img src="../demo/academico/img/png/places.png" alt="places.png" width="24" height="24">
                        </button>
                      </td>
                    </tr>
              ';
            }
            echo '
                  </tbody>
                  <tfoot>
                    <tr>
                      <td colspan="2" >Total: '.$TotalItems.'</td>
                    </tr>
                  </tfoot>
                </table>
            ';
          }
          mysqli_free_result($FirstRecorset);
        } else {
          $FirstRecorset = FALSE;
          $TotalItems = 0;
        }
        mysqli_close($theconnect);
      ?>
      <div id="centrado">
        <div class="tooltipd">
          <button type="submit" formaction="../formulare/Pass02UsersManagement.php" name="btnO3User">Anterior</button>
          <span class="tooltiptext">Pulse para Regresar e Ingresar Otro Módulo/Área/Aplicación...</span>
        </div>
        <div class="tooltipd">
          <button type="submit" name="btnOItem">Adicionar</button>
          <span class="tooltiptext">Pulse para Ingresar Otro Item para el Menú Horizontal...</span>
        </div>
        <div class="tooltipd">
          <button type="button" name="btnCancelar" onclick="s_and_c();">Salir</button>
          <span class="tooltiptext">Pulse para Salir de este formulario...</span>
        </div>
      </div>
      <div id="div-padre">
        <iframe src="../stranky/foot_note.html" name="ifootnote"></iframe>
      </div>
    </form>
  </div>
</body>
</html>