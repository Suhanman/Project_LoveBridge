resource "aws_iam_role" "lambda_ec2_control" {
  name = "lambda-ec2-control-role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17",
    Statement = [{
      Action = "sts:AssumeRole",
      Effect = "Allow",
      Principal = {
        Service = "lambda.amazonaws.com"
      }
    }]
  })
}

resource "aws_iam_role_policy_attachment" "lambda_ec2_policy" {
  role       = aws_iam_role.lambda_ec2_control.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonEC2FullAccess"
}

data "archive_file" "lambda_zip" {
  type        = "zip"
  source_file = "${path.module}/lambda.py"
  output_path = "${path.module}/lambda_bastion.zip"
}

resource "aws_lambda_function" "bastion_controller" {
  function_name = "bastion-controller"
  role          = aws_iam_role.lambda_ec2_control.arn
  handler       = "lambda.lambda_handler"
  runtime       = "python3.9"
  filename      = "lambda_bastion.zip"
  source_code_hash = data.archive_file.lambda_zip.output_base64sha256

  environment {
    variables = {
      INSTANCE_ID = module.bastion.bastion_instance_id  # Bastion 인스턴스 ID 연결
    }
  }
}

resource "aws_cloudwatch_event_rule" "bastion_start" {
  name                = "bastion-start"
  schedule_expression = "cron(0 0 ? * MON-FRI *)"  # KST 오전 9시 = UTC 0시
}

resource "aws_cloudwatch_event_rule" "bastion_stop" {
  name                = "bastion-stop"
  schedule_expression = "cron(0 9 ? * MON-FRI *)"  # KST 오후 6시 = UTC 9시
}

resource "aws_cloudwatch_event_target" "start_target" {
  rule      = aws_cloudwatch_event_rule.bastion_start.name
  target_id = "bastionStartLambda"
  arn       = aws_lambda_function.bastion_controller.arn
  input     = jsonencode({ "action" = "start" })
}

resource "aws_cloudwatch_event_target" "stop_target" {
  rule      = aws_cloudwatch_event_rule.bastion_stop.name
  target_id = "bastionStopLambda"
  arn       = aws_lambda_function.bastion_controller.arn
  input     = jsonencode({ "action" = "stop" })
}

resource "aws_lambda_permission" "allow_eventbridge_start" {
  statement_id  = "AllowStart"
  action        = "lambda:InvokeFunction"
  function_name = aws_lambda_function.bastion_controller.function_name
  principal     = "events.amazonaws.com"
  source_arn    = aws_cloudwatch_event_rule.bastion_start.arn
}

resource "aws_lambda_permission" "allow_eventbridge_stop" {
  statement_id  = "AllowStop"
  action        = "lambda:InvokeFunction"
  function_name = aws_lambda_function.bastion_controller.function_name
  principal     = "events.amazonaws.com"
  source_arn    = aws_cloudwatch_event_rule.bastion_stop.arn
}
