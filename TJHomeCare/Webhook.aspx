<%@ Page Language="C#" AutoEventWireup="true" %>
<%@ Import Namespace="System.IO" %>
<script runat="server">
    // Simple Zaakpay webhook receiver for testing.
    // Logs whatever Zaakpay sends and replies 200 OK.
    protected void Page_Load(object sender, EventArgs e)
    {
        try
        {
            string body;
            Request.InputStream.Position = 0;
            using (var r = new StreamReader(Request.InputStream)) body = r.ReadToEnd();

            var line = DateTime.Now.ToString("yyyy-MM-dd HH:mm:ss") +
                       " | " + Request.HttpMethod +
                       " | ct=" + Request.ContentType +
                       " | body=" + body +
                       " | form=" + Request.Form.ToString() + Environment.NewLine;

            string dir = Server.MapPath("~/App_Data");
            if (!Directory.Exists(dir)) Directory.CreateDirectory(dir);
            File.AppendAllText(Path.Combine(dir, "zaakpay-webhook.log"), line);
        }
        catch { /* never fail the webhook because of logging */ }

        Response.Clear();
        Response.StatusCode = 200;
        Response.ContentType = "text/plain";
        Response.Write("OK");
        Response.End();
    }
</script>
