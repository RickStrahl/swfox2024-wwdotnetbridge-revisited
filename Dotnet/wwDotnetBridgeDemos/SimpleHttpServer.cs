using System;
using System.Collections.Generic;
using System.Net.Sockets;
using System.Net;
using System.IO;
using System.Text;
using System.Threading;
using System.Windows.Forms;

namespace wwDotnetBridgeDemos
{
    /// <summary>
    /// A simple self-contained static file Web Server that can be
    /// launched in a folder with a port and serve static files
    /// from that folder.
    /// 
    /// Server can also be passed a FoxPro WebRequestHandler object
    /// that can intercept and handle requests in FoxPro code.
    /// 
    /// Very basic features but easy to integrate.
    /// 
    /// Not meant to be Internet facing, but can be used for inter
    /// application and inter-network communications, or to provide
    /// local Http services to local folders to run static or
    /// client side (Javascript, Vue, React, Angular etc.) 
    /// Web applications locally.
    /// </summary>
    /// <example>
    /// StartHttpServerOnThread(@"c:\temp\http",8080);
    /// ...
    /// StopHttpServerOnThread();
    ///     
    /// </example>
    /// <remarks>
    /// Additions to make it easier to host server inside of an
    /// external, non-.NET application.
    /// 
    /// Requires that the (non 80/442) HTTP port is allowed access 
    /// on non admin account. Use this syntax to register:
    /// 
    /// netsh http add urlacl url=http://*:21231/ user=Interactive listen=yes 
    /// 
    ///</remarks>
    public class SimpleHttpServer
    {
        public string[] DefaultDocuments =
        {
            "index.html",
            "index.htm",
            "default.html",
            "default.htm"
        };


        /// <summary>
        /// Static instance of the Http Server that's running on a
        /// background thread.
        /// </summary>
        public static SimpleHttpServer Current;


        /// <summary>
        /// This method can be used externally to start a singleton instance of 
        /// the Web Server and keep it running without tracking a reference.                
        /// 
        /// If a server instance is already running it's shut down then restarted
        /// with the new port info.
        /// </summary>
        /// <param name="path">Physical path on disk that is the Web root folder</param>
        /// <param name="port">Port to run server on</param>        
        /// <param name="requestHandler">
        /// Optional parameter of an object that has a Process(Context,Response) method that gets passed a context 
        /// and returns true if the request is handled or false if default processing should occur
        /// </param>
        public static bool StartHttpServerOnThread(string path, int port = 8080, object requestHandler = null)
        {
            // make sure we're not already running
            if (Current != null)
                Current.Stop();

            try
            {
                // see if we can access the port
                TcpListener listener = new TcpListener(IPAddress.Loopback, port);
                listener.Start();
                listener.Stop();
            }
            catch
            {
                return false;
            }

            var t = new Thread(StartHttpServerThread);

            // STA Thread so VFP COM objects can work
            t.SetApartmentState(ApartmentState.STA);

            t.Start(new ServerStartParameters {Path = path, Port = port, RequestHandler = requestHandler});

            return true;
        }

        /// <summary>
        /// Call this method to stop the Singleton instance of the server.
        /// </summary>
        public static void StopHttpServerOnThread()
        {
            Current.Stop();
            Current = null;
        }


        /// <summary>
        /// Internal method that instantiates the server instance
        /// </summary>
        /// <param name="parms"></param>
        private static void StartHttpServerThread(object parms)
        {
            try
            {
                if (Current != null)
                    StopHttpServerOnThread();

                var httpParms = parms as ServerStartParameters;
                Current = new SimpleHttpServer(httpParms.Path, httpParms.Port);
                Current.RequestHandler = httpParms.RequestHandler;
            }
            catch (Exception ex)
            {
                MessageBox.Show(ex.Message, "Html Help Builder: Error loading HTTP Service",
                    MessageBoxButtons.OK, MessageBoxIcon.Error);
            }
        }


