+++
title = "Getting Started with Rust Tracing"
date = 2025-04-10
template = "post-wide.html"
+++

The Tracing crate for Rust is a well-implemented tracing library for a wide
range of tracing and logging needs. However, I haven't seen a simple startup
guide for tracing. This is what would have saved me some time when
getting started with Tracing. This goes over a very common setup of defining
a default set of trace levels, while accepting an overriding setup from
the **`RUST_LOG`** environment variable. It will also go over tips on how
**`RUST_LOG`** can be used. *(Learning to use **`RUST_LOG`** beyond the simple
setting of a global log level is worth it!)*

<!-- more -->

## RUST_LOG Basics

The tracing system uses the standard logging levels, and it's common to see
the logging level globally set level via `*RUST_LOG*`:

- RUST_LOG=error
- RUST_LOG=warn
- RUST_LOG=info
- RUST_LOG=debug
- RUST_LOG=trace
- RUST_LOG=off

**Note: 'off' is more a tracing logger state than a level, but read on to see
how it is useful**

`*RUST_LOG*` can specifiy more than a global logging level though. Multiple log
**targets** each with individual levels can be specified. For example:

`RUST_LOG=info,tokio=warn,hyper=off`

Three specifications were provided here, a global `info` level setting, for
`tokio` show warn or higher level logs, and for `hyper` targets, turn them all
off.

Later in this writeup there is a deeper look at RUST_LOG syntax and how it
connects to the tracing macro invocations, but this covers 80% of the common
uses.

## Setting Up Tracing

Basic setup requires three basic parts:
- adding the `tracing` and `tracing-subscriber` dependencies
to your `Cargo.toml`
- setup of the tracing system near the initilization of the
rust application
- using the tracing macros throughout the code



### Tracing Cargo.toml dependencies

```toml
[dependencies]
tracing = "0.1"
tracing-subscriber = { version = "0.3", features = ["env-filter", "fmt", "time"] }
```
The `env-filter` feature is what enables dynamically applying different tracing
settings from the RUST_LOG

### Initializing the tracing system
Then, initialize the tracing system. A frequent use case is setting up some default
trace levels, but also taking in the `RUST_LOG` environment variable to change
what is logged dynamically. The final `Subscriber::builder()... try_init()` will
setup the tracing configuration as the global tracing configuration.  Setting
up the tracing layer is global, and its generally not recommended to setup
tracing multiple times or places.

The simplest initialization is this:
```rust
fn main() {
    tracing_subscriber::fmt::init();
}
```



```rust
fn setup_tracing() {
    use tracing_subscriber::EnvFilter;
    use tracing_subscriber::fmt::Subscriber;
    use tracing_subscriber::fmt;

    // take value from RUST_LOG or use DEFAULT_RUST_LOG
    const DEFAULT_RUST_LOG: &str = "trace,noisy=error";

    let env_filter = EnvFilter::try_from_default_env()
        .unwrap_or_else(|_| EnvFilter::new(DEFAULT_RUST_LOG));

    Subscriber::builder()
        .with_env_filter(env_filter)
        .with_timer(fmt::time::UtcTime::rfc_3339())
        // .with_timer(fmt::time::uptime())
        // different time formats could be selected
        .with_span_events(fmt::format::FmtSpan::CLOSE)
        .try_init()
        .expect("unable to setup tracing");
}
```

There are a lot of ways to structure outputs, including sending different
logs to different outputs with `Layers`, see the function `setup_tracing_alt()`
for an example. For now just take a look

## Basic Logging Levels

Tracing provides the familiar hierarchy of logging levels:

```rust
tracing::error!("plain error log");
tracing::warn!("plain warn log");
tracing::info!("plain info log");
tracing::debug!("plain debug log");
tracing::trace!("plain trace log");
```

You can set the logging levels, via `RUST_LOG`, eg if your binary is named
`app` `RUST_LOG=warn app`, will log all `warn` level and above items.

## A Sample Log Output and more RUST_LOG

If you run `cargo run` in the `tracing-quickstart` project, you'll see
some lines that look like this:

