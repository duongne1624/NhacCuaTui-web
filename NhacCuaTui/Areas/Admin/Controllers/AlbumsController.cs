using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.Mvc;
using System.IO;
using NhacCuaTui.Models;

namespace NhacCuaTui.Areas.Admin.Controllers
{
    public class AlbumsController : Controller
    {
        // GET: Admin/Albums
        public ActionResult Index()
        {
            if (Session["Role"] == null)
            {
                return Redirect("~/Login/Login");
            }
            if (Session["Role"].Equals("Admin"))
            {
                DataModel db = new DataModel();
                ViewBag.listAlbums = db.get("EXEC GetAlbumWithArtists");
                return View();
            }
            else
            {
                return Redirect("~/Home/Index");
            }
        }

        public ActionResult AddAlbum()
        {
            if (Session["Role"] == null)
            {
                return Redirect("~/Login/Login");
            }
            if (Session["Role"].Equals("Admin"))
            {
                DataModel db = new DataModel();
                ViewBag.listArtists = db.get("EXEC GetAllArtists");
                ViewBag.listSongs = db.get("EXEC GetAllSongs");
                ViewBag.listGenres = db.get("EXEC GetAllGenres");
                return View();
            }
            else
            {
                return Redirect("~/Home/Index");
            }
        }

        [HttpPost]
        public ActionResult ThemAlbum(string albumname, int artist_id, DateTime release_date,
                              HttpPostedFileBase cover_image, List<int> existing_songs,
                              List<NewSongModel> new_songs)
        {
            if (Session["Role"] == null || !Session["Role"].Equals("Admin"))
            {
                return Redirect("~/Home/Index");
            }

            try
            {
                // Xử lý ảnh bìa album
                string coverImageName = "default-cover.jpg";
                if (cover_image != null && cover_image.ContentLength > 0)
                {
                    coverImageName = Path.GetFileName(cover_image.FileName);
                    string path = Path.Combine(Server.MapPath("~/Source/Albums-Cover"), coverImageName);
                    cover_image.SaveAs(path);
                }

                // Gọi Stored Procedure để thêm Album
                DataModel db = new DataModel();
                db.get("EXEC AddAlbum @AlbumName = N'" + albumname + "', " +
                       "@ArtistID = " + artist_id + ", " +
                       "@ReleaseDate = '" + release_date.ToString("yyyy-MM-dd") + "', " +
                       "@CoverImage = N'" + coverImageName + "';");

                // Lấy AlbumId của album vừa thêm
                int albumId = Convert.ToInt32(db.getScalar("SELECT MAX(album_id) FROM Albums"));


                // Thêm bài hát hiện có vào Album (nếu có)
                if (existing_songs != null)
                {
                    foreach (int songId in existing_songs)
                    {
                        db.get("EXEC AddSongToAlbum @AlbumId = " + albumId + ", @SongId = " + songId + ";");
                    }
                }

                // Thêm bài hát mới vào Album (nếu có)
                if (new_songs != null)
                {
                    foreach (var song in new_songs)
                    {
                        db.get("EXEC AddNewSongToAlbum @AlbumId = " + albumId + ", " +
                               "@SongName = N'" + song.SongName + "', " +
                               "@GenreID = " + song.GenreId + ", " +
                               "@Lyrics = N'" + song.Lyrics + "', " +
                               "@ReleaseDate = '" + song.ReleaseDate.ToString("yyyy-MM-dd") + "', " +
                               "@FileName = N'" + song.FileName + "', " +
                               "@ThumbnailImage = N'" + song.ThumbnailImage + "';");
                    }
                }

                return RedirectToAction("Index", "Albums", "Admin");
            }
            catch (Exception)
            {
                Session["AddAlbum_Error"] = "Có lỗi xảy ra khi thêm album.";
            }

            return RedirectToAction("AddAlbum", "Albums", "Admin");
        }



