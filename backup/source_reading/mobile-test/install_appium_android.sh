echo "install appium"
npm install appium -g
npm install -g appium-doctor
echo "install webdriver"
npm install wd -g
echo "setup android path"

echo "export PATH=/Users/patrick/Library/Android/sdk/platform-tools:$PATH" >> ~/.zshrc
source ~/.zshrc

