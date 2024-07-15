postgres:
	docker run --name postgres16 -e POSTGRES_PASSWORD=secret -d -p 5432:5432 postgres

createdb:
	docker exec -t postgres16 createdb --username=postgres --owner=postgres simple_bank

dropdb:
	docker exec -t postgres16 dropdb simple_bank

migrateup:
	migrate -path db/migration/ -database "postgresql://postgres:secret@localhost:5432/simple_bank?sslmode=disable" -verbose up

migratedown:
	migrate -path db/migration/ -database "postgresql://postgres:secret@localhost:5432/simple_bank?sslmode=disable" -verbose down

sqlc:
	sqlc generate

test:
	go test -v -cover ./...

server:
	go run main.go

mock:
	mockgen -package mockdb -destination db/mock/store.go gitlab.com/code-mobi/simplebank/db/sqlc Store

.PHONY: postgres createdb dropdb migrateup migratedown sqlc test server mock