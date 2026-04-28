package main

import (
	"log"
	"net/http"

	"github.com/imanflow/baraka-ai/backend_go/internal/config"
	"github.com/imanflow/baraka-ai/backend_go/internal/database"
	"github.com/imanflow/baraka-ai/backend_go/internal/handler"
	"github.com/imanflow/baraka-ai/backend_go/internal/middleware"
	"github.com/imanflow/baraka-ai/backend_go/internal/repository"
	"github.com/imanflow/baraka-ai/backend_go/internal/service"
)

func main() {
	cfg := config.Load()
	db := database.Open(cfg)
	repo := repository.NewMemoryRepository(db)
	services := service.NewContainer(repo, cfg)
	api := handler.NewAPIHandler(services)

	stack := middleware.CORS(cfg.CORSAllowedOrigin, middleware.RequestLogger(api.Routes()))

	log.Printf("Baraka AI backend listening on %s using %s storage", cfg.HTTPAddr, db.Driver)
	if err := http.ListenAndServe(cfg.HTTPAddr, stack); err != nil {
		log.Fatal(err)
	}
}
