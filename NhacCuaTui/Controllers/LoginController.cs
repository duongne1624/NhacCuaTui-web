using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.Mvc;
using NhacCuaTui.Models;

namespace NhacCuaTui.Controllers
{
    public class LoginController : Controller
    {
        // GET: Login
        public ActionResult Login()
        {
            return View();
        }
        [HttpPost]
        public ActionResult LoginAccount(string username, string password)
        {
            try
            {
                DataModel db = new DataModel();
                ViewBag.Login = db.get("exec UserLogin @Username = '" + username + "',"
                                        + "@Password = '" + password + "';");
                if (ViewBag.Login != null && ViewBag.Login.Count > 0)
                {
                    // Lưu thông tin người dùng vào Session
                    Session["userId"] = ViewBag.Login[0][0];
                    Session["username"] = ViewBag.Login[0][1];
                    Session["email"] = ViewBag.Login[0][2];
                    Session["phone"] = ViewBag.Login[0][3];
                    Session["fullname"] = ViewBag.Login[0][4];
                    Session["Role"] = ViewBag.Login[0][5];
                    Session["Password"] = password;

                    // Điều hướng dựa trên vai trò người dùng
                    string role = Session["Role"].ToString();
                    if (role.Equals("Nhân viên") || role.Equals("Người dùng"))
                    {
                        return Json(new { success = true, redirectUrl = Url.Action("Index", "Home") });
                    }
                    else if (role.Equals("Admin"))
                    {
                        return Json(new { success = true, redirectUrl = Url.Action("Index", "Dashboard", new { area = "Admin" }) });
                    }
                }
                else
                {
                    return Json(new { success = false, message = "Tên đăng nhập hoặc mật khẩu không đúng." });
                }
            }
            catch (Exception ex)
            {
                return Json(new { success = false, message = "Đã xảy ra lỗi: " + ex.Message });
            }

            return Json(new { success = false, message = "Đăng nhập thất bại." });
        }

        public ActionResult Register()
        {
            return View();
        }

        [HttpPost]
        public ActionResult RegisterAccount(string username,
                                    string password,
                                    string email,
                                    string phone,
                                    string fullname)
        {
            DataModel db = new DataModel();
            ViewBag.listUsers = db.get("EXEC GetAllUsers;");

            var existingUser = db.get("EXEC CheckUserExists @Username = '" + username + "';");
            if (existingUser != null && existingUser.Count > 0)
            {
                return Json(new { success = false, message = "Tên đăng nhập đã tồn tại." });
            }

            try
            {
                db.get("EXEC RegisterUser @Username = '" + username + "', " +
                        "@Password = '" + password + "', " +
                        "@Email = '" + email + "', " +
                        "@PhoneNumber = '" + phone + "', " +
                        "@Fullname = N'" + fullname + "'");

                ViewBag.Login = db.get("exec UserLogin @Username = '" + username + "',"
                                        + "@Password = '" + password + "';");
                Session["userId"] = ViewBag.Login[0][0];
                Session["username"] = ViewBag.Login[0][1];
                Session["email"] = ViewBag.Login[0][2];
                Session["phone"] = ViewBag.Login[0][3];
                Session["fullname"] = ViewBag.Login[0][4];
                Session["Role"] = ViewBag.Login[0][5];
                Session["Password"] = password;
                return Json(new { success = true });
            }
            catch (Exception ex)
            {
                return Json(new { success = false, message = "Đã xảy ra lỗi: " + ex.Message });
            }
        }

        public ActionResult LogOut()
        {
            Session["userId"] = null;
            Session["username"] = null;
            Session["email"] = null;
            Session["phone"] = null;
            Session["fullname"] = null;
            Session["Role"] = null;
            Session["Password"] = null;
            return RedirectToAction("Index", "Home");
        }
    }
}