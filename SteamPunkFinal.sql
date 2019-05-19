/*
 * SteamPunk Database (Phase 2)
 */

/* Delete pre-existing SteamPunk database, if it exists. */
USE master;
IF DB_ID('SteamPunk') IS NOT NULL
	DROP DATABASE SteamPunk;
CREATE DATABASE SteamPunk;
GO

USE SteamPunk;
/* 
 * The following tables are created and used in the SteamPunk database:
		GameUser
		GameCategory
		PurchaseOrder
		Vendor
		Game
		DLC
		Promotion
		Achievements
		Community
		News
		PaymentInfo
		Confirmation
		Denial
		ChatRoom
		TalkMessage
		Technicians
		Ticket
		BelongtoCommunity
		Promote
		ParticipateinChatroom
		ResposibleforTicket
		Achieve
		GameResidesIn
		DLCResidentsIn
 */

/*Create Table for GameUser. GameUser links to multiple tables which include PurchaseOrder, Ticket, ParticipateInChatroom, Achieve, and Community by UserID*/
CREATE TABLE GameUser (
	UserID CHAR(8) NOT NULL,
	Name VARCHAR(15) NOT NULL,
	Email VARCHAR(25) NOT NULL,
	PRIMARY KEY(UserID)
	);
/*Create table for GameCategory. Links to Game by CatName.*/
CREATE TABLE GameCategory (
	CatName VARCHAR(15) NOT NULL,
	CategoryDescription TEXT,
	PRIMARY KEY(CatName)
	);
/*CREATE table for PurchaseOrder. Links to GameUser by UserID.*/
CREATE TABLE PurchaseOrder (
	POID CHAR(12) NOT NULL,
	UserID CHAR(8) NOT NULL,
	PRIMARY KEY(POID),
	);
/*Create table for Vendor. Links to Game.*/
CREATE TABLE Vendor (
	VendorID CHAR(8) NOT NULL,
	Name VARCHAR(15) NOT NULL,
	Street VARCHAR(20) NOT NULL,
	City VARCHAR(20) NOT NULL,
	StateAbbr CHAR(2) NOT NULL,
	Zip CHAR(5) NOT NULL CHECK (Zip<99999 AND ZIP>0),
	PRIMARY KEY(VendorID)
	);
/*Create table for Game. Links to GameCategory, and Vendor.*/
CREATE TABLE Game (
	GameID CHAR(10) NOT NULL,
	Title VARCHAR(20) NOT NULL,
	GameDescription TEXT,
	Price FLOAT NOT NULL CHECK (Price>=0),
	CatName VARCHAR(15) NOT NULL,
	VendorID CHAR(8) NOT NULL,
	PRIMARY KEY(GameID)
	);

/*Create table for DLC. DLC links to DLCResidentsIn and Game. */
CREATE TABLE DLC (
	DLCName VARCHAR(20) NOT NULL,
	GameID CHAR(10) NOT NULL,
	DLCDescription TEXT,
	Price Money NOT NULL,
	POID CHAR(12) NOT NULL,
	PRIMARY KEY(DLCName, GameID)
	);
/*Create table for Promotion. Links to Promote */
CREATE TABLE Promotion (
	PromID CHAR(6) NOT NULL,
	StartTime DATE NOT NULL,
	EndTime DATE NOT NULL,
	Name VARCHAR(20) NOT NULL,
	PRIMARY KEY(PromID)
	);
/*Create table for Achievements. Links to Achieve*/
CREATE TABLE Achievements (
	AchieveID CHAR(6) NOT NULL,
	Name VARCHAR(30) NOT NULL,
	DLCDescription TEXT,
	PRIMARY KEY(AchieveID)
	);
/*Create table for Community. Links to Game, News, and BelongToCommunity*/
CREATE TABLE Community (
	ComID CHAR(6) NOT NULL,
	Name VARCHAR(20) NOT NULL,
	GameID CHAR(10) NOT NULL,
	UserID CHAR(8) NOT NULL,
	PRIMARY KEY(ComID)
	);
