<%@LANGUAGE="VBSCRIPT" CODEPAGE="65001"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "https://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="https://www.w3.org/1999/xhtml">
	<head>
		<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
		<link rel="icon" href="img/favicon.ico">
		<title>Sistema Dialogo Social v5</title>
		<!-- Global site tag (gtag.js) - Google Analytics -->
		<script async src="https://www.googletagmanager.com/gtag/js?id=UA-24115378-13"></script>
		<script>
			window.dataLayer = window.dataLayer || [];
			function gtag(){dataLayer.push(arguments);}
			gtag('js', new Date());

			gtag('config', 'UA-24115378-13');
		</script>		
	</head>

	<body>
	<%		
		'dim i
		' dim j
		'j=Session.Contents.Count	
		'if j>=1 then
			If (Session("dialogosocialv5") <> Session.SessionID) Then				
				response.redirect("/ingreso-de-credenciales")							
			else
				if session("ds5_usrperfil")=5 then	'Administrativo'
					response.redirect("/home/bandeja-administrativa")
				else
					response.redirect("/home/bandeja-de-entrada")
				end if
			end if
		'else	
		''	response.redirect("/ingreso-de-credenciales")			
		'end if				
	%>
	</body>
</html>
<script>	
	window.history.forward();
	//window.history.back();
</script>
