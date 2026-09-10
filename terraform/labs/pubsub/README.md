$project = "gcp-learning-508203"
$topic = "projects/$project/topics/orders-topic"
$payload = '{"orderId":"ORD-1001","customerId":"us-101","amount":100.00,"currency":"USD"}'
$token = gcloud auth print-access-token
$body = @{
  messages = @(@{
    data = [Convert]::ToBase64String([Text.Encoding]::UTF8.GetBytes($payload))
    attributes = @{ source = "test"; env = "dev" }
  })
} | ConvertTo-Json -Depth 5

Invoke-RestMethod `
  -Method Post `
  -Uri "https://pubsub.googleapis.com/v1/$topic`:publish" `
  -Headers @{ Authorization = "Bearer $token" } `
  -ContentType "application/json" `
  -Body $body