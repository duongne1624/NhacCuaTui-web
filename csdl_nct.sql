-- Tạo bảng Users (Người dùng)
CREATE TABLE Users (
    user_id INT IDENTITY(1,1) PRIMARY KEY,
    username NVARCHAR(100) NOT NULL,
    password NVARCHAR(255) NOT NULL,
    email NVARCHAR(100) UNIQUE NOT NULL,
    phone_number NVARCHAR(15),
    created_at DATETIME DEFAULT GETDATE(),
    updated_at DATETIME DEFAULT GETDATE(),
	fullname NVARCHAR(100) NOT NULL,
	role NVARCHAR(50) NOT NULL
);
select * from Users
--Drop table Users
-- Tạo bảng Genres (Thể loại)
CREATE TABLE Genres (
    genre_id INT IDENTITY(1,1) PRIMARY KEY,
    genre_name NVARCHAR(50) NOT NULL,
    region NVARCHAR(50) NOT NULL
);
select * from Genres
--Drop table Genres
-- Tạo bảng Artists (Nghệ sĩ)
CREATE TABLE Artists (
    artist_id INT IDENTITY(1,1) PRIMARY KEY,
    artist_name NVARCHAR(100) NOT NULL,
    bio NVARCHAR(MAX),
    avatar_image NVARCHAR(255), -- Hình đại diện của nghệ sĩ
    created_at DATETIME DEFAULT GETDATE(),
    updated_at DATETIME DEFAULT GETDATE()
);
select * from Artists
--Drop table Artists
-- Tạo bảng Albums (Album)
CREATE TABLE Albums (
    album_id INT IDENTITY(1,1) PRIMARY KEY,
    album_name NVARCHAR(100) NOT NULL,
    artist_id INT,
    release_date DATE,
    cover_image NVARCHAR(255), -- Ảnh bìa album
    created_at DATETIME DEFAULT GETDATE(),
    updated_at DATETIME DEFAULT GETDATE(),
    FOREIGN KEY (artist_id) REFERENCES Artists(artist_id)
);
select * from Albums
--Drop table Albums
-- Tạo bảng Songs (Bài hát)
CREATE TABLE Songs (
    song_id INT IDENTITY(1,1) PRIMARY KEY,
    song_name NVARCHAR(100) NOT NULL,
    album_id INT,
    genre_id INT,
    release_date DATE,
    file_name NVARCHAR(255) NOT NULL, -- Tên file MP3
    lyrics NVARCHAR(MAX), -- Lời bài hát
    thumbnail_image NVARCHAR(255), -- Ảnh đại diện bài hát
	views_song INT,
    likes_count INT DEFAULT 0, -- Số lượt thích
    created_at DATETIME DEFAULT GETDATE(),
    updated_at DATETIME DEFAULT GETDATE(),
    FOREIGN KEY (album_id) REFERENCES Albums(album_id),
    FOREIGN KEY (genre_id) REFERENCES Genres(genre_id)
);
select * from Songs
--Drop table Songs
-- Bảng SongArtists (Nghệ sĩ của bài hát)
CREATE TABLE SongArtists (
    song_artist_id INT IDENTITY(1,1) PRIMARY KEY,
    song_id INT,
    artist_id INT,
    FOREIGN KEY (song_id) REFERENCES Songs(song_id),
    FOREIGN KEY (artist_id) REFERENCES Artists(artist_id)
);
--Drop table SongArtists
-- Bảng Playlists (Danh sách phát)
CREATE TABLE Playlists (
    playlist_id INT IDENTITY(1,1) PRIMARY KEY,
    user_id INT,
    playlist_name NVARCHAR(100),
    created_at DATETIME DEFAULT GETDATE(),
    updated_at DATETIME DEFAULT GETDATE(),
    FOREIGN KEY (user_id) REFERENCES Users(user_id)
);
--Drop table Playlists
-- Bảng PlaylistSongs (Bài hát trong danh sách phát)
CREATE TABLE PlaylistSongs (
    playlist_song_id INT IDENTITY(1,1) PRIMARY KEY,
    playlist_id INT,
    song_id INT,
    added_at DATETIME DEFAULT GETDATE(),
    FOREIGN KEY (playlist_id) REFERENCES Playlists(playlist_id),
    FOREIGN KEY (song_id) REFERENCES Songs(song_id)
);
--Drop table PlaylistSongs
-- Bảng Comments (Bình luận)
CREATE TABLE Comments (
    comment_id INT IDENTITY(1,1) PRIMARY KEY,
    user_id INT,
    song_id INT,
    comment_text NVARCHAR(MAX),
    commented_at DATETIME DEFAULT GETDATE(),
    FOREIGN KEY (user_id) REFERENCES Users(user_id),
    FOREIGN KEY (song_id) REFERENCES Songs(song_id)
);
--Drop table Comments


-- Thêm tài khoản admin vào bảng Users
INSERT INTO Users (username, password, email, phone_number)
VALUES ('admin', 'admin_password', 'admin@example.com', '0123456789');

-- Thêm thể loại vào bảng Genres
INSERT INTO Genres (genre_name, region)
VALUES 
-- Thể loại âm nhạc Việt Nam
(N'Nhạc Trẻ', N'Việt Nam'),
(N'Trữ Tình', N'Việt Nam'),
(N'Remix', N'Việt Nam'),
(N'Rap', N'Việt Nam'),
(N'Nhạc Trịnh', N'Việt Nam'),
(N'Nhạc Rock', N'Việt Nam'),
(N'Cách Mạng', N'Việt Nam'),

-- Thể loại âm nhạc Âu Mỹ
(N'Pop', N'Âu Mỹ'),
(N'Rock', N'Âu Mỹ'),
(N'Country', N'Âu Mỹ'),
(N'Latin', N'Âu Mỹ'),
(N'HipHop/Rap', N'Âu Mỹ'),
(N'Blues/Jazz', N'Âu Mỹ'),
(N'EDM', N'Âu Mỹ'),

-- Thể loại âm nhạc Châu Á
(N'Nhạc Trung', N'Châu Á'),
(N'Nhạc Hàn', N'Châu Á'),
(N'Nhạc Nhật', N'Châu Á'),
(N'Nhạc Thái', N'Châu Á');

-- Thêm nghệ sĩ vào bảng Artists
INSERT INTO Artists (artist_name, bio, avatar_image)
VALUES 
(N'Sơn Tùng M-TP', N'Nghệ sĩ nổi tiếng với những bản hit đình đám.', 'son_tung.jpg'),
(N'Mỹ Tâm', N'Ca sĩ, nhạc sĩ nổi tiếng tại Việt Nam.', 'my_tam.jpg'),
(N'Đàm Vĩnh Hưng', N'Một trong những ca sĩ hàng đầu Việt Nam.', 'dam_vinh_hung.jpg'),
(N'Jack', N'Nghệ sĩ trẻ nổi bật với nhiều bản hit.', 'jack.jpg'),
(N'Erik', N'Ca sĩ trẻ được yêu thích với nhiều ca khúc hay.', 'erik.jpg');

-- Thêm album vào bảng Albums
INSERT INTO Albums (album_name, artist_id, release_date, cover_image)
VALUES 
(N'M-TP', 1, '2017-08-15', 'album_mtp.jpg'),
(N'Heartbeat', 2, '2019-12-01', 'album_heartbeat.jpg'),
(N'Và Em Có Thể', 3, '2020-05-10', 'album_vaemcothe.jpg'),
(N'Chạy Ngay Đi', 4, '2018-03-19', 'album_chayngaydi.jpg'),
(N'Em Đã Quên', 5, '2020-09-01', 'album_emdaquen.jpg');