/*Create table for News. Links to BelongToCommunity, and Community*/
CREATE TABLE News (
	ComID CHAR(6) NOT NULL,
	PublishTime TIMESTAMP NOT NULL,
	Content TEXT NOT NULL,
	PRIMARY KEY(ComID, PublishTime)
	);
/*Create table for PaymentInfo. Links to Conformation and Denial. */
CREATE TABLE PaymentInfo (
	PaymentID CHAR(10) NOT NULL,
	CCNum CHAR(16) NOT NULL,
	ExpDate DATE NOT NULL,
	SecurityCode VARCHAR(4) NOT NULL,
	Street VARCHAR(20) NOT NULL,
	City VARCHAR(20) NOT NULL,
	StateAbbr CHAR(2) NOT NULL,
	Zip CHAR(5) NOT NULL CHECK(Zip<99999 AND Zip>0),
	POID CHAR(12) NOT NULL,
	PRIMARY KEY(PaymentID)
	);
/*Create table for Confirmation. Links to PaymentInfo. */
CREATE TABLE Confirmation (
	confID CHAR(11) NOT NULL,
	ConfDate DATE NOT NULL,
	PaymentID CHAR(10) NOT NULL,
	PRIMARY KEY(confID)
	);
/*Create table for Denial. Links to PaymentInfo*/
CREATE TABLE Denial (
	DenialID CHAR(11) NOT NULL,
	DenialDate DATE NOT NULL,
	Reason TEXT,
	PaymentID CHAR(10) NOT NULL,
	PRIMARY KEY(DenialID)
	);
/*Create table for ChatRoom. Links to ParticipateInChatRoom*/
CREATE TABLE ChatRoom (
	RoomID CHAR(9) NOT NULL,
	Name VARCHAR(15) NOT NULL,
	PRIMARY KEY(RoomID)
	);
/*Create table for TalkMessage. Links to ChatRoom*/
CREATE TABLE TalkMessage (
	RoomID CHAR(9) NOT NULL,
	MessageTime DateTime NOT NULL,
	Content TEXT NOT NULL,
	PRIMARY KEY(RoomID, MessageTime)
	);
/*Create table for Technicians. Links to Ticket*/
CREATE TABLE Technicians (
	TechID CHAR(4) NOT NULL,
	Name VARCHAR(15) NOT NULL,
	PRIMARY KEY(TechID)
	);
/*Create table for Ticket. Links to GameUser and Technicians*/
CREATE TABLE Ticket (
	TicketID CHAR(6) NOT NULL,
	Issue TEXT NOT NULL,
	StartTime TIMESTAMP NOT NULL,
	UserID CHAR(8) NOT NULL,
	TechID CHAR(4) NOT NULL,
	PRIMARY KEY(TicketID)
	);
/*Create table for BelongtoCommunity. Links to Community and GameUser*/
CREATE TABLE BelongtoCommunity (
	ComID CHAR(6) NOT NULL,
	UserID CHAR(8) NOT NULL,
	PRIMARY KEY(ComID, UserID)
	);
/*Create table for Promote. Links to Promotion, and Game*/
CREATE TABLE Promote (
	PromID CHAR(6) NOT NULL,
	GameID CHAR(10) NOT NULL,
	DiscountPrice FLOAT NOT NULL CHECK(DiscountPrice>=0),
	PRIMARY KEY(PromID, GameID)
	);
/*Create table for ParticipateinChatroom. Links to ChatRoom and GameUser.*/
CREATE TABLE ParticipateinChatroom (
	RoomID CHAR(9) NOT NULL,
	UserID CHAR(8) NOT NULL,
	PRIMARY KEY(RoomID, UserID)
	);
/*Create table for ResposibleforTicket. Links to Ticket, and Technicians.*/
CREATE TABLE ResposibleforTicket (
	TicketID CHAR(6) NOT NULL,
	TechID CHAR(4),
	ServiceStartTime TIMESTAMP,
	ServiceEndTime DATETIME,
	PRIMARY KEY(TicketID, TechID)
	);
