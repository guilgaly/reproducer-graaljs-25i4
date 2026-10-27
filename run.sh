#!/usr/bin/env bash
# Usage: ./run.sh [--ce|--oracle] [25i3|25i4]
# With 25i3/25i4: downloads that GraalVM build (Community Edition by default, or Oracle GraalVM)
# for this OS/arch, then builds and runs the Maven app with it.
# Without 25i3/25i4: uses the JVM from JAVA_HOME; fails if JAVA_HOME is not defined.
# Overridable: GRAAL_TAG (CE release tag), GRAAL_JDK_VERSION (e.g. 25.0.4.1), GRAAL_URL (full URL).
set -euo pipefail

EDITION=ce
VARIANT=
for arg in "$@"; do
  case "$arg" in
    --ce) EDITION=ce ;;
    --oracle) EDITION=oracle ;;
    25i3|25i4) VARIANT="$arg" ;;
    *) echo "Usage: $0 [--ce|--oracle] [25i3|25i4]" >&2; exit 1 ;;
  esac
done

ROOT="$(cd "$(dirname "$0")" && pwd)"

if [ -z "$VARIANT" ] && [ -n "${JAVA_HOME:-}" ]; then
  echo "Using JAVA_HOME=$JAVA_HOME"
elif [ -z "$VARIANT" ]; then
  echo "No 25i3/25i4 option given and JAVA_HOME is not defined" >&2
  echo "Usage: $0 [--ce|--oracle] [25i3|25i4]" >&2
  exit 1
else
  case "$VARIANT" in
    25i3) TAG="${GRAAL_TAG:-graal-25.3.4.1}"; JDK_VERSION="${GRAAL_JDK_VERSION:-25.0.4.1}" ;;
    25i4) TAG="${GRAAL_TAG:-graal-25.4.4.1.1}"; JDK_VERSION="${GRAAL_JDK_VERSION:-25.0.4.1.1}" ;;
  esac

  case "$(uname -s)" in
    Linux)  OS=linux ;;
    Darwin) OS=macos ;;
    *) echo "Unsupported OS: $(uname -s)" >&2; exit 1 ;;
  esac
  case "$(uname -m)" in
    x86_64|amd64)  ARCH=x64 ;;
    arm64|aarch64) ARCH=aarch64 ;;
    *) echo "Unsupported arch: $(uname -m)" >&2; exit 1 ;;
  esac

  if [ "$EDITION" = oracle ]; then
    DEFAULT_URL="https://gds.oracle.com/download/graal/${VARIANT}/archive/graalvm-jdk-${VARIANT}-${JDK_VERSION}_${OS}-${ARCH}_bin.tar.gz"
  else
    DEFAULT_URL="https://github.com/graalvm/graalvm-ce-builds/releases/download/${TAG}/graalvm-community-jdk-${VARIANT}-${JDK_VERSION}_${OS}-${ARCH}_bin.tar.gz"
  fi
  URL="${GRAAL_URL:-$DEFAULT_URL}"
  DEST="$ROOT/.graalvm/$EDITION-$VARIANT-$OS-$ARCH"

  if [ ! -d "$DEST" ]; then
    echo "Downloading $URL"
    mkdir -p "$DEST"
    curl -fL "$URL" | tar -xz -C "$DEST" --strip-components=1 || { rm -rf "$DEST"; exit 1; }
  fi

  if [ -d "$DEST/Contents/Home" ]; then JAVA_HOME="$DEST/Contents/Home"; else JAVA_HOME="$DEST"; fi
fi
export JAVA_HOME
"$JAVA_HOME/bin/java" -version

cd "$ROOT"
./mvnw -q -B package
"$JAVA_HOME/bin/java" -cp "target/classes:target/lib/*" repro.Main
