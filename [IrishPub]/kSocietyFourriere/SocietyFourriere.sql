
CREATE TABLE `society_vehicles` (
	`society` varchar(40) NOT NULL,
	`plate` varchar(12) NOT NULL,
	`vehicle` longtext,
	`label` varchar(40) NOT NULL,
	`stored` TINYINT NOT NULL DEFAULT '0',
	`lieu` longtext DEFAULT NULL,

	PRIMARY KEY (`plate`)
);