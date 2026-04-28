package middleware

import (
	"context"
	"log"
	"net/http"
	"strings"

	"github.com/imanflow/baraka-ai/backend_go/pkg/response"
	"github.com/imanflow/baraka-ai/backend_go/pkg/token"
)

type contextKey string

const userIDKey contextKey = "user_id"

func RequestLogger(next http.Handler) http.Handler {
	return http.HandlerFunc(func(w http.ResponseWriter, r *http.Request) {
		log.Printf("%s %s", r.Method, r.URL.Path)
		next.ServeHTTP(w, r)
	})
}

func CORS(allowedOrigin string, next http.Handler) http.Handler {
	if allowedOrigin == "" {
		allowedOrigin = "*"
	}

	return http.HandlerFunc(func(w http.ResponseWriter, r *http.Request) {
		w.Header().Set("Access-Control-Allow-Origin", allowedOrigin)
		w.Header().Set("Access-Control-Allow-Headers", "Authorization, Content-Type")
		w.Header().Set("Access-Control-Allow-Methods", "GET, POST, PUT, PATCH, DELETE, OPTIONS")
		w.Header().Set("Access-Control-Max-Age", "86400")
		if r.Method == http.MethodOptions {
			w.WriteHeader(http.StatusNoContent)
			return
		}
		next.ServeHTTP(w, r)
	})
}

func JWTAuth(secret string, next http.Handler) http.Handler {
	return http.HandlerFunc(func(w http.ResponseWriter, r *http.Request) {
		header := r.Header.Get("Authorization")
		rawToken := strings.TrimPrefix(header, "Bearer ")
		if rawToken == "" || rawToken == header {
			response.Error(w, http.StatusUnauthorized, "missing bearer token")
			return
		}

		claims, err := token.Validate(secret, rawToken)
		if err != nil || claims.Type != "access" {
			response.Error(w, http.StatusUnauthorized, "invalid bearer token")
			return
		}

		ctx := context.WithValue(r.Context(), userIDKey, claims.Subject)
		next.ServeHTTP(w, r.WithContext(ctx))
	})
}

func UserIDFromContext(ctx context.Context) (string, bool) {
	userID, ok := ctx.Value(userIDKey).(string)
	return userID, ok && userID != ""
}
