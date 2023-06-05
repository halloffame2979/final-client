#!/usr/bin/env bash

outputs=$(aws cloudformation describe-stacks --stack-name serverless-todo-app-dev | jq -r ".Stacks[0]")
BACKEND_URL=$(echo $outputs | jq -c '.Outputs[] | select( .OutputKey == "ServiceEndpoint")' | jq -r ".OutputValue")
# CLOUDFRONT_DOMAIN=$(aws cloudfront get-distribution --id E2R5JNQ3YCXP1K | jq -r ".Distribution" | jq -r ".DomainName")
cat <<EOT > "src/config.ts"
export const apiEndpoint = `$BACKEND_URL`

export const authConfig = {
  domain: 'dev-e1h1xv2sahl6g78m.us.auth0.com',            // Auth0 domain
  clientId: 'oZvphzeQ7IQ3Xd4Lttj7zO4SXClXRmQI',          // Auth0 client id
  callbackUrl: 'https://d2a8izx25ay28t.cloudfront.net/callback'
}
EOT

cat src/config.ts