import base64
import json

import functions_framework
from google.cloud import firestore


ORDERS_COLLECTION = "orders"

REQUIRED_ORDER_FIELDS = {
    "orderId",
    "customerId",
    "amount",
    "currency",
}


def log_event(severity, event, **fields):
    print(json.dumps({
        "severity": severity,
        "event": event,
        **fields,
    }))


def decode_order(pubsub_message):
    encoded_data = pubsub_message.get("data")
    if not encoded_data:
        return None

    decoded_data = base64.b64decode(encoded_data).decode("utf-8")
    order = json.loads(decoded_data)

    if not isinstance(order, dict):
        raise ValueError("Order message must be a JSON object")

    return order


def validate_order(order):
    missing_fields = REQUIRED_ORDER_FIELDS - order.keys()
    if missing_fields:
        raise ValueError(f"Missing required fields: {sorted(missing_fields)}")


def save_order(order):
    firestore.Client().collection(ORDERS_COLLECTION).document(
        order["orderId"]
    ).set(order)


@functions_framework.cloud_event
def process_order(cloud_event):
    print("Order processor function started")

    pubsub_message = cloud_event.data.get("message", {})
    message_id = pubsub_message.get("messageId", "unknown")

    try:
        order = decode_order(pubsub_message)
    except Exception as error:
        log_event(
            "ERROR",
            "MESSAGE_DECODE_FAILED",
            messageId=message_id,
            error=str(error),
        )
        raise

    if order is None:
        log_event("WARNING", "EMPTY_MESSAGE", messageId=message_id)
        return

    try:
        validate_order(order)
    except ValueError as error:
        log_event(
            "ERROR",
            "ORDER_VALIDATION_FAILED",
            messageId=message_id,
            missingFields=sorted(
                REQUIRED_ORDER_FIELDS - order.keys()
            ),
        )
        raise

    log_event(
        "INFO",
        "ORDER_RECEIVED",
        messageId=message_id,
        publishTime=pubsub_message.get("publishTime", "unknown"),
        attributes=pubsub_message.get("attributes", {}),
        **{
            field: order[field]
            for field in REQUIRED_ORDER_FIELDS
        },
    )

    if order.get("simulateFailure") is True:
        log_event(
            "ERROR",
            "SIMULATED_FAILURE",
            orderId=order["orderId"],
            messageId=message_id,
        )
        raise RuntimeError("Simulated downstream processing failure")

    save_order(order)

    log_event(
        "INFO",
        "ORDER_PROCESSED",
        orderId=order["orderId"],
        messageId=message_id,
    )