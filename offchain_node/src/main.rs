#[macro_use] extern crate rocket;

#[get("/")]
fn index() -> &'static str {
    "Hello, world!"
}

#[get("/price/<id>")] 
fn price(id: String) -> String {
    let price = 100;
    format!("The price of {} is {}", id, price)
}

#[launch]
fn rocket() -> _ {
    rocket::build().mount("/", routes![index])
}