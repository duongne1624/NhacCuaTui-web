using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.Mvc;
using NhacCuaTui.Models;

namespace NhacCuaTui.Areas.Admin.Controllers
{
    public class GenresController : Controller
    {
        // GET: Admin/Genres
        public ActionResult Index()
        {
            if (Session["Role"] == null)
            {
                return Redirect("~/Login/Login");
            }
            if (Session["Role"].Equals("Admin"))
            {
                DataModel db = new DataModel();
                ViewBag.listGenres = db.get("EXEC GetAllGenres;");
                return View();
            }
            else
            {
                return Redirect("~/Home/Index");
            }
        }
    }
}