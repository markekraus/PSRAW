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
    public class UserController : Controller
    {
        public JsonResult Index()
        {
            Hashtable output = new Hashtable
            {
                {"comment_karma"     , 0}, 
                {"created"           , 1389649907.0}, 
                {"created_utc"       , 1389649907.0}, 
                {"has_mail"          , false}, 
                {"has_mod_mail"      , false}, 
                {"has_verified_email", null}, 
                {"id"                , "1"}, 
                {"is_gold"           , false}, 
                {"is_mod"            , true}, 
                {"link_karma"        , 1}, 
                {"name"              ,"reddit_bot"}, 
                {"over_18"           , true}
            };
            return Json(output);
        }
        public IActionResult Error()
        {
            return View(new ErrorViewModel { RequestId = Activity.Current?.Id ?? HttpContext.TraceIdentifier });
        }
    }
}
