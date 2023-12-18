LOAD CSV WITH HEADERS FROM 'https://gist.githubusercontent.com/nathancolgate/e24dee1c9a1763a7a552f31fef551e1e/raw/ed49ef8eb40e4d34af7b2a8a0a7180b1a8fd537c/nodesa.csv' AS row
MERGE (loc:Loc {locID: row.id})
  ON CREATE SET loc.Name = row.name;


LOAD CSV WITH HEADERS FROM 'https://gist.githubusercontent.com/nathancolgate/4b73bc0fd9688ad0610508a3898f0066/raw/6c96e4c889b4860c45b2ed6a7d776ca3628863c7/connecta.csv' AS row
WITH row
MATCH (fromLoc:Loc {locID: row.fromID})
MATCH (toLoc:Loc {locID: row.toID})
FOREACH(ignoreMe IN CASE WHEN row.direction = "NORTH" THEN [1] ELSE [] END |
  MERGE (fromLoc)-[op:NORTH {cost: toFloat(row.cost)}]->(toLoc))
FOREACH(ignoreMe IN CASE WHEN row.direction = "EAST" THEN [1] ELSE [] END |
  MERGE (fromLoc)-[op:EAST {cost: toFloat(row.cost)}]->(toLoc))
FOREACH(ignoreMe IN CASE WHEN row.direction = "SOUTH" THEN [1] ELSE [] END |
  MERGE (fromLoc)-[op:SOUTH {cost: toFloat(row.cost)}]->(toLoc))
FOREACH(ignoreMe IN CASE WHEN row.direction = "WEST" THEN [1] ELSE [] END |
  MERGE (fromLoc)-[op:WEST {cost: toFloat(row.cost)}]->(toLoc))

CALL gds.graph.project(
    'myGraph',
    'Loc',
    ['NORTH','EAST','SOUTH','WEST'],
    {
        relationshipProperties: 'cost'
    }
)

MATCH (source:Loc {Name: "0-0"}), (target:Loc {Name: "12-12"})
CALL gds.shortestPath.dijkstra.stream('myGraph', {
    sourceNode: source,
    targetNode: target,
    relationshipWeightProperty: 'cost'
})
YIELD index, sourceNode, targetNode, totalCost, nodeIds, costs, path
RETURN
    index,
    gds.util.asNode(sourceNode).Name AS sourceNodeName,
    gds.util.asNode(targetNode).Name AS targetNodeName,
    totalCost,
    [nodeId IN nodeIds | gds.util.asNode(nodeId).Name] AS nodeNames,
    costs,
    nodes(path) as path
ORDER BY index