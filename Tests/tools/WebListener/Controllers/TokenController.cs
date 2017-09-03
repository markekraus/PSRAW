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
            {"expires_in"  , 3600},
            {"scope"       , "*"}
        };

        static public Hashtable tokenInstalledObject = new Hashtable
        {
            {"access_token", "3fdd9e66-eaaa-4263-a834-a33cff22886e"},
            {"token_type"  , "bearer"},
            {"expires_in"  , 3600},
            {"scope"       , "*"},
            {"device_id"   , "06383696-d7cd-47ac-a5ce-45330c251215"}
        };

        public JsonResult Index()
        {
            return Json(tokenObject);
        }

        public JsonResult Installed(string device_id)
        {
            Hashtable response;
            if (String.IsNullOrEmpty(device_id))
            {
                response = tokenInstalledObject;
            }
            else
            {
                response = new Hashtable
                {
                    {"access_token", System.Guid.NewGuid().ToString()},
                    {"token_type"  , "bearer"},
                    {"expires_in"  , 3600},
                    {"scope"       , "*"},
                    {"device_id"   , device_id}
                };
            }
            return Json(response);
        }

        public JsonResult New()
        {
            Hashtable newToken = new Hashtable
            {
                {"access_token", System.Guid.NewGuid().ToString()},
                {"token_type"  , "bearer"},
                {"expires_in"  , 3600},
                {"scope"       , "*"}
            };
            return Json(newToken);
        }

        public IActionResult Error()
        {
            return View(new ErrorViewModel { RequestId = Activity.Current?.Id ?? HttpContext.TraceIdentifier });
        }
    }
}
