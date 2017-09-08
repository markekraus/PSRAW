using System;
using System.Collections.Generic;
using System.IO;
using System.Linq;
using System.Net;
using System.Security.Authentication;
using System.Security.Cryptography.X509Certificates;
using System.Threading.Tasks;
using Microsoft.AspNetCore;
using Microsoft.AspNetCore.Hosting;
using Microsoft.AspNetCore.Server.Kestrel.Https;
using Microsoft.Extensions.Configuration;
using Microsoft.Extensions.Logging;



namespace mvc
{
    public class Program
    {
        public static void Main(string[] args)
        {
            if (args.Count() != 1)
            {
                System.Console.WriteLine("Required: <HTTPPortNumber>");  
                Environment.Exit(1); 
            }
            BuildWebHost(args).Run();
        }

        public static IWebHost BuildWebHost(string[] args) =>
            WebHost.CreateDefaultBuilder()
                .UseStartup<Startup>().UseKestrel(options =>
                {
                   options.Listen(IPAddress.Loopback, int.Parse(args[0]));
                })
                .Build();
    }
}
