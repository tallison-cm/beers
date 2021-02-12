resource "aws_cloudwatch_event_rule" "every-five-minutes" {
    name = "every-five-minutes"
    schedule_expression = "rate(5 minutes)"
}

resource "aws_cloudwatch_event_target" "trigger-lambda-producer" {
    rule = aws_cloudwatch_event_rule.every-five-minutes.name
    target_id = "lambda-producer"
    arn = aws_lambda_function.lambda-producer.arn
}

resource "aws_lambda_permission" "allow-cloudwatch-call-lambda-producer" {
    statement_id = "AllowExecutionFromCloudWatch"
    action = "lambda:InvokeFunction"
    function_name = aws_lambda_function.lambda-producer.function_name
    principal = "events.amazonaws.com"
    source_arn = aws_cloudwatch_event_rule.every-five-minutes.arn
}