        public ActionResult EditAlbum(int id)
        {
            if (Session["Role"] == null || !Session["Role"].Equals("Admin"))
            {
                return Redirect("~/Home/Index");
            }

            try
            {
                DataModel db = new DataModel();

                var album = db.get($"SELECT * FROM Albums WHERE album_id = {id}");
                var albumInfo = album[0];

                var albumSongs = db.get($"SELECT song_id, song_name FROM Songs WHERE album_id = {id}");

                var allSongs = db.get("SELECT song_id, song_name FROM Songs");

                var artists = db.get("SELECT artist_id, artist_name FROM Artists");

                var genres = db.get("SELECT genre_id, genre_name FROM Genres");

                ViewBag.AlbumInfo = albumInfo;
                ViewBag.AlbumSongs = albumSongs;
                ViewBag.AllSongs = allSongs;
                ViewBag.Artists = artists;
                ViewBag.Genres = genres;

                return View();
            }
            catch (Exception ex)
            {
                TempData["Error"] = "Có lỗi xảy ra: " + ex.Message;
                return Redirect("~/Admin/Albums/Index");
            }
        }

        [HttpPost]
        public ActionResult SuaAlbum(int id, string albumname, int artist_id, DateTime release_date, HttpPostedFileBase cover_image,
                             List<int> existing_songs, List<NewSongModel> new_songs)
        {
            if (Session["Role"] == null || !Session["Role"].Equals("Admin"))
            {
                return Redirect("~/Home/Index");
            }

            try
            {
                DataModel db = new DataModel();

                // Cập nhật thông tin Album
                string coverImageName = null;
                if (cover_image != null && cover_image.ContentLength > 0)
                {
                    coverImageName = Path.GetFileName(cover_image.FileName);
                    string path = Path.Combine(Server.MapPath("~/Source/Albums-Cover"), coverImageName);
                    cover_image.SaveAs(path);
                }

                db.get($"EXEC UpdateAlbum @AlbumId = {id}, " +
                       $"@AlbumName = N'{albumname}', " +
                       $"@ArtistID = {artist_id}, " +
                       $"@ReleaseDate = '{release_date.ToString("yyyy-MM-dd")}', " +
                       $"@CoverImage = N'{coverImageName ?? "default-cover.jpg"}';");

                // Xóa tất cả bài hát cũ khỏi Album
                db.get($"DELETE FROM Songs WHERE album_id = {id}");

                // Thêm lại bài hát hiện có vào Album
                if (existing_songs != null)
                {
                    foreach (var songId in existing_songs)
                    {
                        db.get($"EXEC AddSongToAlbum @AlbumId = {id}, @SongId = {songId};");
                    }
                }

                // Thêm bài hát mới vào Album
                if (new_songs != null)
                {
                    foreach (var song in new_songs)
                    {
                        db.get($"EXEC AddNewSongToAlbum @AlbumId = {id}, " +
                               $"@SongName = N'{song.SongName}', " +
                               $"@GenreID = {song.GenreId}, " +
                               $"@Lyrics = N'{song.Lyrics}', " +
                               $"@ReleaseDate = '{song.ReleaseDate.ToString("yyyy-MM-dd")}', " +
                               $"@FileName = N'{song.FileName}', " +
                               $"@ThumbnailImage = N'{song.ThumbnailImage}';");
                    }
                }

                TempData["Success"] = "Album đã được cập nhật thành công!";
                return RedirectToAction("Index", "Albums", "Admin");
            }
            catch (Exception ex)
            {
                TempData["Error"] = "Có lỗi xảy ra: " + ex.Message;
                return RedirectToAction("EditAlbum", "Albums", new { id });
            }
        }



        public ActionResult XoaAlbum(int album_id)
        {
            if (Session["Role"] == null || !Session["Role"].Equals("Admin"))
            {
                return Redirect("~/Home/Index");
            }

            try
            {
                DataModel db = new DataModel();
                db.get("EXEC DeleteAlbum @AlbumId = " + album_id + ";");
                return RedirectToAction("Index", "Albums", "Admin");
            }
            catch (Exception)
            {
                Session["DeleteAlbum_Error"] = "Có lỗi xảy ra khi xóa album.";
            }

            return RedirectToAction("Index", "Albums", "Admin");
        }

    }
}