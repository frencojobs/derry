use std::ffi::CStr;
use std::os::raw::c_char;
use std::process::Command;

#[no_mangle]
pub extern "C" fn executor(ptr: *const c_char) {
    let c_str = unsafe { CStr::from_ptr(ptr) };
    let script: String = String::from(c_str.to_str().unwrap());

    println!("> {}", script);
    println!("");
    executor_fn(&script);
}

fn executor_fn(script: &String) {
    #[cfg(target_os = "windows")]
    let shell: &str = "cmd";

    #[cfg(not(target_os = "windows"))]
    let shell: &str = "bash";

    let option: &str = match shell {
        "cmd" => "/C",
        "bash" => "-c",
        _ => "",
    };

    let process = match Command::new(shell).arg(option).arg(script).spawn() {
        Ok(process) => process,
        Err(error) => panic!("Shell starting error: {}", error),
    };

    let output = match process.wait_with_output() {
        Ok(output) => output,
        Err(error) => panic!("Retrieving output error: {}", error),
    };

    let stdout = match std::string::String::from_utf8(output.stdout) {
        Ok(stdout) => stdout,
        Err(error) => panic!("Translating stdout error: {}", error),
    };

    let stderr = match std::string::String::from_utf8(output.stderr) {
        Ok(stdout) => stdout,
        Err(error) => panic!("Translating stderr error: {}", error),
    };

    print!("{}", stdout);
    print!("{}", stderr);
}
