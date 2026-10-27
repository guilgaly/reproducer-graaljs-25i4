# GraalJS 25i3/25i4 compatibility issue reproducer

Uses:
- GraalJS 25.4.4.1.1: [`org.graalvm.polyglot:js:25.4.4.1.1`](https://central.sonatype.com/artifact/org.graalvm.js/js/25.4.4.1.1)
- GraalVM CE: from https://github.com/graalvm/graalvm-ce-builds
- Oracle GraalVM: script-friendly URLs from https://www.graalvm.org/downloads/

### Run with your `JAVA_HOME`

```shell
./run.sh
```

### Run with GraalVM 25i4 (graal 25.4.4.1.1, jdk 25.0.4.1.1)

```shell
./run.sh --ce 25i4
./run.sh --oracle 25i4
```

**Result:** runs fine

### Run with GraalVM 25i3 (graal 25.3.4.1, jdk 25.0.4.1)

```shell
./run.sh --ce 25i3
./run.sh --oracle 25i3
```

**Result:** crashes, even though `TruffleVersions.MIN_COMPILER_VERSION` is 25.1.0 so this should work on Graal 25.3.4.1.

Various warnings like:
```text
Warning: Systemic Graal compilation failure detected: 26 of 26 (100%) of compilations failed during last 89 ms [max rate set by SystemicCompilationFailureRate is 1%]. To mitigate systemic compilation failure detection, set SystemicCompilationFailureRate to a higher value. To disable systemic compilation failure detection, set SystemicCompilationFailureRate to 0. Current failure: java.lang.NoClassDefFoundError: Lcom/oracle/truffle/api/HostCompilerDirectives$BytecodeInterpreterSwitchBoundary;
        at jdk.internal.vm.TranslatedException.translated(Native Method)
        at LibGraalClassLoader//jdk.vm.ci.hotspot.CompilerToVM.lookupType(Native Method)
        at LibGraalClassLoader//jdk.vm.ci.hotspot.CompilerToVM.lookupType(CompilerToVM.java:251)
        at LibGraalClassLoader//jdk.vm.ci.hotspot.HotSpotJVMCIRuntime.lookupTypeInternal(HotSpotJVMCIRuntime.java:892)
        at LibGraalClassLoader//jdk.vm.ci.hotspot.HotSpotJVMCIRuntime.lookupType(HotSpotJVMCIRuntime.java:860)
        at LibGraalClassLoader//jdk.graal.compiler.libgraal.truffle.HSTruffleCompilerRuntime.resolveType(HSTruffleCompilerRuntime.java:123)
        at LibGraalClassLoader//com.oracle.truffle.compiler.TruffleCompilerRuntime.resolveType(TruffleCompilerRuntime.java:300)
        at LibGraalClassLoader//jdk.graal.compiler.truffle.AbstractKnownTruffleTypes.lookupType(AbstractKnownTruffleTypes.java:67)
        at LibGraalClassLoader//jdk.graal.compiler.truffle.host.TruffleKnownHostTypes.<init>(TruffleKnownHostTypes.java:58)
        at LibGraalClassLoader//jdk.graal.compiler.truffle.host.TruffleHostEnvironment.<init>(TruffleHostEnvironment.java:87)
        at LibGraalClassLoader//jdk.graal.compiler.libgraal.truffle.LibGraalTruffleHostEnvironment.<init>(LibGraalTruffleHostEnvironment.java:55)
        at LibGraalClassLoader//jdk.graal.compiler.libgraal.truffle.LibGraalTruffleHostEnvironmentLookup.lookup(LibGraalTruffleHostEnvironmentLookup.java:94)
        at LibGraalClassLoader//jdk.graal.compiler.truffle.host.TruffleHostEnvironment.get(TruffleHostEnvironment.java:155)
        at LibGraalClassLoader//jdk.graal.compiler.truffle.host.TruffleHostEnvironment.get(TruffleHostEnvironment.java:141)
        at LibGraalClassLoader//jdk.graal.compiler.truffle.host.HostInliningPhase.runInlining(HostInliningPhase.java:230)
        at LibGraalClassLoader//jdk.graal.compiler.phases.common.AbstractInliningPhase.run(AbstractInliningPhase.java:57)
        at LibGraalClassLoader//jdk.graal.compiler.phases.common.AbstractInliningPhase.run(AbstractInliningPhase.java:46)
        at LibGraalClassLoader//jdk.graal.compiler.phases.BasePhase.apply(BasePhase.java:511)
        at LibGraalClassLoader//jdk.graal.compiler.phases.BasePhase.apply(BasePhase.java:359)
        at LibGraalClassLoader//jdk.graal.compiler.core.phases.BaseTier.run(BaseTier.java:65)
        at LibGraalClassLoader//jdk.graal.compiler.phases.BasePhase.apply(BasePhase.java:511)
        at LibGraalClassLoader//jdk.graal.compiler.phases.BasePhase.apply(BasePhase.java:359)
        at LibGraalClassLoader//jdk.graal.compiler.core.GraalCompiler.emitFrontEnd(GraalCompiler.java:283)
        at LibGraalClassLoader//jdk.graal.compiler.core.GraalCompiler.compile(GraalCompiler.java:152)
        at LibGraalClassLoader//jdk.graal.compiler.hotspot.HotSpotGraalCompiler.compileHelper(HotSpotGraalCompiler.java:307)
        at LibGraalClassLoader//jdk.graal.compiler.hotspot.HotSpotGraalCompiler.compile(HotSpotGraalCompiler.java:337)
        at LibGraalClassLoader//jdk.graal.compiler.hotspot.CompilationTask$HotSpotCompilationWrapper.performCompilation(CompilationTask.java:347)
        at LibGraalClassLoader//jdk.graal.compiler.hotspot.CompilationTask$HotSpotCompilationWrapper.performCompilation(CompilationTask.java:154)
        at LibGraalClassLoader//jdk.graal.compiler.core.CompilationWrapper.run(CompilationWrapper.java:236)
        at LibGraalClassLoader//jdk.graal.compiler.hotspot.CompilationTask.runCompilation(CompilationTask.java:704)
        at LibGraalClassLoader//jdk.graal.compiler.hotspot.CompilationTask.runCompilation(CompilationTask.java:666)
        at LibGraalClassLoader//jdk.graal.compiler.hotspot.HotSpotGraalCompiler.compileMethod(HotSpotGraalCompiler.java:203)
        at LibGraalClassLoader//jdk.graal.compiler.hotspot.HotSpotGraalCompiler.compileMethod(HotSpotGraalCompiler.java:137)
        at LibGraalClassLoader//jdk.vm.ci.hotspot.HotSpotJVMCIRuntime.compileMethod(HotSpotJVMCIRuntime.java:939)
Caused by: java.lang.ClassNotFoundException: com.oracle.truffle.api.HostCompilerDirectives$BytecodeInterpreterSwitchBoundary
        at java.base@25.0.4.1/jdk.internal.loader.BuiltinClassLoader.loadClass(BuiltinClassLoader.java:580)
        at java.base@25.0.4.1/java.lang.ClassLoader.loadClass(ClassLoader.java:490)
        ... 33 more
```
And then error:

```text
Exception in thread "main" org.graalvm.polyglot.PolyglotException: java.lang.AssertionError: Compiler initialization failed cannot continue.
        at com.oracle.truffle.runtime.hotspot.HotSpotTruffleRuntime.bypassedReservedOop(HotSpotTruffleRuntime.java:482)
        at com.oracle.truffle.runtime.hotspot.HotSpotFastThreadLocal.setJVMCIReservedReference(HotSpotFastThreadLocal.java:112)
        at com.oracle.truffle.runtime.hotspot.HotSpotFastThreadLocal.set(HotSpotFastThreadLocal.java:63)
        at com.oracle.truffle.polyglot.PolyglotFastThreadLocals.leave(PolyglotFastThreadLocals.java:157)
        at com.oracle.truffle.polyglot.PolyglotThreadInfo.leaveInternal(PolyglotThreadInfo.java:298)
        at com.oracle.truffle.polyglot.PolyglotEngineImpl.leaveCached(PolyglotEngineImpl.java:2525)
        at com.oracle.truffle.polyglot.PolyglotEngineImpl.leave(PolyglotEngineImpl.java:2500)
        at com.oracle.truffle.polyglot.PolyglotEngineImpl.leaveIfNeeded(PolyglotEngineImpl.java:2421)
        at com.oracle.truffle.polyglot.PolyglotValueDispatch.hostLeave(PolyglotValueDispatch.java:1319)
        at com.oracle.truffle.polyglot.PolyglotContextImpl.eval(PolyglotContextImpl.java:1917)
        at com.oracle.truffle.polyglot.PolyglotContextDispatch.eval(PolyglotContextDispatch.java:67)
        at org.graalvm.polyglot.Context.eval(Context.java:423)
        at org.graalvm.polyglot.Context.eval(Context.java:453)
        at repro.Main.main(Main.java:11)
        Suppressed: Attached Guest Language Frames (0)
Caused by: java.lang.RuntimeException: jdk.graal.compiler.debug.GraalError: Could not find required field Lcom/oracle/truffle/runtime/OptimizedDirectCallNode;.callCount
        at jdk.graal.compiler.truffle.AbstractKnownTruffleTypes.findField(AbstractKnownTruffleTypes.java:152)
        at jdk.graal.compiler.truffle.AbstractKnownTruffleTypes.findField(AbstractKnownTruffleTypes.java:158)
        at jdk.graal.compiler.truffle.KnownTruffleTypes.<init>(KnownTruffleTypes.java:190)
        at jdk.graal.compiler.truffle.hotspot.HotSpotKnownTruffleTypes.<init>(HotSpotKnownTruffleTypes.java:60)
        at jdk.graal.compiler.truffle.hotspot.HotSpotTruffleCompilerImpl.create(HotSpotTruffleCompilerImpl.java:185)
        at jdk.graal.compiler.libgraal.truffle.LibGraalTruffleEntryPoints.newCompiler(LibGraalTruffleEntryPoints.java:150)
        at com.oracle.truffle.runtime.hotspot.libgraal.TruffleToLibGraalCalls.newCompiler(Native Method)
        at com.oracle.truffle.runtime.hotspot.libgraal.LibGraalHotSpotTruffleCompiler.lambda$getOrCreateIsolate$0(LibGraalHotSpotTruffleCompiler.java:73)
        at com.oracle.truffle.runtime.hotspot.libgraal.LibGraalIsolate.getSingleton(LibGraalIsolate.java:99)
        at com.oracle.truffle.runtime.hotspot.libgraal.LibGraalHotSpotTruffleCompiler.resolveIsolateHandleImpl(LibGraalHotSpotTruffleCompiler.java:81)
        at com.oracle.truffle.runtime.hotspot.libgraal.LibGraalHotSpotTruffleCompiler.getOrCreateIsolate(LibGraalHotSpotTruffleCompiler.java:71)
        at com.oracle.truffle.runtime.hotspot.libgraal.LibGraalHotSpotTruffleCompiler.initialize(LibGraalHotSpotTruffleCompiler.java:92)
        at com.oracle.truffle.runtime.hotspot.HotSpotTruffleRuntime.initializeTruffleCompiler(HotSpotTruffleRuntime.java:311)
        at com.oracle.truffle.runtime.hotspot.HotSpotTruffleRuntime$1.accept(HotSpotTruffleRuntime.java:270)
        at com.oracle.truffle.runtime.hotspot.HotSpotTruffleRuntime$1.accept(HotSpotTruffleRuntime.java:266)
        at com.oracle.truffle.runtime.CompilationTask.call(CompilationTask.java:359)
        at com.oracle.truffle.runtime.CompilationTask.call(CompilationTask.java:58)
        at java.util.concurrent.FutureTask.run(FutureTask.java:328)
        at java.util.concurrent.ThreadPoolExecutor.runWorker(ThreadPoolExecutor.java:1090)
        at java.util.concurrent.ThreadPoolExecutor$Worker.run(ThreadPoolExecutor.java:614)
        at java.lang.Thread.run(Thread.java:1474)
        at com.oracle.truffle.runtime.BackgroundCompileQueue$TruffleCompilerThreadFactory$1.run(BackgroundCompileQueue.java:444)
Internal GraalVM error, please report at https://github.com/oracle/graal/issues/.
```
