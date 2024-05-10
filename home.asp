<%@LANGUAGE="VBSCRIPT" CODEPAGE="65001"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "https://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="https://www.w3.org/1999/xhtml">
	<head>
		<!--head-->
		<!-- Global site tag (gtag.js) - Google Analytics -->
		<script async src="https://www.googletagmanager.com/gtag/js?id=UA-24115378-13"></script>
		<script>
			window.dataLayer = window.dataLayer || [];
			function gtag(){dataLayer.push(arguments);}
			gtag('js', new Date());

			gtag('config', 'UA-24115378-13');
		</script>


		<!-- Google Tag Manager -->
		<script>(function(w,d,s,l,i){w[l]=w[l]||[];w[l].push({'gtm.start':
		new Date().getTime(),event:'gtm.js'});var f=d.getElementsByTagName(s)[0],
		j=d.createElement(s),dl=l!='dataLayer'?'&l='+l:'';j.async=true;j.src=
		'https://www.googletagmanager.com/gtm.js?id='+i+dl;f.parentNode.insertBefore(j,f);
		})(window,document,'script','dataLayer','GTM-PQVT5BP');</script>
		<!-- End Google Tag Manager -->
		<!-- #INCLUDE FILE="include\template\session.inc" -->
		<!-- #INCLUDE FILE="include\template\meta.inc" -->
		<!-- #INCLUDE FILE="include\template\escritorio.inc" -->
		<!--head-->	
		<title>Escritorio <%=ds5_usuario%> - Sistema Dialogo Social v5</title>
	</head><%
	servername=Request.ServerVariables("SERVER_NAME")
	if(servername="dev.dialogosocial.cl") then	'Desarrollo
	%>
	<div class="alert alert-danger" role="alert" style="position: fixed;top: 0;width: 100%;padding: 0.02rem 1.25rem;">
		Máquina de desarrollo Servidor:<%=servername%>
	</div>
	<%
	end if
	menu=request("nompage")
	submenu=request("submenu")
	accion=request("accion")
	
	
	'Usuarios Modificar
	user_id=request("user_id")		
	tok1=request("tok1")
	tok2=request("tok2")
	tok3=request("tok3")
	tok4=request("tok4")
	tok5=request("tok5")
	token=tok1 & "-" & tok2 & "-" & tok3 & "-" & tok4 & "-" & tok5		
	'Usuario Modificar
	
	
	'Acciones 1K
	key=request("key")
	'Acciones 2K
	key2=request("key2")
	key3=request("key3")
	
	param=""		
	'Lista negra
	'response.write(menu &"/"& submenu & "/" & accion & "/" & key & "/" & key2 & "/" & key3)
	'response.end
	if(lcase(menu)="user-ldap") then
		response.redirect("/bandeja-de-entrada")
	end if
	
	if (menu<>"") and (submenu<>"") and ((accion<>"") and not IsNumeric(accion)) then			
		page=menu & "." & submenu & "." & accion			
		'Usuarios
		'if (trim(submenu)="usuarios" and trim(accion)="modificar" and (user_id<>"") and (token<>"")) or (trim(submenu)="usuarios" and trim(accion)="visualizar" and (user_id<>"") and (token<>"")) then
		''	param="data-keys='2' data-key1='" & user_id & "' data-key2='" & token & "'"
		'else
			'if (trim(submenu)="tipos-de-documento" and trim(accion)="modificar" and (key<>"")) or (trim(submenu)="tipos-de-documento" and trim(accion)="visualizar" and (key<>"")) then
			''	param="data-keys='1' data-key1='" & key & "'"
			'else
			''	if (trim(submenu)="complejidad" and trim(accion)="modificar" and (key<>"")) or (trim(submenu)="complejidad" and trim(accion)="visualizar" and (key<>"")) then
			''		param="data-keys='1' data-key1='" & key & "'"
			''	else
			''		if (trim(submenu)="departamento" and trim(accion)="modificar" and (key<>"")) or (trim(submenu)="departamento" and trim(accion)="visualizar" and (key<>"")) then
			''			param="data-keys='1' data-key1='" & key & "'"
			''		else						
			''			if (trim(submenu)="perfiles" and trim(accion)="modificar" and (key<>"")) or (trim(submenu)="perfiles" and trim(accion)="visualizar" and (key<>"")) then
			''				param="data-keys='1' data-key1='" & key & "'"
			''			else
							
			''			end if
			''		end if
			''	end if
			'end if
		'end if
	else
		if (menu<>"") and (submenu<>"" ) and not IsNumeric(accion) then				
			page=menu & "." & submenu
		else				
			'response.write("SI")
			'response.write("data-keys='1' data-key1='" & accion & "'"	)
			'response.write(menu & "/" & submenu & "/" & accion & "/" & key)
			'menu y accion												
			if ((  (trim(menu)="bandeja-de-entrada" or trim(menu)="bandeja-administrativa" or trim(menu)="bandeja-ejecucion-presupuestaria") and trim(submenu)="agregar" and accion<>"" and key="")) then
				page=menu & "." & submenu
				param="data-keys='1' data-key1='" & accion & "'"
				'response.write("si")
			else
				if (((trim(menu)="bandeja-de-entrada" or trim(menu)="bandeja-administrativa" or trim(menu)="bandeja-ejecucion-presupuestaria") and trim(submenu)="modificar" and (accion<>"") and key<>"" and key2="" and key3="") or ((trim(menu)="bandeja-de-entrada" or trim(menu)="bandeja-administrativa" or trim(menu)="bandeja-ejecucion-presupuestaria") and trim(submenu)="visualizar" and (accion<>"") and key<>"" and key2="" and key3="")) then
					page=menu & "." & submenu
					param="data-keys='2' data-key1='" & accion & "'" & "data-key2='" & key & "'"
					'response.write("si")
				else
					if (((trim(menu)="bandeja-de-entrada" or trim(menu)="bandeja-administrativa" or trim(menu)="bandeja-ejecucion-presupuestaria") and trim(submenu)="modificar" and (accion<>"") and key<>"" and key2<>"" and key3="") or ((trim(menu)="bandeja-de-entrada" or trim(menu)="bandeja-administrativa" or trim(menu)="bandeja-ejecucion-presupuestaria") and trim(submenu)="visualizar" and (accion<>"") and key<>"" and key2<>"" and key3="")) then
						page=menu & "." & submenu
						param="data-keys='3' data-key1='" & accion & "'" & "data-key2='" & key & "'" & "data-key3='" & key2 & "'"
						'response.write("si")
					else
						if (((trim(menu)="bandeja-de-entrada" or trim(menu)="bandeja-administrativa" or trim(menu)="bandeja-ejecucion-presupuestaria") and trim(submenu)="modificar" and (accion<>"") and key<>"" and key2<>"" and key3<>"") or ((trim(menu)="bandeja-de-entrada" or trim(menu)="bandeja-administrativa" or trim(menu)="bandeja-ejecucion-presupuestaria") and trim(submenu)="visualizar" and (accion<>"") and key<>"" and key2<>"" and key<>"")) then
							page=menu & "." & submenu
							param="data-keys='4' data-key1='" & accion & "'" & "data-key2='" & key & "'" & "data-key3='" & key2 & "'" & "data-key4='" & key3 & "'"
							'response.write("si")
						else
							if (((trim(menu)="mantenedores" or trim(menu)="reportes") and submenu<>"" and accion="")) then
								page=menu ''& "." & submenu
								param="data-keys='2' data-key1='" & menu & "'" & "data-key2='" & submenu & "'"
								'response.write("Entre")
							else
						
								if (menu<>"") and (submenu<>"" ) then
									page=menu & "." & submenu										
								else
									page=menu
								end if
								
							end if
						end if
					end if
				end if
			end if				
		end if
	end if		
				
	%>
	<body class="text-center" data-id="<%=page%>" <%response.write(param)%> id="ds_body">
		<!-- Google Tag Manager (noscript) -->
		<noscript><iframe src="https://www.googletagmanager.com/ns.html?id=GTM-PQVT5BP"
		height="0" width="0" style="display:none;visibility:hidden"></iframe></noscript>
		<!-- End Google Tag Manager (noscript) -->

		<div class="py-1 content" style="width:100%">
			<div class="container-fluid">
			  	<div class="row">
					<!--<div class="col-1" id="menubody"></div>-->
					<div class="col-md-12">
					
						<div class="py-1">
							<div class="container-fluid">
								<div class="row">
									<div class="col-md-6" id="breadcrumbbody"></div>
									<div class="col-md-6" id="perfilbody"></div>
								</div>
								<div class="row">
									<div class="col-md-12" id="contenbody"></div>
								</div>
							</div>
						</div>
						
					</div>
				</div>
			</div>			
		</div>
		
	</body>
	<footer>
		<!-- #INCLUDE FILE="include\template\footer.inc" -->
	</footer>	
</html>
<div id="descargas">
	<div class="wrapper">
		<div class="desarrow"><i class="fas fa-caret-up text-primary"></i></div>
		<header>Descarga de Informes</header>		
		<section class="progress-area"></section>
		<section class="uploaded-area"></section>
	</div>
</div>