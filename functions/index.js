const { app } = require("@azure/functions");

app.http("hit", {
  methods: ["GET","POST"],
  authLevel: "anonymous",
  route: "hit",
  handler: async (req, ctx) => {
    let name = req.query.get("name");
    if (!name) {
      try { name = (await req.json()).name; } catch {}
    }
    const msg = name ? `Hello, ${name}.` :
      "This HTTP triggered function executed successfully.";
    return { status: 200, body: msg };
  }
});
