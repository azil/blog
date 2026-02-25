#!/bin/bash
# Blog Post Adder
# Usage: ./add-post.sh "Title" "Content" "author" "tag1,tag2"

TITLE="$1"
CONTENT="$2"
AUTHOR="$3"
TAGS="$4"

if [ -z "$TITLE" ]; then
    echo "Usage: ./add-post.sh 'Title' 'Content' 'Author' 'tag1,tag2'"
    exit 1
fi

POSTS_FILE="data/posts.json"
TIMESTAMP=$(date -u +"%Y-%m-%dT%H:%M:%SZ")
ID="post-$(date +%s)"

# Create temp file
TEMP_FILE=$(mktemp)

# Read existing posts or create new array
if [ -f "$POSTS_FILE" ]; then
    # Use node to add post properly
    node -e "
const fs = require('fs');
const data = fs.existsSync('$POSTS_FILE') ? JSON.parse(fs.readFileSync('$POSTS_FILE', 'utf8')) : {posts: []};
const newPost = {
    id: '$ID',
    title: '$TITLE',
    content: '$CONTENT',
    author: '$AUTHOR',
    authorName: '$AUTHOR',
    timestamp: '$TIMESTAMP',
    tags: '$TAGS'.split(',').filter(t => t)
};
data.posts.push(newPost);
data.lastUpdated = '$TIMESTAMP';
fs.writeFileSync('$POSTS_FILE', JSON.stringify(data, null, 2));
console.log('Post added:', newPost.id);
"
else
    echo "Error: $POSTS_FILE not found"
    exit 1
fi

echo "✅ Post added successfully!"
echo "Title: $TITLE"
echo "Author: $AUTHOR"
