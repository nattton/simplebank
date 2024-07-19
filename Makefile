postgres:
	docker run --name postgres16 -e POSTGRES_PASSWORD=secret -d -p 5432:5432 postgres

createdb:
	docker exec -t postgres16 createdb --username=postgres --owner=postgres simple_bank

dropdb:
	docker exec -t postgres16 dropdb simple_bank

migrateup:
	migrate -path db/migration/ -database "postgresql://postgres:secret@localhost:5432/simple_bank?sslmode=disable" -verbose up

migrateup1:
	migrate -path db/migration/ -database "postgresql://postgres:secret@localhost:5432/simple_bank?sslmode=disable" -verbose up 1

migratedown:
	migrate -path db/migration/ -database "postgresql://postgres:secret@localhost:5432/simple_bank?sslmode=disable" -verbose down

migratedown1:
	migrate -path db/migration/ -database "postgresql://postgres:secret@localhost:5432/simple_bank?sslmode=disable" -verbose down 1

sqlc:
	sqlc generate

test:
	go test -v -cover ./...

server:
	go run main.go

mock:
	mockgen -package mockdb -destination db/mock/store.go github.com/code-mobi/simplebank/db/sqlc Store

.PHONY: postgres createdb dropdb migrateup migratedown migrateup1 migratedown1 sqlc test server mock