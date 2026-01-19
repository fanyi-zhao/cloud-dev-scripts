#!/bin/bash

# Exit immediately if a command exits with a non-zero status
set -e

# 0. Validation: Ensure required environment variables are present
if [ -z "$AWS_ACCESS_KEY" ] || [ -z "$AWS_SECRET_KEY" ] || [ -z "$AWS_REGION" ]; then
    echo "------------------------------------------------------------"
    echo "💡 To setup the AWS S3 client, you need to set the following environment variables:"
    echo "   export AWS_ACCESS_KEY='your_access_key_id'"
    echo "   export AWS_SECRET_KEY='your_secret_access_key'"
    echo "   export AWS_REGION='your_aws_region' (e.g., us-east-1)"
    echo "------------------------------------------------------------"
fi
REQUIRED_VARS=(AWS_ACCESS_KEY AWS_SECRET_KEY AWS_REGION)
for var in "${REQUIRED_VARS[@]}"; do
    if [ -z "${!var}" ]; then
        echo "❌ Error: Environment variable $var is not set."
        exit 1
    fi
done

# 1. Auto-Install AWS CLI if not present
if ! command -v aws &> /dev/null; then
    echo "📦 AWS CLI not found. Installing..."
    LOCAL_BIN="$HOME/.local/bin"
    EXPORT_LINE="export PATH=\"$LOCAL_BIN:\$PATH\""
    mkdir -p "$LOCAL_BIN"
    
    # Update and install unzip/curl
    sudo apt-get update && sudo apt-get install -y unzip curl
    
    # Download and install the official AWS CLI v2
    curl "https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip" -o "awscliv2.zip"
    unzip -q awscliv2.zip
    ./aws/install -i ~/.local/aws-cli -b ~/.local/bin
    
    # Cleanup installation files
    rm -rf aws awscliv2.zip

    # Add to current session if missing
    if [[ ":$PATH:" != *":$LOCAL_BIN:"* ]]; then
        echo "Updating current session PATH..."
        export PATH="$LOCAL_BIN:$PATH"
    fi

    # Add to .bashrc for future sessions if missing
    if ! grep -qF "$EXPORT_LINE" ~/.bashrc; then
        echo "Adding ~/.local/bin to ~/.bashrc..."
        echo -e "\n# Added by init_aws.sh\n$EXPORT_LINE" >> ~/.bashrc
        echo "✅ ~/.bashrc updated. Run 'source ~/.bashrc' to refresh manually."
    else
        echo "✅ ~/.bashrc already contains the correct PATH."
    fi
    echo "✅ AWS CLI installed to ~/.local/bin"
fi

# 2. Create the .aws directory and config files
mkdir -p ~/.aws

cat <<EOF > ~/.aws/credentials
[default]
aws_access_key_id = $AWS_ACCESS_KEY
aws_secret_access_key = $AWS_SECRET_KEY
EOF

cat <<EOF > ~/.aws/config
[default]
region = $AWS_REGION
EOF

# 3. Secure the credential files
chmod 600 ~/.aws/credentials ~/.aws/config

echo "✨ AWS configuration files generated for region: $AWS_REGION"
echo "------------------------------------------------------------"
echo "🚀 Useful Commands:"
echo "List:   aws s3 ls s3://<bucket_name>"
echo "Push:   aws s3 cp <local_path> s3://<bucket_name>/<path> --recursive"
echo "Pull:   aws s3 cp s3://<bucket_name>/<path> <local_path> --recursive"