        /// <summary>
        /// Mime Type conversion table
        /// </summary>
        private static IDictionary<string, string> _mimeTypeMappings =
            new Dictionary<string, string>(StringComparer.InvariantCultureIgnoreCase)
            {
                #region extension to MIME type list
                {".asf", "video/x-ms-asf"},
                {".asx", "video/x-ms-asf"},
                {".avi", "video/x-msvideo"},
                {".bin", "application/octet-stream"},
                {".cco", "application/x-cocoa"},
                {".crt", "application/x-x509-ca-cert"},
                {".css", "text/css"},
                {".deb", "application/octet-stream"},
                {".der", "application/x-x509-ca-cert"},
                {".dll", "application/octet-stream"},
                {".dmg", "application/octet-stream"},
                {".ear", "application/java-archive"},
                {".eot", "application/octet-stream"},
                {".exe", "application/octet-stream"},
                {".flv", "video/x-flv"},
                {".gif", "image/gif"},
                {".hqx", "application/mac-binhex40"},
                {".htc", "text/x-component"},
                {".htm", "text/html"},
                {".html", "text/html"},
                {".ico", "image/x-icon"},
                {".img", "application/octet-stream"},
                {".iso", "application/octet-stream"},
                {".jar", "application/java-archive"},
                {".jardiff", "application/x-java-archive-diff"},
                {".jng", "image/x-jng"},
                {".jnlp", "application/x-java-jnlp-file"},
                {".jpeg", "image/jpeg"},
                {".jpg", "image/jpeg"},
                {".js", "application/x-javascript"},
                {".mml", "text/mathml"},
                {".mng", "video/x-mng"},
                {".mov", "video/quicktime"},
                {".mp3", "audio/mpeg"},
                {".mpeg", "video/mpeg"},
                {".mpg", "video/mpeg"},
                {".msi", "application/octet-stream"},
                {".msm", "application/octet-stream"},
                {".msp", "application/octet-stream"},
                {".pdb", "application/x-pilot"},
                {".pdf", "application/pdf"},
                {".pem", "application/x-x509-ca-cert"},
                {".pl", "application/x-perl"},
                {".pm", "application/x-perl"},
                {".png", "image/png"},
                {".prc", "application/x-pilot"},
                {".ra", "audio/x-realaudio"},
                {".rar", "application/x-rar-compressed"},
                {".rpm", "application/x-redhat-package-manager"},
                {".rss", "text/xml"},
                {".run", "application/x-makeself"},
                {".sea", "application/x-sea"},
                {".shtml", "text/html"},
                {".sit", "application/x-stuffit"},
                {".swf", "application/x-shockwave-flash"},
                {".tcl", "application/x-tcl"},
                {".tk", "application/x-tcl"},
                {".txt", "text/plain"},
                {".war", "application/java-archive"},
                {".wbmp", "image/vnd.wap.wbmp"},
                {".wmv", "video/x-ms-wmv"},
                {".xml", "text/xml"},
                {".xpi", "application/x-xpinstall"},
                {".zip", "application/zip"},

                #endregion
            };

        private Thread _serverThread;
        private string _rootDirectory;
        private HttpListener _listener;
        private int _port;

        public int Port
        {
            get { return _port; }
        }


        /// <summary>
        /// Instance of an object whose Process() method is called on each request.
        /// Return true if the reuqest is handled, fase if it's not.
        /// </summary>
        public object RequestHandler { get; set; }

        /// <summary>
        /// Construct server with given port.
        /// </summary>
        /// <param name="path">Directory path to serve.</param>
        /// <param name="port">Port of the server.</param>
        public SimpleHttpServer(string path, int port = 8080)
        {
            Initialize(path, port);
        }



        /// <summary>
        /// Construct server with an available port.
        /// </summary>
        /// <param name="path">Directory path to serve.</param>
        public SimpleHttpServer(string path)
        {
            // Find an open port and bind to it
            TcpListener listener = new TcpListener(IPAddress.Loopback, 0);
            listener.Start();
            int port = ((IPEndPoint) listener.LocalEndpoint).Port;
            listener.Stop();

            Initialize(path, port);
        }

        private void Initialize(string path, int port)
        {
            _rootDirectory = path;
            _port = port;
            _serverThread = new Thread(Listen);
            _serverThread.SetApartmentState(ApartmentState.STA);
            _serverThread.Start();
        }

        /// <summary>
        /// Stop server and dispose all functions.
        /// </summary>
        public void Stop()
        {
            _serverThread.Abort();
            _listener.Stop();
        }