-- Thêm 10 bài hát nổi tiếng vào bảng Songs
INSERT INTO Songs (song_name, album_id, genre_id, release_date, file_name, thumbnail_image, likes_count, views_song, lyrics) 
VALUES 
	(N'Chạy Ngay Đi', 4, 1, '2018-03-19', 'chay_ngay_di.mp3', 'chay_ngay_di.jpg', 3500, 123000000, 
		N'Lời bài hát Chạy Ngay Đi...'),
	(N'Hãy Trao Cho Anh', 1, 1, '2019-07-01', 'hay_trao_cho_anh.mp3', 'hay_trao_cho_anh.jpg', 5000, 90000000, 
		N'Lời bài hát Hãy Trao Cho Anh...'),
	(N'Có Chắc Yêu Là Đây', 1, 1, '2017-07-12', 'co_chac_yeu_la_day.mp3', 'co_chac_yeu_la_day.jpg', 4000, 105000000, 
		N'Lời bài hát Có Chắc Yêu Là Đây...'),
	(N'Em Gái Mưa', 5, 3, '2017-04-14', 'em_gai_mua.mp3', 'em_gai_mua.jpg', 3000, 150000000, 
		N'Lời bài hát Em Gái Mưa...'),
	(N'Rời Bỏ', 3, 2, '2020-08-24', 'roi_bo.mp3', 'roi_bo.jpg', 3700, 80000000, 
		N'Lời bài hát Rời Bỏ...'),
	(N'Bạc Phận', 4, 1, '2019-09-27', 'bac_phan.mp3', 'bac_phan.jpg', 4500, 130000000, 
		N'Lời bài hát Bạc Phận...'),
	(N'Người Ơi Người Ở Đừng Về', 2, 3, '2020-02-12', 'nguoi_oi_nguoi_o_dung_ve.mp3', 'nguoi_oi_nguoi_o_dung_ve.jpg', 2500, 95000000, 
		N'Lời bài hát Người Ơi Người Ở Đừng Về...'),
	(N'Đừng Như Thói Quen', 2, 3, '2018-10-20', 'dung_nhu_thoi_quen.mp3', 'dung_nhu_thoi_quen.jpg', 3500, 92000000, 
		N'Lời bài hát Đừng Như Thói Quen...'),
	(N'Sống Xa Anh Chẳng Dễ Dàng', 5, 1, '2020-01-15', 'song_xa_anh_chang_de_dang.mp3', 'song_xa_anh_chang_de_dang.jpg', 3300, 78000000, 
		N'Lời bài hát Sống Xa Anh Chẳng Dễ Dàng...'),
	(N'Yêu Đơn Phương', 3, 1, '2019-06-10', 'yeu_don_phuong.mp3', 'yeu_don_phuong.jpg', 2800, 72000000, 
		N'Lời bài hát Yêu Đơn Phương...'),
	(N'Tình Yêu Màu Nắng', 1, 2, '2017-11-10', 'tinh_yeu_mau_nang.mp3', 'tinh_yeu_mau_nang.jpg', 2400, 65000000, 
		N'Lời bài hát Tình Yêu Màu Nắng...'),
	(N'Thương Em Là Định Mệnh', 2, 1, '2021-04-14', 'thuong_em_la_dinh_menh.mp3', 'thuong_em_la_dinh_menh.jpg', 3600, 55000000, 
		N'Lời bài hát Thương Em Là Định Mệnh...'),
	(N'Kẻ Cắp Gặp Bà Già', 3, 2, '2020-11-05', 'ke_cap_gap_ba_gia.mp3', 'ke_cap_gap_ba_gia.jpg', 4000, 48000000, 
		N'Lời bài hát Kẻ Cắp Gặp Bà Già...'),
	(N'Sai Lầm', 1, 1, '2019-05-20', 'sai_lam.mp3', 'sai_lam.jpg', 2800, 61000000, 
		N'Lời bài hát Sai Lầm...'),
	(N'Thời Gian', 5, 2, '2020-02-29', 'thoi_gian.mp3', 'thumbnail15.jpg', 3100, 70000000, 
		N'Lời bài hát Thời Gian...');

-- Thêm các nghệ sĩ cho bài hát vào bảng SongArtists
INSERT INTO SongArtists (song_id, artist_id)
VALUES 
    (1, 1),  -- Chạy Ngay Đi - Sơn Tùng M-TP
    (2, 1),  -- Hãy Trao Cho Anh - Sơn Tùng M-TP
    (3, 1),  -- Có Chắc Yêu Là Đây - Sơn Tùng M-TP
    (4, 4),  -- Em Gái Mưa - Jack
    (5, 3),  -- Rời Bỏ - Đàm Vĩnh Hưng
    (6, 4),  -- Bạc Phận - Jack
    (7, 2),  -- Người Ơi Người Ở Đừng Về - Mỹ Tâm
    (8, 2),  -- Đừng Như Thói Quen - Mỹ Tâm
    (9, 4),  -- Sống Xa Anh Chẳng Dễ Dàng - Jack
    (10, 3), -- Yêu Đơn Phương - Đàm Vĩnh Hưng
    (11, 2), -- Tình Yêu Màu Nắng - Mỹ Tâm
    (12, 2), -- Thương Em Là Định Mệnh - Mỹ Tâm
    (13, 4), -- Kẻ Cắp Gặp Bà Già - Jack
    (14, 1), -- Sai Lầm - Sơn Tùng M-TP
    (15, 5); -- Thời Gian - Erik

-- Thêm danh sách phát vào bảng Playlists
INSERT INTO Playlists (user_id, playlist_name)
VALUES 
    (1, N'Danh sách phát yêu thích 1'),
    (1, N'Danh sách phát cho mùa hè'),
    (1, N'Thể loại Nhạc Trẻ'),
    (1, N'Thể loại Nhạc Trữ Tình');

-- Thêm bài hát vào danh sách phát trong bảng PlaylistSongs
INSERT INTO PlaylistSongs (playlist_id, song_id)
VALUES 
    (1, 1),  -- Chạy Ngay Đi
    (1, 2),  -- Hãy Trao Cho Anh
    (1, 3),  -- Có Chắc Yêu Là Đây
    (2, 4),  -- Em Gái Mưa
    (2, 5),  -- Rời Bỏ
    (3, 6),  -- Bạc Phận
    (3, 7),  -- Người Ơi Người Ở Đừng Về
    (4, 8),  -- Đừng Như Thói Quen
    (1, 9),  -- Sống Xa Anh Chẳng Dễ Dàng
    (1, 10), -- Yêu Đơn Phương
    (2, 11), -- Tình Yêu Màu Nắng
    (3, 12), -- Thương Em Là Định Mệnh
    (4, 13), -- Kẻ Cắp Gặp Bà Già
    (1, 14), -- Sai Lầm
    (1, 15); -- Thời Gian

-- Thêm bình luận vào bảng Comments
INSERT INTO Comments (user_id, song_id, comment_text)
VALUES 
    (1, 1, N'Bài này hay quá!'),
    (1, 2, N'Chạy Ngay Đi thật sự rất tuyệt!'),
    (1, 3, N'Tôi thích giai điệu của bài hát này.'),
    (1, 4, N'Em Gái Mưa rất cảm động!'),
    (1, 5, N'Rời Bỏ là một bản ballad tuyệt vời.'),
    (1, 6, N'Bạc Phận thật sự gây nghiện!'),
    (1, 7, N'Người Ơi Người Ở Đừng Về có một thông điệp hay.'),
    (1, 8, N'Đừng Như Thói Quen thật sự rất ý nghĩa.'),
    (1, 9, N'Sống Xa Anh Chẳng Dễ Dàng gợi nhớ nhiều kỷ niệm.'),
    (1, 10, N'Yêu Đơn Phương rất dễ thương!'),
    (1, 11, N'Tình Yêu Màu Nắng là một bài hát tuyệt vời.'),
    (1, 12, N'Thương Em Là Định Mệnh thật sự là một kiệt tác.'),
    (1, 13, N'Kẻ Cắp Gặp Bà Già là một bản hit vui vẻ!'),
    (1, 14, N'Sai Lầm thật sự đáng suy ngẫm.'),
    (1, 15, N'Thời Gian gợi nhớ đến nhiều kỷ niệm đẹp.');



