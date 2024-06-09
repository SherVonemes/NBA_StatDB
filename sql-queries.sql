SELECT Home, Visitor, Arena, MAX(Attendance) AS MaxAttendance
FROM matches
GROUP BY Home, Visitor
ORDER BY MaxAttendance DESC
LIMIT 10;

SELECT Pos, AVG(Points) AS AvgPoints
FROM players
GROUP BY Pos
HAVING AVG(Points) > 6
ORDER BY AvgPoints DESC;

SELECT Player, Points
FROM players
WHERE Points = (
    SELECT MAX(Points)
    FROM players p
    WHERE p.Team = players.Team
);

SELECT Player, EfficientFieldGoalsRate, points
FROM players
where points>10
ORDER BY EfficientFieldGoalsRate DESC
limit 10;


SELECT avg(Points) AS avgPoints
FROM players;
SELECT DISTINCT Pos FROM players;

SELECT Date, Home, Visitor, PointsHome, PointsVisitor
FROM matches
WHERE PointsHome = (
    SELECT MAX(PointsHome)
    FROM matches
);

SELECT Date, Home, Visitor, PointsHome, PointsVisitor
FROM matches
WHERE PointsVisitor = (
    SELECT MAX(PointsVisitor)
    FROM matches
);

WITH HomeWins AS (
    SELECT Home AS Team, COUNT(*) AS Wins
    FROM matches
    WHERE PointsHome > PointsVisitor
    GROUP BY Home
)

SELECT hw.Team, hw.Wins AS HomeWins, s.Home AS RecordedHome
FROM HomeWins hw
JOIN standing s ON hw.Team = s.Team;


SELECT DISTINCT Pos, Team
FROM players
ORDER BY Team, Pos;


UPDATE coach
SET GamesCurRegul = GamesCurRegul + 1
WHERE Coach = 'Steve Kerr';

ALTER TABLE coach
ADD COLUMN Email VARCHAR(100);

UPDATE coach
SET Email = 'steve.kerr@warriorsfun.com'
WHERE Coach = 'Steve Kerr';

ALTER TABLE coach
DROP COLUMN Email;



SELECT Coach, WinCurRegul, GamesCurRegul, (WinCurRegul * 1.0 / GamesCurRegul) AS CurrentWinRate
FROM coach
WHERE (WinCurRegul * 1.0 / GamesCurRegul) > (
    SELECT AVG(WinCurRegul * 1.0 / GamesCurRegul)
    FROM coach
    WHERE GamesCurRegul > 0)
Order by CurrentWinRate desc;


