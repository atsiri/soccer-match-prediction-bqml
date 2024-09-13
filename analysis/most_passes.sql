SELECT
 playerId,
 (Players.firstName || ' ' || Players.lastName) AS playerName,
 COUNT(id) AS numPasses

FROM
 `soccer.events` Events

LEFT JOIN
 `soccer.players` Players ON
   Events.playerId = Players.wyId

WHERE
 eventName = 'Pass'

GROUP BY
 playerId, playerName

ORDER BY
 numPasses DESC

LIMIT 10