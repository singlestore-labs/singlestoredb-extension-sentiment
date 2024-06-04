create table youtube (
  video_id text not null primary key,
  title text,
  publishedAt datetime,
  channelId text,
  channelTitle text,
  categoryId int,
  trending_date datetime,
  tags text,
  view_count int,
  likes int,
  dislikes int,
  comment_count int,
  thumbnail_link text,
  comments_disabled text,
  ratings_disabled text,
  video_description text
);


load data local infile 'example/youtube_trending.csv'
into table youtube
character set 'utf8'
columns terminated by ',' enclosed by '"'
lines terminated by '\n';

