# desafio-87-blue-application-notes-api

API REST em **Ruby on Rails 7.1** (modo **API-only**) para gestão de **notas**, com persistência em **SQLite**, paginação via **Pagy**, serialização JSON com **ActiveModel::Serializers** e **CORS** habilitado para consumo por aplicações front-end no desenvolvimento local.

Este repositório faz parte do desafio técnico **desafio-87** (Blue Application Notes): expõe endpoints para **listar** notas com paginação e **criar** novas notas, alinhado a um cliente Vue no repositório correspondente de front-end.

---

## Stack principal

| Item | Versão / observação |
|------|----------------------|
| Ruby | 3.3.1 |
| Rails | ~> 7.1.5 |
| Banco | SQLite3 |
| Servidor | Puma |
| Paginação | Pagy ~> 43.5 |
| CORS | rack-cors (`http://localhost:8080` em `config/initializers/cors.rb`) |

---

## Docker: build e execução

Na raiz deste repositório (onde está o `docker-compose.yml`):

### Subir a API

```bash
docker compose build
docker compose up
```

Na primeira subida, o serviço `web` executa `rails db:migrate` e em seguida `rails s -b 0.0.0.0`. A API fica disponível em **http://localhost:3000**.

### Rodar comandos Rails dentro do container

```bash
docker compose exec web bundle exec rails db:seed
docker compose exec web bundle exec rails console
docker compose exec web bundle exec rspec
```

O banco SQLite fica no volume nomeado `sqlite_data` (montado em `/rails/db` no container), para os dados persistirem entre reinícios do Compose.

### Desenvolvimento sem Docker (opcional)

```bash
bundle install
bin/rails db:create db:migrate
bin/rails server
```

---

## Endpoints da API

Base URL (Docker local): `http://localhost:3000`

Todas as respostas são **JSON**. Chaves em **snake_case**, salvo configuração futura do serializer.

### `GET /notes`

Lista notas ordenadas por **`created_at` descendente**, com **paginação**.

**Query parameters (opcionais)**

| Parâmetro | Descrição |
|-----------|-----------|
| `page` | Número da página (inteiro ≥ 1). |
| `limit` | Quantidade de itens por página. |

**Resposta `200 OK`**

Corpo JSON:

| Campo | Tipo | Descrição |
|-------|------|-----------|
| `notes` | array | Lista de notas da página atual. Cada item contém `id`, `title`, `content`, `created_at`. |
| `total_pages` | integer | Total de páginas segundo o Pagy. |
| `current_page` | integer | Página atual. |

**Exemplo**

```http
GET /notes?page=1&limit=10
```

```json
{
  "notes": [
    {
      "id": 1,
      "title": "Minha nota",
      "content": "Texto da nota",
      "created_at": "2026-05-03T12:00:00.000Z"
    }
  ],
  "total_pages": 3,
  "current_page": 1
}
```

---

### `POST /notes`

Cria uma nova nota.

**Corpo da requisição (JSON)**

O payload deve envolver os atributos sob a chave **`note`**:

```json
{
  "note": {
    "title": "Título da nota",
    "content": "Conteúdo opcional em texto"
  }
}
```

**Validações (modelo `Note`)**

- `title`: obrigatório, entre **5** e **50** caracteres.

**Resposta `201 Created`**

Objeto da nota criada com `id`, `title`, `content`, `created_at`.

**Resposta `422 Unprocessable Entity`**

Quando a validação falha (por exemplo `create!` levanta `ActiveRecord::RecordInvalid`), o retorno segue o concern `ErrorHandler`:

```json
{
  "error": "Validation failed: Title is too short (minimum is 5 characters)"
}
```

(A mensagem exata depende do idioma e da regra violada.)

---

## CORS

O arquivo `config/initializers/cors.rb` restringe origens permitidas. Para outro host ou porta do front-end, ajuste `origins` e **reinicie** o servidor Rails.

---

## Testes

```bash
bundle exec rspec
```

---

## O que ficou de fora por limitação de tempo

Itens pedidos no escopo desafio que não puderam ser adicionados neste repositório:

- **Autenticação:** usuários, tokens ou sessões;

Esses pontos podem ser priorizados em iterações futuras conforme o escopo do produto ou do desafio.

