const { app } = require("@azure/functions");
const { CosmosClient } = require("@azure/cosmos");
const client = new CosmosClient(process.env.CosmosDBConnectionString);
const container = client.database("VisitorDB").container("VisitorContainer");
const COUNTER_ID = "visitorCount";

app.http("UpdateVisitorCount", {
  methods: ["GET", "POST"],
  authLevel: "anonymous",
  route: "UpdateVisitorCount",
  handler: async (req, ctx) => {
    try {
      let current = 0;
      try {
        const { resource } = await container.item(COUNTER_ID, COUNTER_ID).read();
        current = resource?.count || 0;
      } catch (err) {
        if (err.code !== 404) throw err;
        ctx.log("Counter document not found; will create it.");
      }

      const doc = { id: COUNTER_ID, count: current + 1 };
      await container.items.upsert(doc);

      return new Response(
        JSON.stringify({ visitorCount: doc.count }),
        { status: 200, headers: { "content-type": "application/json" } }
      );
    } catch (e) {
      ctx.log.error("Failed to update visitor count:", e);
      return new Response(
        JSON.stringify({ error: "Internal server error" }),
        { status: 500, headers: { "content-type": "application/json" } }
      );
    }
  },
});