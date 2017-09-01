using System;
using System.Collections.Generic;
using System.Diagnostics;
using System.Linq;
using System.Threading.Tasks;
using Microsoft.AspNetCore.Mvc;
using mvc.Models;

namespace mvc.Controllers
{
    public class SubmissionController : Controller
    {
        public IActionResult Index()
        {
            Response.ContentType = "application/json";
            return View();
        }
        
        public IActionResult Nested()
        {
            Response.ContentType = "application/json";
            return View();
        }

        public IActionResult Error()
        {
            return View(new ErrorViewModel { RequestId = Activity.Current?.Id ?? HttpContext.TraceIdentifier });
        }
    }
}
