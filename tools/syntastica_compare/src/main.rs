use std::env;
use std::fs;
use syntastica::{renderer::TerminalRenderer, Highlights, Processor};
use syntastica_core::theme::ResolvedTheme;
use syntastica_parsers_git::{Lang, LanguageSetImpl};

fn main() {
    let args: Vec<String> = env::args().collect();
    if args.len() < 4 {
        eprintln!("Usage: {} <lang> <file> <theme> [output]", args[0]);
        std::process::exit(1);
    }

    let lang_str = &args[1];
    let file_path = &args[2];
    let theme_name = &args[3];
    let source = fs::read_to_string(file_path).expect("Failed to read input file");

    let lang = match lang_str.to_lowercase().as_str() {
        "crystal" => Lang::Crystal,
        "rust" => Lang::Rust,
        "python" => Lang::Python,
        "ruby" => Lang::Ruby,
        "javascript" => Lang::JavaScript,
        "typescript" => Lang::TypeScript,
        "go" => Lang::Go,
        "bash" => Lang::Bash,
        "c" => Lang::C,
        "cpp" => Lang::Cpp,
        "java" => Lang::Java,
        "json" => Lang::Json,
        "yaml" => Lang::Yaml,
        "toml" => Lang::Toml,
        "markdown" => Lang::Markdown,
        "html" => Lang::Html,
        "css" => Lang::Css,
        _ => { eprintln!("Unknown language: {}", lang_str); std::process::exit(1); }
    };

    let highlights = Processor::process_once(&source, lang, &LanguageSetImpl::new())
        .expect("Failed to process source");

    let theme = syntastica_themes::from_str(theme_name)
        .unwrap_or_else(|| panic!("Unknown theme: {}", theme_name));

    let bg_color = theme.bg();
    let output = syntastica::render(&highlights, &mut TerminalRenderer::new(bg_color), theme);

    if args.len() > 4 {
        fs::write(&args[4], &output).expect("Failed to write output");
    } else {
        print!("{}", output);
    }
}