/*Create table for Achieve. Links to Achievements, and GameUser*/
CREATE TABLE Achieve (
	AchieveID CHAR(6) NOT NULL,
	UserID CHAR(8) NOT NULL,
	AchTime TIMESTAMP NOT NULL,
	PRIMARY KEY(AchieveID, UserID)
	);
/*Create table for GameResidesIn. Links to Game, and PurchaseOrder*/
CREATE TABLE GameResidesIn (
	GameID CHAR(10) NOT NULL,
	POID CHAR(12) NOT NULL,
	PRIMARY KEY(GameID, POID)
	);
/*Create table for DLCResidentsIn. Links to Game, DLC, and PurchaseOrder.*/
CREATE TABLE DLCResidesIn (
	GameID CHAR(10) NOT NULL,
	DLCName VARCHAR(20) NOT NULL,
	POID CHAR(12) NOT NULL,
	PRIMARY KEY(GameID, DLCName, POID)
	);
GO

ALTER TABLE PurchaseOrder ADD
	FOREIGN KEY(UserID) REFERENCES GameUser(UserID)
	;
ALTER TABLE Game ADD
	FOREIGN KEY(CatName) REFERENCES GameCategory(CatName),
	FOREIGN KEY(VendorID) REFERENCES Vendor(VendorID)
	;
ALTER TABLE DLC ADD
	FOREIGN KEY(GameID) REFERENCES Game(GameID)
	;
ALTER TABLE Community ADD
	FOREIGN KEY(GameID) REFERENCES Game(GameID)
	;
ALTER TABLE News ADD
	FOREIGN KEY(ComID) REFERENCES Community(ComID)
	;
ALTER TABLE PaymentInfo ADD
	FOREIGN KEY(POID) REFERENCES PurchaseOrder(POID)
	;
ALTER TABLE Confirmation ADD
	FOREIGN KEY(PaymentID) REFERENCES PaymentInfo(PaymentID)
	;
ALTER TABLE Denial ADD
	FOREIGN KEY(PaymentID) REFERENCES PaymentInfo(PaymentID)
	;
ALTER TABLE TalkMessage ADD
	FOREIGN KEY(RoomID) REFERENCES ChatRoom(RoomID)
	;
ALTER TABLE Ticket ADD
	FOREIGN KEY(UserID) REFERENCES GameUser(UserID),
	FOREIGN KEY(TechID) REFERENCES Technicians(TechID)
	;
ALTER TABLE BelongtoCommunity ADD
	FOREIGN KEY(ComID) REFERENCES Community(ComID),
	FOREIGN KEY(UserID) REFERENCES GameUser(UserID)
	;
ALTER TABLE Promote ADD
	FOREIGN KEY(PromID) REFERENCES Promotion(PromID),
	FOREIGN KEY(GameID) REFERENCES Game(GameID)
	;
ALTER TABLE ParticipateinChatroom ADD
	FOREIGN KEY(RoomID) REFERENCES ChatRoom(RoomID),
	FOREIGN KEY(UserID) REFERENCES GameUser(UserID)
	;
ALTER TABLE ResposibleforTicket ADD
	FOREIGN KEY(TicketID) REFERENCES Ticket(TicketID),
	FOREIGN KEY(TechID) REFERENCES Technicians(TechID)
	;
ALTER TABLE Achieve ADD
	FOREIGN KEY(AchieveID) REFERENCES Achievements(AchieveID),
	FOREIGN KEY(UserID) REFERENCES GameUser(UserID)
	;
ALTER TABLE GameResidesIn ADD
	FOREIGN KEY(GameID) REFERENCES Game(GameID),
	FOREIGN KEY(POID) REFERENCES PurchaseOrder(POID)
	;
ALTER TABLE DLCResidesIn ADD
	FOREIGN KEY(DLCName, GameID) REFERENCES DLC(DLCName, GameID),
	FOREIGN KEY(POID) REFERENCES PurchaseOrder(POID)
	;
