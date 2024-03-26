# Provide shortcuts to Rhino for envjs
#alias js="java -cp lib/js.jar:lib/jline.jar jline.ConsoleRunner org.mozilla.javascript.tools.shell.Main -opt -1"
#alias jsd="java -cp lib/js.jar:lib/jline.jar jline.ConsoleRunner org.mozilla.javascript.tools.debugger.Main"

export JRUBY_OPTS="-J-XX:+TieredCompilation -J-XX:TieredStopAtLevel=1 -J-noverify"

export JAVA_HOME="/Library/Java/JavaVirtualMachines/zulu-17.jdk/Contents/Home"

if ! [[ -e "$JAVA_HOME" ]]; then
  echo "It looks like you are missing Azul Zulu JDK. This is a JDK optimized for Apple Silicon Macs."
  echo "You can get it by running: brew tap homebrew/cask-versions && brew install --cask zulu17"
fi
