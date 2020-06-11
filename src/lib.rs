use std::ffi::CStr;
use std::os::raw::c_char;
use std::process::Command;

#[no_mangle]
pub extern "C" fn executor(ptr: *const c_char, silent: bool) {
    let c_str = unsafe { CStr::from_ptr(ptr) };
    let script: String = String::from(c_str.to_str().unwrap());

    println!("> {}", script);
    if !silent {
        println!("");
    }
    executor_fn(&script, silent);
}

fn executor_fn(script: &String, silent: bool) {
    #[cfg(target_os = "windows")]
    let shell: &str = "cmd";

    #[cfg(not(target_os = "windows"))]
    let shell: &str = "bash";

    let option: &str = match shell {
        "cmd" => "/C",
        "bash" => "-c",
        _ => "",
    };

    if silent {
        Command::new(shell)
            .arg(option)
            .arg(script)
            .output()
            .expect("Rust: Unable to get process output");
    } else {
        Command::new(shell)
            .arg(option)
            .arg(script)
            .spawn()
            .expect("Rust: Process can't be spawned")
            .wait()
            .expect("Rust: Unable to execute script");
    }
}
