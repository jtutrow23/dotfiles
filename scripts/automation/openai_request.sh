#!/bin/zsh
if [[ -z "$1" ]]; then
  echo "Usage: openai_request.sh '<prompt>'"
  exit 1
fi

response=$(curl -s -X POST https://api.openai.com/v1/chat/completions \
  -H "Authorization: Bearer $OPENAI_API_KEY" \
  -H "Content-Type: application/json" \
  -d '{"model": "gpt-4", "messages": [{"role": "user", "content": "'"$1"'"}]}')

echo $response | jq '.choices[0].message.content'
