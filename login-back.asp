<%@LANGUAGE="VBSCRIPT" CODEPAGE="65001"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "https://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="https://www.w3.org/1999/xhtml">
	<head>
		<title>Ingreso - Sistema de Encuestas TIC</title>
		<!--head-->
		<!-- #INCLUDE FILE="include\template\meta.inc" -->
		<!-- #INCLUDE FILE="include\template\loginhead.inc" -->
		<!--head-->
	</head>
	<%
	'Response.AddHeader "Refresh",CStr(CInt(Session.Timeout + 1) * 60)
	Response.AddHeader "cache-control", "private"
	Response.AddHeader "Pragma","No-Cache"
	Response.Buffer = TRUE
	Response.Expires = 0
	Response.ExpiresAbsolute = 0
	'Session.Contents.Removeall()  
    Session.Abandon		
	%>
	<body onload="noBack();" onpageshow="if (event.persisted) noBack();" onunload="" class="text-center justify-content-center">
	
		<!-- Table with panel -->					
		<div class="card card-cascade narrower">

			<!--Card image-->
			<div class="view view-cascade gradient-card-header blue-gradient narrower py-2 mx-4 mb-3 d-flex justify-content-center align-items-center">
				<!--<img class="mb-4  " src="img/logo_subtrab.png" alt="" width="150" height="150">-->
				
				<div class="text-left">Ingresa tus</div>

				<div id="UsrPhoto"></div>

				<div class="text-right">Credenciales</div>
					
		  </div>
		  <!--/Card image-->
		  
		  <form role="form" action="/valida-usuario" method="POST" name="login" id="login" class="form-signin needs-validation">
			
			<div>
				<div id="UsrPhoto">
				</div>
				<div>					
					<div class="md-form  " style="text-align:initial;">
						<div class="error-message input-field">						
							<i class="material-icons prefix">account_circle</i>							
							<input type="text" id="USR_Cod" name="USR_Cod" class="form-control validate" autofocus required>
							<label for="USR_Cod">Usuario</label>
							<!--<div class="valid-feedback">
								Se ve bien!
							</div>-->
						</div>						
					</div>					
					<div class="md-form " style="text-align:initial;">
						<div class="error-message input-field">
							<i class="material-icons prefix">vpn_key</i>
							<i class="far fa-eye-slash viewpass"></i>
						  	<input type="password" id="USR_Pass" name="USR_Pass" class="form-control validate" required>
							<label for="USR_Pass">Contraseña</label>							
						</div>						
					</div>
				</div>
			</div>
			
			<br/>
			<button class="btn btn-primary wow fadeInUp animated waves-effect" data-wow-offset="30" data-wow-duration="1.5s" data-wow-delay="0.15s" type="submit"><i class="fas fa-sign-in-alt"></i> Ingresar</button>
			<div class="card-footer text-muted text-center mt-4">			  
				<p class="text-muted" id="copyright" data-wow-offset="30" data-wow-duration="3.5s" data-wow-delay="0.35s">Sistema Dialogo Social v5.0 2020<br/>Subsecretaría del Trabajo</p>
				<div class="bicolor bottom ">
					<span class="azul"></span>
					<span class="rojo"></span>
				</div>
			</div>
						
		</form>	
		  
		</div>
		<!-- Table with panel -->
		
	</body>
</html>