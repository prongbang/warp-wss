
gen_cert:
	openssl req -newkey rsa:2048 -new -nodes -x509 -days 3650 -keyout key.rsa -out cert.pem

login:
	heroku login

logout:
	heroku logout

login_container:
	heroku container:login

build:
	heroku container:push web -a warp-wss

deploy:
	heroku container:release web -a warp-wss

build_deploy:
	make build && make deploy

open:
	heroku open -a warp-wss