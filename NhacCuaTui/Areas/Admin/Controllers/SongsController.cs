using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.Mvc;
using System.IO;
using NhacCuaTui.Models;

namespace NhacCuaTui.Areas.Admin.Controllers
{
    public class SongsController : Controller
    {
        DataModel db = new DataModel();
        // GET: Admin/Songs
        public ActionResult Index()
        {
            if (Session["Role"] == null)
            {
                return Redirect("~/Login/Login");
            }
            if (Session["Role"].Equals("Admin"))
            {
                ViewBag.listSongs = db.get("EXEC GetAllSongs");
                return View();
            }
            else
            {
                return Redirect("~/Home/Index");
            }
        }

        public ActionResult AddSong()
        {
            if (Session["Role"] == null)
            {
                return Redirect("~/Login/Login");
            }
            if (Session["Role"].Equals("Admin"))
            {
                ViewBag.listAlbums = db.get("EXEC GetAlbumWithArtists");
                ViewBag.listGenres = db.get("EXEC GetAllGenres");
                return View();
            }
            else
            {
                return Redirect("~/Home/Index");
            }
        }

        [HttpPost]
        public ActionResult ThemBaiHat(string songname,
                               int album_id,
                               int genre_id,
                               string lyrics,
                               DateTime release_date,
                               HttpPostedFileBase file,
                               HttpPostedFileBase thumbnail_image)
        {
            // Kiểm tra quyền Admin
            if (Session["Role"].Equals("Admin") == false)
            {
                return Redirect("~/Home/Index");
            }

            try
            {
                // Đường dẫn và xử lý file nhạc
                string filePath = null;
                if (file != null && file.ContentLength > 0)
                {
                    string fileName = Path.GetFileName(file.FileName);
                    filePath = Path.Combine(Server.MapPath("~/Source/Songs"), fileName);
                    file.SaveAs(filePath);
                }
                else
                {
                    Session["AddSong_Error"] = "File nhạc không được để trống.";
                    return RedirectToAction("AddSong", "Songs", "Admin");
                }

                // Đường dẫn và xử lý ảnh thumbnail
                string thumbnailPath = "default-thumbnail.jpg"; // Ảnh mặc định
                if (thumbnail_image != null && thumbnail_image.ContentLength > 0)
                {
                    string thumbnailName = Path.GetFileName(thumbnail_image.FileName);
                    thumbnailPath = Path.Combine(Server.MapPath("~/Source/Song-Thumbnails"), thumbnailName);
                    thumbnail_image.SaveAs(thumbnailPath);
                }
                db.get("EXEC AddSong " +
                        "@SongName = N'" + songname + "', " +
                        "@AlbumID = " + album_id + ", " +
                        "@GenreID = " + genre_id + ", " +
                        "@Lyrics = N'" + lyrics + "', " +
                        "@ReleaseDate = '" + release_date.ToString("yyyy-MM-dd") + "', " +
                        "@FileName = N'" + file.FileName + "', " +
                        "@ThumbnailImage = N'" + thumbnail_image?.FileName + "';");

                return RedirectToAction("Index", "Songs", "Admin");
            }
            catch (Exception)
            {
                Session["AddSong_Error"] = "Có lỗi xảy ra khi thêm bài hát.";
            }

            return RedirectToAction("AddSong", "Songs", "Admin");
        }



        public ActionResult EditSong(int id)
        {
            if (Session["Role"] == null)
            {
                return Redirect("~/Login/Login");
            }
            if (Session["Role"].Equals("Admin"))
            {
                ViewBag.GetSongById = db.get("EXEC GetSongById " + id + ";");
                ViewBag.listAlbums = db.get("EXEC GetAlbumWithArtists");
                ViewBag.listGenres = db.get("EXEC GetAllGenres");
                return View();
            }
            else
            {
                return Redirect("~/Login/Login");
            }
        }

        [HttpPost]
        public ActionResult SuaBaiHat(int song_id,
                              string songname,
                              int album_id,
                              int genre_id,
                              string lyrics,
                              DateTime release_date,
                              string file_name,
                              HttpPostedFileBase file,
                              string thumbnail_image,
                              HttpPostedFileBase thumbnail_image2)
        {
            if (Session["Role"].Equals("Admin") == false)
            {
                return Redirect("~/Home/Index");
            }

            try
            {
                DataModel db = new DataModel();

                // Kiểm tra và xử lý file bài hát mới
                if (file != null && file.ContentLength > 0)
                {
                    string newFileName = Path.GetFileName(file.FileName);
                    string filePath = Path.Combine(Server.MapPath("~/Source/Songs"), newFileName);
                    file.SaveAs(filePath);
                    file_name = newFileName; // Cập nhật tên file mới
                }

                // Kiểm tra và xử lý ảnh thumbnail mới
                if (thumbnail_image2 != null && thumbnail_image2.ContentLength > 0)
                {
                    string newThumbnailName = Path.GetFileName(thumbnail_image2.FileName);
                    string thumbnailPath = Path.Combine(Server.MapPath("~/Source/Song-Thumbnails"), newThumbnailName);
                    thumbnail_image2.SaveAs(thumbnailPath);
                    thumbnail_image = newThumbnailName; // Cập nhật tên ảnh mới
                }

                // Gọi Stored Procedure để cập nhật bài hát
                db.get("EXEC UpdateSongById " +
                       "@SongId = " + song_id + ", " +
                       "@SongName = N'" + songname + "', " +
                       "@AlbumID = " + album_id + ", " +
                       "@GenreID = " + genre_id + ", " +
                       "@Lyrics = N'" + lyrics + "', " +
                       "@ReleaseDate = '" + release_date.ToString("yyyy-MM-dd") + "', " +
                       "@FileName = N'" + file_name + "', " +
                       "@ThumbnailImage = N'" + thumbnail_image + "';");

                return RedirectToAction("Index", "Songs", "Admin");
            }
            catch (Exception)
            {
                Session["EditSong_Error"] = "Có lỗi xảy ra khi sửa bài hát.";
            }

            return RedirectToAction("EditSong", "Songs", "Admin");
        }


        public ActionResult XoaBaiHat(int id)
        {
            if (Session["Role"] == null)
            {
                return Redirect("~/Login/Login");
            }

            if (!Session["Role"].Equals("Admin"))
            {
                return Redirect("~/Home/Index");
            }

            try
            {
                DataModel db = new DataModel();
                db.get("EXEC DeleteSong @SongId = " + id + ";");
                return RedirectToAction("Index", "Songs", "Admin");
            }
            catch (Exception)
            {
                Session["DeleteSong_Error"] = "Có lỗi xảy ra khi xóa bài hát.";
                return RedirectToAction("Index", "Songs", "Admin");
            }
        }

    }
}