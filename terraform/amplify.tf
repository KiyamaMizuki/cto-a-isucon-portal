resource "aws_amplify_app" "isucon_portal" {
  name       = "isucon-portal"
  repository = var.repository
  access_token = var.access_token

  build_spec = file("${path.module}/build_spec.yaml")

  enable_auto_branch_creation = true

  auto_branch_creation_patterns = var.auto_branch_creation_patterns

  # The default rewrites and redirects added by the Amplify Console.
  custom_rule {
    source = "/<*>"
    status = "404"
    target = "/index.html"
  }

  environment_variables = {
    ENV                          = "test"
    SHEET_API_ENDPOINT           = var.sheet_api_endpoint
    AUTH_REGION                  = var.region
    AUTH_USER_POOL_ID            = aws_cognito_user_pool.main.id
    AUTH_USER_POOL_WEB_CLIENT_ID = aws_cognito_user_pool_client.main.id
    APPSYNC_GRAPHQL_ENDPOINT     = aws_appsync_graphql_api.portal_api.uris.GRAPHQL
    APPSYNC_REGION               = var.region
    TEAM_COUNT                   = var.team_count
  }
}

resource "aws_amplify_branch" "master" {
  app_id  = aws_amplify_app.isucon_portal.id
  branch_name = "master"
}