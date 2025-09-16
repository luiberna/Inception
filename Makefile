up:
	mkdir -p /home/luiberna/data
	docker compose -f srcs/docker-compose.yml up --build

upd:
	mkdir -p /home/luiberna/data
	docker compose -f srcs/docker-compose.yml up -d --build

down:
	docker compose -f srcs/docker-compose.yml down -v

re:
	docker compose -f srcs/docker-compose.yml logs -f

clean:
	$(MAKE) down
	sudo rm -rf /home/luiberna/data
	docker system prune -a --volumes -f
	docker volume prune -f
	docker rmi -f srcs-mariadb || true
	docker rmi -f srcs-wordpress || true
	docker rmi -f srcs-nginx || true
	docker image prune -f

logs:
	docker compose -f srcs/docker-compose.yml logs -f