import base64
import json

import functions_framework


@functions_framework.cloud_event
def process_order(cloud_event):
    """
    Receives an order message from Pub/Sub.
    """

    print("Order processor function started")

    event_data = cloud_event.data
    pubsub_message = event_data.get("message", {})

    message_id = pubsub_message.get(
        "messageId",
        "unknown",
    )

    publish_time = pubsub_message.get(
        "publishTime",
        "unknown",
    )

    attributes = pubsub_message.get(
        "attributes",
        {},
    )

    encoded_data = pubsub_message.get("data")

    if not encoded_data:
        print(
            json.dumps({
                "severity": "WARNING",
                "event": "EMPTY_MESSAGE",
                "messageId": message_id,
            })
        )
        return

    try:
        decoded_data = base64.b64decode(
            encoded_data
        ).decode("utf-8")

        order = json.loads(decoded_data)

    except Exception as error:
        print(
            json.dumps({
                "severity": "ERROR",
                "event": "MESSAGE_DECODE_FAILED",
                "messageId": message_id,
                "error": str(error),
            })
        )

        raise

    required_fields = {
        "orderId",
        "customerId",
        "amount",
        "currency",
    }

    missing_fields = required_fields - order.keys()

    if missing_fields:
        print(
            json.dumps({
                "severity": "ERROR",
                "event": "ORDER_VALIDATION_FAILED",
                "messageId": message_id,
                "missingFields": sorted(missing_fields),
            })
        )

        raise ValueError(
            f"Missing required fields: "
            f"{sorted(missing_fields)}"
        )

    print(
        json.dumps({
            "severity": "INFO",
            "event": "ORDER_RECEIVED",
            "messageId": message_id,
            "publishTime": publish_time,
            "attributes": attributes,
            "orderId": order["orderId"],
            "customerId": order["customerId"],
            "amount": order["amount"],
            "currency": order["currency"],
        })
    )

    if order.get("simulateFailure") is True:
        print(
            json.dumps({
                "severity": "ERROR",
                "event": "SIMULATED_FAILURE",
                "orderId": order["orderId"],
                "messageId": message_id,
            })
        )

        raise RuntimeError(
            "Simulated downstream processing failure"
        )

    print(
        json.dumps({
            "severity": "INFO",
            "event": "ORDER_PROCESSED",
            "orderId": order["orderId"],
            "messageId": message_id,
        })
    )