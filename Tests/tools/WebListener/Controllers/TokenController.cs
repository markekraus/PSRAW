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
    public class TokenController : Controller
    {
        static public Hashtable tokenObject = new Hashtable
        {
            {"access_token", "3fdd9e66-eaaa-4263-a834-a33cff22886e"},
            {"token_type"  , "bearer"},
            {"expires_in"  , 900},
            {"scope"       , "*"}
        };

        public JsonResult Index()
        {
            return Json(tokenObject);
        }
        public IActionResult Error()
        {
            return View(new ErrorViewModel { RequestId = Activity.Current?.Id ?? HttpContext.TraceIdentifier });
        }
    }
}