GO

/*Insert three GameUsers into GameUser table*/
INSERT INTO GameUser VALUES ('20150001', 'Mike', 'mike123@osu.edu');
INSERT INTO GameUser VALUES ('20150002', 'Jones', 'jones@gamil.com');
INSERT INTO GameUser VALUES ('20150003', 'Susan', 'ss520@outlook.com');
/*Insert two GameCategories into GameCategory table*/
INSERT INTO GameCategory VALUES ('RPG', '');
INSERT INTO GameCategory VALUES ('Sports','All kinds of sports games. Includes soccer, football, baseball and so on.');
/*Insert two PurchaseOrder into PurchaseOrder table*/
INSERT INTO PurchaseOrder VALUES ('201510220001','20150001');
INSERT INTO PurchaseOrder VALUES ('201510220002','20150002');
/*Insert two Vendors into Vendor table*/
INSERT INTO Vendor VALUES ('00000001', 'EA', 'Harley', 'Columbus', 'OH', '43202');
INSERT INTO Vendor VALUES ('00000002', 'Konami', '5th', 'Los Angeles', 'CA', '12345');
/*Insert four Games into Game table*/
INSERT INTO Game VALUES ('0000000001', 'FIFA2015', '', 49.99, 'Sports', '00000001');
INSERT INTO Game VALUES ('0000000002', 'NBA2015', '', 49.99, 'Sports', '00000001');
INSERT INTO Game VALUES ('0000000003', 'Metal Gear', '', 59.99, 'RPG', '00000002');
INSERT INTO Game VALUES ('0000000004', 'Metal Gear V', '', 69.99, 'RPG', '00000002');
/*Insert two DLCs into DLC table*/
INSERT INTO DLC VALUES ('Classic England', '0000000001', 'cool', 9.99,'001');
INSERT INTO DLC VALUES ('Classic Germany', '0000000001', 'yep', 9.99,'002');
/*Insert two Promotions into Promotion table*/
INSERT INTO Promotion VALUES ('201511', '2015-11-15', '2015-11-30', 'Thanksgiving Sale');
/*Insert two Achievements into Achievements table*/
INSERT INTO Achievements VALUES ('000101', 'World Cup Champion', 'Win the world cup with any team.');
INSERT INTO Achievements VALUES ('000401', 'Just Start', 'Play the game for 5 hours.');
/*Insert two Community into Community table*/
INSERT INTO Community VALUES ('000101', 'Brazil Fans', '0000000001','0001');
INSERT INTO Community VALUES ('000102', 'Germany Fans', '0000000001','0001');
/*Insert two News into News table*/
INSERT INTO News(ComID, Content) VALUES ('000101', 'Welcome to Brazil Fan!');
INSERT INTO News(ComID, Content) VALUES ('000101', 'Congratulation to Mike win the world cup competetion!');
/*Insert two PaymentInfos into PaymentInfo table*/
INSERT INTO PaymentInfo VALUES ('2015102201', '1234123412341234', '2017-08-31', '000', 'St John Ct', 'Columbus', 'OH', '43202', '201510220001');
INSERT INTO PaymentInfo VALUES ('2015102202', '4321432143214321', '2015-01-31', '1111', '10th Ave', 'Cleverland', 'OH', '12345', '201510220002');
/*Insert one Confirmation into Confirmation table*/
INSERT INTO Confirmation VALUES ('02015102201', '2015-10-31', '2015102201');
/*Insert one Denial into Denial table*/
INSERT INTO Denial VALUES ('12015102202', '2015-10-30', 'Expired Credit Card', '2015102202');
/*Insert two ChatRooms into ChatRoom table*/
INSERT INTO ChatRoom VALUES ('123456789', 'OSU Fan');
INSERT INTO ChatRoom VALUES ('987654321', 'Soccer Lover');
/*Insert three Messages into Messages table*/
INSERT INTO TalkMessage(RoomID, MessageTime, Content) VALUES ('123456789', '2015-10-30', 'Hi!');
INSERT INTO TalkMessage(RoomID, MessageTime, Content) VALUES ('123456789', '2015-10-31', 'Happy Halloween!');
INSERT INTO TalkMessage(RoomID, MessageTime, Content) VALUES ('123456789', '2015-11-01', 'Nice to meet you guys!');
/*Insert one Technician into Technicians table*/
INSERT INTO Technicians VALUES ('0001', 'John');
/*Insert two Tickets into Ticket table*/
INSERT INTO Ticket(TicketID, Issue, UserID, TechID) VALUES ('102201', 'Cannot log into my account.', '20150002','0001');
INSERT INTO Ticket(TicketID, Issue, UserID, TechID) VALUES ('102202', 'Where is my new purchased game?',  '20150003','0001');
/*Insert two BelongtoCommunity into BelongtoCommunity table*/
INSERT INTO BelongtoCommunity VALUES ('000101', '20150001');
INSERT INTO BelongtoCommunity VALUES ('000101', '20150003');
/*Insert two Promotes into Promote table*/
INSERT INTO Promote VALUES ('201511', '0000000001', 29.99);
INSERT INTO Promote VALUES ('201511', '0000000003', 39.99);
/*Insert three ParticipateinChatrooms into ParticipateinChatroom table*/
INSERT INTO ParticipateinChatroom VALUES ('123456789', '20150001');
INSERT INTO ParticipateinChatroom VALUES ('123456789', '20150002');
INSERT INTO ParticipateinChatroom VALUES ('987654321', '20150001');
/*Insert two ResposibleforTickets into ResposibleforTicket table*/
INSERT INTO ResposibleforTicket(TicketID, TechID) VALUES ('102201', '0001');
INSERT INTO ResposibleforTicket(TicketID, TechID) VALUES ('102202', '0001');



