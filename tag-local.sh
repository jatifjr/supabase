#!/bin/bash
# This script retags Supabase images from the public ECR to ':local' for local development and docker-compose.yml.

set -e

echo "🔄 Retagging Supabase images to ':local'..."

# Filter Supabase images only
docker images --format '{{.Repository}}:{{.Tag}} {{.ID}}' \
  | grep '^public.ecr.aws/supabase/' \
  | while read -r line; do
      image=$(echo "$line" | awk '{print $1}')
      image_id=$(echo "$line" | awk '{print $2}')
      repo_name=$(echo "$image" | cut -d':' -f1)

      # Check if already tagged as :local
      if docker images --format '{{.Repository}}:{{.Tag}}' | grep -q "^$repo_name:local$"; then
        echo "✅ Already tagged: $repo_name:local"
      else
        echo "🔖 Tagging $image_id as $repo_name:local"
        docker tag "$image_id" "$repo_name:local"
      fi
  done

echo "✅ Done. You can now use ':local' tags in docker-compose."
