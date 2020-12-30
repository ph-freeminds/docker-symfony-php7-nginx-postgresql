CONTAINER_NAME=rolliver_database_app

app.docker_compose.build:
	docker-compose -f docker-compose.yml pull
	docker-compose -f docker-compose.yml up --build -d ${DOCKER_COMPOSE_UP_OPTION}

app.docker_compose.cleanup:
	make app.docker.fix_file_ownership || true
	make app.docker_compose.stop || true
	make app.docker_compose.remove || true

app.docker_compose.stop:
	docker-compose -f docker-compose.yml stop

app.docker_compose.remove:
	docker-compose -f docker-compose.yml rm -vf

app.docker.fix_file_ownership:
	# Give proper owner ship to all files. On gitlab, we may face issues where ACLs are not enough
	docker exec -t $(CONTAINER_NAME) sh -c 'chown -R $(shell id -u):$(shell id -g) .'

app.docker_compose.rebuild:
	make app.docker_compose.stop
	make app.docker_compose.remove
	make app.docker_compose.build

app.composer.install:
	docker exec -it $(CONTAINER_NAME) sh -c ' \
		COMPOSER_MEMORY_LIMIT=-1 composer install --optimize-autoloader --no-interaction \
    '

app.composer.install.ci:
	docker exec -t $(CONTAINER_NAME) sh -c ' \
		COMPOSER_MEMORY_LIMIT=-1 composer install --optimize-autoloader --no-interaction \
    '
app.docker.sh:
	docker exec -it $(CONTAINER_NAME) /bin/sh

app.docker.set_file_permissions:
	setfacl -R -m u:`whoami`:rwx -m g:`whoami`:rwx -m o:rwx -m m:rwx . && setfacl -R -d -m u:`whoami`:rwx -m g:`whoami`:rwx -m o:rwx -m m:rwx . 2>/dev/null

app.doctrine.load_fixtures:
	docker exec -t $(CONTAINER_NAME) bin/console doctrine:fixtures:load -n

app.doctrine_migrations:
	# History tracking
	docker exec -t $(CONTAINER_NAME) bin/console change:tracking:apply --apply-super-user-config
	# classic migrations
	docker exec -t $(CONTAINER_NAME) bin/console doctrine:migrations:migrate -n --allow-no-migration

app.doctrine_migrations.diff:
	# classic migrations
	docker exec -t $(CONTAINER_NAME) bin/console doctrine:migrations:diff

app.db.check_entities:
	docker exec -t $(CONTAINER_NAME) bin/console doctrine:schema:validate