/*Insert one Achieves into Achieve table*/
INSERT INTO Achieve(AchieveID, UserID) VALUES ('000101', '20150001');
INSERT INTO Achieve(AchieveID, UserID) VALUES ('000401', '20150001');
/*Insert one GameResidesIns into GameResidesIn table*/
INSERT INTO GameResidesIn VALUES ('0000000001', '201510220001');
INSERT INTO GameResidesIn VALUES ('0000000001', '201510220002');
INSERT INTO GameResidesIn VALUES ('0000000004', '201510220002');


/*titleIndex will allow queries by game title in addition to the primary key GameID*/
CREATE INDEX titleIndex
On Game(Title)

/*The userNameIndex will allow queries of the GameUser table by the Name attribute in addition to the userID primary key*/
CREATE INDEX userNameIndex
On GameUser(Name)

/*The vendorNameIndex will allow Vendor table queries via name in addition to the VendorID primary key*/
CREATE INDEX vendorNameIndex
On Vendor(Name)





/*Insert one GameResidesIns into GameResidesIn table*/
/* TODO:  The following first needs a DLC insert into the database, to fit FK
 * INSERT INTO DLCResidesIn VALUES ('000000001', 'Classic England', '201510220001');
 */

/* Finish batch of INSERTs */
GO

CREATE TRIGGER DenialGreaterThanFive
ON Denial
FOR INSERT
AS BEGIN
	DECLARE @Attempts INT
	SELECT @Attempts = COUNT(DenialID) FROM Denial
	IF @Attempts > 5
		BEGIN
			PRINT 'ILLEGAL Intrusion'
		END
	END;
GO

CREATE TRIGGER PriceExceedsOriginal
ON Promote
FOR INSERT,UPDATE
AS
BEGIN
	DECLARE @Original MONEY
	DECLARE @Promoted MONEY
	SELECT @Original = Price FROM Game
	SELECT @Promoted = DiscountPrice FROM Promote
	IF (@Promoted >= @Original)
		BEGIN
			PRINT 'ILLEGAL PRICE CHANGE'
			PRINT 'ALERT ADMIN'
		END
END;
GO

