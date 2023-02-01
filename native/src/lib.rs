use colored::*;
use shared_child::SharedChild;
use std::ffi::CStr;
use std::os::raw::c_char;
use std::process::Command;
use std::sync::Arc;

#[no_mangle]
pub extern "C" fn run_script(ptr: *const c_char) -> i32 {
    let c_str = unsafe { CStr::from_ptr(ptr) };
    let script: String = String::from(c_str.to_str().unwrap());

    println!("$ {}", script.dimmed());
    println!("");

    #[cfg(target_os = "windows")]
    let shell: &str = "cmd";

    #[cfg(not(target_os = "windows"))]
    let shell: &str = "bash";

    let option: &str = match shell {
        "cmd" => "/C",
        "bash" => "-c",
        _ => "",
    };

    let mut child = Command::new(shell);
    child.arg(option).arg(script);
    let child_shared =
        SharedChild::spawn(&mut child).expect("Rust: Coudln't spawn the shared_child process!");
    let child_arc = Arc::new(child_shared);
    let child_arc_clone = child_arc.clone();

    let _ = ctrlc::set_handler(move || {
        child_arc_clone
            .kill()
            .expect("Rust: Couldn't kill the process!");
        println!();
    });
    // .expect("Rust: Error setting interrupt handler!");

    let status = child_arc.wait().expect("Rust: Process can't be awaited");
    status.code().unwrap_or(1)
}
