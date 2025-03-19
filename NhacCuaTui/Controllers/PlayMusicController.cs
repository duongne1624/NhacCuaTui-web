using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.Mvc;
using NhacCuaTui.Models;

namespace NhacCuaTui.Controllers
{
    public class PlayMusicController : Controller
    {
        // GET: PlayMusic
        public ActionResult Index(int id = 1)
        {
            DataModel db = new DataModel();
            //Lấy list bài hát
            ViewBag.listSongPlay = db.get("EXEC GetSongDetailsAndRelatedSongs @song_id = "+ id +";");
            //List bai hat
            ViewBag.list10BaiHatMoiNhat = db.get("EXEC GetTop10NewestSongs;");
            //BXH
            ViewBag.Top10BXH = db.get("EXEC GetTop10SongsByViews;");
            //Ca sĩ nhiều like nhất
            ViewBag.Top6CaSi = db.get("EXEC GetTop6ArtistsWithRanking;");
            //Tim kiem
            ViewBag.GetAllSong = db.get("EXEC GetAllSongs;");
            return View();
        }

        public ActionResult PlayAlbum(string id)
        {
            DataModel db = new DataModel();
            //Tim kiem
            ViewBag.GetAllSong = db.get("EXEC GetAllSongs;");
            return View();
        }
    }
}