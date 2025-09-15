package krista

import (
	"errors"
	"io"
	"log/slog"
	"net/http"
	"os"

	"github.com/shurcooL/githubv4"
	"github.com/yuin/goldmark"
)

type ExecuteTemplateFunc func(wr io.Writer, name string, data any) error

func NewServer(cfg Config, httpClient *http.Client, githubClient *githubv4.Client, md goldmark.Markdown, assets http.FileSystem, tmpl ExecuteTemplateFunc) *Server {
	s := &Server{
		cfg:          cfg,
		httpClient:   httpClient,
		githubClient: githubClient,
		md:           md,
		assets:       assets,
		tmpl:         tmpl,
	}

	s.server = &http.Server{
		Addr:    cfg.ListenAddr,
		Handler: s.Routes(),
	}

	return s
}

type Server struct {
	cfg          Config
	httpClient   *http.Client
	githubClient *githubv4.Client
	server       *http.Server
	md           goldmark.Markdown
	assets       http.FileSystem
	tmpl         ExecuteTemplateFunc
}

func (s *Server) Start() {
	if err := s.server.ListenAndServe(); err != nil && !errors.Is(err, http.ErrServerClosed) {
		slog.Error("Error while listening", slog.Any("err", err))
		os.Exit(-1)
	}
}

func (s *Server) Close() {
	if err := s.server.Close(); err != nil {
		slog.Error("Error while closing server", slog.Any("err", err))
	}
}
