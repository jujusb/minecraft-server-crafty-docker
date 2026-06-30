# Step 1: Build ARM64 image
#git clone https://github.com/jujusb/crafty-4.git
cd crafty-4
docker buildx create --use  # if not already using buildx
docker buildx build --platform linux/arm64 -t crafty-controller/crafty-4:arm64 --load .