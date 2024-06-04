create table youtube (
  video_id text CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci not null primary key,
  title text CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci,
  publishedAt datetime,
  channelId text CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci,
  channelTitle text CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci,
  categoryId int,
  trending_date datetime,
  tags text CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci,
  view_count int,
  likes int,
  dislikes int,
  comment_count int,
  thumbnail_link text CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci,
  comments_disabled text CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci,
  ratings_disabled text CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci,
  video_description text character set utf8mb4 collate utf8mb4_general_ci
);


load data local infile 'example/youtube_trending.csv'
into table youtube
character set 'utf8'
columns terminated by ',' enclosed by '"'
lines terminated by '\n';

