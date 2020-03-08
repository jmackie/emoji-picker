// https://doc.rust-lang.org/cargo/reference/build-scripts.html
//
// rls doesn't seem to work here, so `cargo watch -w build.rs -x check`

#[macro_use]
extern crate quote;

use proc_macro2::TokenStream;
use serde::Deserialize;
use std::collections::HashMap;
use std::fs::File;
use std::io::prelude::*;

fn main() -> std::io::Result<()> {
    generate_emojis_module()?;
    Ok(())
}

fn generate_emojis_module() -> std::io::Result<()> {
    println!("cargo:rerun-if-changed=emojis.json");

    #[derive(Deserialize)]
    struct Emoji {
        keywords: Vec<String>,
        char: String,
        fitzpatrick_scale: bool,
        category: String,
    }

    let json_file = File::open("emojis.json")?;

    let mut file = File::create("src/emojis.rs")?;

    // Parse emojis and return a _sorted_ vector of pairs
    // (sorted so that we don't keep dirtying the generated file)
    let emojis = {
        let m: HashMap<String, Emoji> =
            serde_json::from_reader(json_file).expect("error reading emojis.json");
        let mut v: Vec<(String, Emoji)> = m.into_iter().collect();
        v.sort_by(|a, b| a.0.cmp(&b.0));
        v
    };

    let mut inserts = TokenStream::new();
    for (k, v) in emojis {
        let keywords_iter = v.keywords.iter();
        let keywords_field = quote! {
            &[#(#keywords_iter),*]
        };
        let char_field = &v.char;
        let fitzpatrick_scale_field = v.fitzpatrick_scale;
        let category_field = &v.category;

        inserts.extend(quote! {
            m.insert(#k, Emoji {
                keywords: #keywords_field,
                char: #char_field,
                fitzpatrick_scale: #fitzpatrick_scale_field,
                category: #category_field,
            });
        })
    }

    let tokens = quote! {
        pub struct Emoji {
            pub keywords: &'static [&'static str],
            pub char: &'static str,
            pub fitzpatrick_scale: bool,
            pub category: &'static str,
        }
        lazy_static! {
            pub static ref EMOJIS: std::collections::HashMap<&'static str, Emoji> = {
                let mut m = std::collections::HashMap::new();
                #inserts
                m
            };
        }
    };
    file.write(tokens.to_string().as_bytes())?;
    Ok(())
}
