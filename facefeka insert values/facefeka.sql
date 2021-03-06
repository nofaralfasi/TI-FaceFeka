-- phpMyAdmin SQL Dump
-- version 4.9.0.1
-- https://www.phpmyadmin.net/
--
-- Host: 127.0.0.1
-- Generation Time: Jul 3, 2019 at 05:29 PM
-- Server version: 10.3.16-MariaDB
-- PHP Version: 7.3.7

SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
SET AUTOCOMMIT = 0;
START TRANSACTION;
SET time_zone = "+00:00";


/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8mb4 */;

--
-- Database: `facefeka`
--
CREATE DATABASE IF NOT EXISTS `facefeka` DEFAULT CHARACTER SET latin1 COLLATE latin1_swedish_ci;
USE `facefeka`;

-- --------------------------------------------------------

--
-- Table structure for table `certificates`
--

CREATE TABLE `certificates` (
  `certIndex` int(11) NOT NULL,
  `usersID` int(4) NOT NULL,
  `certificate` varchar(128) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

--
-- Dumping data for table `certificates`
--

INSERT INTO `certificates` (`certIndex`, `usersID`, `certificate`) VALUES
(2, 22222, '$7DtCTXaTEVDk'),
(3, 33333, '$7tDYz5fOsOV6'),
(4, 44444, '$7hmTbIqIL8QQ'),
(5, 55555, '$7jObasqJ85.c'),
(6, 66666, '$7hLg0YYG3Ryw'),
(7, 99999, '$7jhuQKAFpkXk');

-- --------------------------------------------------------

--
-- Table structure for table `follow`
--

CREATE TABLE `follow` (
  `followIndex` int(11) NOT NULL,
  `followedID` int(11) NOT NULL,
  `followerID` int(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

--
-- Dumping data for table `follow`
--

INSERT INTO `follow` (`followIndex`, `followedID`, `followerID`) VALUES
(1, 22222, 33333),
(2, 55555, 33333),
(3, 44444, 33333),
(5, 33333, 99999),
(6, 33333, 55555),
(7, 55555, 22222);

-- --------------------------------------------------------

--
-- Table structure for table `likes`
--

CREATE TABLE `likes` (
  `likesIndex` int(11) NOT NULL,
  `postID` int(11) NOT NULL,
  `usersID` int(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

-- --------------------------------------------------------

--
-- Table structure for table `posts`
--

CREATE TABLE `posts` (
  `postsID` int(11) NOT NULL,
  `usersID` int(11) NOT NULL,
  `postsContent` text NOT NULL,
  `postsPic` varchar(1000) DEFAULT NULL,
  `postsPic2` varchar(1000) DEFAULT NULL,
  `postsPic3` varchar(1000) DEFAULT NULL,
  `postsPic4` varchar(1000) DEFAULT NULL,
  `postsPic5` varchar(1000) DEFAULT NULL,
  `postsPic6` varchar(1000) DEFAULT NULL,
  `postsDateCreated` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `postsPerPic` varchar(2000) DEFAULT NULL,
  `private` tinyint(1) NOT NULL DEFAULT '0'
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

--
-- Dumping data for table `posts`
--

INSERT INTO `posts` (`postsID`, `usersID`, `postsContent`, `postsPic`,`postsPic2`,`postsPic3`,`postsPic4`,`postsPic5`,`postsPic6`, `postsDateCreated`, `private`,`postsPerPic`) VALUES
(1, 22222, 'We are engineers, not robots', 'https://sensi.emerson.com/resource/blob/partner-wink-robots-cool-tw-data-4204132.jpg','https://upload.wikimedia.org/wikipedia/he/1/14/LogoDisney.JPG','https://static.askpeople.co.il/tips/pictures/630x505/91_1511031381.jpg','https://images1.calcalist.co.il/PicServer2/20122005/594399/6_l.jpg','https://www.ashops.co.il/Shops/shop_162/products/501/picture_744.jpg','https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcRvP3bzpJEyqMZ9ocvmHrmXokQr5kl4CIlJD34oMF7WwitmqJ-l2g', '2019-07-12 20:42:31', 0,'https://scontent-lhr3-1.cdninstagram.com/vp/ecea2b776939a0dd56bee1dcefa7a5b4/5DAF0ADD/t51.2885-19/12677240_629567913867848_1800421903_a.jpg?_nc_ht=scontent-lhr3-1.cdninstagram.com'),
(2, 22222, 'I Want Ice-Cream.', 'https://sugarspunrun.com/wp-content/uploads/2018/07/Ice-Cream-Cone-Cupcakes-Recipe-1-of-1-6.jpg','https://img.wcdn.co.il/f_auto,w_700/2/4/2/8/2428769-46.jpg','https://www.intex-pool.co.il/images/itempics/58757_10032019163550_large.jpg','https://images-rosh1.yit.co.il//API/Media/Default/WP/2014/01/92275263.jpg','https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcR91tKryL7ej-Cxkzo1F5N1oqf-PTJ7akRXR8jD7xQdT3a_UH9LgA','https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcTAZvIrFdjefKzDNszjzhg0Y76GMsKTktHurG2qS8b_6aoYwxhD', '2019-07-12 21:26:37', 0,'https://scontent-lhr3-1.cdninstagram.com/vp/ecea2b776939a0dd56bee1dcefa7a5b4/5DAF0ADD/t51.2885-19/12677240_629567913867848_1800421903_a.jpg?_nc_ht=scontent-lhr3-1.cdninstagram.com'),
(5, 33333, 'Play Flappy Birds together!', 'https://i.ytimg.com/vi/WSW-5m8lRMs/maxresdefault.jpg','https://cdn.vox-cdn.com/thumbor/vysE6HXQ1iRyqA1IZqHzREZvI_c=/0x0:639x426/1400x1400/filters:focal(0x0:639x426):format(png)/cdn.vox-cdn.com/assets/3964735/flappy_bird.png',NULL,NULL,NULL,NULL, '2019-07-13 07:26:37', 0,'https://www.startus.cc/system/files/styles/squared_photos_style/private/photo/filehs8rBb.jpg?itok=np9aN8uY&sc=298b6a182ccd20df1eea6197d03f7cc6'),
(6, 55555, 'I can never find a decent parking spot near the phickus', 'https://media.wired.com/photos/5926b773f3e2356fd800a373/master/w_2130,c_limit/WarOnParking_TA_GettyImages-83314262.png',NULL,NULL,NULL,NULL,NULL, '2019-07-14 20:17:03', 0,'http://www.emedia-p.co.il/wp-content/uploads/2013/08/DS01.jpg'),
(7, 99999, 'Pretty #bad', 'https://www.hallaminternet.com/assets/Bad-Reviews-Dislike-Netative-Reviews.jpg',NULL,NULL,NULL,NULL,NULL, '2019-07-14 20:25:30', 0,'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcRnqbXblDsbiJnUeExlJkp4KCPfNeOmPNH5EBM00mXksO_RbMIy'),
(3, 33333, 'Chernobyl', 'https://i.imgur.com/gCPcOBj.jpg','https://f.frogi.co.il/news/640x300/0101700e7cb.jpg','https://www.gadgety.co.il/wp-content/themes/main/thumbs/2019/07/micky-disney-350x233.jpg',NULL,NULL,NULL, '2019-07-13 12:23:17', 1,'https://www.startus.cc/system/files/styles/squared_photos_style/private/photo/filehs8rBb.jpg?itok=np9aN8uY&sc=298b6a182ccd20df1eea6197d03f7cc6'),
(4, 22222, 'When is the release of Angular 9?', 'https://i0.wp.com/helpdev.eu/wp-content/uploads/2019/06/angular-9.jpg?resize=696%2C557&ssl=1','https://upload.wikimedia.org/wikipedia/commons/thumb/d/d9/Node.js_logo.svg/1200px-Node.js_logo.svg.png','https://oauth.net/images/code/nodejs.png',NULL,NULL,NULL, '2019-07-13 12:27:55', 1,'https://scontent-lhr3-1.cdninstagram.com/vp/ecea2b776939a0dd56bee1dcefa7a5b4/5DAF0ADD/t51.2885-19/12677240_629567913867848_1800421903_a.jpg?_nc_ht=scontent-lhr3-1.cdninstagram.com');
-- --------------------------------------------------------

--
-- Table structure for table `reply`
--

CREATE TABLE `reply` (
  `replyIndex` int(11) NOT NULL,
  `postsID` int(11) NOT NULL,
  `usersID` int(11) NOT NULL,
  `replyContent` text NOT NULL,
  `replyCreated` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

--
-- Dumping data for table `reply`
--

INSERT INTO `reply` (`replyIndex`, `postsID`, `usersID`, `replyContent`, `replyCreated`) VALUES
(1, 2, 22222, 'Reply 1 TEST', '2019-07-12 22:44:52'),
(2, 2, 44444, 'LOL.', '2019-07-12 22:46:55'),
(3, 2, 33333, 'We are engineers, not robots', '2019-07-12 23:06:52'),
(4, 2, 22222, 'I can never find a decent parking spot near the phickus', '2019-07-13 00:13:58'),
(5, 3, 99999, 'The answer is 42', '2019-07-13 00:15:35'),
(6, 2, 22222, 'Why do you go to there?', '2019-07-13 11:08:23'),
(7, 1, 33333, 'Did you quit?', '2019-07-13 11:12:02'),
(8, 2, 33333, 'Hahahahaha', '2019-07-13 11:13:18'),
(9, 2, 44444, 'Play Flappy Birds together!', '2019-07-13 11:13:48'),
(10, 4, 33333, 'Even my sixth year in Afeka is better', '2019-07-13 11:15:24'),
(11, 6, 55555, 'When is the release of Angular 9?', '2019-07-14 20:17:21'),
(12, 5, 66666, 'Trust me, I am an engineer', '2019-07-14 20:17:39');

-- --------------------------------------------------------

--
-- Table structure for table `users`
--

CREATE TABLE `users` (
  `usersIndex` int(11) NOT NULL,
  `usersID` int(4) NOT NULL,
  `usersName` varchar(32) CHARACTER SET utf8 COLLATE utf8_bin NOT NULL,
  `usersPass` varchar(128) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

--
-- Dumping data for table `users`
--

INSERT INTO `users` (`usersIndex`, `usersID`, `usersName`, `usersPass`) VALUES
(2, 22222, 'avia', '$7Ssq34cARZQc'),
(3, 33333, 'nofar', '$7.pB1DRQ1iro'),
(4, 44444, 'mica', '$7htfyt1oxDZ2'),
(5, 55555, 'tom', '$71mtWt2hSULA'),
(6, 66666, 'haim', '$7KFhFYVG4dH6'),
(7, 99999, 'bibi', '$7lYSi.3FuIRo');



CREATE TABLE `facefeka`.`details` ( `userID` INT(9) NOT NULL ,
 `detailsContent` VARCHAR(1000) NULL ,
 `detailsPic` VARCHAR(1000) NULL ,
 `userCity` VARCHAR(1000) NULL ,
 `userAge` VARCHAR(1000) NULL ) ENGINE = InnoDB;



INSERT INTO `details` (`userID`, `detailsContent`, `detailsPic`, `userCity`, `userAge`) VALUES
 ('22222', 'Im a student of mica', 'https://scontent-lhr3-1.cdninstagram.com/vp/ecea2b776939a0dd56bee1dcefa7a5b4/5DAF0ADD/t51.2885-19/12677240_629567913867848_1800421903_a.jpg?_nc_ht=scontent-lhr3-1.cdninstagram.com', 'Ramat Hashron', '26'),
 ('33333', 'Im a student of mica', 'https://www.startus.cc/system/files/styles/squared_photos_style/private/photo/filehs8rBb.jpg?itok=np9aN8uY&sc=298b6a182ccd20df1eea6197d03f7cc6', 'Rison Lezion', '25'),
 ('44444', 'The Best Lecturer ever', 'https://yedionpub.afeka.ac.il/yedion/fireflyweb.aspx?prgname=GetFile&Arguments=-N200,-N,-N,-A,-N442,-A,-A,-A,-A,-A', 'Ness-Ziona', '35'),
 ('55555', 'I LOVE CHEESE', 'http://www.emedia-p.co.il/wp-content/uploads/2013/08/DS01.jpg', 'Tel Aviv', '10'),
 ('66666', 'i like cooking', 'https://i.ytimg.com/vi/3zruuf8fbCw/maxresdefault.jpg', 'Rehovot', '20'),
 ('99999', 'Im here for stay', 'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcRnqbXblDsbiJnUeExlJkp4KCPfNeOmPNH5EBM00mXksO_RbMIy', 'Jerusalem', '45');
 
 



--
-- Indexes for dumped tables
--

--
-- Indexes for table `certificates`
--
ALTER TABLE `certificates`
  ADD PRIMARY KEY (`certIndex`);

--
-- Indexes for table `follow`
--
ALTER TABLE `follow`
  ADD PRIMARY KEY (`followIndex`);

--
-- Indexes for table `likes`
--
ALTER TABLE `likes`
  ADD PRIMARY KEY (`likesIndex`);

--
-- Indexes for table `posts`
--
ALTER TABLE `posts`
  ADD PRIMARY KEY (`postsID`);

--
-- Indexes for table `reply`
--
ALTER TABLE `reply`
  ADD PRIMARY KEY (`replyIndex`);

--
-- Indexes for table `users`
--
ALTER TABLE `users`
  ADD PRIMARY KEY (`usersID`),
  ADD KEY `usersIndex` (`usersIndex`);

--
-- AUTO_INCREMENT for dumped tables
--

--
-- AUTO_INCREMENT for table `certificates`
--
ALTER TABLE `certificates`
  MODIFY `certIndex` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=10;
--
-- AUTO_INCREMENT for table `follow`
--
ALTER TABLE `follow`
  MODIFY `followIndex` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=8;
--
-- AUTO_INCREMENT for table `likes`
--
ALTER TABLE `likes`
  MODIFY `likesIndex` int(11) NOT NULL AUTO_INCREMENT;
--
-- AUTO_INCREMENT for table `posts`
--
ALTER TABLE `posts`
  MODIFY `postsID` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=8;
--
-- AUTO_INCREMENT for table `reply`
--
ALTER TABLE `reply`
  MODIFY `replyIndex` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=13;
--
-- AUTO_INCREMENT for table `users`
--
ALTER TABLE `users`
  MODIFY `usersIndex` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=10;
COMMIT;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
