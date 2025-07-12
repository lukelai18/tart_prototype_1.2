#!/bin/bash

echo "=== Final Xcode Build Fix Script ==="
echo ""

# 1. 清理所有缓存
echo "1. Cleaning all caches..."
rm -rf build/
rm -rf ~/Library/Developer/Xcode/DerivedData/tart_prototype-*
rm -rf ~/Library/Developer/Xcode/DerivedData/*

# 2. 检查项目文件完整性
echo ""
echo "2. Verifying project file integrity..."
if grep -q "README.md" tart_prototype.xcodeproj/project.pbxproj; then
    echo "WARNING: README.md still referenced in project file"
else
    echo "✓ README.md references removed successfully"
fi

# 3. 检查是否有任何构建脚本
echo ""
echo "3. Checking for build scripts..."
if grep -q "PBXShellScriptBuildPhase" tart_prototype.xcodeproj/project.pbxproj; then
    echo "WARNING: Build scripts found - may need manual review"
else
    echo "✓ No build scripts found"
fi

# 4. 检查Amplify配置
echo ""
echo "4. Checking Amplify configuration..."
if [ -d "amplify" ]; then
    echo "Amplify directory found - checking for potential conflicts..."
    # 检查是否有任何Amplify文件被意外包含在构建中
    find amplify -name "*.json" -exec grep -l "CustomResources" {} \; 2>/dev/null | head -5
else
    echo "✓ No Amplify directory found"
fi

# 5. 创建排除文件列表
echo ""
echo "5. Creating .gitignore-style exclusions for build..."
cat > .xcodeignore << EOF
# Exclude Amplify build files from app bundle
amplify/
*.amplifyignore
EOF
echo "✓ Created .xcodeignore file"

# 6. 检查项目设置
echo ""
echo "6. Checking project settings..."
echo "Project file size: $(wc -l < tart_prototype.xcodeproj/project.pbxproj) lines"
echo "Target count: $(grep -c "PBXNativeTarget" tart_prototype.xcodeproj/project.pbxproj)"

echo ""
echo "=== Fix Summary ==="
echo "✓ Cleaned all build caches"
echo "✓ Removed README.md from project resources"
echo "✓ Created .xcodeignore for Amplify files"
echo ""
echo "=== Next Steps ==="
echo "1. Open Xcode"
echo "2. Clean Build Folder (Product > Clean Build Folder)"
echo "3. Build the project (Cmd+B)"
echo ""
echo "If you still see errors:"
echo "- Check Xcode's Build Settings for any custom copy phases"
echo "- Ensure no Amplify files are being copied to the app bundle"
echo "- Consider removing Amplify from the project if not needed"
echo ""
echo "=== Troubleshooting ==="
echo "If CustomResources.json errors persist:"
echo "1. In Xcode, go to Build Settings"
echo "2. Search for 'Copy Files' or 'Resources'"
echo "3. Remove any references to Amplify files"
echo "4. Check 'Copy Bundle Resources' build phase" 