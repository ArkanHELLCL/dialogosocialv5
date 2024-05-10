<%
    Option Explicit
    On Error Resume Next
    
    Dim strUrlRoot
    Dim strHttpHost
    Dim strUserAgent

    Response.Clear
    Response.Buffer = True
    Response.ContentType = "text/plain"
    Response.CacheControl = "public"

    Response.Write "# Robots.txt" & vbCrLf
    Response.Write "# For more information on this file see:" & vbCrLf
    Response.Write "# https://www.robotstxt.org/" & vbCrLf & vbCrLf

    strHttpHost = LCase(Request.ServerVariables("HTTP_HOST"))
    strUserAgent = LCase(Request.ServerVariables("HTTP_USER_AGENT"))
    strUrlRoot = "http://" & strHttpHost

    Response.Write "# Define the sitemap path" & vbCrLf
    Response.Write "Sitemap: " & strUrlRoot & "/sitemap.xml" & vbCrLf & vbCrLf

    Response.Write "# Make changes for all web spiders" & vbCrLf
    Response.Write "User-agent: *" & vbCrLf
    Response.Write "Allow: /" & vbCrLf
    Response.Write "Disallow: " & vbCrLf
    Response.End
%>