        /// <summary>
        /// Internal Listener Handler that starts the listener and 
        /// then waits for incoming requests (GetContext)
        /// </summary>
        private void Listen()
        {
            try
            {
                _listener = new HttpListener();
                _listener.Prefixes.Add("http://*:" + _port + "/");
                _listener.Start();
            }
            catch (Exception ex)
            {
                MessageBox.Show("The HttpListener could not start. Most likely port " + _port +
                                " has not been configured to allow access by non-admin users.\r\n\r\n" +
                                "Use:\r\n\r\n" +
                                $"netsh http add urlacl url=http://*:{_port}/ user=Interactive listen=yes\r\n\r\n" +
                                "Error message:\r\n" +
                                ex.Message,
                    "HttpListener could not start", MessageBoxButtons.OK, MessageBoxIcon.Error);

                Clipboard.SetText($"netsh http add urlacl url=http://*:{_port}/ user=Interactive listen=yes");
                return;
            }

            while (true)
            {
                try
                {
                    HttpListenerContext context = _listener.GetContext();
                    Process(context);
                }
                catch (Exception ex)
                {
                    Console.WriteLine("Error: " + ex.Message);
                }
            }
        }


        /// <summary>
        /// Process an individual request. Handles only static file based requests
        /// </summary>
        /// <param name="context"></param>
        private void Process(HttpListenerContext context)
        {
            string filename = context.Request.Url.AbsolutePath;
            Console.WriteLine(filename);

            if (RequestHandler != null)
            {
                var response = new HttpResponse(context);

                // process passed in Event handler and it's Process() method
                // if it returns true exist - otherwise let internal static files be served
                dynamic handler = RequestHandler;

                bool result = false;
                try
                {
                    result = (bool) handler.Process(context, response);
                }
                catch (Exception ex)
                {
                    // foxpro exception so we don't crash
                    response.WriteOutput("An error occurred during processing: " + ex.Message, "text/plain");
                    return;
                }
                if (result)
                    return; // we handled it in FoxPro                
            }

            // *** Otherwise try to serve the file from disk
            filename = filename.Substring(1);

            if (string.IsNullOrEmpty(filename))
            {
                foreach (string indexFile in DefaultDocuments)
                {
                    if (File.Exists(Path.Combine(_rootDirectory, indexFile)))
                    {
                        filename = indexFile;
                        break;
                    }
                }
            }

            filename = Path.Combine(_rootDirectory, filename);

            if (File.Exists(filename))
            {
                try
                {
                    Stream input = new FileStream(filename, FileMode.Open);

                    //Adding permanent http response headers
                    string mime;
                    context.Response.ContentType = _mimeTypeMappings.TryGetValue(Path.GetExtension(filename), out mime)
                        ? mime
                        : "application/octet-stream";
                    context.Response.ContentLength64 = input.Length;
                    context.Response.AddHeader("Date", DateTime.Now.ToString("r"));
                    context.Response.AddHeader("Last-Modified", File.GetLastWriteTime(filename).ToString("r"));

                    byte[] buffer = new byte[1024*32];
                    int nbytes;
                    while ((nbytes = input.Read(buffer, 0, buffer.Length)) > 0)
                        context.Response.OutputStream.Write(buffer, 0, nbytes);
                    input.Close();
                    context.Response.OutputStream.Flush();

                    context.Response.StatusCode = (int) HttpStatusCode.OK;
                }
                catch (Exception)
                {
                    context.Response.StatusCode = (int) HttpStatusCode.InternalServerError;
                }

            }
            else
            {
                context.Response.StatusCode = (int) HttpStatusCode.NotFound;
            }

            context.Response.OutputStream.Close();
        }
    }

    /// <summary>
    /// Parameters that are passed to the thread method
    /// </summary>
    public class ServerStartParameters
    {
        public string Path { get; set; }
        public int Port { get; set; }

        /// <summary>
        ///  Any object that implements a Process method
        ///  method should return true (request is handled) 
        /// or false (to fall through and handle as files)
        /// </summary>
        public object RequestHandler { get; set; }
    }


    /// <summary>
    /// Response helper class that simplifies sending output
    /// to the server.
    /// </summary>
    public class HttpResponse
    {
        private HttpListenerContext Context;

        public HttpResponse(HttpListenerContext context)
        {
            Context = context;
        }

        public void WriteOutput(string output, string contentType)
        {
            if (string.IsNullOrEmpty(contentType))
                contentType = "text/html";

            Context.Response.ContentType = contentType;

            var buf = Encoding.UTF8.GetBytes(output);
            Context.Response.ContentLength64 = buf.Length;
            Context.Response.OutputStream.Write(buf, 0, buf.Length);
        }


        public void Write(string output)
        {
            var buf = Encoding.UTF8.GetBytes(output);
            Context.Response.OutputStream.Write(buf, 0, buf.Length);
        }
    }
}