CREATE PROCEDURE GetSongsWithArtists
AS
BEGIN
    SELECT 
        s.song_id,
        s.song_name,
        a.album_name,
        g.genre_name,
        ar.artist_name,
        s.release_date,
        s.file_name,
        s.thumbnail_image,
        s.likes_count,
        s.views_song,
        s.lyrics
    FROM 
        Songs s
    JOIN 
        Albums a ON s.album_id = a.album_id
    JOIN 
        Genres g ON s.genre_id = g.genre_id
    JOIN 
        SongArtists sa ON s.song_id = sa.song_id
    JOIN 
        Artists ar ON sa.artist_id = ar.artist_id
    ORDER BY 
        s.release_date DESC; -- Sắp xếp theo ngày phát hành, có thể thay đổi nếu cần
END;



EXEC GetSongsWithArtists;

drop proc GetSongsWithArtists

select * from Artists

CREATE PROCEDURE GetTop12SongsByViews
AS
BEGIN
    SET NOCOUNT ON;

    SELECT TOP 12
        s.song_id,
        s.song_name,
        s.release_date,
        s.file_name,
        s.thumbnail_image,
        s.likes_count,
        s.views_song,
        s.lyrics,
        a.artist_name,
        al.album_name,
        g.genre_name
    FROM Songs s
    JOIN SongArtists sa ON s.song_id = sa.song_id
    JOIN Artists a ON sa.artist_id = a.artist_id
    JOIN Albums al ON s.album_id = al.album_id
    JOIN Genres g ON s.genre_id = g.genre_id
    ORDER BY s.views_song DESC; -- Sắp xếp theo lượng view giảm dần
END;

EXEC GetTop12SongsByViews;


CREATE PROCEDURE GetTop10NewestSongs
AS
BEGIN
    SET NOCOUNT ON;

    SELECT TOP 10
        s.song_id,
        s.song_name,
        s.release_date,
        s.file_name,
        s.thumbnail_image,
        s.likes_count,
        s.views_song,
        s.lyrics,
        a.artist_name,
        al.album_name,
        g.genre_name
    FROM Songs s
    JOIN SongArtists sa ON s.song_id = sa.song_id
    JOIN Artists a ON sa.artist_id = a.artist_id
    JOIN Albums al ON s.album_id = al.album_id
    JOIN Genres g ON s.genre_id = g.genre_id
    ORDER BY s.release_date DESC; -- Sắp xếp theo ngày phát hành giảm dần
END;

EXEC GetTop10NewestSongs;

CREATE PROCEDURE GetTop10Albums
AS
BEGIN
    SET NOCOUNT ON;

    SELECT TOP 10
        al.album_id,
        al.album_name,
        al.release_date,
        al.cover_image,
        a.artist_name,
        COUNT(s.song_id) AS song_count -- Số lượng bài hát trong album
    FROM Albums al
    JOIN Artists a ON al.artist_id = a.artist_id
    JOIN Songs s ON al.album_id = s.album_id
    GROUP BY al.album_id, al.album_name, al.release_date, al.cover_image, a.artist_name
    ORDER BY COUNT(s.song_id) DESC; -- Sắp xếp theo số lượng bài hát giảm dần
END;

EXEC GetTop10Albums;


CREATE PROCEDURE GetTop10SongsToday
AS
BEGIN
    SET NOCOUNT ON;

    -- Lấy ngày hiện tại
    DECLARE @Today DATE = CAST(GETDATE() AS DATE);

    -- Kiểm tra xem có bài hát nào được nghe trong ngày hiện tại không
    IF EXISTS (
        SELECT 1
        FROM Songs s
        WHERE CAST(s.created_at AS DATE) = @Today
    )
    BEGIN
        -- Nếu có bài hát được nghe trong ngày hôm nay
        SELECT TOP 10
            s.song_id,
            s.song_name,
            s.album_id,
            s.genre_id,
            s.release_date,
            s.file_name,
            s.thumbnail_image,
            s.views_song,
            s.likes_count,
            s.created_at,
            s.updated_at,
            a.artist_name,
            g.genre_name
        FROM Songs s
        JOIN SongArtists sa ON s.song_id = sa.song_id
        JOIN Artists a ON sa.artist_id = a.artist_id
        JOIN Genres g ON s.genre_id = g.genre_id
        WHERE CAST(s.created_at AS DATE) = @Today -- Chỉ lấy bài hát được phát hành hôm nay
        ORDER BY s.views_song DESC; -- Sắp xếp theo lượt nghe từ cao đến thấp
    END
    ELSE
    BEGIN
        -- Nếu không có bài hát nào được phát hành hôm nay, hiển thị ngẫu nhiên các bài hát
        SELECT TOP 10
            s.song_id,
            s.song_name,
            s.album_id,
            s.genre_id,
            s.release_date,
            s.file_name,
            s.thumbnail_image,
            s.views_song,
            s.likes_count,
            s.created_at,
            s.updated_at,
            a.artist_name,
            g.genre_name
        FROM Songs s
        JOIN SongArtists sa ON s.song_id = sa.song_id
        JOIN Artists a ON sa.artist_id = a.artist_id
        JOIN Genres g ON s.genre_id = g.genre_id
        ORDER BY NEWID(); -- Sắp xếp ngẫu nhiên
    END
END;


EXEC GetTop10SongsToday;

drop proc GetTop10SongsToday

EXEC GetTop10SongsToday;
EXEC GetTop10Albums;
EXEC GetTop10NewestSongs;
EXEC GetTop12SongsByViews;

CREATE PROCEDURE GetTop10SongsByViews
AS
BEGIN
    -- Lấy 10 bài hát có lượt xem cao nhất cùng với thông tin nghệ sĩ
    SELECT 
        ROW_NUMBER() OVER (ORDER BY S.views_song DESC) AS Rank, -- Cột xếp hạng
        S.song_id,
        S.song_name,
        S.views_song,
        S.likes_count,
        S.release_date,
        S.thumbnail_image,
        A.artist_name -- Thông tin ca sĩ
    FROM 
        Songs S
    JOIN 
        SongArtists SA ON S.song_id = SA.song_id
    JOIN 
        Artists A ON SA.artist_id = A.artist_id
    ORDER BY 
        S.views_song DESC
    OFFSET 0 ROWS FETCH NEXT 10 ROWS ONLY; -- Chỉ lấy 10 bài hát
END;



EXEC GetTop10SongsByViews;

drop proc GetTop10SongsByViews

select * from Artists

CREATE PROCEDURE GetTop6ArtistsWithRanking
AS
BEGIN
    -- Tạo bảng tạm để lưu trữ kết quả
    WITH RankedArtists AS (
        SELECT 
            A.artist_id,
            A.artist_name,
            A.bio,
            A.avatar_image,
            COALESCE(SUM(S.likes_count), 0) AS total_likes, -- Tổng số lượt thích
            ROW_NUMBER() OVER (ORDER BY COALESCE(SUM(S.likes_count), 0) DESC) AS ranking -- Xếp hạng
        FROM 
            Artists A
        LEFT JOIN 
            SongArtists SA ON A.artist_id = SA.artist_id
        LEFT JOIN 
            Songs S ON SA.song_id = S.song_id
        GROUP BY 
            A.artist_id, A.artist_name, A.bio, A.avatar_image
    )
    
    -- Lấy 6 nghệ sĩ đầu tiên
    SELECT 
        artist_id,
        artist_name,
        bio,
        avatar_image,
        total_likes,
        ranking
    FROM 
        RankedArtists
    WHERE 
        ranking <= 6; -- Chỉ lấy 6 ca sĩ
END;


EXEC GetTop6ArtistsWithRanking;


drop proc GetTop6Artists;

CREATE PROCEDURE GetSongDetailsAndRelatedSongs
    @song_id INT