/*
 *Retrieve the list of users who are using either the communities or the chat rooms
 */
IF OBJECT_ID ( 'chatroom_or_community', 'P' ) IS NOT NULL 
    DROP PROCEDURE chatroom_or_community;
GO
CREATE PROCEDURE chatroom_or_community
AS
SELECT *
FROM GameUser
WHERE (
	UserID IN (SELECT UserID FROM ParticipateInChatroom) OR
	UserID IN (SELECT UserID FROM BelongToCommunity)
	);
GO

/*
 *Retrieve the list of users who are using both the communities and the chat rooms
 */
IF OBJECT_ID ( 'chatroom_and_community', 'P' ) IS NOT NULL 
    DROP PROCEDURE chatroom_and_community;
GO
CREATE PROCEDURE chatroom_and_community
AS
SELECT *
FROM GameUser
WHERE (
UserID IN (SELECT UserID FROM ParticipateInChatroom) AND
UserID IN (SELECT UserID FROM BelongToCommunity)
);
GO

/*
 *Retrieve the list of games which have never been in a promotion
 */
IF OBJECT_ID ( 'never_in_promotion', 'P' ) IS NOT NULL 
    DROP PROCEDURE never_in_promotion;
GO
CREATE PROCEDURE never_in_promotion
AS
SELECT *
FROM Game AS G
WHERE NOT EXISTS (
SELECT * FROM Promote AS P WHERE P.GameID = G.GameID
);
GO

/*
 *Retrieve the UserID of users who have achieved all the achievements
 */
IF OBJECT_ID ( 'all_achievements', 'P' ) IS NOT NULL 
    DROP PROCEDURE all_achievements;
GO
CREATE PROCEDURE all_achievements
AS
SELECT *
FROM GameUser AS G
WHERE NOT EXISTS (
    SELECT AchieveID
    FROM Achievements AS A
    WHERE NOT EXISTS (
        SELECT *
        FROM Achieve AS B
        WHERE B.UserID = G.UserID AND A.AchieveID = B.AchieveID
    )
);
GO

/*
 *For each game, tell me how many have been purchased
 */
IF OBJECT_ID ( 'total_sale_number', 'P' ) IS NOT NULL 
    DROP PROCEDURE total_sale_number;
GO
CREATE PROCEDURE total_sale_number
AS
SELECT GameID, COUNT(*) AS SaleNumber
FROM GameResidesIn
GROUP BY GameID;
GO

/*
 *Retrieve the list of users whose payment info has been denied
 */
IF OBJECT_ID ( 'payment_denied', 'P' ) IS NOT NULL 
    DROP PROCEDURE payment_denied;
GO
CREATE PROCEDURE payment_denied
AS
SELECT *
FROM GameUser AS G
WHERE G.UserID IN
      (SELECT UserID 
       FROM PurchaseOrder AS S
	   WHERE S.POID IN
	   (SELECT POID
	    FROM PaymentInfo AS P
		WHERE P.PaymentID IN
		(SELECT PaymentID 
		 FROM Denial )));
GO

/*
 *Retrieve users who have purchased games
 */
 IF OBJECT_ID ( 'game_users_huge_table', 'P' ) IS NOT NULL
	DROP PROCEDURE game_users_huge_table;
GO
CREATE PROCEDURE game_users_huge_table
AS 
SELECT *
FROM GameUser
	FULL OUTER JOIN PurchaseOrder ON GameUser.UserID = PurchaseOrder.UserID
	FULL OUTER JOIN GameResidesIn ON GameResidesIn.POID = PurchaseOrder.POID
	FULL OUTER JOIN Game ON Game.GameID = GameResidesIn.GameID;
 SELECT *
 FROM GameUser 
	FULL OUTER JOIN PurchaseOrder ON GameUser.UserID = PurchaseOrder.UserID
	FULL OUTER JOIN GameResidesIn ON GameResidesIn.POID = PurchaseOrder.POID
	FULL OUTER JOIN Game ON Game.GameID = GameResidesIn.GameID;
GO