```
0.000242940s  INFO my_span: tracing_quickstart: inside span
0.000247360s  INFO my_span: my_app: custom, inside span
0.000252570s  INFO my_span: tracing_quickstart: close time.busy=9.49µs time.idle=1.49µs
0.000228990s  INFO my_target: targeted log
0.000231860s  WARN my_target: targeted log with parameter parameter
0.000234600s  INFO my_app::level2: multi level targetd log
0.000237540s  INFO my_app::sub2: multi level targetd log
```

Tracing and `RUST_LOG` let you specify targeted logs and log levels. Multiple
scopes can be targeted, each with a different level. The tracing-subscriber
refers to this as a [Directive](https://docs.rs/tracing-subscriber/latest/tracing_subscriber/filter/struct.EnvFilter.html#directives)
For example, `RUST_LOG=off,my_target cargo run` will reduce the output to:
```
0.000091780s  INFO my_target: targeted log
0.000104580s  WARN my_target: targeted log with parameter parameter
```

Each spec is separated by a `,`, and can change the output level. `off` or one
of the log levels `error`, `warn`, `info`, `debug`, `trace` by itself will
globally apply, but the `my_target` above, turns logging back on for those lines.

`RUST_LOG=off,my_target=warn cargo run` reduces the log output to a single line.

```
0.000104580s  WARN my_target: targeted log with parameter parameter
```

*Specific spans and fields can be specified too, `target[span{field=value}]=level`, see [Directives](https://docs.rs/tracing-subscriber/latest/tracing_subscriber/filter/struct.EnvFilter.html#directives)*

## Creating targets

What are targets? They are useful tags to associate connected log lines. For example,
you can mark certain operations with similar targets. They can be explictly named
and heirarchically organized. Each level can be selected in `RUST_LOG`.

```
tracing::info!(target: "my_target", "targeted log");
tracing::warn!(target: "my_target", "targeted log with parameter {}", "parameter");
tracing::info!(target: "my_app::level2", "multi level targetd log");
tracing::info!(target: "my_app::sub2", "multi level targetd log");
```

## Structured Event Parameters

Tracing allows marking parameters to be logged in a systematic way.

```rust
let a = "Earth";
tracing::info!("regular println usage a={}", a);
tracing::info!(name = a, "named param");
tracing::info!(a, "quick named param");

let dbg_val = DebugVal { value: 42 };
// use display trait print
tracing::info!(%dbg_val, "display print param");

// use debug trait print
tracing::info!(?dbg_val, "debug print param");

// named param w/ expression
tracing::info!(val = dbg_val.value, "named debug print param");

```

results in:

```
0.000111930s  INFO tracing_quickstart: regular println usage a=Earth
0.000115370s  INFO tracing_quickstart: named param name="Earth"
0.000119270s  INFO tracing_quickstart: quick named param a="Earth"
0.000123860s  INFO tracing_quickstart: display print param dbg_val=Val: 42
0.000127890s  INFO tracing_quickstart: debug print param dbg_val=DebugVal { value: 42 }
0.000132160s  INFO tracing_quickstart: named debug print param val=42
```

See the [Recording Fields](https://docs.rs/tracing/latest/tracing#recording-fields) section
of the docs for more detail.

## Spans for Context

Spans create execution contexts, providing structure to your logs:

```rust
let span = tracing::span!(tracing::Level::INFO, "my_span");
let _guard = span.enter();
tracing::info!("inside span"); // This log will be associated with "my_span"
```

When run this generates

```
0.000205640s  INFO my_span: tracing_quickstart: inside span
0.000210240s  INFO my_span: my_app: custom, inside span
0.000215700s  INFO my_span: tracing_quickstart: close time.busy=9.89µs time.idle=1.48µs
```

## Conclusion

There are a lot more nuances of the tracing crate. Only the bare basics are
outlined here. Some interesting, but still basic, variations are provided in the
[`tracing-quickstart` repository]((https://github.com/digikata/tracing-quickstart)),
but there are many richer examples in the[tracing documentation](https://docs.rs/tracing)
and overall rust ecosystem.