AS
BEGIN
    SET NOCOUNT ON;

    -- Sử dụng CTE để xác định thứ tự và gắn cờ bài hát chính
    WITH SongWithOrder AS (
        -- Lấy thông tin của bài hát chính và các bài hát liên quan
        SELECT 
            S.song_id,
            S.song_name,
            S.album_id,
            A.album_name,
            G.genre_name,
            S.release_date,
            S.file_name,
            S.thumbnail_image,
            S.lyrics,
            S.views_song,
            S.likes_count,
            AR.artist_name,
            1 AS IsMainSong -- Đánh dấu bài hát chính
        FROM 
            Songs S
        LEFT JOIN 
            Albums A ON S.album_id = A.album_id
        JOIN 
            Genres G ON S.genre_id = G.genre_id
        JOIN 
            SongArtists SA ON S.song_id = SA.song_id
        JOIN 
            Artists AR ON SA.artist_id = AR.artist_id
        WHERE 
            S.song_id = @song_id

        UNION ALL

        -- Lấy các bài hát liên quan theo thể loại
        SELECT 
            S.song_id,
            S.song_name,
            S.album_id,
            A.album_name,
            G.genre_name,
            S.release_date,
            S.file_name,
            S.thumbnail_image,
            S.lyrics,
            S.views_song,
            S.likes_count,
            AR.artist_name,
            0 AS IsMainSong -- Đánh dấu bài hát liên quan
        FROM 
            Songs S
        LEFT JOIN 
            Albums A ON S.album_id = A.album_id
        JOIN 
            Genres G ON S.genre_id = G.genre_id
        JOIN 
            SongArtists SA ON S.song_id = SA.song_id
        JOIN 
            Artists AR ON SA.artist_id = AR.artist_id
        WHERE 
            S.genre_id = (SELECT genre_id FROM Songs WHERE song_id = @song_id)
            AND S.song_id <> @song_id -- Loại trừ bài hát chính
    )

    -- Hiển thị thông tin bài hát chính và bài hát liên quan
    SELECT 
        ROW_NUMBER() OVER (ORDER BY IsMainSong DESC, views_song DESC) AS RowNum, -- Cột số thứ tự
        song_id,
        song_name,
        album_id,
        album_name,
        genre_name,
        release_date,
        file_name,
        thumbnail_image,
        lyrics,
        views_song,
        likes_count,
        artist_name,
        IsMainSong
    FROM 
        SongWithOrder
    ORDER BY 
        IsMainSong DESC, views_song DESC; -- Ưu tiên bài hát chính và sắp xếp theo lượt view giảm dần
END;



EXEC GetSongDetailsAndRelatedSongs @song_id = 1;

drop proc GetSongDetailsAndRelatedSongs


select * from Users
alter table users add role NVARCHAR(20)

update Users set fullname = N'Administrator', role = N'Admin' where user_id = 1

CREATE PROCEDURE GetAllUsers
AS
BEGIN
    SET NOCOUNT ON;

    SELECT 
        user_id,
        username,
		password,
		fullname,
		role,
        email,
        phone_number,
        created_at,
        updated_at
    FROM 
        Users
    ORDER BY 
        created_at DESC; -- Sắp xếp người dùng theo thời gian tạo từ mới nhất đến cũ nhất
END;

EXEC GetAllUsers;

drop proc GetAllUsers

CREATE PROCEDURE AddNewUser
    @Username NVARCHAR(100),
    @Password NVARCHAR(255),
	@Fullname Nvarchar(100),
	@Role Nvarchar(20),
    @Email NVARCHAR(100),
    @PhoneNumber NVARCHAR(15) = NULL -- Giá trị mặc định là NULL
AS
BEGIN
    SET NOCOUNT ON;
	-- Kiểm tra xem username đã tồn tại chưa
    IF EXISTS (SELECT 1 FROM Users WHERE username = @Username)
    BEGIN
        -- Trả về thông báo lỗi nếu username đã tồn tại
        RAISERROR('Username đã tồn tại. Vui lòng chọn username khác.', 16, 1);
        RETURN;
    END

    -- Kiểm tra email đã tồn tại hay chưa
    IF EXISTS (SELECT 1 FROM Users WHERE email = @Email)
    BEGIN
        RAISERROR('Email này đã tồn tại.', 16, 1);
        RETURN;
    END

    -- Thêm người dùng mới vào bảng Users
    INSERT INTO Users (username, password, email, phone_number, created_at, updated_at, fullname, role)
			VALUES (@Username, @Password, @Email, @PhoneNumber, GETDATE(), GETDATE(), @Fullname, @Role);
END;

drop proc AddNewUser

EXEC AddNewUser 
    @Username = 'duong123456',
    @Password = '123',
	@Fullname = N'Dương',
	@Role = N'Nhân viên',
    @Email = 'newuser456@example.com',
    @PhoneNumber = '0987123456';


CREATE PROCEDURE UpdateUser
    @UserId INT,
    @Email NVARCHAR(100),
    @PhoneNumber NVARCHAR(15) = NULL, -- Không bắt buộc
	@Fullname NVARCHAR(100),
	@Role NVARCHAR(20)
AS
BEGIN
    SET NOCOUNT ON;

    -- Kiểm tra nếu UserId không tồn tại
    IF NOT EXISTS (SELECT 1 FROM Users WHERE user_id = @UserId)
    BEGIN
        -- Trả về thông báo lỗi nếu không tìm thấy UserId
        RAISERROR('Người dùng không tồn tại.', 16, 1);
        RETURN;
    END
    -- Kiểm tra nếu email mới đã tồn tại và không phải của người dùng hiện tại
    IF EXISTS (SELECT 1 FROM Users WHERE email = @Email AND user_id <> @UserId)
    BEGIN
        -- Trả về thông báo lỗi nếu email đã tồn tại
        RAISERROR('Email đã tồn tại. Vui lòng nhập email khác.', 16, 1);
        RETURN;
    END

    -- Cập nhật thông tin người dùng
    UPDATE Users
    SET
        email = @Email,
        phone_number = @PhoneNumber,
        updated_at = GETDATE(),
		fullname = @Fullname,
		role = @Role
    WHERE user_id = @UserId;
END;

drop proc UpdateUser

EXEC UpdateUser 
    @UserId = 1, 
    @Email = 'newemail@example.com', 
    @PhoneNumber = '0987654321',
	@Fullname = N'',
	@Role = N''

drop proc GetUserById
CREATE PROCEDURE GetUserById
    @UserId INT
AS
BEGIN
    SET NOCOUNT ON;

    -- Kiểm tra nếu UserId không tồn tại
    IF NOT EXISTS (SELECT 1 FROM Users WHERE user_id = @UserId)
    BEGIN
        -- Trả về thông báo lỗi nếu không tìm thấy UserId
        RAISERROR('Người dùng không tồn tại.', 16, 1);
        RETURN;
    END

    -- Lấy thông tin người dùng
    SELECT 
        user_id,
        username,
		fullname,
		role,
        email,
        phone_number,
        created_at,
        updated_at
    FROM Users
    WHERE user_id = @UserId;
END;


EXEC GetUserById @UserId = 1;

EXEC GetAllUsers;

CREATE PROCEDURE GetAllGenres
AS
BEGIN
    SET NOCOUNT ON;

    -- Lấy tất cả thể loại
    SELECT 
        genre_id,
        genre_name,
        region
    FROM Genres;
END;

EXEC GetAllGenres;

select * from songs

update Songs set thumbnail_image = 'thoi_gian.jpg' where song_id=15

EXEC GetSongDetailsAndRelatedSongs @song_id = 1

EXEC GetTop12SongsByViews;


--PROC Xóa User
CREATE PROCEDURE DeleteUser
    @UserId INT
AS
BEGIN
    SET NOCOUNT ON;

    -- Kiểm tra xem người dùng có tồn tại không
    IF EXISTS (SELECT 1 FROM Users WHERE user_id = @UserId)
    BEGIN
        -- Xóa người dùng nếu tồn tại
        DELETE FROM Users
        WHERE user_id = @UserId;

        -- Trả về thông báo thành công
        SELECT 'Người dùng đã được xóa thành công.' AS Message;
    END
    ELSE
    BEGIN
        -- Trả về thông báo nếu không tìm thấy người dùng
        SELECT 'Người dùng không tồn tại.' AS Message;
    END
