import time
from opentelemetry import trace
from opentelemetry.sdk.resources import Resource
from opentelemetry.sdk.trace import TracerProvider
from opentelemetry.sdk.trace.export import ConsoleSpanExporter, SimpleSpanProcessor
from opentelemetry.instrumentation.flask import FlaskInstrumentor
from flask import Flask, jsonify, request
from prometheus_client import Counter, Histogram, generate_latest

resource = Resource.create({
    "service.name": "order-api"
    })

tracer_provider = TracerProvider(resource=resource)

tracer_provider.add_span_processor(SimpleSpanProcessor(ConsoleSpanExporter()))

trace.set_tracer_provider(tracer_provider) 

app = Flask(__name__)

FlaskInstrumentor().instrument_app(app)

 

REQUEST_COUNT = Counter(

    "http_requests_total",

    "Total number of HTTP requests",

    ["method", "endpoint", "status"],

)

 

REQUEST_LATENCY = Histogram(

    "http_request_duration_seconds",

    "HTTP request latency in seconds",

    ["method", "endpoint"],

)

 

 

@app.before_request

def before_request():

    request.start_time = time.time()

 

 

@app.after_request

def after_request(response):

    latency = time.time() - request.start_time

 

    REQUEST_COUNT.labels(

        method=request.method,

        endpoint=request.path,

        status=response.status_code,

    ).inc()

 

    REQUEST_LATENCY.labels(

        method=request.method,

        endpoint=request.path,

    ).observe(latency)

 

    return response

 

 

@app.route("/")

def home():

    return jsonify({

        "application": "order-api",

        "status": "running",

    })

 

 

@app.route("/health")

def health():

    return jsonify({

        "status": "healthy",

    })

 

 

@app.route("/orders")

def orders():

    return jsonify({

        "orders": [

            {"id": 1001, "status": "created"},

            {"id": 1002, "status": "shipped"},

            {"id": 1003, "status": "delivered"},

        ]

    })

 

 

@app.route("/metrics")

def metrics():

    return generate_latest(), 200, {

        "Content-Type": "text/plain; version=0.0.4; charset=utf-8"

    }

 

 

if __name__ == "__main__":

    app.run(host="0.0.0.0", port=8000)
