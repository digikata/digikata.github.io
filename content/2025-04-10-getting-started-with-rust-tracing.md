+++
title = "Getting Started with Rust Tracing"
date = 2025-04-10
+++

The Tracing crate for Rust is a well-implemented tracing library for a wide
range of tracing and logging needs. However, I haven't seen a simple startup
guide for tracing. This is what would have saved me some time when
getting started with Tracing.

<!-- more -->

I've put together a [quickstart repository](https://github.com/digikata/tracing-quickstart)
with the examples below.

## Setting Up Tracing

Basic setup requires adding the `tracing` and `tracing-subscriber` dependencies
to your `Cargo.toml`.

```toml
[dependencies]
tracing = "0.1"
tracing-subscriber = "0.3"
```

Then, initialize the tracing system. A frequent use case is setting up some default
trace levels, but also taking in the `RUST_LOG` environment variable to change
what is logged dynamically. The final `Subscriber::builder()... try_init()` will
setup the tracing configuration as the global tracing configuration.  It's not
recommended to setup tracing multiple times or places.

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
        // .with_timer(fmt::time::uptime()) // different time formats allowed
        .with_timer(fmt::time::UtcTime::rfc_3339())
        .with_span_events(fmt::format::FmtSpan::CLOSE)
        .try_init()
        .expect("unable to setup tracing");
}
```

There are a lot of ways to structure outputs, including sending different
logs to different outputs with `Layers`, see the function `setup_tracing_alt()`
for an example.

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
scopes can be targeted, each with a different level. For example,
`RUST_LOG=off,my_target cargo run` will reduce the output to:
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
tracing::info!(%dbg_val, "display print param"); // use display trait print
tracing::info!(?dbg_val, "debug print param"); // use debug trait print
tracing::info!(val = dbg_val.value, "named debug print param"); // named param w/ expression

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
`tracing-quickstart` code, but there are much richer examples in the
[documentation](https://docs.rs/tracing) and overall rust ecosystem.