END;

select * from Users

CREATE PROCEDURE UserLogin
    @Username NVARCHAR(100),
    @Password NVARCHAR(255)
AS
BEGIN
    SET NOCOUNT ON;

    -- Kiểm tra người dùng có tồn tại không
    DECLARE @UserCount INT;
    SET @UserCount = (SELECT COUNT(1) FROM Users WHERE username = @Username AND password = @Password);

    IF @UserCount > 0
    BEGIN
        -- Trả về thông tin người dùng nếu đăng nhập thành công
        SELECT user_id, username, email, phone_number, fullname, role, created_at, updated_at
        FROM Users
        WHERE username = @Username AND password = @Password;
    END
END;



drop proc UserLogin

exec UserLogin @Username = 'duong123',
				@Password = '123';

update users set password = 123 where username = 'admin'


CREATE PROCEDURE RegisterUser
    @Username NVARCHAR(100),
    @Password NVARCHAR(255),
    @Email NVARCHAR(100),
    @PhoneNumber NVARCHAR(15) = NULL,
	@Fullname NVARCHAR(100)
AS
BEGIN
    SET NOCOUNT ON;

    -- Kiểm tra xem tên người dùng đã tồn tại chưa
    IF EXISTS (SELECT 1 FROM Users WHERE username = @Username)
    BEGIN
        -- Nếu tồn tại, trả về lỗi
        RAISERROR('Tên người dùng đã tồn tại!', 16, 1);
        RETURN;
    END

    -- Thêm người dùng mới vào bảng Users
    INSERT INTO Users (username, password, email, phone_number, fullname, role, created_at, updated_at)
    VALUES (@Username, @Password, @Email, @PhoneNumber, @Fullname, N'Người dùng', GETDATE(), GETDATE());
END;

EXEC RegisterUser @Username = '', @Password = '', @Email = '', @PhoneNumber = '', @Fullname = ''


EXEC GetSongDetailsAndRelatedSongs @song_id = 1

Update songs set 
lyrics = N'Từng phút cứ mãi trôi xa phai nhòa dần kí ức giữa đôi ta
Từng chút nỗi nhớ hôm qua đâu về lạc bước cứ thế phôi pha
Con tim giờ không cùng chung đôi nhịp
Nụ cười lạnh băng còn đâu nồng ấm thân quen
Vô tâm làm ngơ thờ ơ tương lai ai ngờ
Quên đi mộng mơ ngày thơ tan theo sương mờ
Mưa lặng thầm đường vắng chiều nay
In giọt lệ nhòe khóe mắt sầu cay
Bao hẹn thề tàn úa vụt bay
Trôi dạt chìm vào những giấc nồng say
Quay lưng chia hai lối
Còn một mình anh thôi
Giả dối bao trùm bỗng chốc lên ngôi
Trong đêm tối
Bầu bạn cùng đơn côi
Suy tư anh kìm nén đã bốc cháy yêu thương trao em rồi (đốt sạch hết)
Son môi hồng vương trên môi bấy lấu
Hương thơm dịu êm mê man bấy lâu (đốt sạch hết)
Anh không chờ mong quan tâm nữa đâu
Tương lai từ giờ như bức tranh em quên tô màu (đốt sạch hết)
Xin chôn vùi tên em trong đớn đau
Nơi hiu quạnh tan hoang ngàn nỗi đau
Dư âm tàn tro vô vọng phía sau
Đua chen dày vò xâu xé quanh thân xác nát nhàu
Chạy ngay đi trước khi
Mọi điều dần tồi tệ hơn
Chạy ngay đi trước khi
Lòng hận thù cuộn từng cơn
Tựa giông tố
Đến đây ghé thăm
Từ nơi
Hố sâu tối tăm
Chạy đi
Trước khi
Mọi điều dần tồi tệ hơn
Không còn ai cạnh bên em ngày mai
Tạm biệt một tương lai ngang trái
Không còn ai cạnh bên em ngày mai
Tạm biệt một tương lai ngang trái
Không còn ai cạnh bên em ngày mai
Tạm biệt một tương lai ngang trái
Không còn ai cạnh bên em ngày mai
Tạm biệt một tương lai ngang trái yeah
Buông bàn tay
Buông xuôi hi vọng buông bình yên (buông)
Đâu còn nguyên tháng ngày rực rỡ phai úa hằn sâu triền miên
Vết thương cứ thêm khắc thêm mãi thêm
Chà đạp vùi dập dẫm lên tiếng yêu ấm êm
Nhìn lại niềm tin từng trao giờ sao
Sau bao ngu muội sai lầm anh vẫn yếu mềm
Căn phòng giam cầm thiêu linh hồn cô độc em trơ trọi kêu gào xót xa
Căm hận tuôn trào dâng lên nhuộm đen ghì đôi vai đừng mong chờ thứ tha
Chính em gây ra mà
Những điều vừa diễn ra
Chính em gây ra mà chính em gây ra mà
Những điều vừa diễn ra
Hết thật rồi
Đốt sạch hết
Son môi hồng vương trên môi bấy lâu
Hương thơm dịu êm mê man bấy lâu (đốt sạch hết)
Anh không chờ mong quan tâm nữa đâu
Tương lai từ giờ như bức tranh em quên tô màu
Đốt sạch hết
Xin chôn vùi tên em trong đớn đau
Nơi hiu quạnh tan hoang ngàn nỗi đau (đốt sạch hết)
Dư âm tàn tro vô vọng phía sau
Đua chen dày vò xâu xé quanh thân xác nát nhàu
Chạy ngay đi trước khi
Mọi điều dần tồi tệ hơn (đốt sạch)
Chạy ngay đi trước khi
Lòng hận thù cuộn từng cơn (đốt sạch)
Tựa giông tố
Đến đây ghé thăm
Từ nơi
Hố sâu tối tăm
Chạy đi
Trước khi
Mọi điều dần tồi tệ hơn
Không còn ai cạnh bên em ngày mai
Tạm biệt một tương lai ngang trái
Không còn ai cạnh bên em ngày mai
Tạm biệt một tương lai ngang trái
Không còn ai cạnh bên em ngày mai
Tạm biệt một tương lai ngang trái
Không còn ai cạnh bên em ngày mai
Tạm biệt một tương lai ngang trái
Đốt sạch hết
Oh
Chính em gây ra mà chính em gây ra mà
Đốt sạch hết
Oh
Đừng nhìn anh với khuôn mặt xa lạ
Xin đừng lang thang trong tâm trí anh từng đêm nữa
Quên đi quên đi hết đi
Quên đi quên đi hết đi
Thắp lên điều đáng thương lạnh giá ôm trọn giấc mơ vụn vỡ
Bốc cháy lên cơn hận thù trong anh (quên đi quên đi quên đi hết)
Cơn hận thù trong anh
Bốc cháy lên cơn hận thù trong anh
Ai khơi dậy cơn hận thù trong anh
Bốc cháy lên cơn hận thù trong anh (quên đi quên đi quên đi hết)
Cơn hận thù trong anh
Bốc cháy lên cơn hận thù trong anh
Ai khơi dậy cơn hận thù trong anh (phải cô đơn rồi)
Không còn ai cạnh bên em ngày mai
Tạm biệt một tương lai ngang trái (cô đơn rồi)
Không còn ai cạnh bên em ngày mai
Tạm biệt một tương lai ngang trái (cô đơn rồi)
Không còn ai cạnh bên em ngày mai
Tạm biệt một tương lai ngang trái (cô đơn rồi)
Không còn ai cạnh bên em ngày mai
Tạm biệt một tương lai ngang trái'
where song_name = N'Chạy ngay đi'

select * from artists

create proc GetAllArtists
as
begin
	select * from artists
