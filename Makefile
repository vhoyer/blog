include .env
export $(shell sed 's/=.*//' .env)

run:
	docker-compose up

down:
	docker-compose down

bash:
	docker ps | grep -q "blog-app-1$$" && docker-compose exec app "bash" || docker-compose rum --rm app "bash";

startup:
	npm install
	npm start
