#!/bin/bash
set -e

# Конфигурация
PKG_NAME="file2prompt"
VERSION="2.0"
ARCH="all"
BUILD_DIR="build"
OUTPUT_DEB="${PKG_NAME}_${VERSION}_${ARCH}.deb"

# Очистка предыдущей сборки
rm -rf "${BUILD_DIR}" "${PKG_NAME}"
mkdir -p "${BUILD_DIR}"

# Создание структуры пакета
mkdir -p "${PKG_NAME}/DEBIAN" \
         "${PKG_NAME}/usr/bin" \
         "${PKG_NAME}/usr/share/man/man1"

# Копирование файлов
cp src/file2prompt.sh "${PKG_NAME}/usr/bin/file2prompt"
chmod 755 "${PKG_NAME}/usr/bin/file2prompt"

cp man/file2prompt.1 "${PKG_NAME}/usr/share/man/man1/"
gzip -9n "${PKG_NAME}/usr/share/man/man1/file2prompt.1"

# Создание control-файла
cat > "${PKG_NAME}/DEBIAN/control" <<EOF
Package: ${PKG_NAME}
Version: ${VERSION}
Section: utils
Priority: optional
Architecture: ${ARCH}
Maintainer: DeepSeek Team <dev@deepseek.com>
Description: Generate markdown code blocks from files
 Tool to extract code files into markdown blocks for AI prompts.
 Features:
  - Recursive directory search
  - Exclusion patterns for files/dirs
  - Colorized output
Homepage: https://github.com/Traineratwot/File2Prompt
EOF

# Скрипт пост-установки
cat > "${PKG_NAME}/DEBIAN/postinst" <<'EOF'
#!/bin/sh
set -e
if command -v mandb >/dev/null; then
    mandb -q
fi
exit 0
EOF
chmod 755 "${PKG_NAME}/DEBIAN/postinst"

# Сборка пакета
dpkg-deb --build "${PKG_NAME}" "${BUILD_DIR}/${OUTPUT_DEB}"

# Проверка пакета
lintian "${BUILD_DIR}/${OUTPUT_DEB}" || true

echo "Пакет собран: ${BUILD_DIR}/${OUTPUT_DEB}"