end


exec GetAllArtists

select * from Albums

CREATE PROCEDURE GetAlbumWithArtists
AS
BEGIN
    SET NOCOUNT ON;

    SELECT 
        a.album_id,
        a.album_name,
        a.release_date,
        a.cover_image,
        ar.artist_id,
        ar.artist_name
    FROM Albums a
    JOIN Artists ar ON a.artist_id = ar.artist_id
    ORDER BY a.release_date DESC; -- Sắp xếp theo ngày phát hành giảm dần
END;

EXEC GetAlbumWithArtists


CREATE PROCEDURE GetAllSongs
AS
BEGIN
    SET NOCOUNT ON;

    SELECT 
        s.song_id,
        s.song_name,
        s.release_date,
        s.file_name,
        s.thumbnail_image,
        s.views_song,
        s.likes_count,
        a.album_name,
        g.genre_name,
        ar.artist_name
    FROM Songs s
    LEFT JOIN Albums a ON s.album_id = a.album_id
    LEFT JOIN Genres g ON s.genre_id = g.genre_id
    LEFT JOIN SongArtists sa ON s.song_id = sa.song_id
    LEFT JOIN Artists ar ON sa.artist_id = ar.artist_id
    ORDER BY s.release_date DESC; -- Sắp xếp theo ngày phát hành giảm dần
END;
drop proc GetAllSongs

--new
CREATE PROCEDURE GetAllSongs
AS
BEGIN
    SET NOCOUNT ON;

    SELECT 
        s.song_id,
        s.song_name,
        s.release_date,
        s.file_name,
        s.thumbnail_image,
        s.views_song,
        s.likes_count,
        a.album_name,
        g.genre_name,
        STRING_AGG(ar.artist_name, ', ') AS artist_names
    FROM Songs s
    LEFT JOIN Albums a ON s.album_id = a.album_id
    LEFT JOIN Genres g ON s.genre_id = g.genre_id
    LEFT JOIN SongArtists sa ON s.song_id = sa.song_id
    LEFT JOIN Artists ar ON sa.artist_id = ar.artist_id
    GROUP BY 
        s.song_id, 
        s.song_name, 
        s.release_date, 
        s.file_name, 
        s.thumbnail_image, 
        s.views_song, 
        s.likes_count, 
        a.album_name, 
        g.genre_name
    ORDER BY s.views_song DESC; -- Bạn có thể sắp xếp theo bất kỳ tiêu chí nào phù hợp
END;


EXEC GetAllSongs

select * from SongArtists

select * from users

CREATE PROCEDURE GetUserInfoById
    @UserId INT
AS
BEGIN
    SET NOCOUNT ON;

    SELECT 
        user_id,
        username,
		fullname,
        email,
        phone_number,
        created_at,
        updated_at,
		role
    FROM Users
    WHERE user_id = @UserId;
END;
drop proc GetUserInfoById
EXEC GetUserInfoById @UserId = 1;

CREATE PROCEDURE ChangeUserPassword
    @UserId INT,
    @NewPassword NVARCHAR(255)
AS
BEGIN
    SET NOCOUNT ON;

    -- Cập nhật mật khẩu cho người dùng
    UPDATE Users
    SET password = @NewPassword,
        updated_at = GETDATE() -- Cập nhật thời gian chỉnh sửa
    WHERE user_id = @UserId;
END;

CREATE PROCEDURE GetSongsByGenre
    @GenreId INT
AS
BEGIN
    SET NOCOUNT ON;

    SELECT 
        s.song_id,
        s.song_name,
        a.album_name,
        ar.artist_name,
        g.genre_name,
        s.release_date,
        s.views_song,
        s.likes_count
    FROM Songs s
    JOIN Albums a ON s.album_id = a.album_id
    JOIN SongArtists sa ON s.song_id = sa.song_id
    JOIN Artists ar ON sa.artist_id = ar.artist_id
    JOIN Genres g ON s.genre_id = g.genre_id
    WHERE s.genre_id = @GenreId
    ORDER BY s.views_song DESC;  -- Sắp xếp theo số lượt xem từ cao đến thấp
END;

EXEC GetSongsByGenre '1';

CREATE PROCEDURE GetSongsByGenreName
    @GenreName NVARCHAR(50)
AS
BEGIN
    SET NOCOUNT ON;

    SELECT 
        s.song_id,
        s.song_name,
		s.release_date,
		s.file_name,
		s.thumbnail_image,
        s.views_song,
        s.likes_count,
        a.album_name,
        g.genre_name,
        ar.artist_name
    FROM Songs s
    JOIN Albums a ON s.album_id = a.album_id
    JOIN SongArtists sa ON s.song_id = sa.song_id
    JOIN Artists ar ON sa.artist_id = ar.artist_id
    JOIN Genres g ON s.genre_id = g.genre_id
    WHERE g.genre_name = @GenreName
    ORDER BY s.views_song DESC;  -- Sắp xếp theo số lượt xem từ cao đến thấp
END;
drop proc GetSongsByGenreName
EXEC GetSongsByGenreName N'Nhạc trẻ';
EXEC GetAllSongs

select * from Artists
select * from Songs
select * from SongArtists


CREATE PROCEDURE SearchSongsOrArtists
    @SearchTerm NVARCHAR(100)
AS
BEGIN
    SET NOCOUNT ON;

    SELECT 
        s.song_id,
        s.song_name,
        s.release_date,
        s.file_name,
        s.thumbnail_image,
        s.views_song,
        s.likes_count,
        a.album_name,              -- Album Name (có thể NULL)
        g.genre_name,
        ar.artist_name
    FROM Songs s
    LEFT JOIN Albums a ON s.album_id = a.album_id  -- LEFT JOIN để xử lý trường hợp album_id NULL
    JOIN SongArtists sa ON s.song_id = sa.song_id
    JOIN Artists ar ON sa.artist_id = ar.artist_id
    JOIN Genres g ON s.genre_id = g.genre_id
    WHERE s.song_name LIKE '%' + @SearchTerm + '%'
       OR ar.artist_name LIKE '%' + @SearchTerm + '%'
    ORDER BY s.views_song DESC;  -- Sắp xếp theo lượt xem từ cao đến thấp
END;

drop proc SearchSongsOrArtists

drop proc SearchSongsOrArtists
exec SearchSongsOrArtists N'Ph'

select * from artists


CREATE PROCEDURE AddArtist
    @ArtistName NVARCHAR(100),
    @Bio NVARCHAR(MAX) = NULL,
    @AvatarImage NVARCHAR(255) = NULL
AS
BEGIN
    SET NOCOUNT ON;

    -- Kiểm tra nếu tên ca sĩ đã tồn tại để tránh thêm trùng
    IF EXISTS (SELECT 1 FROM Artists WHERE artist_name = @ArtistName)
    BEGIN
        -- Nếu ca sĩ đã tồn tại, trả về thông báo
        RAISERROR ('Artist with the same name already exists.', 16, 1);
        RETURN;
    END

    -- Thêm ca sĩ mới vào bảng Artists
    INSERT INTO Artists (artist_name, bio, avatar_image, created_at, updated_at)
    VALUES (@ArtistName, @Bio, @AvatarImage, GETDATE(), GETDATE());
END;

drop proc AddArtist

CREATE PROCEDURE GetArtistById
    @ArtistId INT
AS
BEGIN
    SET NOCOUNT ON;

    -- Lấy thông tin ca sĩ dựa trên ID
    SELECT 
        artist_id,
        artist_name,
        bio,
        avatar_image,
        created_at,
        updated_at
    FROM 
        Artists
    WHERE 
        artist_id = @ArtistId;
END;

EXEC GetArtistById 1;

CREATE PROCEDURE UpdateArtistById
    @ArtistId INT,
    @ArtistName NVARCHAR(100),
    @Bio NVARCHAR(MAX),
    @AvatarImage NVARCHAR(255)
