# ChefExperto

Sistema experto para selección de desayunos.

## Tecnologías

- Python
- CLIPS
- clipspy
- FastAPI
- HTML
- CSS
- JavaScript
- pytest

## Descripción

ChefExperto analiza el tipo de desayuno solicitado por el usuario
y los ingredientes disponibles.

Un desayuno completo requiere:

- proteína
- bebida
- carbohidrato

La fruta es opcional.

Si no es posible preparar un desayuno completo,
el sistema recomienda una combinación de desayuno ligero.

## Ingredientes

### Bebidas

- Café
- Té

### Proteínas

- Huevo
- Queso

### Carbohidratos

- Pan
- Tortilla

### Frutas

- Banano
- Manzana

## Instalación

Crear entorno virtual:
python -m venv .venv
pip install -r backend/requirements.txt



# CHEFEXPERTO - Backend Semana 10
## Estructura
backend/
  __init__.py
  main.py
  modelos.py
  motor_experto.py
  conocimiento.clp
  requirements.txt

## Ejecutar
Desde la carpeta que contiene `backend`:
uvicorn backend.main:app --reload

## Probar sin frontend
Abrir:
http://127.0.0.1:8000/docs

En Swagger:
POST /api/v1/recomendar

Ejemplo:
{
  "tipo_desayuno": "completo",
  "ingredientes": ["huevo", "cafe", "pan"]
}

También:
GET /api/v1/health
GET /api/v1/ingredientes

## Idea central
FastAPI recibe JSON -> Python prepara hechos -> clipspy ejecuta CLIPS -> CLIPS aplica reglas -> Python devuelve JSON.


# CHEFEXPERTO - Frontend
## Estructura

frontend/
  app.js
  index.html
  style.css
