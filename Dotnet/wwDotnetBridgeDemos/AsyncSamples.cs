using System;
using System.Collections.Generic;
using System.Diagnostics;
using System.Linq;
using System.Net;
using System.Text;
using System.Threading;
using System.Threading.Tasks;
using Westwind.Utilities;

namespace wwDotnetBridgeDemos
{
    public class AsyncSamples
    {

        public object InvokeComMethod(string comProgId, string method, object[] parameters)
        {
            var com = ReflectionUtils.CreateComInstance(comProgId);
            if (com == null)
                return null;

            return ReflectionUtils.CallMethodCom(com, method, parameters);
        }

        public string LongRunningOperation(string url)
        {
            Thread.Sleep(4000);

            var http = new WebClient();
            http.Headers.Add("cache", "no-cache");
            return http.DownloadString(url);
        }



        /// <summary>
        /// Retrieve content of a URL synchronously
        /// </summary>
        /// <param name="url"></param>
        /// <returns></returns>
        public byte[] GetUrl(string url)
        {
            ServicePointManager.DefaultConnectionLimit = 30;

            Debug.WriteLine(Thread.CurrentThread.ManagedThreadId);

            var http = new WebClient();
            http.Headers.Add("cache", "no-cache");

            var rand = new Random();

            var timeout = rand.Next(200, 1000);
            Thread.Sleep(timeout);

            return http.DownloadData(url);
        }

        /// <summary>
        /// Async version that uses the .NET Task API to 
        /// run in non-blocking mode (true async)
        /// </summary>
        /// <param name="url"></param>
        /// <returns></returns>
        public async Task<byte[]> GetUrlAsync(string url)
        {
            ServicePointManager.DefaultConnectionLimit = 30;

            Debug.WriteLine(Thread.CurrentThread.ManagedThreadId);

            var http = new WebClient();
            http.Headers.Add("cache", "no-cache");

            var rand = new Random();

            var timeout = rand.Next(200, 1000);
            await Task.Delay(timeout);

            return await http.DownloadDataTaskAsync(url);
        }
    }
}
    