AS
BEGIN
    SET NOCOUNT ON;

    -- Cập nhật thông tin ca sĩ
    UPDATE Artists
    SET 
        artist_name = @ArtistName,
        bio = @Bio,
        avatar_image = @AvatarImage,
        updated_at = GETDATE()
    WHERE 
        artist_id = @ArtistId;
END;

drop proc UpdateArtistById
exec UpdateArtistById


select * from Songs

select * from Albums

CREATE PROCEDURE DeleteArtist
    @ArtistId INT
AS
BEGIN
    SET NOCOUNT ON;

    -- Xóa ca sĩ dựa vào artist_id
    DELETE FROM Artists
    WHERE artist_id = @ArtistId;
END;

INSERT INTO Songs (song_name, genre_id, release_date, file_name, thumbnail_image, likes_count, views_song, lyrics) 
VALUES 
	(N'Buông đôi tay nhau ra', 1, '2018-03-19', 'buong_doi_tay_nhau_ra.mp3', 'buong_doi_tay_nhau_ra.jpg', 13500, 155000000, 
		N'Lời bài hát Buông đôi tay nhau ra...')

		select * from Songs

-- Thêm bài hát vào bảng Songs
INSERT INTO Songs (song_name, album_id, genre_id, release_date, file_name, thumbnail_image, likes_count, views_song, lyrics) 
VALUES 
(N'Tháng Tư Là Lời Nói Dối Của Em', 2, 3, '2015-04-01', 'thang_tu_la_loi_noi_doi_cua_em.mp3', 'thumbnail16.jpg', 2900, 45000000, 
    N'Lời bài hát Tháng Tư Là Lời Nói Dối Của Em...');

-- Giả sử bài hát này có hai nghệ sĩ tham gia: Mỹ Tâm và Sơn Tùng M-TP (artist_id: 2 và 1)
INSERT INTO SongArtists (song_id, artist_id)
VALUES 
(17, 2),  -- Mỹ Tâm
(17, 1);  -- Sơn Tùng M-TP

update Songs set thumbnail_image = 'thang_tu_la_loi_noi_doi_cua_em.jpg' where song_id = 17

select * from Albums

CREATE PROCEDURE CheckUserExists
    @Username NVARCHAR(100)
AS
BEGIN
    SET NOCOUNT ON;

    -- Kiểm tra xem username có tồn tại trong bảng Users hay không
    IF EXISTS (SELECT 1 FROM Users WHERE username = @Username)
    BEGIN
        SELECT 1 AS UserExists;  -- Username tồn tại
    END
END;

drop proc CheckUserExists
select * from Users

exec UserLogin @Username = 'duong123', @Password =  '123'
select * from Songs
update songs set album_id = null
where song_id = 16

select * from SongArtists
insert into SongArtists(song_id, artist_id) values (16, 1)




select * from Playlists

select * from users

CREATE PROCEDURE GetSongById
	@id int
AS
BEGIN
    SET NOCOUNT ON;

    SELECT 
        s.song_id,
        s.song_name,
        s.release_date,
        s.file_name,
        s.thumbnail_image,
        s.views_song,
        s.likes_count,
        a.album_name,
        g.genre_name,
        ar.artist_name
    FROM Songs s
    LEFT JOIN Albums a ON s.album_id = a.album_id
    LEFT JOIN Genres g ON s.genre_id = g.genre_id
    LEFT JOIN SongArtists sa ON s.song_id = sa.song_id
    LEFT JOIN Artists ar ON sa.artist_id = ar.artist_id
	WHERE s.song_id = @id
END;

CREATE PROCEDURE AddSong
    @SongName NVARCHAR(100),
    @AlbumID INT,
    @GenreID INT,
    @Lyrics NVARCHAR(MAX),
    @ReleaseDate DATE,
    @FileName NVARCHAR(255),
    @ThumbnailImage NVARCHAR(255)
AS
BEGIN
    BEGIN TRY
        INSERT INTO Songs (song_name, album_id, genre_id, lyrics, release_date, file_name, thumbnail_image, created_at, updated_at)
        VALUES (@SongName, @AlbumID, @GenreID, @Lyrics, @ReleaseDate, @FileName, @ThumbnailImage, GETDATE(), GETDATE());
    END TRY
    BEGIN CATCH
        -- Bắt lỗi và hiển thị thông báo
        DECLARE @ErrorMessage NVARCHAR(4000) = ERROR_MESSAGE();
        THROW 50001, @ErrorMessage, 1;
    END CATCH
END;
GO


CREATE PROCEDURE UpdateSongById
    @SongId INT,
    @SongName NVARCHAR(100),
    @AlbumID INT,
    @GenreID INT,
    @Lyrics NVARCHAR(MAX),
    @ReleaseDate DATE,
    @FileName NVARCHAR(255),
    @ThumbnailImage NVARCHAR(255)
AS
BEGIN
    BEGIN TRY
        -- Kiểm tra sự tồn tại của bài hát
        IF NOT EXISTS (SELECT 1 FROM Songs WHERE song_id = @SongId)
        BEGIN
            THROW 50000, 'Bài hát không tồn tại.', 1;
        END

        -- Cập nhật bài hát
        UPDATE Songs
        SET song_name = @SongName,
            album_id = @AlbumID,
            genre_id = @GenreID,
            lyrics = @Lyrics,
            release_date = @ReleaseDate,
            file_name = @FileName,
            thumbnail_image = @ThumbnailImage,
            updated_at = GETDATE()
        WHERE song_id = @SongId;
    END TRY
    BEGIN CATCH
        -- Bắt lỗi và hiển thị thông báo
        DECLARE @ErrorMessage NVARCHAR(4000) = ERROR_MESSAGE();
        THROW 50001, @ErrorMessage, 1;
    END CATCH
END;
GO

CREATE PROCEDURE DeleteSong
    @SongId INT
AS
BEGIN
    BEGIN TRY
        -- Kiểm tra sự tồn tại của bài hát
        IF NOT EXISTS (SELECT 1 FROM Songs WHERE song_id = @SongId)
        BEGIN
            THROW 50000, 'Bài hát không tồn tại.', 1;
        END

        -- Xóa bài hát
        DELETE FROM PlaylistSongs WHERE song_id = @SongId;
		DELETE FROM SongArtists WHERE song_id = @SongId;
		DELETE FROM Comments WHERE song_id = @SongId;
		DELETE FROM Songs WHERE song_id = @SongId;

    END TRY
    BEGIN CATCH
        -- Bắt lỗi và hiển thị thông báo
        DECLARE @ErrorMessage NVARCHAR(4000) = ERROR_MESSAGE();
        THROW 50001, @ErrorMessage, 1;
    END CATCH
END;
GO
drop proc DeleteSong

CREATE PROCEDURE AddAlbum
    @AlbumName NVARCHAR(100),
    @ArtistID INT,
    @ReleaseDate DATE,
    @CoverImage NVARCHAR(255)
AS
BEGIN
    INSERT INTO Albums (album_name, artist_id, release_date, cover_image, created_at, updated_at)
    VALUES (@AlbumName, @ArtistID, @ReleaseDate, @CoverImage, GETDATE(), GETDATE());
END;

CREATE PROCEDURE UpdateAlbum
    @AlbumId INT,
    @AlbumName NVARCHAR(100),
    @ArtistID INT,
    @ReleaseDate DATE,
    @CoverImage NVARCHAR(255)
AS
BEGIN
    UPDATE Albums
    SET album_name = @AlbumName,
        artist_id = @ArtistID,
        release_date = @ReleaseDate,
        cover_image = @CoverImage,
        updated_at = GETDATE()
    WHERE album_id = @AlbumId;
END;


CREATE PROCEDURE DeleteAlbum
    @AlbumId INT
AS
BEGIN
    DELETE FROM PlaylistSongs WHERE song_id IN (SELECT song_id FROM Songs WHERE album_id = @AlbumId);
    DELETE FROM SongArtists WHERE song_id IN (SELECT song_id FROM Songs WHERE album_id = @AlbumId);
    DELETE FROM Songs WHERE album_id = @AlbumId;
    DELETE FROM Albums WHERE album_id = @AlbumId;
