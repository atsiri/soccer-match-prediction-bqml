SELECT
 *

FROM
 ML.PREDICT(
   MODEL `soccer.xg_logistic_reg_model`,
   (
     SELECT
       Events.subEventName AS shotType,

       /* 101 is known Tag for 'goals' from goals table */
       (101 IN UNNEST(Events.tags.id)) AS isGoal,

       `soccer.GetShotDistanceToGoal`(Events.positions[ORDINAL(1)].x,
           Events.positions[ORDINAL(1)].y) AS shotDistance,

       `soccer.GetShotAngleToGoal`(Events.positions[ORDINAL(1)].x,
           Events.positions[ORDINAL(1)].y) AS shotAngle

     FROM
       `soccer.events` Events

     LEFT JOIN
       `soccer.matches` Matches ON
           Events.matchId = Matches.wyId

     LEFT JOIN
       `soccer.competitions` Competitions ON
           Matches.competitionId = Competitions.wyId

     WHERE
       /* Look only at World Cup matches for model predictions */
       Competitions.name = 'World Cup' AND
       /* Includes both "open play" & free kick shots (including penalties) */
       (
           eventName = 'Shot' OR
           (eventName = 'Free Kick' AND subEventName IN ('Free kick shot', 'Penalty'))
       )
   )
 )