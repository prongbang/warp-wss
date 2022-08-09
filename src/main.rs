use futures::StreamExt;
use futures::FutureExt;
use warp::Filter;

#[tokio::main]
async fn main() {
    let echo = warp::path("echo")
        .and(warp::ws())
        .map(|ws: warp::ws::Ws| {
            ws.on_upgrade(|websocket| {
                let (tx, rx) = websocket.split();
                rx.forward(tx).map(|result| {
                    if let Err(e) = result {
                        eprintln!("websocket error: {:?}", e);
                    }
                })
            })
        });

    let current_dir = std::env::current_dir().expect("failed to read current directory");
    let routes = warp::get().and(echo.or(warp::fs::dir(current_dir)));
    warp::serve(routes)
        .tls()
        .cert_path("cert.pem")
        .key_path("key.rsa")
        .run(([0, 0, 0, 0], 9231)).await;
}