END;

CREATE PROCEDURE AddSongToAlbum
    @AlbumId INT,
    @SongId INT
AS
BEGIN
    UPDATE Songs
    SET album_id = @AlbumId
    WHERE song_id = @SongId;
END;

CREATE PROCEDURE AddNewSongToAlbum
    @AlbumId INT,
    @SongName NVARCHAR(100),
    @GenreID INT,
    @Lyrics NVARCHAR(MAX),
    @ReleaseDate DATE,
    @FileName NVARCHAR(255),
    @ThumbnailImage NVARCHAR(255)
AS
BEGIN
    INSERT INTO Songs (song_name, album_id, genre_id, lyrics, release_date, file_name, thumbnail_image, created_at, updated_at)
    VALUES (@SongName, @AlbumId, @GenreID, @Lyrics, @ReleaseDate, @FileName, @ThumbnailImage, GETDATE(), GETDATE());
END;

drop proc AddNewSongToAlbum

CREATE PROCEDURE RemoveAllSongsFromAlbum
    @AlbumId INT
AS
BEGIN
    UPDATE Songs
    SET album_id = NULL
    WHERE album_id = @AlbumId;
END;

CREATE PROCEDURE AddAlbum
    @AlbumName NVARCHAR(100),
    @ArtistID INT,
    @ReleaseDate DATE,
    @CoverImage NVARCHAR(255)
AS
BEGIN
    INSERT INTO Albums (album_name, artist_id, release_date, cover_image, created_at, updated_at)
    VALUES (@AlbumName, @ArtistID, @ReleaseDate, @CoverImage, GETDATE(), GETDATE());
END;

CREATE PROCEDURE UpdateAlbum
    @AlbumId INT,
    @AlbumName NVARCHAR(100),
    @ArtistID INT,
    @ReleaseDate DATE,
    @CoverImage NVARCHAR(255)
AS
BEGIN
    UPDATE Albums
    SET album_name = @AlbumName,
        artist_id = @ArtistID,
        release_date = @ReleaseDate,
        cover_image = @CoverImage,
        updated_at = GETDATE()
    WHERE album_id = @AlbumId;
END;

CREATE PROCEDURE GetAlbumById
    @AlbumId INT
AS
BEGIN
    SET NOCOUNT ON;

    -- Lấy thông tin chung của album
    SELECT 
        a.album_id,
        a.album_name,
        a.artist_id,
        ar.artist_name,
        a.release_date,
        a.cover_image,
        a.created_at,
        a.updated_at
    FROM Albums a
    LEFT JOIN Artists ar ON a.artist_id = ar.artist_id
    WHERE a.album_id = @AlbumId;

    -- Lấy danh sách bài hát trong album
    SELECT 
        s.song_id,
        s.song_name,
        s.genre_id,
        g.genre_name,
        s.lyrics,
        s.release_date,
        s.file_name,
        s.thumbnail_image,
        s.created_at,
        s.updated_at
    FROM Songs s
    LEFT JOIN Genres g ON s.genre_id = g.genre_id
    WHERE s.album_id = @AlbumId;
END;



CREATE PROCEDURE AddPlaylist
    @UserId INT,
    @PlaylistName NVARCHAR(100)
AS
BEGIN
    INSERT INTO Playlists (user_id, playlist_name, created_at, updated_at)
    VALUES (@UserId, @PlaylistName, GETDATE(), GETDATE());
END;
CREATE PROCEDURE AddSongToPlaylist
    @PlaylistId INT,
    @SongId INT
AS
BEGIN
    INSERT INTO PlaylistSongs (playlist_id, song_id, added_at)
    VALUES (@PlaylistId, @SongId, GETDATE());
END;

drop proc AddPlaylist

select * from Users
select * from Playlists
select * from PlaylistSongs

CREATE PROCEDURE RemoveSongFromPlaylist
    @PlaylistId INT,
    @SongId INT
AS
BEGIN
    DELETE FROM PlaylistSongs
    WHERE playlist_id = @PlaylistId AND song_id = @SongId;
END;

CREATE PROCEDURE DeletePlaylist
    @PlaylistId INT
AS
BEGIN
    DELETE FROM PlaylistSongs WHERE playlist_id = @PlaylistId;
    DELETE FROM Playlists WHERE playlist_id = @PlaylistId;
END;

CREATE PROCEDURE GetUserInfo
    @UserId INT
AS
BEGIN
    SET NOCOUNT ON;

    SELECT 
        user_id,
        username,
        fullname,
        email,
        phone_number,
        created_at,
        updated_at,
        role
    FROM Users
    WHERE user_id = @UserId;
END;

CREATE PROCEDURE GetUserPlaylists
    @UserId INT
AS
BEGIN
    SET NOCOUNT ON;

    SELECT 
        p.playlist_id,
        p.playlist_name,
        p.created_at,
        p.updated_at
    FROM Playlists p
    WHERE p.user_id = @UserId;
END;
CREATE PROCEDURE GetSongsInPlaylist
    @PlaylistId INT
AS
BEGIN
    SET NOCOUNT ON;

    SELECT 
        s.song_id,
        s.song_name,
        s.release_date,
        s.file_name,
        s.thumbnail_image,
        s.views_song,
        s.likes_count,
        a.album_name,
        g.genre_name,
        ar.artist_name
    FROM PlaylistSongs ps
    JOIN Songs s ON ps.song_id = s.song_id
    LEFT JOIN Albums a ON s.album_id = a.album_id
    LEFT JOIN Genres g ON s.genre_id = g.genre_id
    LEFT JOIN SongArtists sa ON s.song_id = sa.song_id
    LEFT JOIN Artists ar ON sa.artist_id = ar.artist_id
    WHERE ps.playlist_id = @PlaylistId;
END;

drop proc GetSongsInPlaylist
select * from Users

EXEC GetUserPlaylists @UserId = 2
select * from PlaylistSongs

CREATE PROCEDURE GetAllData
AS
BEGIN
    -- Set NOCOUNT ON để tránh ảnh hưởng đến các thông báo ghi đếm
    SET NOCOUNT ON;

    -- Lấy danh sách người dùng
    SELECT *
    FROM Users;

    -- Lấy danh sách thể loại
    SELECT *
    FROM Genres;

    -- Lấy danh sách nghệ sĩ
    SELECT *
    FROM Artists;

    -- Lấy danh sách album
    SELECT a.*, ar.artist_name
    FROM Albums a
    LEFT JOIN Artists ar ON a.artist_id = ar.artist_id;

    -- Lấy danh sách bài hát
    SELECT s.*, g.genre_name, al.album_name, al.cover_image
    FROM Songs s
    LEFT JOIN Genres g ON s.genre_id = g.genre_id
    LEFT JOIN Albums al ON s.album_id = al.album_id;

    -- Lấy nghệ sĩ của bài hát
    SELECT sa.*, ar.artist_name, s.song_name
    FROM SongArtists sa
    LEFT JOIN Artists ar ON sa.artist_id = ar.artist_id
    LEFT JOIN Songs s ON sa.song_id = s.song_id;

    -- Lấy danh sách phát
    SELECT p.*, u.username
    FROM Playlists p
    LEFT JOIN Users u ON p.user_id = u.user_id;

    -- Lấy bài hát trong danh sách phát
    SELECT ps.*, pl.playlist_name, s.song_name
    FROM PlaylistSongs ps
    LEFT JOIN Playlists pl ON ps.playlist_id = pl.playlist_id
    LEFT JOIN Songs s ON ps.song_id = s.song_id;

    -- Lấy bình luận
    SELECT c.*, u.username, s.song_name
    FROM Comments c
    LEFT JOIN Users u ON c.user_id = u.user_id
    LEFT JOIN Songs s ON c.song_id = s.song_id;

END;
GO
EXEC GetAllData