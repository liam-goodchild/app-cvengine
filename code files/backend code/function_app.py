import logging
import json
import azure.functions as func

app = func.FunctionApp()

@app.function_name(name="UpdateVisitorCount")
@app.route(route="UpdateVisitorCount", methods=["GET", "POST"], auth_level=func.AuthLevel.ANONYMOUS)
@app.cosmos_db_input(
    arg_name="visitor",
    database_name="VisitorDB",
    container_name="VisitorContainer",
    partition_key="visitorCount",
    id="visitorCount",
    connection="CosmosDBConnectionString"
)
@app.cosmos_db_output(
    arg_name="outputDocument",
    database_name="VisitorDB",
    container_name="VisitorContainer",
    partition_key="visitorCount",
    connection="CosmosDBConnectionString"
)
def UpdateVisitorCount(req: func.HttpRequest, visitor: func.DocumentList, outputDocument: func.Out[func.Document]) -> func.HttpResponse:
    logging.info('Python HTTP trigger function processed a request.')

    if visitor and len(visitor) > 0:
        # Get the visitor document
        visitor_doc = visitor[0]

        # Increment the visitor count
        count = visitor_doc.get('count', 0) + 1
        visitor_doc['count'] = count

        # Update the document in Cosmos DB
        outputDocument.set(visitor_doc)

        # Return the updated count
        return func.HttpResponse(
            json.dumps({"visitorCount": count}),
            status_code=200,
            mimetype="application/json"
        )
    else:
        logging.error("Visitor count document not found.")
        return func.HttpResponse(
            "Visitor count document not found.",
            status_code=404
        )
