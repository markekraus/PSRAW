using System;
using System.Collections;
using System.Collections.Generic;
using System.Diagnostics;
using System.Linq;
using System.Threading.Tasks;
using Microsoft.AspNetCore.Mvc;
using mvc.Models;

namespace mvc.Controllers
{
    public class EchoController : Controller
    {
        public ContentResult Index(string Body)
        {
            Response.Headers.Clear();
            foreach (var key in Request.Query.Keys)
            {
                if(key.ToLower() == "body")
                {
                    continue;
                }
                if (key.ToLower() == "statuscode")
                {
                    Response.StatusCode = int.Parse(Request.Query[key]);
                    continue;
                }
                Response.Headers.Add(key,Request.Query[key]);
            }
            return Content(Body);
        }
        public IActionResult Error()
        {
            return View(new ErrorViewModel { RequestId = Activity.Current?.Id ?? HttpContext.TraceIdentifier });
        }
    }
}
