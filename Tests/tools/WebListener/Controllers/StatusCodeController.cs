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
    public class StatusCodeController : Controller
    {
        public JsonResult Index(Int32 StatusCode)
        {
            Response.StatusCode = StatusCode;
            Hashtable output = new Hashtable
            {
                {"StatusCode" , StatusCode}, 
            };
            return Json(output);
        }
        public IActionResult Error()
        {
            return View(new ErrorViewModel { RequestId = Activity.Current?.Id ?? HttpContext.TraceIdentifier });
        }
    }
}
